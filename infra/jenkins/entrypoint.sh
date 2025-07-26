#!/bin/sh
set -e

if [ -S /var/run/docker.sock ]; then
    chgrp docker /var/run/docker.sock
    chmod g+rw /var/run/docker.sock
fi

exec gosu jenkins "$@"
