function __machine --description "Resolve a machine registry field: __machine <name> <field>"
    set -l name $argv[1]
    set -l field $argv[2]

    if not string match -qr '^[a-z0-9_-]+$' -- $name
        echo "invalid machine name: $name" >&2
        return 1
    end

    set -l varname machine_$name"_$field"
    set -l value $$varname
    if test -z "$value"
        echo "unknown machine: $name (define it in ~/.config/fish/conf.d/machines.fish)" >&2
        return 1
    end
    echo $value
end
