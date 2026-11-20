# Concept Audit

Survey one domain concept (a field, status, signal, role, lifecycle stage, etc.) across the codebase and report where it's defined, how it's used, and where it's surfaced — so the user can decide how to redesign or extend it.

User triggers via `/concept-audit <name>` or "audit how X is used", "where does Y live in the code?", or similar prompts that name one concept and ask for a structured read.

## Inputs

- `<name>` — the concept to audit. Examples: `p2`, `Hot_List`, `priority`, `signal`, `theme`, `stage`, `Pluck Bar`, `meeting_brief`.
- Optional: a hint about which subsystem to start in (e.g. "the Django side", "the MCP").

## Output: six-facet report

For each facet below, give file:line citations and 1–3 sentences. Skip a facet if it genuinely doesn't apply, but say so explicitly — silence is not the same as absence.

### 1. Definition
Where is the concept declared? Models, enums, choices, constants, dataclasses, settings keys, SFDC `__c` fields, BigQuery columns. Prefer the *canonical* declaration if there is one.

### 2. Business logic
Where is it computed, set, derived, or branched on? Services, signals, managers, pipelines, management commands, LLM prompts. Include the rule that determines it (the "what makes something `p2`?").

### 3. Storage and provenance
How is it persisted? Column, JSONField key, `SourceValues` row, related table, computed-on-the-fly. Note any soft-delete or partial-unique constraint that touches it.

### 4. UI / template / Slack / email surface
Where does an end user see it? Django templates, the Pluck Bar, Slack bot, digest emails, MCP tool descriptions, admin list_display.

### 5. Interaction with other concepts
What other concepts depend on it, derive from it, or compete with it? E.g. `p2` interacts with `priority`, `hot list`, `stage`. List the relationships.

### 6. Open redesign space
Synthesize: what's underspecified, inconsistent, or duplicated? Where would a redesign add the most leverage? Keep this to 2–4 bullets — the goal is to set up the next design conversation, not finish it.

## Procedure

1. Read `planning/designs/principles.md` and any obviously-related design docs first (grep `planning/designs/` for the name). Without principles context the redesign-space section is shallow.
2. Search the codebase broadly. Use ripgrep with case-insensitive and word-boundary variants. The concept may appear as snake_case, CamelCase, SFDC `__c`, dashed slug, or human prose.
3. For each hit, decide which facet it belongs to. Don't list every hit — pick the canonical example per facet.
4. Spawn a parallel Explore subagent only if the concept spans `code/`, `mcp/`, and `planning/` and a single pass would be too shallow.
5. Write the report. file:line citations are mandatory.

## Rules

- Read-only. Don't edit code. The goal is a faithful map, not a fix.
- If the concept doesn't exist (zero hits), say so plainly and suggest 2–3 close-by terms the user may have meant.
- Don't propose a redesign solution in the report — only the *space* where one could live. The user will steer the design conversation that follows.
- If the audit takes more than ~6 tool calls of grep/read, summarize what you found so far and ask whether to keep going. Don't silently keep digging.
