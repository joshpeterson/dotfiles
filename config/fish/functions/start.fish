function start --description "Boot a machine (default: $machines_default) and wait for SSH over Tailscale"
    set -l name $argv[1]
    if test -z "$name"
        set name $machines_default
    end

    set -l target (__machine $name target); or return 1
    set -l timeout (__machine $name timeout)
    if test -z "$timeout"
        set timeout 120
    end

    switch (__machine_state $name)
        case running
            echo "$name is already running"
        case off
            echo "Powering on $name ..."
            set -l cmd (__machine $name start)
            sh -c "$cmd"
        case '*'
            echo "$name is in an unexpected power state, aborting." >&2
            return 1
    end

    printf "waiting for SSH over Tailscale "
    for i in (seq (math --scale=0 $timeout / 5))
        if ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=accept-new $target true 2>/dev/null
            echo " ready!"
            return 0
        end
        printf "."
        sleep 5
    end
    echo
    echo "Timed out after {$timeout}s waiting for SSH on $target." >&2
    return 1
end
