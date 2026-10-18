#!/bin/sh
# Split the current herdr pane to the right and run a command in the new
# pane. When the command exits, the shell exits and the pane closes.
#
# Usage: split-command.sh <ratio> <command...>
# Invoked by [[keys.command]] bindings in config.toml; herdr provides
# HERDR_BIN_PATH, HERDR_SOCKET_PATH, and HERDR_ACTIVE_PANE_ID for those
# commands. --current does not work in this detached context, so the active
# pane id is passed explicitly.
set -e

ratio="$1"
shift

bin="${HERDR_BIN_PATH:-herdr}"
target="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"

if [ -n "$target" ]; then
    split_args="$target"
else
    split_args="--current"
fi

id=$("$bin" pane split $split_args --direction right --ratio "$ratio" --focus \
    | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$id" ]; then
    "$bin" pane run "$id" "$*; exit"
else
    echo "$(date) split failed (target=${target:-current})" >>/tmp/herdr-split-command.log
fi
