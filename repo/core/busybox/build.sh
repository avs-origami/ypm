#!/bin/bash
cp ../busybox-1.36.0.config .config
make menuconfig
make
make DESTDIR=$1 install
