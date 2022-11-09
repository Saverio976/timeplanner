#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "main.h"

static int clear_flag(args_t *args,
        __attribute__((unused)) int i,
        __attribute__((unused)) int argc,
        __attribute__((unused)) const char *argv[])
{
    args->is_clear = true;
    args->is_add_time = false;
    return 0;
}

static int output_time_flag(args_t *args,
        __attribute__((unused)) int i,
        __attribute__((unused)) int argc,
        __attribute__((unused)) const char *argv[])
{
    args->is_output_time = true;
    args->is_add_time = false;
    return 0;
}

static int help_flag(args_t *args,
        __attribute__((unused)) int i,
        __attribute__((unused)) int argc,
        __attribute__((unused)) const char *argv[])
{
    args->is_help = true;
    args->is_add_time = false;
    return 0;
}

static int add_time_flag(args_t *args,
        __attribute__((unused)) int i,
        __attribute__((unused)) int argc,
        __attribute__((unused)) const char *argv[])
{
    args->is_add_time = true;
    return 0;
}

static int cur_branch_flag(args_t *args, int i, int argc, const char *argv[])
{
    if (i == argc - 1) {
        printf("branch param not provided... Could cause errors\n");
        return 0;
    }
    if (args->cur_branch != NULL) {
        free(args->cur_branch);
    }
    args->cur_branch = strdup(argv[i + 1]);
    return 1;
}

static int cur_repo_flag(args_t *args, int i, int argc, const char *argv[])
{
    if (i == argc - 1) {
        printf("repo param not provided... Could cause errors\n");
        return 0;
    }
    if (args->cur_reponame != NULL) {
        free(args->cur_reponame);
    }
    args->cur_reponame = strdup(argv[i + 1]);
    return 1;
}

static int timeplanner_path_flag(args_t *args, int i, int argc, const char *argv[])
{
    if (i == argc - 1) {
        printf("Why flag with no param ?\n");
        return 0;
    }
    if (args->timeplanner_path != NULL) {
        free(args->timeplanner_path);
    }
    args->timeplanner_path = strdup(argv[i + 1]);
    return 1;
}

static const char *flags_key[] = {
    "--clear",
    "--output-time",
    "--help",
    "--add-time",
    "--cur-branch",
    "--cur-repo",
    "--timeplanner-path",
    NULL,
};

static int (*flags_action[])(args_t *, int, int, const char **) = {
    clear_flag,
    output_time_flag,
    help_flag,
    add_time_flag,
    cur_branch_flag,
    cur_repo_flag,
    timeplanner_path_flag,
    NULL,
};

static args_t *init_args(void)
{
    args_t *args = NULL;

    args = malloc(sizeof(args_t));
    args->cur_branch = NULL;
    args->cur_reponame = NULL;
    args->timeplanner_path = NULL;
    args->is_clear = false;
    args->is_add_time = true;
    args->is_help = false;
    args->is_output_time = false;
    return args;
}

void destroy_args(args_t *args)
{
    if (args == NULL) {
        return;
    }
    if (args->cur_reponame) {
        free(args->cur_reponame);
    }
    if (args->cur_branch) {
        free(args->cur_branch);
    }
    if (args->timeplanner_path) {
        free(args->timeplanner_path);
    }
    free(args);
}

bool check_args(args_t *args)
{
    char *tmp = NULL;

    if (args->is_add_time == true &&
            (
                args->is_help == true ||
                args->is_clear == true ||
                args->is_output_time == true
            )
       ) {
        printf("--add-time flag must not be conbined with --clear or "
                "--output-time or --help\n");
        return false;
    }
    if (args->is_add_time == true && args->cur_branch == NULL) {
        printf("--cur-branch must be provided\n");
        return false;
    }
    if (args->is_add_time == true && args->cur_reponame == NULL) {
        printf("--cur-repo must be provided\n");
        return false;
    }
    if (args->timeplanner_path == NULL) {
        tmp = getenv("HOME");
        args->timeplanner_path = malloc(sizeof(char) * (strlen(tmp) + strlen(timeplanner_path) + 2));
        args->timeplanner_path = strcpy(args->timeplanner_path, tmp);
        args->timeplanner_path = strcat(args->timeplanner_path, "/");
        args->timeplanner_path = strcat(args->timeplanner_path, timeplanner_path);
    }
    return true;
}

args_t *process_args(int argc, const char *argv[])
{
    args_t *args = init_args();
    bool skip = false;

    for (int i = 0; i < argc; i++) {
        skip = false;
        for (int j = 0; skip == false && flags_key[j] != NULL; j++) {
            if (strcmp(argv[i], flags_key[j]) == 0) {
                i += flags_action[j](args, i, argc, argv);
                skip = true;
            }
        }
    }
    if (check_args(args) == false) {
        destroy_args(args);
        exit(2);
    }
    return args;
}
