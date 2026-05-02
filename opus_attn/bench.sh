#!/bin/sh
# Benchmark opus_attn across the documented problem sizes (README.md)
# B=16, H=64, H_KV=8, D=128, N=1024..16384, causal + non-causal
TOP=$(cd "$(dirname "$0")" && pwd)
EXE="$TOP/build/gqa_attn.exe"

if [ ! -x "$EXE" ]; then
    echo "Error: $EXE not found. Run 'make -j' first."
    exit 1
fi

echo "=== Causal ==="
for n in 1024 2048 4096 8192 16384; do
    "$EXE" --causal -n "$n"
done

echo ""
echo "=== Non-causal ==="
for n in 1024 2048 4096 8192 16384; do
    "$EXE" --no-causal -n "$n"
done
