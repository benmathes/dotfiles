# Subagent model routing (global directive)

Claude Code has no automatic difficulty→model router. When you spawn a subagent
(the Agent/Task tool), set its `model` explicitly, sized to the difficulty of
THAT subagent's task — not the main thread's model:

- `model: sonnet` — SIMPLE / mechanical: searches, file & code lookups, routine
  edits, summarizing, formatting, running commands, gathering facts.
- `model: opus`   — HARD: non-trivial implementation, multi-file refactors, real
  debugging, architecture & design reasoning, security review — anything needing
  careful multi-step reasoning.
- `model: fable`  — VERY HARD only: highly novel, cross-domain, or net-new
  problems with no established pattern or prior art to lean on.

Don't let a subagent silently `inherit` an expensive main-thread model for cheap
work. Haiku isn't used for subagents. If a subagent's task is genuinely as hard
as the main thread's, set the matching tier explicitly rather than relying on
inherit.
