# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS + bash + vim. Configuration files are symlinked to the home directory.

## Setup Commands

Install dotfiles by creating symlinks (will prompt for each file):
```bash
bin/symlinks
```

Apply macOS preferences (run individual scripts in `bin/osx/`):
```bash
bin/osx/NSGlobalDomain
bin/osx/com.apple.dock
# etc.
```

## Architecture

- **Root dotfiles**: Configuration files (`.bash_profile`, `.vimrc`, `.gitconfig`, etc.) that get symlinked to `~`
- **bin/symlinks**: Interactive installer that creates symlinks with confirmation prompts
- **bin/osx/**: macOS preference scripts using `defaults write` commands
- **vim.colors/**: Custom vim colorscheme (vilight) symlinked to `~/.vim/colors/`
- **git-completion.bash**: Git tab-completion sourced by `.bash_profile`

## Local Overrides

The configs support machine-specific customization via `.local` files (not tracked):
- `~/.bash_profile.local` - sourced by `.bash_profile`
- `~/.vimrc.local` - sourced by `.vimrc`
- `~/.gitconfig.local` - included by `.gitconfig`

## Key Conventions

- Vim uses pathogen for plugins, comma as leader key, 2-space indentation
- Git aliases in `.bash_profile`: `g`, `gb`, `gd`, `gs`, `gap`, `gc`, `gp`, `gch`
- Git tab-completion enabled for aliases via `__git_complete`

## Agent Safety: The Lethal Trifecta

Per [Simon Willison](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/), never combine all three of these in a single agent or tool chain:

1. **Access to private data** (files, emails, credentials, etc.)
2. **Exposure to untrusted content** (web pages, user-submitted text, public issues, emails from strangers)
3. **Ability to exfiltrate** (send emails, make HTTP requests, post to APIs)

Any two are manageable. All three together means an attacker can embed instructions in untrusted content that trick the agent into leaking private data. LLMs cannot reliably distinguish instruction source, so "guardrails" are not sufficient — avoid the combination entirely.


## Possibly using CMUX

# CMUX Environment & Tooling Rules

Check if you are running inside cmux, a specialized terminal multiplexer built for parallel AI multi-agent orchestration. if so, You have full programmatic access to cmux windows, sidebars, panes, and an embedded browser via the native `cmux` CLI command. Use it to optimize parallel tasks, handle asynchronous processes, and notify the user when input is required.

## 1. Multi-Agent & Git Worktree Parallelism
- **Parallel Feature Branching**: When the user requests multiple independent features or bug fixes simultaneously, do not work sequentially. Use the `cmux` primitive to spawn isolated Git worktrees so you do not cause state pollution or git conflicts.
  - To spin up a parallel agent on a new branch: `cmux new <branch-name>`
- **Background Task Isolation**: Never block your main interactive loop with long-running scripts (e.g., dev servers, bulk docker builds, exhaustive test suites). Use split panes to run them in the background:
  - Create vertical split pane: `cmux split -v -- <command>`
  - Create horizontal split pane: `cmux split -h -- <command>`

## 2. Notification Rings & Status Badges
- **Human-in-the-Loop Interruption**: When executing commands that require manual user approval, or when waiting for a prompt response, trigger a visual alert so the user knows you need attention.
  - Flash the current window rim blue & play alert: `cmux notification trigger-flash`
- **Sidebar Status Tracking**: Keep the cmux sidebar metadata synchronized with your actual intent. Whenever you transition to a new phase (e.g., installing dependencies, compiling, testing), update your workspace tab status so the user can monitor your progress at a glance:
  - Update status string: `cmux status "Running unit tests (14/42)..."`

## 3. Embedded Browser Preview & E2E Testing
- **Visual Validation**: When editing UI, CSS, front-end features, or modifying local APIs, do not blindly assume success. Launch cmux's integrated Chromium instance side-by-side with your terminal pane to inspect the app.
  - Open localhost in a browser pane: `cmux browser open http://localhost:3000`
- **Scripted E2E Testing**: You can interact with and read from the active cmux browser pane to verify your work programmatically:
  - Extract accessibility tree / HTML text: `cmux browser dump`
  - Simulate a user click on an element: `cmux browser click "#submit-btn"`
  - Take a screenshot for context: `cmux browser screenshot ./tmp/capture.png`

## 4. UI Context Optimization
- **Clean Workspace Environment**: If you are launching a complex sub-agent framework or need maximum workspace area for log streams, optimize the screen layout for scannability:
  - Hide/Show the sidebar layout: `cmux sidebar toggle`
  - Maximize the active terminal pane focus: `cmux pane maximize`
