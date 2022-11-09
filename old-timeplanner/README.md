# timeplanner

## INSTALL

```bash
make
```

## USAGE

```txt
USAGE: ./timeplanner {--clear,--output-time,--help} [--timeplanner-path PATH]
USAGE: ./timeplanner [--add-time] --cur-branch BRANCH --cur-repo REPO [--timeplanner-path PATH]

OPTIONS:
        --clear                 clear timeplanner (usefull after run 
                                --output-time to start the month with a cleaned time).
        --output-time           output time from the last cleaned planner to now.
        --help                  show this message.
        --add-time              if --clear or --output-time or --help not provided, 
                                default action. Add current branch 
                                and current repo name to timeplanner
        --cur-branch BRANCH     the current branch name to track
        --cur-repo REPO         the current repository name to track
        --timeplanner-path PATH path where timeplaner could edit/write 
                                the file. 
                                By default: $HOME/.config/timeplanner.tp
```
