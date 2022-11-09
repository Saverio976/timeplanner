#!/bin/bash

if [[ "$TIMEPLANNER_PATH" == "" ]]; then
    export TIMEPLANNER_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/timeplanner.tp"
fi

function preexec_timeplanner() {
    cmd_start="$SECONDS"
    cmd_cmd="$3"
}

function precmd_timeplanner() {
    local cmd_end="$SECONDS"
    elapsed=$((cmd_end-cmd_start))
    git_branch=$(git branch --show-current)
    if [[ "$git_branch" == "" ]]; then
        return
    fi
    directory_name=$(git rev-parse --show-toplevel)
    msg="['$directory_name', '$git_branch', '$elapsed', '$cmd_cmd']"
    echo "$msg" >> "$TIMEPLANNER_PATH"
}

function timeplanner_clear() {
    echo "Are you sure ? (Ctrl+C if no)"
    read -r
    true > "$TIMEPLANNER_PATH"
}
