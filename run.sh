#!/bin/bash
build/qemu-system-arm \
    -M iPod-Touch,bootrom=bootrom_s5l8900,iboot=iboot_204_n45ap.bin,nand=nand \
    -serial mon:stdio \
    -cpu max \
    -m 1G \
    -d unimp \
    -drive file=nor_n45ap.bin,format=raw,if=pflash
