#!/bin/bash
## type_date.sh

sh -c 'sleep 0.5; xdotool type "$(\date +%Y-%m-%d_%H-%M-%S)"'
