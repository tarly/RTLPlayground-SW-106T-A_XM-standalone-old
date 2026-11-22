#!/bin/sh
# Build SW-106T-A_XM on top of an RTLPlayground checkout.
# Copy machine/ and config/ into the RTLPlayground tree first.
set -e

MACHINE=SW-106T-A_XM
CONFIG=${CONFIG:-config/default.txt}
VERSION=${VERSION:-0.2.6}

make MACHINE="$MACHINE" CONFIG="$CONFIG" VERSION="$VERSION" \
     CC="${CC:-sdcc}" ASM="${ASM:-sdas8051}"

echo "Built a 512 KB image. Do not pad it to 4 MB."
