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
