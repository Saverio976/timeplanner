#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include "main.h"

static int clear_flag(args_t *args)
{
    FILE *file = fopen(args->timeplanner_path, "w");
    fclose(file);
    return 0;
}

int add_time(args_t *args)
{
    char delim[] = " :: ";
    char time_char[50] = {0};
    time_t rawtime = 0;
    struct tm *timeinfo = {0};

    FILE *file = fopen(args->timeplanner_path, "a");
    fwrite(args->cur_reponame, sizeof(char), strlen(args->cur_reponame), file);
    fwrite(delim, sizeof(char), strlen(delim), file);
    fwrite(args->cur_branch, sizeof(char), strlen(args->cur_branch), file);
    fwrite(delim, sizeof(char), strlen(delim), file);
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(time_char, 49, "%Y-%m-%d %H:%M:%S\n", timeinfo);
    fwrite(time_char, sizeof(char), strlen(time_char), file);
    fclose(file);
    return 0;
}

int run_args(args_t *args)
{
    if (args->is_output_time == true) {
        execl("timeplanner.py", args->timeplanner_path, "--output-time", NULL);
        return 1;
    }
    if (args->is_clear == true) {
        return clear_flag(args);
    }
    if (args->is_add_time == true) {
        return add_time(args);
    }
    printf("don't know what to do\n");
    return 1;
}
