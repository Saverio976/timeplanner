# TIMEPLANNER

show time of commands by repository folder name and branch

## INSTALL
```bash
./install.sh install
```

## UNINSTALL
```bash
./install.sh uninstall
```

## USAGE

### AVAILIBLE FUNCTIONS

1. timeplanner_clear
clear the log file of time (useful after 'timeplanner_output_time')

2. timeplanner_cat
cat the log file of time

3. timeplanner_path
show path of the log file of time

4. timeplanner_output_time
show a prety table with log time

## HOW IT WORKS

(not tested on bash, but, it use this to use same method of zsh : https://github.com/rcaloras/bash-preexec)

1. get the start of a command (with $SECONDS and using the preexec hook)

2. get the end of a command (with $SECONDS) and using the precmd hook)

3. get the total time of the command ($SECONDS end - $SECONDS start)

4. write this time, with the current date, and the cmd to a file (you can get the file with `timeplanner_path` function)

5. when you want the total time, it calls a python script (put on /usr/local/bin/ folder [thats why you need sudo to install this tool])
