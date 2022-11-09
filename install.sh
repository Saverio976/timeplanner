#!/bin/bash
# -o ~/.bash-preexec.sh

FOLDER_CONFIG_SHELL="$HOME"

if [[ "$ZDOTDIR" != "" ]]; then
    FOLDER_CONFIG_SHELL="$ZDOTDIR"
fi

FILEPREEXEC_PATH="$FOLDER_CONFIG_SHELL/.bash-preexec.sh"

include_preexec="source '$FILEPREEXEC_PATH'"
include_timeplanner="source '$FOLDER_CONFIG_SHELL/.timeplanner.sh'"
include_add_preexec='preexec_functions+=(preexec_timeplanner)'
include_add_precmd='precmd_functions+=(precmd_timeplanner)'

function install_timeplanner() {
    uninstall_timeplanner

    if [[ "$SHELL" == *"bash"* ]]; then
        curl -Lo "$FILEPREEXEC_PATH" \
            'https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh'
    fi

    cp "./src/.timeplanner.sh" "$FOLDER_CONFIG_SHELL"

    if [[ "$SHELL" == *"bash"* ]]; then
        {
            echo "$include_preexec";
            echo "$include_timeplanner";
            echo "$include_add_preexec";
            echo "$include_add_precmd";
        } >> "$FOLDER_CONFIG_SHELL/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        {
            echo "$include_timeplanner";
            echo "$include_add_preexec";
            echo "$include_add_precmd";
        } >> "$FOLDER_CONFIG_SHELL/.zshrc"
    else
        echo "could not find your shell (bash/zsh/...?)"
    fi
}

function uninstall_timeplanner() {
    rm -rf "$FILEPREEXEC_PATH" "$FOLDER_CONFIG_SHELL/.timeplanner.sh"

    if [[ "$SHELL" == *"bash"* ]]; then
        sed -i "\|$(echo "$include_preexec" | sed 's/\//\\\//g')/d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_timeplanner" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_add_preexec" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_add_precmd" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        sed -i "\|$(echo "$include_timeplanner" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
        sed -i "\|$(echo "$include_add_preexec" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
        sed -i "\|$(echo "$include_add_precmd" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
    else
        echo "could not find your shell (bash/zsh/...?)"
    fi
}

function help_timeplanner() {
    echo "USAGE: ./install.sh [install | uninstall]"
}

if [[ "$1" == "install" ]]; then
    install_timeplanner
elif [[ "$1" == "uninstall" ]]; then
    uninstall_timeplanner
elif [[ "$1" == "--help" ]]; then
    help_timeplanner
else
    echo "try with --help"
    exit 1
fi