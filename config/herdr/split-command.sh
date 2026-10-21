#!/bin/sh
# Open a tool (lazygit, nvim, ...) either as a right split of the current
# herdr pane or, when the tab is too narrow for a side-by-side split, in a
# new tab. When the command exits, the shell exits and the pane (and thus
# the tab, if it holds the last pane) closes.
#
# Usage: split-command.sh <ratio> <command...>
# Invoked by [[keys.command]] bindings in config.toml; herdr provides
# HERDR_BIN_PATH, HERDR_SOCKET_PATH, and HERDR_ACTIVE_PANE_ID for those
# commands. --current does not work in this detached context, so the active
# pane id is passed explicitly.
set -e

# Tabs narrower than this many columns open the command in a new tab
# instead of a side split. Override with HERDR_SPLIT_MIN_WIDTH.
min_width="${HERDR_SPLIT_MIN_WIDTH:-200}"

ratio="$1"
shift

bin="${HERDR_BIN_PATH:-herdr}"
target="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"

# pane get needs an explicit id, so resolve --current to a real one.
if [ -z "$target" ]; then
    target=$("$bin" pane current | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [ -n "$target" ]; then
    pane_args="--pane $target"
else
    pane_args="--current"
fi

# Width in columns of the tab that contains the target pane.
width=$("$bin" pane layout $pane_args \
    | grep -o '"area":{[^}]*}' | grep -o '"width":[0-9]*' | cut -d: -f2)

id=
if [ -n "$width" ] && [ "$width" -lt "$min_width" ]; then
    # Narrow tab: open the command in a new tab, started in the target
    # pane's working directory.
    cwd=
    if [ -n "$target" ]; then
        cwd=$("$bin" pane get "$target" \
            | grep -o '"foreground_cwd":"[^"]*"' | head -1 | cut -d'"' -f4)
        [ -n "$cwd" ] || cwd=$("$bin" pane get "$target" \
            | grep -o '"cwd":"[^"]*"' | head -1 | cut -d'"' -f4)
    fi
    label=$(printf '%s' "$*" | cut -d' ' -f1)
    id=$("$bin" tab create --label "$label" ${cwd:+--cwd "$cwd"} --focus \
        | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)
else
    id=$("$bin" pane split $pane_args --direction right --ratio "$ratio" --focus \
        | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [ -n "$id" ]; then
    "$bin" pane run "$id" "$*; exit"
else
    echo "$(date) split failed (target=${target:-current})" >>/tmp/herdr-split-command.log
fi
