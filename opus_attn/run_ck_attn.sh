#!/bin/sh
EXE=/root/workspace/repo/rocm-libraries/projects/composablekernel/build/bin/tile_example_fmha_fwd

$EXE -prec=bf16 -b=1 -h=32 -h_k=2 -d=256 -s=1024 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=2 -h=32 -h_k=2 -d=256 -s=1024 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=4 -h=32 -h_k=2 -d=256 -s=1024 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=8 -h=32 -h_k=2 -d=256 -s=1024 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=1 -h=32 -h_k=2 -d=256 -s=2048 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=2 -h=32 -h_k=2 -d=256 -s=2048 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=4 -h=32 -h_k=2 -d=256 -s=2048 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=8 -h=32 -h_k=2 -d=256 -s=2048 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=1 -h=32 -h_k=2 -d=256 -s=4096 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=2 -h=32 -h_k=2 -d=256 -s=4096 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=4 -h=32 -h_k=2 -d=256 -s=4096 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=8 -h=32 -h_k=2 -d=256 -s=4096 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=1 -h=32 -h_k=2 -d=256 -s=8192 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=2 -h=32 -h_k=2 -d=256 -s=8192 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=4 -h=32 -h_k=2 -d=256 -s=8192 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=8 -h=32 -h_k=2 -d=256 -s=8192 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=1 -h=32 -h_k=2 -d=256 -s=16384 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=2 -h=32 -h_k=2 -d=256 -s=16384 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=4 -h=32 -h_k=2 -d=256 -s=16384 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
$EXE -prec=bf16 -b=8 -h=32 -h_k=2 -d=256 -s=16384 -mask=2 -kname=1 -v=0 -warmup=100 -repeat=50 -iperm=0 -operm=0 -init=nf
