# ────────────────────────────────────────────────────────────────────────
#   ▄▄▄▄▄▄                                                  
#  █▀██▀▀▀█▄                                              █▄ 
#    ██▄▄▄█▀     ▄    ▄         ▄                        ▄██▄▄
#    ██▀▀▀██ ██ ████▄████▄████▄ ████▄▄███▄ ███▄███▄ ████▄ ██
#  ▄ ██   ██ ██ ██   ██   ██ ██ ██   ██ ██ ██ ██ ██ ██ ██ ██ 
#  ▀██▀  ▄▀██▀█▄█▀  ▄█▀  ▄████▀▄█▀   ▀███▀▄██ ██ ▀█▄████▀▄██ 
#                         ██                        ██       
#                         ▀                         ▀        
# ────────────────────────────────────────────────────────────────────────

# --- 1. Shell Configuration ---
shopt -s checkwinsize              # Update window size after every command
bind 'set colored-stats on'
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# LS_COLORS (Dir=Blue, Link=Pink, Exe=Green, Archive=Red, Image=Yellow)
export LS_COLORS="di=1;38;2;137;180;250:ln=1;38;2;245;194;231:ex=1;38;2;166;227;161:*.tar=01;31:*.zip=01;31:*.jpg=01;33:*.png=01;33:*.sh=01;32"

# --- 2. State Management ---
# 0 = Init (Pending Fastfetch) | 1 = Active (Separator) | 2 = Clean (No separator)
__PURR_STATE=0

# --- 3. Aliases ---
alias ls='ls --color=auto --group-directories-first -h'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Clear screen and reset state to 2 (snaps prompt to top)
alias clear='clear; __PURR_STATE=2'
alias c='clear'

# --- 4. Prompt Logic ---
purrprompt_builder() {
    local EXIT_CODE=$?
    local SEPARATOR=""

    # Startup Logic (Fixes window resize race conditions)
    if [ "$__PURR_STATE" -eq 0 ]; then
        if command -v fastfetch &> /dev/null; then
            sleep 0.2      # Wait for GPU terminal to resize
            clear          # Wipe any render artifacts
            fastfetch
        fi
        SEPARATOR=""       # No extra newline after banner
        __PURR_STATE=1

    # Post-Clear Logic
    elif [ "$__PURR_STATE" -eq 2 ]; then
        SEPARATOR=""
        __PURR_STATE=1

    # Standard Logic
    else
        SEPARATOR="\n"
    fi

    # Palette (Catppuccin Mocha)
    local PINK="\[\e[38;2;245;194;231m\]"
    local YELLOW="\[\e[38;2;249;226;175m\]"
    local MAUVE="\[\e[38;2;203;166;247m\]"
    local GREEN="\[\e[38;2;166;227;161m\]"
    local RED="\[\e[38;2;243;139;168m\]"
    local BLUE="\[\e[38;2;137;180;250m\]"
    local TEAL="\[\e[38;2;148;226;213m\]"
    local OVERLAY="\[\e[38;2;147;153;178m\]"
    local RESET="\[\e[0m\]"

    # Icons (Nerd Fonts)
    local I_CLOCK=""
    local I_USER=""
    local I_HOST="󰒋"
    local I_FOLDER=""
    local I_GIT=""
    local I_EDIT=""
    local S_ARROW="❯"

    # Git Status Integration
    local GIT_STATUS=""
    if command -v git &> /dev/null; then
        local BRANCH
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "$BRANCH" ]; then
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                GIT_STATUS=" ${RED}${I_GIT} ${BRANCH} ${I_EDIT}${RESET}" # Dirty
            else
                GIT_STATUS=" ${MAUVE}${I_GIT} ${BRANCH}${RESET}"       # Clean
            fi
        fi
    fi

    # Error Handler
    local PROMPT_ARROW
    if [ $EXIT_CODE -eq 0 ]; then
        PROMPT_ARROW="${GREEN}${S_ARROW}${RESET}"
    else
        PROMPT_ARROW="${RED}${S_ARROW}${RESET}"
    fi

    # Prompt Assembly
    PS1="${SEPARATOR}${TEAL}${I_CLOCK} \A ${PINK}${I_USER} \u ${OVERLAY}@ ${BLUE}${I_HOST} \h\n${YELLOW}${I_FOLDER} \w${GIT_STATUS}\n${PROMPT_ARROW} "
}

PROMPT_COMMAND=purrprompt_builder
. "$HOME/.cargo/env"