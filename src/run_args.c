#include <stdbool.h>
#include <stdio.h>
#include "main.h"

static int clear_flag(args_t *args)
{
    FILE *file = fopen(args->timeplanner_path, "w");
    fclose(file);
    return 0;
}

int run_args(args_t *args)
{
    if (args->is_output_time == true) {
        return 1;
    }
    if (args->is_clear == true) {
        return clear_flag(args);
    }
    if (args->is_add_time == true) {
        return 1;
    }
    printf("don't know what to do\n");
    return 1;
}
