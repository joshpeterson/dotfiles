#!/bin/sh
# Split the current herdr pane to the right and run a command in the new
# pane. When the command exits, the shell exits and the pane closes.
#
# Usage: split-command.sh <ratio> <command...>
# Invoked by [[keys.command]] bindings in config.toml; herdr provides
# HERDR_BIN_PATH and HERDR_SOCKET_PATH for those commands.
set -e

ratio="$1"
shift

bin="${HERDR_BIN_PATH:-herdr}"

id=$("$bin" pane split --current --direction right --ratio "$ratio" --focus \
    | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$id" ]; then
    "$bin" pane run "$id" "$*; exit"
fi
