# Machine registry for the start/stop/agents commands.
#
# One block per cloud machine. Status output is normalized: anything
# matching running/active counts as up; off/stopped/down counts as off.
#
#   machine_<name>_target   SSH target (Tailscale MagicDNS name)
#   machine_<name>_status   command printing the provider's power state
#   machine_<name>_start    command powering the machine on
#   machine_<name>_stop     command shutting the machine down gracefully
#   machine_<name>_timeout  optional seconds to wait for SSH (default 120)

set -g machines_default gandalf

# Hetzner Cloud
set -g machine_gandalf_target josh@gandalf
set -g machine_gandalf_status "hcloud server describe gandalf --output json | jq -r .status"
set -g machine_gandalf_start "hcloud server poweron gandalf"
set -g machine_gandalf_stop "hcloud server shutdown gandalf"

# DigitalOcean (doctl) — copy and fill in when needed:
# set -g machine_builds_target josh@builds
# set -g machine_builds_status "doctl compute droplet get builds -o json | jq -r '.[0].status'"
# set -g machine_builds_start "doctl compute power-action builds --power-on"
# set -g machine_builds_stop "doctl compute power-action builds --shutdown"

# Oracle Cloud (oci) — status via lifecycle-state, start/stop via instance action:
# set -g machine_oracle_target josh@oracle
# set -g machine_oracle_status "oci compute instance list --compartment-id <ocid> --query 'data[?\"display-name\"=='\''oracle'\''].\"lifecycle-state\"' --raw-output"
# set -g machine_oracle_start "oci compute instance action <instance-ocid> --action START"
# set -g machine_oracle_stop "oci compute instance action <instance-ocid> --action SOFTSTOP"
