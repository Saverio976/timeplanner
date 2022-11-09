#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "main.h"

int print_help(const char *exe)
{
    printf("USAGE: %s {--clear,--output-time,--help} [--timeplanner-path PATH]\n", exe);
    printf("USAGE: %s [--add-time] --cur-branch BRANCH --cur-repo REPO [--timeplanner-path PATH]\n", exe);
    printf("\n");
    printf("OPTIONS:\n");
    printf("\t--clear\t\t\tclear timeplanner (usefull after run \n\t\t\t\t--output-time "
            "to start the month with a cleaned time).\n");
    printf("\t--output-time\t\toutput time from the last cleaned planner to now.\n");
    printf("\t--help\t\t\tshow this message.\n");
    printf("\t--add-time\t\tif --clear or --output-time or --help not "
            "provided, \n\t\t\t\tdefault action. Add current branch \n\t\t\t\t"
            "and current repo name to timeplanner\n");
    printf("\t--cur-branch BRANCH\tthe current branch name to track\n");
    printf("\t--cur-repo REPO\t\tthe current repository name to track\n");
    printf("\t--timeplanner-path PATH\tpath where timeplaner could edit/write "
            "\n\t\t\t\tthe file. \n\t\t\t\tBy default: $HOME/.config/timeplanner.tp\n");
    return 0;
}

int main(int argc, const char *argv[])
{
    int ret = 0;
    args_t *args = NULL;

    args = process_args(argc, argv);
    if (args->is_help == true) {
        ret = print_help(argv[0]);
    } else {
        ret = run_args(args);
    }
    return ret;
}
