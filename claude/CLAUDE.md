## Development Workflow: Mandatory TDD
- **Test-First Requirement**: For any new feature or bug fix, you MUST write the tests first before writing implementation code.
- **Verification Loop**:
  1. Create unit tests (they should initially fail).
  2. Don't create excessive testing. mutually exclusive and collectively exhaustive
  2. Run tests to confirm failure.

- **No Test Removal**: It is unacceptable to remove or edit existing tests unless the underlying requirements have explicitly changed.

## Critical Testing Commands
- **Run Unit Tests**: you should infer from the project or from repo-specific config files what the test commands are

## Guardrails
- **Pre-Commit Check**: You must run all tests and verify they pass before suggesting a `git commit`.
- **Regression Check**: When modifying existing functions, ensure a test exists; if not, create one before making changes.

Unless overridden by a specific repo:
## Feature development
- develop on a separate, per-feature git (or similar version control) branch
- name the branch based on the work we are doing, with snake_case
- When I first am discussing a new feature, interview me in detail using the AskUserQuestionTool about the feature: technical implementation, UI & UX, concerns, tradeoffs, etc. that we haven't covered.
- every repo should have some strategic dimensions, like "A even over B" statements such as "stability even over speed" or "cheap even over quality" or similar "Real Strategy". If none exist, interview me about what you think the key dimensions (3-5) should be and write that into that repo's LEARNINGS.md

## LEARNING LOOP IN EACH REPO
* always create a .claude/LEARNINGS.md file if it's not there. It should be checked in and then in context for any claude code sessions.
* Log Every Friction Point: If a build fails, a test hangs, or a logic error occurs, document the root cause and the specific fix before proceeding.
* Mandatory Update on Intervention: If you stop to ask for guidance, or if I provide a correction, you must update learnings.md with the "Signpost" (the specific instruction or realization) that prevented you from succeeding independently.
* Iterate Toward Autonomy: Use the existing log to avoid repeating mistakes. Your goal is to reach a state where you can complete the objective without manual triggers.

## Spec Mode vs Engineering Design Mode
When brainstorming or doing product/feature discovery, stay in "WHAT" (spec) mode, not "HOW" (eng design) mode.
- **WHAT (spec)**: "The system needs to track which actions contributed to which deals"
- **HOW (eng design)**: "Use a vector embedding with pgvector for semantic similarity"
Vector embeddings, specific database choices, API design - these are HOW. They should be deferred to implementation, not mixed into spec-level brainstorming. If you find yourself naming specific technologies or implementation patterns during brainstorming, pull back to describing what the system does, not how it does it.

## Design Docs Organization
All markdown planning and design docs live under `planning/` at the repo root. Never create a root `designs/` folder.
- `planning/designs/unbuilt/` - Unbuilt/pending feature designs
- `planning/designs/built/` - Implemented feature designs
- `planning/product/` - Product descriptions and vision
- `planning/strategy/` - Strategic tradeoffs and dimensions

No design files should live directly in `planning/designs/` - always use the `unbuilt/` or `built/` subfolder. When a feature is implemented, move its design doc from `planning/designs/unbuilt/` to `planning/designs/built/`. Update any symlinks in `.claude/commands/` accordingly.

## Post-Feature Consolidation Check
After completing any feature, ask: "What does this replace, overlap with, or obsolete?"

If consolidation candidates exist:
1. Discuss with user before any removal
2. Create structured entry in `planning/designs/unbuilt/consolidation-<name>.md`
3. Split removal work to a separate branch

This guards against: feature bloat, combinatorial state/bug explosion, and pager burden. These systems must be maintainable by one person.
