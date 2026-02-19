#!/bin/bash
systemd-inhibit --what=idle:sleep \
  --who="AutostartInhibit" \
  --why="Prevent lock" \
  sleep infinity
