# Pull Request Flow

End-to-end PR workflow: lightweight red-team of the diff, open the PR, optionally wait for a bot reviewer, address findings, reply.

User triggers via `/pr` or "ok lets PR this" or similar.

**A project-local `.claude/commands/pr.md` overrides this file.** If the current repo has its own version (which may know about project-specific design docs, review bots, test commands, etc.), follow that one instead. This global flow is the fallback.

## Flow

### 1. Detect the environment

Before doing anything, gather these facts about the current repo. Do not assume — check.

- **Repo identity**: `gh repo view --json nameWithOwner --jq .nameWithOwner` (e.g. `myorg/myrepo`). Need this for API calls later.
- **Main branch**: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name` (could be `main`, `master`, `trunk`).
- **Test command**: detect from project files in priority order:
  - `pyproject.toml` or `pytest.ini` or `tox.ini` → `pytest -q`
  - `package.json` with a `test` script → `npm test` (or `yarn test` / `pnpm test` depending on lockfile)
  - `Cargo.toml` → `cargo test`
  - `go.mod` → `go test ./...`
  - `Gemfile` with rspec → `bundle exec rspec`
  - Otherwise → ask the user.
- **Lint command** (same priority idea): `ruff check`, `eslint`, `cargo clippy`, `rubocop`, etc. Skip silently if no linter config is present.
- **Project red-team skill**: does `.claude/commands/red-team-architecture.md` exist in the current repo? If yes, use it. If no, fall back to the inline checklist in step 3 below.
- **Bot reviewer**: scan the last 10 closed PRs for a reviewer that posts automated reviews:
  ```bash
  gh pr list --state all --limit 10 --json number \
    --jq '.[].number' | while read n; do
      gh pr view "$n" --json reviews \
        --jq '.reviews[] | select(.author.login | test("claude|bot|coderabbit|sonarqube"; "i")) | .author.login'
    done | sort -u
  ```
  If a bot reviewer is found, record its login. If not, skip steps 5-8.
- **Co-author convention**: check the project's `CLAUDE.md` for a `Co-Authored-By:` line. If present, use it on commits. If not, omit.

### 2. Sanity check & branch hygiene
- Verify uncommitted work or unpushed commits exist on the current branch. If not, stop and tell the user there's nothing to PR.
- Current branch must not be the main branch (from step 1). If on main, create a feature branch using a name appropriate to the project's convention (check recent merged PRs — `gh pr list --state merged --limit 5 --json headRefName`). If the repo uses snake_case branches, use snake_case; if kebab-case, use kebab-case. Ask the user if it isn't obvious.
- Run the detected test command. If anything fails, stop and surface the failures.
- Run the detected lint command on touched files. If errors appear specifically from the diff (not pre-existing), stop and surface them.

### 3. Architecture red team (local)
- **If the project has its own `red-team-architecture` skill**, follow its workflow.
- **Otherwise, run this lightweight inline check** against the diff (`git diff <main_branch>...HEAD` and `git diff --cached`):
  - **N+1 queries**: are there DB/API calls inside loops where a batch fetch would work?
  - **God files**: any single file changed >1000 lines, or any function >100 lines? Flag for refactor consideration.
  - **DRY**: same literal string, helper, or pattern duplicated in 3+ places — promote to a constant or helper.
  - **Dead code**: unused imports, functions never called, commented-out blocks. Remove.
  - **Type / lint cleanliness**: did the diff *introduce* any new type or lint errors (compared to pre-diff baseline)? Fix.
  - **Test coverage**: did the diff add behavior without adding tests? If yes, either add tests or call out the gap explicitly.
  - **Boundary checks**: any new user input, external API call, or file read without validation / error handling at the boundary?
- Produce a short structured report (per-violation: file:line, what, fix, severity).
- **Address each violation** with severity ≥ medium before opening the PR. Commit fixes. Low-severity can be noted in the PR body as follow-ups.
- Re-run tests after fixes.

### 4. Open the PR
- Push the branch with upstream tracking (`git push -u origin <branch>`).
- Open the PR via `gh pr create --title "<title>" --body-file /tmp/pr_body.md`.
- Title: short (<70 chars), imperative mood, describes the change.
- Body template (adapt to project — check recent merged PRs for style):
  ```markdown
  ## Summary
  - <1-3 bullets on what changed and why>

  ## Test plan
  - [x] <existing automated check>
  - [ ] <manual verification step the user should do>
  ```
- If you have a co-author convention from step 1, the commit messages already carry it — no need to repeat in the PR body.
- Record the PR number returned by `gh pr create`.

### 5. (Optional) Wait for bot review

**Skip this entire section if no bot reviewer was detected in step 1.**

- Start a background poll using `Bash` with `run_in_background: true`:
  ```bash
  cat > /tmp/wait_bot_review.sh << 'WAIT_EOF'
  #!/usr/bin/env bash
  # Replace BOT_LOGIN with the login detected in step 1.
  PR_NUMBER=<PR_NUMBER>
  BOT_LOGIN=<BOT_LOGIN>
  deadline=$(($(date +%s) + 1200))   # 20 min
  while [ "$(date +%s)" -lt "$deadline" ]; do
    count=$(gh pr view "$PR_NUMBER" --json reviews \
      --jq "[.reviews[] | select(.author.login == \"$BOT_LOGIN\")] | length" 2>/dev/null || echo 0)
    if [ "${count:-0}" -gt 0 ]; then
      echo "bot_review_received"
      exit 0
    fi
    sleep 30
  done
  echo "timeout_no_bot_review_after_20min"
  exit 1
  WAIT_EOF
  chmod +x /tmp/wait_bot_review.sh
  /tmp/wait_bot_review.sh
  ```
- You'll get one notification when it exits. Do not poll yourself.
- On timeout: tell the user "no review arrived after 20 min" and hand back; don't keep waiting.

### 6. Fetch and parse the review

After the notification fires:

```bash
# Review body (LGTM summary + extended reasoning):
gh pr view <PR_NUMBER> --json reviews \
  --jq '.reviews[] | select(.author.login == "<BOT_LOGIN>")'

# Inline file:line comments:
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments \
  --jq '.[] | select(.user.login == "<BOT_LOGIN>") | {path, line, body, id}'
```

### 7. Address review findings

For each finding (review body + inline):
- **Actionable, small fix** → fix in this branch and commit.
- **Out of scope** → reply explaining; do not fix.
- **Disagree** → reply with reasoning; do not silently ignore.

Push fixes (`git push`).

### 8. Reply to each comment

For inline comments:
```bash
gh api -X POST repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments/<COMMENT_ID>/replies \
  -f body="Fixed in <commit_sha>: <one-line description>"
```

For the top-level review:
```bash
gh pr comment <PR_NUMBER> --body "Addressed in <commit_sha>:
- <finding 1>: <what changed>
- <finding 2>: out of scope, <reason>"
```

### 9. Hand back to the user

Surface: PR URL, what was addressed, what was deferred (and why), current CI status (`gh pr checks <PR_NUMBER>`).

Do **not** merge. The user merges.

## Rules
- Never commit on the main branch. Never force-push to it. Never skip pre-commit hooks (`--no-verify`).
- Use the HEREDOC pattern for commit messages to preserve formatting.
- Co-author tag is optional — use it only if the project's `CLAUDE.md` defines one.
- If anything blocks (tests fail, lint introduces new errors, push rejected, etc.), stop and surface — do not retry destructively.
- If the user already has a feature branch and unpushed work, do not create a new branch — extend the existing one.

## Tools used
`Bash` (git, gh, test/lint runners), `Read`/`Edit`/`Write` (fixing findings), `Skill` (invoke local `red-team-architecture` if present).
