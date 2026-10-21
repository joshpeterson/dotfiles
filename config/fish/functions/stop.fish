function stop --description "Gracefully shut down a machine (default: $machines_default)"
    set -l name $argv[1]
    if test -z "$name"
        set name $machines_default
    end

    switch (__machine_state $name)
        case off
            echo "$name is already off"
        case running
            echo "Shutting down $name (herdr sessions on it will stop) ..."
            set -l cmd (__machine $name stop)
            sh -c "$cmd"
        case '*'
            echo "$name is in an unexpected power state, aborting." >&2
            return 1
    end
end
