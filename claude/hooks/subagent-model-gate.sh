#!/usr/bin/env bash
# Global PreToolUse gate for the Agent/Task (subagent) tool.
#
# Blocks a TOP-LEVEL subagent spawn that omits `model`, forcing an explicit,
# difficulty-sized choice (see subagent-model-routing.md). Spawns from INSIDE a
# subagent — skills running as forked subagents, nested agents — carry a caller
# `agent_id` in the hook payload and are allowed through; with no model they
# inherit the main session model, which is the desired default there.
#
# Fails OPEN: malformed/unexpected input always allows the spawn, so this hook
# can never wedge tooling. Only a positively-identified top-level, no-model,
# valid-JSON Agent spawn is denied.
#
# Verified live (2026-07-28): top-level no-model spawn -> DENIED; spawn with an
# explicit model -> allowed; nested spawn from inside a subagent -> allowed;
# Workflow agent() spawn with no model -> allowed (workflow spawns bypass this
# gate or present as nested, so deterministic workflows are never blocked).

input="$(cat)"

# Not valid JSON? Allow (fail open).
if ! printf '%s' "$input" | jq -e . >/dev/null 2>&1; then
  exit 0
fi

# Was a model explicitly set on this spawn?
model="$(printf '%s' "$input" | jq -r '.tool_input.model // empty')"
# Is the CALLER itself a subagent? (agent_id is present only inside subagent contexts.)
caller="$(printf '%s' "$input" | jq -r '.agent_id // empty')"

# Allow if a model is set, or if this is a nested (skill/subagent) spawn.
if [ -n "$model" ] || [ -n "$caller" ]; then
  exit 0
fi

# Top-level spawn with no model -> deny with actionable guidance for the model.
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"This subagent spawn has no explicit model. Choose one sized to the task difficulty: model: sonnet (simple), model: opus (hard), or model: fable (very hard or novel). Nested spawns from skills or subagents are exempt and inherit the main session model. See ~/.claude/hooks/subagent-model-routing.md for the full rule."}}
JSON
exit 0
