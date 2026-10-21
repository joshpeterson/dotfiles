function agents --description "Boot a machine (default: $machines_default) and open herdr"
    start $argv; or return 1
    herdr
end
