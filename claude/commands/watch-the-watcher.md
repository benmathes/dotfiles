# Watch the Watcher

Audit the guidance documents that shape how Claude operates in this repo. Find contradictions, staleness, redundancy, and drift so the docs stay trustworthy.

## Step 1: Discover guidance files

Do NOT assume a specific directory structure. Dynamically find all markdown files that guide Claude's behavior:

**Always present:**
- `~/.claude/CLAUDE.md` (global user instructions)
- `.claude/CLAUDE.md` (repo-level instructions, if exists)
- `.claude/LEARNINGS.md` (repo learnings, if exists)

**Discover by scanning:**
- `CLAUDE.md` files anywhere in the repo (nested project instructions)
- Markdown files in any `planning/`, `designs/`, `docs/`, `strategy/`, `policy/` directories
- Any `.claude/commands/*.md` files (skill definitions)
- `CONTRIBUTING.md`, `ARCHITECTURE.md`, `DEVELOPMENT.md`, or similar top-level guidance docs
- Memory files: `~/.claude/projects/*/memory/*.md` or `.claude/memory/*.md`

Use Glob with patterns like `**/CLAUDE.md`, `**/planning/**/*.md`, `**/docs/**/*.md`, `**/designs/**/*.md`, `**/{CONTRIBUTING,ARCHITECTURE,DEVELOPMENT,CONVENTIONS}.md` to find them. Report what you found before proceeding.

## Step 2: Read and analyze

Read ALL discovered guidance files. For large directories of design docs, read all of them if you can. Read core guidance files (CLAUDE.md, LEARNINGS.md, principles, strategy, policy) in full.

Then run every check below across the full set of files.

## Checks

### 1. Contradictions
Statements in one file that directly conflict with statements in another. Examples:
- A principle says "never do X" but another file says "we do X because..."
- Global CLAUDE.md says one thing, repo CLAUDE.md says the opposite
- Strategy implies one priority, a design doc assumes the opposite
- Policy forbids something that a design doc proposes

### 2. Stale references
- File paths mentioned in docs that don't exist on disk (verify with Glob)
- Function/class names referenced that don't exist in code (verify with Grep)
- Cross-references to other docs that have moved or been deleted
- Signposts about code patterns that no longer apply

### 3. Redundancy
- Same information stated in multiple files unnecessarily
- Entries that restate what's already covered in another guidance file
- Design docs that duplicate strategy/principle content verbatim
- Note: some intentional repetition is fine (e.g., a summary pointing to a detailed source). Flag cases where the duplication adds no value or risks going stale independently.

### 4. Lifecycle mismatches
- Design docs containing `**Status**:` or `## Status:` lines when folder structure is supposed to convey status
- Design docs in a "built/done" folder for features that don't appear to exist in code
- Design docs in an "unbuilt/todo" folder for features that have actually been implemented
- Design docs that seem abandoned (no references, no recent git activity)

### 5. Dead cross-links
- Markdown links (`[text](path)`) pointing to files that don't exist
- References like "see X in Y file" where Y doesn't contain X
- Anchors to headings that don't exist in the target file

### 6. Context window waste
- Guidance entries that are excessively verbose for the information they convey
- Entries that could be derived from the code itself (instructions about what the code does, rather than why or how to work with it)
- Redundant entries that say the same thing in slightly different ways
- Guidance that has become so obvious from the codebase that it no longer needs to be stated

### 7. Principle drift
- Design docs whose described approach conflicts with current principles or strategy
- Features that may surface data in new ways without noting policy/legal review (if a data policy exists)
- Designs that rely on patterns explicitly forbidden elsewhere in guidance

### 8. Ghost entities
- Docs that reference database models, fields, API endpoints, or CLI commands that don't exist in the codebase
- Signposts about schema patterns for tables that have been removed or renamed
- References to tools, management commands, or scripts that no longer exist

## Output format

Present findings as a structured report in the conversation. Group by check type. For each finding:

```
**[SEVERITY]** Check type — short description
- File A: "quoted text"
- File B: "conflicting/problematic text"
- Recommendation: what to do about it
```

Severity levels:
- **HIGH**: Active contradiction that could cause Claude to do the wrong thing
- **MEDIUM**: Staleness or redundancy that wastes context or misleads
- **LOW**: Hygiene issue, minor drift, or optimization opportunity

End with a summary count: X high, Y medium, Z low.

## Step 3: Follow-up

After presenting findings, ask which items the user wants to act on. If they say to fix things, make the actual edits — remove stale entries, resolve contradictions, deduplicate, move design docs, fix broken links, etc. Do not just report; be ready to execute.
