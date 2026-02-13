#!/bin/bash
exec systemd-inhibit --what=sleep:handle-lid-switch --who="User" --why="User preference" sleep infinity
