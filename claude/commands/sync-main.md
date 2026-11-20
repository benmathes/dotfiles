# Sync With Main

Bring the current feature branch up to date with `origin/main` by **merging** (not rebasing), resolving conflicts, and re-running tests. The merge-not-rebase rule comes from a deliberate user preference: avoid force pushes and history rewrites when the goal is just to absorb upstream changes.

User triggers via `/sync-main`, "rebase off main" (treat as merge despite the wording), "get the latest main into this branch", or similar.

## Preconditions

- Current branch is NOT `main`. If on `main`, the user wanted `git pull --ff-only`, not this skill — stop and say so.

## Step 0: Auto-stash WIP if dirty

If `git status --porcelain` is non-empty, stash everything (including untracked) so the merge has a clean tree to work with:

```bash
git stash push -u -m "sync-main auto-stash $(date +%s)"
```

Remember that a stash was created — you'll restore it at the end. If `git stash` itself fails (rare), stop and surface the error.

## Step 1: Fetch and assess

```bash
git fetch origin main
git rev-list --left-right --count origin/main...HEAD
```

Read the two numbers: `<behind> <ahead>`.

- `behind == 0` → branch already has all of main. Tell the user "already up to date" and stop. Do not create an empty merge commit.
- `behind > 0 && ahead == 0` → branch is strictly behind. Fast-forward via `git merge --ff-only origin/main`. No conflicts possible. Skip to step 4.
- `behind > 0 && ahead > 0` → continue to step 2.

## Step 2: Merge

```bash
git merge --no-edit origin/main
```

If merge succeeds cleanly, skip to step 4.

If `git merge` reports conflicts:

1. List conflicted files: `git diff --name-only --diff-filter=U`.
2. For each conflicted file:
   - Read it. Identify the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
   - Resolve based on intent — read surrounding code and recent commits on both sides if needed.
   - When a conflict is in a migration file or generated artifact, prefer regeneration (e.g. delete the conflicting migration, re-run `makemigrations`) over manual edit.
   - Do NOT accept-ours-blindly or accept-theirs-blindly without reading what's being discarded.
3. `git add` resolved files.
4. After every file resolves, `git commit --no-edit` (uses the default merge message).
5. Push: `git push`.

If you can't confidently resolve a conflict (intent ambiguous, or it crosses concepts you don't understand), STOP. Surface the conflict to the user with both sides quoted, and ask. Don't guess.

## Step 3: Sanity check after merge

Run the full test suite from the Django project root. Its location
differs by repo layout and by branch — `deploy-surfaces/web/` after the
surface-folders restructure, `code/` before it — so detect rather than
assume (a hardcoded path silently tests nothing on the other layout):

```bash
for d in deploy-surfaces/web code .; do
  [ -f "$d/manage.py" ] && cd "$d" && break
done
python -m pytest -q
```

Use the repo's own venv if the root carries one (`.venv/bin/python`).

Also run lint/type checks on touched files:

```bash
ruff check <files>
DJANGO_SETTINGS_MODULE=config.settings mypy <files>
```

If any test fails or check errors, investigate. A test failure after merging main means either:
- Main introduced a regression (rare — check if main is green)
- The branch's code drifted away from a contract main now enforces
- The conflict resolution lost something

Surface the failure and stop. Do not "fix" by skipping or deleting the test.

## Step 4: Push

```bash
git push
```

## Step 5: Restore the WIP stash (if step 0 stashed)

```bash
git stash pop
```

If `git stash pop` reports a conflict:
- Do NOT drop the stash. Tell the user main's incoming changes touched the same lines as their WIP, leave the stash intact (`git stash list` will show it), and let them resolve.

If `git stash pop` succeeds, verify `git status --porcelain` shows the same dirty files as before step 0 — same count, same paths. If they differ, surface the diff to the user.

## Step 6: Report

How many commits were absorbed from main, how many conflicts (if any), whether the WIP stash was restored cleanly, whether tests pass, and the current `ahead/behind` of origin/main.

## Rules

- **Merge, not rebase.** Rebase rewrites history and requires force-push, which is unnecessary risk when the goal is just to resolve conflicts and absorb upstream changes.
- Never force-push. Never use `git reset --hard` to "fix" a bad merge — `git merge --abort` is the right reversal, and only during the merge.
- Never commit on `main`. Never skip pre-commit hooks (`--no-verify`).
- If `bin/server` is running, leave it alone.
- If anything blocks (tests fail, conflict ambiguous, push rejected), stop and surface — do not retry destructively.
