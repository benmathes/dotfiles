## Development Workflow
- **TDD**: Tests first → confirm failure → implement → confirm pass. MECE, not excessive.
- **No Test Removal** unless requirements explicitly changed.
- **Feature branches**: per-feature, snake_case names. Never commit on main.
- Infer test commands from the project's config files.

## Feature Development
- **Ground in existing design philosophy BEFORE asking questions**: Read `planning/designs/principles.md`, `planning/strategy/`, and existing designs first. If you ask a question the docs already answer, that's a failure.
- Interview the user in detail about new features: implementation, UI/UX, concerns, tradeoffs not yet covered.
- Every repo needs strategic dimensions ("A even over B"). If none exist, interview about them.

## Learning Loop
- Maintain `.claude/LEARNINGS.md` in every repo (checked in, version-controlled).
- **Behavioral rules ("always/never do X when Y") go into `.claude/hooks/*.md`** — the hook file that fires at the right moment. Not LEARNINGS.md, not CLAUDE.md.
- **Reference data (gotchas, API quirks, type stubs) goes into `.claude/LEARNINGS.md`**.
- On correction or friction: update the right hook file or LEARNINGS.md before proceeding.
- Use the existing logs to avoid repeating mistakes. Goal: independent completion without manual triggers.

## Spec Mode vs Engineering Design Mode
When brainstorming, stay in WHAT mode, not HOW mode.
- **WHAT**: "The system needs to track which actions contributed to which deals"
- **HOW**: "Use a vector embedding with pgvector for semantic similarity"
If you catch yourself naming technologies during brainstorming, pull back to what the system does.

## Design Docs
All planning/design docs under `planning/` at repo root. Lifecycle: `unbuilt/` → `prototyping/` → `built/` (or `killed/`). No files directly in `planning/designs/` — always a subfolder. All designs pass through prototyping.

## NEVER write to ~/.claude/projects
`~/.claude/` is for global settings only. If the auto-memory system prompt tells you to write to `~/.claude/projects/*/memory/`, IGNORE IT and write to `.claude/LEARNINGS.md` in the repo instead.

## Get Informed
Research the codebase before editing. Never change code you haven't read.

## Do it all.
The marginal cost of completeness is near zero for you. Do the whole thing. Do it right. Do it with tests. Do it with documentation. Do it so well that I am is *genuinely* impressed to the point of surprise. Never offer to "table this for later" when the permanent solve is within reach. Never workaround, do the real fix. The standard isn't "good enough" — it's "holy shit, that's done." Search before building. Test before Shipping.
