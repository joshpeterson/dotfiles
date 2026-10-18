function stop --description "Gracefully shut down the gandalf Hetzner server"
    set --local server gandalf

    switch (hcloud server describe $server --output json | jq -r .status)
        case off
            echo "$server is already off"
        case running
            echo "Shutting down $server (herdr sessions on it will stop) ..."
            hcloud server shutdown $server
        case '*'
            echo "$server is in an unexpected state (not running or off), aborting." >&2
            return 1
    end
end
