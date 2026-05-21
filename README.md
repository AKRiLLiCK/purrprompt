# PurrPrompt 󰄛

A highly optimized, dependency-lean Bash prompt built with the Catppuccin color palette. It features adaptive system theme detection, non-blocking asynchronous Git status, high-precision execution timing, and native integration with `fzf` for fuzzy finding.

## Features

* **Adaptive System Theme**: Automatically detects your GNOME color-scheme (`gsettings`) and switches between **Catppuccin Latte** (light) and **Catppuccin Mocha** (dark) palettes in real-time — no restart or re-sourcing required.
* **Asynchronous Git Status**: Implements a Stale-While-Revalidate (SWR) caching mechanism. Git index queries (`git diff-index`) run in an isolated background subshell, guaranteeing zero rendering latency even in massive monorepos.
* **Execution Timer**: Accurately tracks command duration down to the millisecond (`ms`, `s`, `m`, `h`, `d`).
* **Fuzzy Finding Integration**: Pre-configured hooks for `fzf` command and file navigation.
* **Stateful Clear**: Custom clear alias (`c`) that seamlessly integrates with `pfetch` on execution.
* **Native Readline Compatibility**: Safely maps multi-line structures to `PS1` to prevent buffer corruption during `Ctrl+L` (clear-screen) operations.
* **Minimalist Footprint**: Pure Bash logic. No compiled prompt engines (like Starship or Oh-My-Posh) required.

## Prerequisites

To render the prompt correctly and utilize all features, you must have the following installed:

* A **Nerd Font** (for the UI icons: `󰄛`, ``, `󰔟`, etc.)
* **`fzf`** (required for the fuzzy finding shortcuts)
* **`git`** (for repository status)
* **`gsettings`** (ships with GNOME — used for automatic light/dark theme detection)
* **`pfetch`** or **`fastfetch`** (optional, triggered when clearing the terminal)

## Installation

1. Clone this repository or copy the `.bashrc` file.
2. Replace or append the contents to your existing `~/.bashrc`.
3. Source the file to apply the changes immediately:

```bash
source ~/.bashrc
```

## Theme Adaptation

PurrPrompt queries the GNOME desktop color-scheme on every prompt render:

```
gsettings get org.gnome.desktop.interface color-scheme
```

| System Scheme | Palette Applied |
| --- | --- |
| `prefer-dark` | **Catppuccin Mocha** (dark) |
| `default` / `prefer-light` | **Catppuccin Latte** (light) |

Toggle your system theme at any time — the prompt adapts on the very next command with no manual intervention.

## Prompt Indicators

The prompt dynamically displays segments based on the current environment state:

| Icon | Description | Trigger Condition |
| --- | --- | --- |
| `󰔟` | **Execution Timer** | Displays if the previous command took > 0ms. |
| `` | **Git Branch** | Displays when inside a Git repository. Adds `*` if the working tree is dirty. |
| `󰜎` | **Background Jobs** | Displays the count of active background jobs (`jobs -rp`). |
| `󰅙` | **Exit Code** | Displays the numeric exit code if the previous command failed. |

## Shortcuts & Keybindings

PurrPrompt includes a built-in quick reference menu. Type `purrprompt` in your terminal to view it, or check the embedded hints on the right side of the prompt bar.

### Commands

* `c` or `clear`: Clears the terminal and executes `pfetch` / `fastfetch`.
* `purrprompt`: Prints the feature and shortcut cheat sheet.

### Fuzzy Finding (via `fzf`)

* `⌃R` (**Ctrl + R**): Fuzzy search your command history.
* `⌃T` (**Ctrl + T**): Fuzzy search files in the current directory tree (pastes path into prompt).
* `⌥C` (**Alt + C**): Fuzzy search directories and instantly `cd` into the selection.

## Architecture Notes

* **Theme Detection**: The `__purr_detect_theme` function runs `gsettings` once per prompt render. Both `purrprompt_builder` (the prompt itself) and `purrprompt` (the help command) use the detected theme to select the correct palette.
* **Git Polling**: The prompt intentionally avoids `git status --porcelain` in favor of lower-level index checks (`git diff-index` and `git ls-files`). This significantly reduces I/O overhead.
* **Eventual Consistency**: Because the Git check is asynchronous, branch changes or commits are reflected exactly one command *after* the change occurs. The prompt renders instantly using the last known cached state while the background worker updates the cache for the next render.