#!/usr/bin/env sh

image_name="$1"
tmp_entrypoint=$(mktemp)
dir=$(dirname "$0")

cat <<EOF > "$tmp_entrypoint"
#!/bin/sh

LIBGL_ALWAYS_SOFTWARE=0 node dist/server.js -p 80 -t /app/tiles -v &
LIBGL_ALWAYS_SOFTWARE=1 node dist/server.js -p 81 -t /app/tiles -v &

wait
EOF
chmod +x "$tmp_entrypoint"

docker-slim build  \
    --mount "$tmp_entrypoint:/docker/entrypoint.sh" \
    --entrypoint /docker/entrypoint.sh \
    --http-probe-cmd-file "$dir/slim.http-probe.json" \
    --http-probe-full \
    --expose 81 \
    --include-path /app/tiles \
    --include-path /lib64 \
    --include-path /root/entrypoint.sh \
    --exclude-pattern '/root/.cache/**' \
    --tag "${image_name}:slim" \
    "$image_name"

rm -f "$tmp_entrypoint"
