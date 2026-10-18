function agents --description "Boot gandalf (Hetzner) and open herdr with Local + gandalf machines"
    set --local server gandalf
    set --local target josh@gandalf # Tailscale MagicDNS name
    set --local timeout 120 # seconds to wait for SSH to come up

    switch (hcloud server describe $server --output json | jq -r .status)
        case running
            echo "$server is already running"
        case off
            echo "Powering on $server ..."
            hcloud server poweron $server
        case '*'
            echo "$server is in an unexpected state (not running or off), aborting." >&2
            return 1
    end

    printf "waiting for SSH over Tailscale "
    for i in (seq (math --scale=0 $timeout / 5))
        if ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=accept-new $target true 2>/dev/null
            echo " ready!"
            herdr
            return
        end
        printf "."
        sleep 5
    end
    echo
    echo "Timed out after {$timeout}s waiting for SSH on $target." >&2
    return 1
end
