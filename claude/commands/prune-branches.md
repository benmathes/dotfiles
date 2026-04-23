# Prune Merged Branches

Delete local and remote branches whose work is fully merged into main — including commits that were cherry-picked, rebased, or squash-merged (not just `--merged`).

## Step 1: First pass — `git cherry`

Use `git cherry` to detect equivalent commits regardless of SHA differences. For every branch (local and remote, excluding main):

```
git cherry main <ref>
```

- Lines starting with `+` = commits NOT in main
- Lines starting with `-` = commits whose patch equivalent IS in main
- If a branch has zero `+` lines (or zero total commits ahead), it's fully merged

Classify each branch:
- **MERGED** — has commits, all equivalent patches exist in main
- **EMPTY** — zero commits ahead of main (was branched and never diverged)
- **MAYBE ACTIVE** — has `+` commits according to `git cherry` (needs step 2)

## Step 2: Squash-merge detection for MAYBE ACTIVE branches

`git cherry` compares individual patches. Squash merges combine N branch commits into 1 main commit, so no individual patch matches — `git cherry` reports all commits as unmerged even when the work is fully on main.

For every MAYBE ACTIVE branch, run a **tip-to-tip diff**:

```
git diff main <branch> --stat
```

This shows the actual state difference between main and the branch right now, ignoring commit history entirely.

Classify based on the result:
- **Empty diff** → branch is identical to main → **MERGED** (squash-merged)
- **Branch is net-behind** (diff shows only deletions, or files main has that branch doesn't, or the branch version is strictly older) → **STALE** — main has superseded this branch. The branch's work was squash-merged and main kept going.
- **Branch has genuine additions** (new files, new code not on main) → **ACTIVE**

To confirm STALE status: spot-check that "new" files/features from the branch's commit log actually exist on main (e.g., `git show main:<path>` for key files the branch added). If everything the branch introduced already exists on main, it's stale.

Classify each branch into its final category:
- **MERGED** — all patches matched by `git cherry`, or tip-to-tip diff shows no additions
- **STALE** — branch has commits, but main has superseded it (squash-merged + main moved ahead)
- **EMPTY** — zero commits ahead of main
- **ACTIVE** — has genuine unmerged work (do NOT delete)

Present the full classified list to the user before deleting anything.

## Step 3: Confirm and delete

After showing the list, ask the user for confirmation before proceeding. Then for each MERGED, STALE, and EMPTY branch:

1. Delete the local branch if it exists: `git branch -D <name>`
2. Delete the remote branch if it exists: `git push origin --delete <name>`
3. Run `git fetch --prune` to clean up stale remote-tracking refs

Report what was deleted and any branches that failed to delete (already gone, protected, etc.).

## Notes

- Never delete `main` or the current branch
- `git cherry` catches cherry-picks and rebases (same patch, different SHA) but NOT squash merges — the tip-to-tip diff in step 2 catches those
- If a branch has even one genuinely unmerged commit, leave it alone — partial merges stay for the user to decide
