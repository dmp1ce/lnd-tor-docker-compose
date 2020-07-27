#!/bin/bash

# Check for verbose
if [ "$1" == "-v" ]; then
    VERBOSE=true
    shift 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=scripts/create_env.bash
. "$DIR/scripts/create_env.bash"

# Start LND, Bitcoin and Tor with added overrides
CMD=""
case "$1" in
    "restart" | "up" | "logs" | "ps" | "stop" | "exec" | "kill" | "rm" | "run" | "config" )
        read -r -a CMD <<< "$@"
        ;;
    "")
        CMD=(up -d)
        ;;
    * )
        echo "Start services with overrides. Supported parameters are 'up' and 'restart'."
        echo "Example: \`./start restart bitcoin\`"
        echo ""
        echo "Default command is \`up -d\`"
        exit 0
        ;;

esac

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get list of overrides
OVERRIDE_OPTIONS=()
shopt -s nullglob
for f in "$DIR/overrides"/*.yml
do
    OVERRIDE_OPTIONS+=(-f)
    OVERRIDE_OPTIONS+=("$f")
done

# Start docker-compose with override options
if [ "$VERBOSE" ]; then
   echo docker-compose -f docker-compose.yml "${OVERRIDE_OPTIONS[@]}" "${CMD[@]}"
fi
cd "$DIR" && exec docker-compose -f docker-compose.yml "${OVERRIDE_OPTIONS[@]}" "${CMD[@]}"
