#!/bin/bash
set -e
cd "$HOME/xiaomi10g/repo"
cp rtlplayground.c /tmp/rtlplayground.c.bak
sed -i 's/^[[:space:]]*leds_setup();/\/\/ leds_setup();/' rtlplayground.c
make -j8 MACHINE=XIAOMI_MINLED CONFIG=config.txt \
    CC="$HOME/xiaomi10g/toolchain/sdcc-4.6.0/bin/sdcc" \
    ASM="$HOME/xiaomi10g/toolchain/sdcc-4.6.0/bin/sdas8051" \
    OUTPUT_DIR="$HOME/xiaomi10g/out_minled" \
    OUTPUT_NAME="rtlplayground-xiaomi-minled.bin"
cp /tmp/rtlplayground.c.bak rtlplayground.c
ls -l "$HOME/xiaomi10g/out_minled/"
