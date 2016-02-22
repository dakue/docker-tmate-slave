#!/bin/bash
set -e

if [[ "$1" == 'tmate-slave' ]]
then
    cd $TMATE_HOME

    if [ -z "$TMATE_PORT" ]
    then
        export TMATE_PORT=2222
        echo "$(date -Iseconds) -INFO: setting tmate hostname to $TMATE_PORT"
    fi

    if [ -z "$TMATE_KEYS_DIR" ]
    then
        export TMATE_KEYS_DIR="$TMATE_HOME/keys"
        echo "$(date -Iseconds) -INFO: setting tmate keys dir to $TMATE_KEYS_DIR"
    fi

    if [ -z "$TMATE_HOSTNAME" ]
    then
        export TMATE_HOSTNAME="$(hostname -s)"
        echo "$(date -Iseconds) -INFO: setting tmate hostname to $TMATE_HOSTNAME"
    fi
    
    echo "$(date -Iseconds) - INFO: Creating host keys for tmate-slave ..."
    sed -i 's| -E md5||g' create_keys.sh
    ./create_keys.sh
    ./message.sh

    echo "$(date -Iseconds) - INFO: starting tmate-slave ..."
    ldconfig
    exec tmate-slave -k "$TMATE_KEYS_DIR" -p "$TMATE_PORT" -h "$TMATE_HOSTNAME"
fi

exec "$@"
