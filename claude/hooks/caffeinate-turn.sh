#!/usr/bin/env bash
# Toggle caffeinate around Claude Code's working state (per-turn).
#
# - start: spawn caffeinate, also watching the claude PID (-w) so it
#   auto-exits if claude dies before Stop fires. Records caffeinate's PID.
# - stop:  kill the recorded caffeinate. Normal end-of-turn path.
#
# Usage:
#   caffeinate-turn.sh start <session_id> <claude_pid>
#   caffeinate-turn.sh stop  <session_id>
set -euo pipefail
state_dir="${HOME}/.claude/caffeinate-state"
mkdir -p "${state_dir}"
session_id="${2:?session_id required}"
pid_file="${state_dir}/${session_id}.pid"

case "${1:-}" in
  start)
    claude_pid="${3:?claude_pid required}"
    [ -s "${pid_file}" ] && kill "$(cat "${pid_file}")" 2>/dev/null || true
    nohup caffeinate -i -m -s -w "${claude_pid}" >/dev/null 2>&1 &
    echo $! > "${pid_file}"
    disown 2>/dev/null || true
    ;;
  stop)
    [ -s "${pid_file}" ] && kill "$(cat "${pid_file}")" 2>/dev/null || true
    rm -f "${pid_file}"
    ;;
  *)
    echo "Usage: $0 {start|stop} <session_id> [<claude_pid>]" >&2
    exit 1
    ;;
esac
