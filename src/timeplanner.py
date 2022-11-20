#!/usr/bin/env python3

import ast
import os
import sys
from copy import deepcopy
from datetime import datetime, timedelta
from typing import Dict, List, Union

TIMEPLANNER_PATH = os.environ.get(
    "TIMEPLANNER_PATH", None if len(sys.argv) <= 1 else sys.argv[1]
)

if TIMEPLANNER_PATH is None:
    print(
        "TIMEPLANNER_PATH not found (int env or not provided in first param)",
        file=sys.stderr,
    )
    sys.exit(1)


def is_time_between(begin_time: datetime, end_time: datetime, check_time: datetime):
    if check_time > begin_time and check_time < end_time:
        return True
    return False


class Cmd:
    def __init__(
        self,
        cmd: str,
        elapsed_time: Union[str, timedelta],
        end_date: Union[str, datetime],
    ) -> None:
        self.cmd = cmd
        if isinstance(elapsed_time, timedelta):
            self.elapsed_time = elapsed_time.total_seconds()
        else:
            self.elapsed_time = int(elapsed_time)
        if isinstance(end_date, datetime):
            self.end_date = end_date
        else:
            days, hours = end_date.split(" ")
            year, month, day = list(map(int, days.split("-")))
            hour, minute, second = list(map(int, hours.split(":")))
            self.end_date = datetime(year, month, day, hour, minute, second)
        self.start_date = self.end_date - timedelta(seconds=self.elapsed_time)


class ElapsedTime:
    def __init__(self, end_date: datetime, start_date: datetime) -> None:
        self.end_date = end_date
        self.start_date = start_date
        self.total_time = end_date - start_date


class Branch:
    def __init__(self, branch: str) -> None:
        self.name = branch
        self.nodes: List[Cmd] = []
        self.ellapsed: List[ElapsedTime] = []

    def add_cmd(self, cmd: Cmd):
        for c in self.nodes:
            if (
                c.end_date == cmd.end_date
                and c.elapsed_time == cmd.elapsed_time
                and c.cmd == cmd.cmd
            ):
                return
        self.nodes.append(cmd)

    def sort_cmd_by_time(self):
        nodes = sorted(self.nodes, key=lambda x: x.end_date)
        self.nodes = nodes

    def nodes_to_ellapsed(self):
        self.ellapsed = []
        self.sort_cmd_by_time()
        tmp_nodes: List[Cmd] = deepcopy(self.nodes)
        i = 0
        while i < len(tmp_nodes):
            if i >= len(tmp_nodes) - 1:
                tmp_nodes.append(tmp_nodes[i])
                i += 1
                break
            start_a = tmp_nodes[i].start_date
            end_a = tmp_nodes[i].end_date
            start_b = tmp_nodes[i + 1].start_date
            end_b = tmp_nodes[i + 1].end_date
            if (
                is_time_between(start_a, end_a, start_b)
                or is_time_between(start_a, end_a, end_b)
                or (start_b < start_a and end_b > end_a)
            ):
                tmp_nodes[i] = Cmd(
                    "", max(end_a, end_b) - min(start_a, start_b), max(end_a, end_b)
                )
                tmp_nodes.pop(i + 1)
            else:
                i += 1
        for node in tmp_nodes:
            self.ellapsed.append(ElapsedTime(node.end_date, node.start_date))

    def to_table(self):
        self.nodes_to_ellapsed()
        by_day: List[List[ElapsedTime]] = [[] for _ in range(31)]
        for elapse in self.ellapsed:
            by_day[elapse.start_date.day].append(elapse)
        x = {}
        for day in by_day:
            if not day:
                continue
            total_time = timedelta()
            for elapse in day:
                total_time += elapse.total_time
            nb_days = total_time.days
            nb_hour = int(total_time.seconds / 3600)
            nb_minute = int((total_time.seconds - (nb_hour * 3600)) / 60)
            x[
                day[0].start_date.strftime("%Y-%m-%d")
            ] = f"{nb_days}d {nb_hour}h {nb_minute}m"
        return x


class Project:
    def __init__(self, path: str) -> None:
        self.path = path
        self.name = path.split(os.path.sep)[-1]
        self.nodes: Dict[str, Branch] = {}

    def add_branch(self, branch: Union[str, Branch]):
        branch_name = branch if isinstance(branch, str) else branch.name
        if branch_name not in self.nodes:
            if isinstance(branch, str):
                self.nodes[branch_name] = Branch(branch_name)
            else:
                self.nodes[branch_name] = branch

    def add_cmd(self, branch: Union[str, Branch], cmd: Cmd):
        branch_name = branch if isinstance(branch, str) else branch.name
        if branch_name not in self.nodes.keys():
            self.add_branch(branch)
        if branch_name in self.nodes.keys():
            self.nodes[branch_name].add_cmd(cmd)

    def to_table(self):
        x = {}
        for name, branch in self.nodes.items():
            x[name] = branch.to_table()
        return x


file = open(TIMEPLANNER_PATH)

projects: List[Project] = []

for line in file.readlines():
    try:
        info = ast.literal_eval(line)
    except Exception as esc:
        print("ERROR:", esc, file=sys.stderr)
        continue
    index = -1
    for i, project in enumerate(projects):
        if project.path == info[0]:
            index = i
    cmd = Cmd(info[3], info[2], info[4])
    if index == -1:
        proj = Project(info[0])
        proj.add_cmd(info[1], cmd)
        projects.append(proj)
    else:
        projects[index].add_cmd(info[1], cmd)

for project in projects:
    print(project.path)
    for branch_name, dates in project.to_table().items():
        print(f"{branch_name}:: {dates}")
        d, h, m = 0, 0, 0
        for date in dates.values():
            ds, hs, ms = date.split(" ")
            ds, hs, ms = int(ds[:-1]), int(hs[:-1]), int(ms[:-1])
            d, h, m = d + ds, h + hs, m + ms
        total = timedelta(days=d, hours=h, minutes=m)
        print(f"{branch_name}:: total:: {total}")
    print()

file.close()
