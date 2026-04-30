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

shopt -s checkwinsize histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null
bind 'set colored-stats on' 2>/dev/null
bind 'set show-all-if-ambiguous on' 2>/dev/null
bind 'set completion-ignore-case on' 2>/dev/null
bind 'set menu-complete-display-prefix on' 2>/dev/null

export LS_COLORS=""
__PURR_STATE=0
__PURR_CMD_START=""

alias ls='ls --color=auto --group-directories-first -h'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

alias clear='clear; __PURR_STATE=2'
alias c='clear'

PS0='${__PURR_CMD_START:+}$(: "${__PURR_CMD_START:=$EPOCHREALTIME}")'

purrprompt_builder() {
    local EXIT_CODE=$?

    if [ "$__PURR_STATE" -eq 0 ]; then
        if command -v pfetch &> /dev/null; then
            sleep 0.2
            clear
            pfetch
        fi
        __PURR_STATE=1
    elif [ "$__PURR_STATE" -eq 2 ]; then
        __PURR_STATE=1
    else
        echo ""
    fi

    local DURATION_STR=""
    if [[ -n "$__PURR_CMD_START" ]]; then
        local NOW=$EPOCHREALTIME
        local ELAPSED=$(( ${NOW%.*} - ${__PURR_CMD_START%.*} ))
        if (( ELAPSED >= 1 )); then
            if (( ELAPSED >= 3600 )); then
                DURATION_STR=" $((ELAPSED/3600))h$((ELAPSED%3600/60))m"
            elif (( ELAPSED >= 60 )); then
                DURATION_STR=" $((ELAPSED/60))m$((ELAPSED%60))s"
            else
                DURATION_STR=" ${ELAPSED}s"
            fi
        fi
    fi
    __PURR_CMD_START=""

    # Round powerline caps (U+E0B6 left, U+E0B4 right)
    local RR=$'\uE0B4'

    local BG_S0="\[\e[48;2;49;50;68m\]"
    local FG_S0="\[\e[38;2;49;50;68m\]"

    local PINK="\[\e[38;2;245;194;231m\]"
    local MAUVE="\[\e[38;2;203;166;247m\]"
    local RED="\[\e[38;2;243;139;168m\]"
    local PEACH="\[\e[38;2;250;179;135m\]"
    local YELLOW="\[\e[38;2;249;226;175m\]"
    local GREEN="\[\e[38;2;166;227;161m\]"
    local TEAL="\[\e[38;2;148;226;213m\]"
    local BLUE="\[\e[38;2;137;180;250m\]"
    local LAVENDER="\[\e[38;2;180;190;254m\]"
    local OVERLAY="\[\e[38;2;88;91;112m\]"
    local RESET="\[\e[0m\]"

    local GIT_SEG=""
    local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        local GIT_COLOR="${MAUVE}"
        local GIT_ICON=""
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            GIT_COLOR="${PEACH}"
            GIT_ICON=" *"
        fi
        GIT_SEG=" ${OVERLAY}│ ${GIT_COLOR} ${BRANCH}${GIT_ICON}"
    fi

    local STATUS=""
    if [[ -n "$DURATION_STR" ]]; then
        STATUS+=" ${OVERLAY}│ ${PEACH}${DURATION_STR}"
    fi

    local JOB_COUNT=$(jobs -rp 2>/dev/null | wc -l)
    if (( JOB_COUNT > 0 )); then
        STATUS+=" ${OVERLAY}│ ${LAVENDER} 󰜎 ${JOB_COUNT}"
    fi

    if [ $EXIT_CODE -ne 0 ]; then
        STATUS+=" ${OVERLAY}│ ${RED}  ${EXIT_CODE}"
    fi

    local PROMPT_ARROW="${GREEN}❯${RESET}"
    if [ $EXIT_CODE -ne 0 ]; then
        PROMPT_ARROW="${RED}❯${RESET}"
    fi

    PS1="${BG_S0}${TEAL}  \A ${OVERLAY}│ ${PINK} \u ${OVERLAY}@ ${BLUE}󰒋 \h ${OVERLAY}│ ${YELLOW} \w${GIT_SEG}${STATUS} ${RESET}${FG_S0}${RR}\n${PROMPT_ARROW} "
}

PROMPT_COMMAND=purrprompt_builder
. "$HOME/.cargo/env"