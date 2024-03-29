#!/bin/bash
# -o ~/.bash-preexec.sh

FOLDER_CONFIG_SHELL="$HOME"

if [[ "$ZDOTDIR" != "" ]]; then
    FOLDER_CONFIG_SHELL="$ZDOTDIR"
fi

FILEPREEXEC_PATH="$FOLDER_CONFIG_SHELL/.bash-preexec.sh"

COND_SINEQUANON="[[ -f '$FOLDER_CONFIG_SHELL/.timeplanner.sh' ]]"

include_preexec="$COND_SINEQUANON && source '$FILEPREEXEC_PATH'"
include_timeplanner="$COND_SINEQUANON && source '$FOLDER_CONFIG_SHELL/.timeplanner.sh'"
include_add_preexec='preexec_functions+=(_preexec_timeplanner)'
include_add_preexec="$COND_SINEQUANON && $include_add_preexec"
include_add_precmd='precmd_functions+=(_precmd_timeplanner)'
include_add_precmd="$COND_SINEQUANON && $include_add_precmd"

function install_timeplanner() {
    uninstall_timeplanner "install"

    if [[ "$SHELL" == *"bash"* ]]; then
        set -x
        curl -Lo "$FILEPREEXEC_PATH" \
            'https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh'
        set +x
    fi

    set -x
    cp "./src/.timeplanner.sh" "$FOLDER_CONFIG_SHELL"

    sudo cp "./src/timeplanner.py" "/usr/local/bin"
    set +x

    if [[ "$SHELL" == *"bash"* ]]; then
        set -x
        {
            echo "$include_preexec";
            echo "$include_timeplanner";
            echo "$include_add_preexec";
            echo "$include_add_precmd";
        } >> "$FOLDER_CONFIG_SHELL/.bashrc"
        set +x
    elif [[ "$SHELL" == *"zsh"* ]]; then
        set -x
        {
            echo "$include_timeplanner";
            echo "$include_add_preexec";
            echo "$include_add_precmd";
        } >> "$FOLDER_CONFIG_SHELL/.zshrc"
        set +x
    else
        echo "could not find your shell (bash/zsh/...?)"
    fi
}

function uninstall_timeplanner() {
    set -x
    rm -rf "$FILEPREEXEC_PATH"
    if [[ "$1" != "install" ]]; then
        rm -rf "$FOLDER_CONFIG_SHELL/.timeplanner.sh"
    fi

    sudo rm -f "/usr/local/timeplanner.py"
    set +x

    if [[ "$SHELL" == *"bash"* ]]; then
        set -x
        sed -i "\|$(echo "$include_preexec" | sed 's/\//\\\//g')/d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_timeplanner" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_add_preexec" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
        sed -i "\|$(echo "$include_add_precmd" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.bashrc"
        set +x
    elif [[ "$SHELL" == *"zsh"* ]]; then
        set -x
        sed -i "\|$(echo "$include_timeplanner" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
        sed -i "\|$(echo "$include_add_preexec" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
        sed -i "\|$(echo "$include_add_precmd" | sed 's/\//\\\//g')|d" "$FOLDER_CONFIG_SHELL/.zshrc"
        set +x
    else
        echo "could not find your shell (bash/zsh/...?)"
    fi
}

function help_timeplanner() {
    echo "USAGE: ./install.sh [install | uninstall | --help]"
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
