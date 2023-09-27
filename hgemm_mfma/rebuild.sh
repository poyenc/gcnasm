#!/bin/sh
SRC=hgemm.cc
OUT=hgemm.exe
TOP=`pwd`
BUILD="$TOP/build/"

rm -rf $BUILD ; mkdir $BUILD ; cd $BUILD

# PASS_NAME=si-load-store-opt # SI Load Store Optimizer
# PASS_NAME=amdgpu-isel # AMDGPU DAG->DAG Pattern Instruction Selection
# PASS_NAME=pre-isel-intrinsic-lowering # Pre-ISel Intrinsic Lowering
# PASS_NAME=amdgpu-promote-alloca # AMDGPU Promote Alloca
# PASS_NAME=amdgpu-codegenprepare # AMDGPU IR optimizations
# PASS_NAME=amdgpu-rewrite-undef-for-phi # AMDGPU Rewrite Undef for PHI
# PASS_NAME=amdgpu-always-inline # AMDGPU Inline All Functions
# PASS_NAME=opt-remark-emitter # Optimization Remark Emitter      X
PASS_NAME=amdgpu-promote-kernel-arguments # AMDGPU Promote Kernel Arguments

PHASE=before

# /opt/rocm/bin/hipcc $TOP/$SRC -fPIC -std=c++17 -O3 -Wall --offload-arch=gfx90a -save-temps -mllvm --print-$PHASE=$PASS_NAME \
#   -o $BUILD/$OUT

# /opt/rocm/bin/hipcc $TOP/$SRC -fPIC -std=c++17 -O3 -Wall --offload-arch=gfx90a -save-temps -mllvm --print-after= \
#   -o $BUILD/$OUT

/opt/rocm/bin/hipcc $TOP/$SRC -fPIC -std=c++17 -O3 -Wall --offload-arch=gfx90a -v -save-temps -mllvm --debug-pass=Structure \
  -o $BUILD/$OUT
