#!/bin/sh

echo "Starting mbgl-renderer server"
node dist/server.js -p 80 -t /app/tiles -v &
node_pid="$!"
echo "Hit Ctrl-C to exit"

trap "echo 'Stopping'; kill -s TERM $node_pid" INT TERM

# Wait for process to end.
while kill -0 $node_pid > /dev/null 2>&1; do
    wait
done
