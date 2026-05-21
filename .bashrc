# ────────────────────────────────────────────────────────────────────────
#  ____                 ____                           _ 
# |  _ \ _   _ _ __ _ _|  _ \ _ __ ___  _ __ ___  _ __| |_ 
# | |_) | | | | '__| '__| |_) | '__/ _ \| '_ ` _ \| '_ \ __|
# |  __/| |_| | |  | |  |  __/| | | (_) | | | | | | |_) | |_ 
# |_|    \__,_|_|  |_|  |_|   |_|  \___/|_| |_| |_| .__/ \__|
#                                                 |_| 
# ────────────────────────────────────────────────────────────────────────

eval "$(fzf --bash)"

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
__PURR_GIT_CACHE="/tmp/.purr_git_cache_$$"

alias ls='ls --color=auto --group-directories-first -h'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

alias clear='clear; __PURR_STATE=2'
alias c='clear'

PS0='${__PURR_CMD_START:=$EPOCHREALTIME}\e[1K\r'

purrprompt() {
    local MAUVE="\e[38;2;203;166;247m"
    local TEAL="\e[38;2;148;226;213m"
    local OVERLAY="\e[38;2;88;91;112m"
    local RESET="\e[0m"
    
    echo -e "${MAUVE}󰄛 PurrPrompt Features & Shortcuts${RESET}\n"
    
    echo -e "${TEAL}Commands:${RESET}"
    echo -e "  ${OVERLAY}󰃢 c, clear${RESET}    Clear terminal and display pfetch"
    echo -e "  ${OVERLAY}󰋖 purrprompt${RESET}  Show this help menu\n"
    
    echo -e "${TEAL}Fuzzy Finding (fzf):${RESET}"
    echo -e "  ${OVERLAY}󰋚 ⌃R${RESET}          Search command history"
    echo -e "  ${OVERLAY}󰈔 ⌃T${RESET}          Search files in current tree"
    echo -e "  ${OVERLAY}󰉋 ⌥C${RESET}          Search and cd into directory\n"
    
    echo -e "${TEAL}Prompt Indicators:${RESET}"
    echo -e "  ${OVERLAY}󰔟${RESET}  Execution duration (ms/s/m/h/d)"
    echo -e "  ${OVERLAY}${RESET}  Asynchronous Git branch (* = dirty)"
    echo -e "  ${OVERLAY}󰜎${RESET}  Background jobs count"
    echo -e "  ${OVERLAY}󰅙${RESET}  Non-zero exit code"
}

__purr_async_git_worker() {
    local target_dir="$PWD"
    local tmp_file="${__PURR_GIT_CACHE}.${EPOCHREALTIME}.tmp"
    local branch
    
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -z "$branch" ]]; then
        echo "${target_dir}|" > "$tmp_file"
        mv -f "$tmp_file" "$__PURR_GIT_CACHE"
        return
    fi

    local dirty="0"
    if ! git diff-index --quiet HEAD -- 2>/dev/null || [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
        dirty="1"
    fi

    echo "${target_dir}|${branch}|${dirty}" > "$tmp_file"
    mv -f "$tmp_file" "$__PURR_GIT_CACHE"
}

purrprompt_builder() {
    local EXIT_CODE=$?

    if [ "$__PURR_STATE" -eq 0 ]; then
        if command -v fastfetch &> /dev/null; then
            sleep 0.2
            clear
            fastfetch
        elif command -v pfetch &> /dev/null; then
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
        local START_SEC=${__PURR_CMD_START%%[.,]*}
        local START_MICRO=${__PURR_CMD_START#*[.,]}
        local NOW_SEC=${NOW%%[.,]*}
        local NOW_MICRO=${NOW#*[.,]}

        START_MICRO="${START_MICRO}000"
        NOW_MICRO="${NOW_MICRO}000"

        local SEC_DIFF=$(( NOW_SEC - START_SEC ))
        local MS_DIFF=$(( 10#${NOW_MICRO:0:3} - 10#${START_MICRO:0:3} ))

        if (( MS_DIFF < 0 )); then
            (( SEC_DIFF -= 1 ))
            (( MS_DIFF += 1000 ))
        fi

        local ELAPSED_MS=$(( SEC_DIFF * 1000 + MS_DIFF ))

        if (( ELAPSED_MS > 0 )); then
            local D=$(( ELAPSED_MS / 86400000 ))
            local H=$(( (ELAPSED_MS % 86400000) / 3600000 ))
            local M=$(( (ELAPSED_MS % 3600000) / 60000 ))
            local S=$(( (ELAPSED_MS % 60000) / 1000 ))
            local MS=$(( ELAPSED_MS % 1000 ))

            local FORMATTED_DUR=""
            if (( D > 0 )); then FORMATTED_DUR+="${D}d "; fi
            if (( H > 0 || D > 0 )); then FORMATTED_DUR+="${H}h "; fi
            if (( M > 0 || H > 0 || D > 0 )); then FORMATTED_DUR+="${M}m "; fi
            if (( S > 0 || M > 0 || H > 0 || D > 0 )); then FORMATTED_DUR+="${S}s "; fi
            if (( H == 0 && D == 0 )); then FORMATTED_DUR+="${MS}ms"; fi
            if [[ -z "$FORMATTED_DUR" ]]; then FORMATTED_DUR="0ms"; fi

            FORMATTED_DUR=${FORMATTED_DUR% }
            DURATION_STR="󰔟 ${FORMATTED_DUR}"
        fi
    fi
    __PURR_CMD_START=""
<<<<<<< HEAD
    
=======

>>>>>>> 1ed7453 (update)
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
    if [[ -f "$__PURR_GIT_CACHE" ]]; then
        IFS='|' read -r c_dir c_branch c_dirty < "$__PURR_GIT_CACHE"
        if [[ "$c_dir" == "$PWD" && -n "$c_branch" ]]; then
            local GIT_COLOR="${MAUVE}"
            local GIT_ICON=""
            if [[ "$c_dirty" == "1" ]]; then
                GIT_COLOR="${PEACH}"
                GIT_ICON=" *"
            fi
            GIT_SEG=" ${OVERLAY}│ ${GIT_COLOR} ${c_branch}${GIT_ICON}"
        fi
    fi

    ( __purr_async_git_worker >/dev/null 2>&1 & )

    local STATUS=""
    if [[ -n "$DURATION_STR" ]]; then
        STATUS+=" ${OVERLAY}│ ${PEACH}${DURATION_STR}"
    fi

    local JOB_COUNT=$(jobs -rp 2>/dev/null | wc -l)
    if (( JOB_COUNT > 0 )); then
        STATUS+=" ${OVERLAY}│ ${LAVENDER}󰜎 ${JOB_COUNT}"
    fi

    if [ $EXIT_CODE -ne 0 ]; then
        STATUS+=" ${OVERLAY}│ ${RED}󰅙 ${EXIT_CODE}"
    fi

    local HINTS=" ${OVERLAY}│ ${MAUVE}󰄛 󰃢 c · 󰋚 ⌃R · 󰈔 ⌃T · 󰉋 ⌥C · 󰋖 purrprompt"

    local PROMPT_ARROW="${GREEN}❯${RESET}"
    if [ $EXIT_CODE -ne 0 ]; then
        PROMPT_ARROW="${RED}❯${RESET}"
    fi

<<<<<<< HEAD
    local FIRST_LINE="${BG_S0}${TEAL}  \A ${OVERLAY}│ ${PINK} \u ${OVERLAY}@ ${BLUE}󰒋 \h ${OVERLAY}│ ${YELLOW} \w${GIT_SEG}${STATUS} ${RESET}${FG_S0}${RR}"

=======
    local FIRST_LINE="${BG_S0}${TEAL}  \A ${OVERLAY}│ ${PINK} \u ${OVERLAY}@ ${BLUE}󰒋 \h ${OVERLAY}│ ${YELLOW} \w${GIT_SEG}${STATUS}${HINTS} ${RESET}${FG_S0}${RR}"
    
    # Combine FIRST_LINE and the arrow into a single PS1 variable
    # so Readline natively redraws both lines on Ctrl+L
>>>>>>> 1ed7453 (update)
    PS1="${FIRST_LINE}\n${PROMPT_ARROW} "
}

PROMPT_COMMAND=purrprompt_builder
. "$HOME/.cargo/env"
