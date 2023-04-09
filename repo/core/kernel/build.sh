#!/bin/bash
make mrproper

cp ../kernel-5.19.2.config .config
make menuconfig

make
make DESTDIR=$1 modules_install
