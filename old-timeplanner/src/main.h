#ifndef TIMEPLANNER_MAIN_H_
    #define TIMEPLANNER_MAIN_H_

struct args {
    int is_clear;
    int is_output_time;
    int is_add_time;
    int is_help;
    char *cur_branch;
    char *cur_reponame;
    char *timeplanner_path;
};

typedef struct args args_t;

args_t *process_args(int argc, const char *argv[]);

void destroy_args(args_t *args);

int run_args(args_t *args);

static const char timeplanner_path[] = ".config/timeplanner_path.tp";

#endif
