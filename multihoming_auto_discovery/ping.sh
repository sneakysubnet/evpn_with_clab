#! /bin/sh
DEST='10.10.10.1'
for i in $(seq 10 19); do
    SRC="10.10.10.$i"

    ping -I "$SRC" "$DEST" >/dev/null 2>&1 &

    echo "Started ping from $SRC (PID $!)"
done
