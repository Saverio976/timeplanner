#!/bin/bash

if [[ "$TIMEPLANNER_PATH" == "" ]]; then
    export TIMEPLANNER_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/timeplanner.tp"
fi

function _preexec_timeplanner() {
    cmd_start="$SECONDS"
    cmd_cmd="$3"
}

function _precmd_timeplanner() {
    git_branch=$(git branch --show-current 2>/dev/null)
    if [[ "$git_branch" == "" ]]; then
        return
    fi
    local cmd_end="$SECONDS"
    elapsed=$((cmd_end-cmd_start))
    directory_name=$(git rev-parse --show-toplevel)
    msg="['$directory_name', '$git_branch', '$elapsed', '$cmd_cmd', '$(date "+%Y-%m-%d %H:%M:%S")']"
    echo "$msg" >> "$TIMEPLANNER_PATH"
}

function timeplanner_clear() {
    echo "Are you sure ? (Ctrl+C if no)"
    read -r
    true > "$TIMEPLANNER_PATH"
}

function timeplanner_cat() {
    cat "$TIMEPLANNER_PATH"
}

function timeplanner_path() {
    echo "$TIMEPLANNER_PATH"
}

function timeplanner_output_time() {
    timeplanner.py "$TIMEPLANNER_PATH"
}

function timeplanner_help() {
    echo "AVAILIBLE FUNCTIONS: timeplanner_clear, timeplanner_cat, timeplanner_path, timeplanner_output_time"
    echo
    echo "timeplanner_clear : clear the log file of time (useful after 'timeplanner_output_time')"
    echo
    echo "timeplanner_cat : cat the log file of time"
    echo
    echo "timeplanner_path : show path of the log file of time"
    echo
    echo "timeplanner_output_time : show a prety table with log time"
}
