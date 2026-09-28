#! /bin/sh
list=("10.110.110.10" "10.110.110.30" "10.120.120.20" "10.120.120.40" "10.130.130.50")
for item in "${list[@]}"; do


    ping  "$item" >/dev/null 2>&1 &

    echo "Started ping  (PID $!)"
done
