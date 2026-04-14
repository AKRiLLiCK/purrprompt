<div align="center">
  <img src="logo.svg" alt="PurrPrompt Logo" width="200"/>
  <h1>PurrPrompt</h1>

  ![License: MIT](https://img.shields.io/badge/License-MIT-89b4fa.svg?style=flat-square)![Bash](https://img.shields.io/badge/Bash-%3E%3D4.0-a6e3a1.svg?logo=gnu-bash&logoColor=ffffff&style=flat-square)
  
</div>

Bash relies on synchronous evaluation of `PS1` and `PROMPT_COMMAND`. Unlike Zsh, which supports asynchronous worker threads, or Fish, which has native async capabilities, extending Bash visually often blocks the input loop during heavy I/O operations. This architectural limitation typically forces users toward compiled cross-shell binaries (like Starship) to manage execution overhead, or heavy Zsh frameworks (like Powerlevel10k). 

PurrPrompt is a native Bash implementation that utilizes raw ANSI escape sequences and state management to deliver high-density data and visual hierarchy without external binary execution for prompt rendering. It strictly adheres to the Catppuccin Mocha palette.

---

## ![Features](https://img.shields.io/badge/-Architecture_%26_Features-cba6f7?style=for-the-badge)

- **Pure Bash Execution:** Prompt rendering relies entirely on `PROMPT_COMMAND` array execution and variable assignment. Zero external binary calls are made for the prompt string assembly itself.
- **Palette Compliance:** Hardcoded ANSI sequences mapped exactly to Catppuccin Mocha hex values.
- **State Management (`__PURR_STATE`):** Implements a state machine to track terminal clearing events (`clear`), preventing duplicate visual separators or `\n` artifacts that plague standard multiline Bash prompts.
- **Synchronous Git Parsing:** Evaluates `git rev-parse` and `git status --porcelain` to indicate branch and dirty state via Nerd Font glyphs.
- **Execution Code Hook:** Captures `$?` prior to prompt rendering to toggle the prompt arrow color (Success/Failure).

## ![Dependencies](https://img.shields.io/badge/-Dependencies-94e2d5?style=for-the-badge)

* `bash` (v4.0 or higher recommended for associative array support if expanded in the future)
* `git` (Accessible in `$PATH` for repository status)
* `fastfetch` (For the initial session initialization banner)
* A patched [Nerd Font](https://www.nerdfonts.com/) configured in your terminal emulator (e.g., JetBrainsMono NF).

## ![License](https://img.shields.io/badge/-License-f9e2af?style=for-the-badge)

This project is licensed under the [MIT License](https://mit-license.org/).