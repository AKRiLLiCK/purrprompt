<div align="center">
  <img src="logo.svg" alt="PurrPrompt Logo" width="200"/>
  <h1>PurrPrompt</h1>

  ![License: MIT](https://img.shields.io/badge/License-MIT-89b4fa.svg?style=flat-square)![Bash](https://img.shields.io/badge/Bash-%3E%3D5.0-a6e3a1.svg?logo=gnu-bash&logoColor=ffffff&style=flat-square)![Catppuccin](https://img.shields.io/badge/Catppuccin-Mocha-cba6f7.svg?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgdmlld0JveD0iMCAwIDI0IDI0Ij48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSIxMCIgZmlsbD0iI2NiYTZmNyIvPjwvc3ZnPg==)

</div>

A native Bash prompt that delivers powerline-grade visual density using only raw ANSI escape sequences, state management, and zero external binary calls for rendering. Strict adherence to the **Catppuccin Mocha** palette.

Bash relies on synchronous evaluation of `PS1` and `PROMPT_COMMAND`. Unlike Zsh (async worker threads) or Fish (native async), extending Bash visually often blocks the input loop during heavy I/O. PurrPrompt avoids this entirely — no compiled cross-shell binaries, no frameworks, just Bash.

---

## ![Features](https://img.shields.io/badge/-Features-cba6f7?style=for-the-badge)

### Visuals
- **Powerline Segments** — Joined, rounded segments with smooth transitions between `Surface0` and `Surface1` backgrounds using powerline glyphs (`` `` ``)
- **Full Catppuccin Mocha Palette** — Rosewater, Flamingo, Pink, Mauve, Red, Maroon, Peach, Yellow, Green, Teal, Sky, Sapphire, Blue, Lavender across prompt elements
- **Nerd Font Icons** — Contextual glyphs for time (``), user (``), host (`󰒋`), directory (``), git (``), dirty state (``), errors (``), jobs (`󰜎`), and duration (``)

### Prompt Architecture
- **Pure Bash Execution** — The entire prompt assembles using only Bash built-ins. No subshells or forks for rendering
- **State Management** — Terminal clear events (`Ctrl+L`, `clear`) are tracked via `__PURR_STATE` to prevent duplicate separators and blank line artifacts
- **Synchronous Git Parsing** — Branch name and dirty/clean status detected via `git rev-parse` and `git status --porcelain`
- **Exit Code Display** — Failed commands show the actual exit code (e.g., `127`, `1`) as a red badge, plus the arrow changes color
- **Command Duration** — Execution time tracked via `$EPOCHREALTIME` (Bash 5.0+) using `PS0`. Only displayed when a command takes ≥ 1 second, formatted as `5s`, `2m30s`, or `1h5m`
- **Background Jobs Indicator** — Displays a count when running background processes are detected

### Workflow Enhancements
- **History Search** — `Up`/`Down` arrows search history by prefix (type `git` then press `Up` to find your last `git` command)
- **Smart Tab Completion** — Case-insensitive, colored stats, instant display on ambiguity
- **Startup Banner** — Runs `pfetch` on first terminal open with GPU-safe initialization delay
- **LS_COLORS** — Catppuccin-mapped directory, symlink, executable, and archive colors

---

## ![Dependencies](https://img.shields.io/badge/-Dependencies-94e2d5?style=for-the-badge)

| Dependency | Purpose | Required |
|---|---|---|
| `bash` ≥ 5.0 | `$EPOCHREALTIME` for command timing | ✅ |
| A [Nerd Font](https://www.nerdfonts.com/) | Powerline glyphs and icons | ✅ |
| `git` | Repository status in prompt | Optional |
| `pfetch` | Startup session banner | Optional |

---

## ![Installation](https://img.shields.io/badge/-Installation-f9e2af?style=for-the-badge)

```bash
# Clone
git clone https://github.com/AKRiLLiCK/purrprompt.git

# Symlink or source in your existing .bashrc
echo 'source ~/purrprompt/.bashrc' >> ~/.bashrc

# Reload
source ~/.bashrc
```

---

## ![License](https://img.shields.io/badge/-License-f9e2af?style=for-the-badge)

This project is licensed under the [MIT License](https://mit-license.org/).