#!/usr/bin/env python3

import sys
import os
import ast

TIMEPLANNER_PATH = os.environ.get(
    "TIMEPLANNER_PATH",
    None if len(sys.argv) <= 1 else sys.argv[1]
)

file = open(TIMEPLANNER_PATH)

projects = []

for line in file.readlines():
    try:
        info = ast.literal_eval(line)
    except Exception as esc:
        print("ERROR:", esc, file=sys.stderr)
        continue
    index = -1
    for i, project in enumerate(projects):
        if project[0] == info[0]:
            index = i
    if index == -1:
        projects.append([info[0], [info]])
    else:
        projects[1].append(info)

print("parsing:", projects)

file.close()
