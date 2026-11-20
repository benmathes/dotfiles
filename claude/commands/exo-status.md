# Sibling Exo Status

Report the state of every `exoN` sibling under `~/coding/felicis/exoskeleton/` in one table — so the user can pick which copy to work in and spot stale/conflicting branches across instances.

User triggers via `/exo-status`, "what's each exo doing?", "where should I work?", or similar.

## When to use

The user runs N parallel copies of the same repo (`exo1`, `exo2`, …) and frequently:
- forgets which copy has which branch
- pulls a sibling's branch into the wrong copy
- runs ingestion in one copy and forgets to sync the others
- merges a PR in one copy and forgets to deploy from another

This skill is read-only: it observes. It does NOT pull, rebase, or push anything.

## Step 1: Discover siblings

```bash
ls -d ~/coding/felicis/exoskeleton/exo[0-9]* 2>/dev/null
```

Skip any that aren't git repos (`test -d <dir>/.git`).

## Step 2: For each sibling, collect

Run these in parallel via a single shell loop — one `git -C <dir>` per fact:

| Field | Command |
|---|---|
| Branch | `git -C <dir> rev-parse --abbrev-ref HEAD` |
| Ahead/behind main | `git -C <dir> rev-list --left-right --count origin/main...HEAD` |
| Uncommitted files | `git -C <dir> status --porcelain | wc -l` |
| Last commit (subject + age) | `git -C <dir> log -1 --format='%s (%cr)'` |
| Last fetch age | `stat -f '%Sm' -t '%Y-%m-%d %H:%M' <dir>/.git/FETCH_HEAD` (macOS) |
| Latest migration | `ls <dir>/code/core/migrations/ \| grep -E '^[0-9]+_' \| tail -1` |

Fetch `origin/main` once per sibling first (`git -C <dir> fetch -q origin main`) so ahead/behind numbers are accurate. If fetch fails (offline, no remote), note "no fetch" in that row and use cached ref data.

## Step 3: Render the table

Markdown table, one row per sibling, columns: **exo**, **branch**, **ahead/behind main**, **dirty**, **last commit**, **last migration**, **note**.

The **note** column flags anything worth attention:
- `⚠ on main with uncommitted` — risky (hook would block commits, but user might forget)
- `⚠ ahead of main but stale` — feature branch hasn't moved in 7+ days
- `⚠ same branch as exoN` — two siblings on the same feature branch (likely accidental)
- `⚠ migration drift` — latest migration number differs from majority

After the table, surface a one-line recommendation: which sibling looks idle (clean, on main, fetched recently) for new work.

## Step 4: Stop

Do not pull, rebase, push, or merge. If the user wants any of that, they can invoke `/sync-main` in the chosen copy. This skill is purely observational.

## Rules

- Read-only. Never modify any sibling's working tree.
- Don't run `pytest`, `ingest_all`, `bin/server`, or any side-effecting command.
- If `git -C <dir> fetch` would prompt for credentials, skip the fetch for that sibling and note "no fetch".
- Quote the table in code fences so columns align in the terminal.
