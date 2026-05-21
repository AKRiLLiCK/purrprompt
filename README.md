<p align="center">
  <img src="logo.svg" width="128" alt="PurrPrompt logo" />
</p>

<h1 align="center">PurrPrompt</h1>

<p align="center">
  <img src="https://img.shields.io/badge/shell-bash-89b4fa?style=flat-square&logo=gnubash&logoColor=white" alt="Bash" />
  <img src="https://img.shields.io/badge/theme-catppuccin-cba6f7?style=flat-square&logo=catppuccin&logoColor=white" alt="Catppuccin" />
  <img src="https://img.shields.io/badge/deps-zero-a6e3a1?style=flat-square" alt="Zero dependencies" />
  <img src="https://img.shields.io/badge/license-MIT-f9e2af?style=flat-square" alt="MIT" />
</p>

<p align="center">
  <em>A tiny, purring Bash prompt with Catppuccin colors, async Git, and a love for naps.</em>
</p>

---

## Features

| | Feature | What it does |
|---|---|---|
| 🎨 | **Adaptive theme** | Auto-detects GNOME light/dark mode; switches between Catppuccin Latte & Mocha instantly |
| 🌿 | **Async Git** | Stale-while-revalidate cache — zero rendering latency, even in huge repos |
| ⏱️ | **Exec timer** | Tracks command duration down to the millisecond |
| 🔍 | **fzf integration** | Pre-wired fuzzy history, file, and directory search |
| 🧹 | **Smart clear** | `c` / `clear` resets the screen and runs `pfetch` or `fastfetch` |
| 🐾 | **Pure Bash** | No Starship, no Oh-My-Posh — just a `.bashrc` |

## Prerequisites

| Tool | Why |
|---|---|
| [Nerd Font](https://www.nerdfonts.com/) | Prompt icons |
| [`fzf`](https://github.com/junegunn/fzf) | Fuzzy finding |
| `git` | Branch & dirty-state info |
| `gsettings` | Light/dark detection (ships with GNOME) |
| `pfetch` / `fastfetch` | *(optional)* Shown on clear |

## Install

```bash
git clone https://github.com/AKRiLLiCK/purrprompt.git
cp purrprompt/.bashrc ~/.bashrc   # or append to your existing one
source ~/.bashrc
```

## Theme Adaptation

PurrPrompt checks GNOME's color-scheme on every prompt render:

| System scheme | Palette |
|---|---|
| `prefer-dark` | **Catppuccin Mocha** |
| `default` / `prefer-light` | **Catppuccin Latte** |

Toggle your system theme — the prompt follows on the very next command. No restart needed. 🐱

## Prompt Segments

| Indicator | Meaning |
|---|---|
| ⏱️ duration | Previous command took > 0 ms |
| 🌿 branch `*` | Inside a Git repo (`*` = dirty tree) |
| 📌 count | Background jobs running |
| ❌ code | Last command exited non-zero |

## Keybindings

| Keys | Action |
|---|---|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy search files (pastes path) |
| `Alt+C` | Fuzzy search & `cd` into directory |

> **Tip** — type `purrprompt` in your terminal for the built-in cheat sheet!

## Architecture

- **Theme detection** — `__purr_detect_theme` calls `gsettings` once per render; both the prompt and the help command share the result.
- **Git polling** — Uses `git diff-index` + `git ls-files` instead of `git status --porcelain` to minimize I/O.
- **Eventual consistency** — The async worker updates a cache file; changes appear one command after they occur.

---

<p align="center"><sub>made with 💜 and cat hair</sub></p>