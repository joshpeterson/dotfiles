function __machine_state --description "Print a machine's normalized power state: running, off, or unknown"
    set -l name $argv[1]
    set -l cmd (__machine $name status); or return 1

    set -l raw (sh -c "$cmd" 2>/dev/null | string trim | string lower)
    if test -z "$raw"
        echo unknown
    else if string match -qr 'running|active' -- $raw
        echo running
    else if string match -qr 'off|stopped|stopping|down' -- $raw
        echo off
    else
        echo unknown
    end
end
