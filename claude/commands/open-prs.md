# Open PRs

Open every pull request this session is working on, each in the browser with macOS `open`, so they are all in front of the user at once.

User triggers via `/open-prs`, "open my PRs", "open the PRs we're working on", or similar. By default it opens only the un-merged ones; `/open-prs all` opens the merged ones too.

## Which PRs

The pull requests this session has worked on, in any repo: ones it opened, pushed to, reviewed or replied on, merged, or was asked to merge.

1. Collect them from this conversation, compacted summaries included. Take exact URLs (`https://github.com/<owner>/<repo>/pull/<n>`) or `<owner>/<repo>#<n>`; never guess a repo or a number.
2. A long or compacted session can hold more than its summaries name, so also read them off this session's own transcript. If your scratchpad directory is `…/<project>/<session>/scratchpad`, the transcript is `~/.claude/projects/<project>/<session>.jsonl`.
   - Read only what this session itself said and ran (assistant entries), never tool output, which can carry any page's links.
   - Collect PR URLs, `gh pr <verb> <n> --repo <owner>/<repo>` commands, and `repos/<owner>/<repo>/pulls/<n>` API paths. A PR touched only as `gh pr view 799` with no URL or `--repo` still shows up, since it is in step 1's conversation.

   ```
   python3 -I - "$HOME/.claude/projects/<project>/<session>.jsonl" <<'EOF'
   import json, re, sys
   urls = set()
   URL = re.compile(r"https://github\.com/([\w.-]+/[\w.-]+)/pull/(\d+)")
   GH = re.compile(r"gh pr [a-z]+ (\d+)\b[^\n|;&]*?--repo[ =]([\w.-]+/[\w.-]+)")
   API = re.compile(r"repos/([\w.-]+/[\w.-]+)/pulls/(\d+)")
   for line in open(sys.argv[1], errors="replace"):
       try:
           entry = json.loads(line)
       except ValueError:
           continue
       if entry.get("type") != "assistant":
           continue
       text = json.dumps(entry.get("message", {}))
       urls |= {f"https://github.com/{r}/pull/{n}" for r, n in URL.findall(text)}
       urls |= {f"https://github.com/{r}/pull/{n}" for n, r in GH.findall(text)}
       urls |= {f"https://github.com/{r}/pull/{n}" for r, n in API.findall(text)}
   print("\n".join(sorted(urls)))
   EOF
   ```

3. Merge the two lists, one entry per PR.

## Open them

4. Check each one's state: `gh pr view <url> --json state,title,url --jq '"\(.state)\t\(.url)\t\(.title)"'`. By default keep every one that is not `MERGED`: `OPEN` (drafts included) and `CLOSED` without merging. With `all`, keep the `MERGED` ones too. A PR `gh` cannot read is not opened and is named in the report.
5. Open the kept URLs in one call: `open <url> <url> …`. Pass `open` nothing but `https://github.com/…/pull/<n>` URLs.
6. Report one line per PR: number, title, state, and whether it was opened. If nothing is left to open, say so and open nothing.

## Never

- Never fall back to searching GitHub for every PR the user authored, or every open PR in a repo: those are not this session's work.
