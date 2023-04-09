#!/bin/bash
mkdir -pv /etc/ypm/
mkdir -pv /etc/ypm/cache
mkdir -pv /etc/ypm/pkg

cp target/release/ypm $1/usr/bin/ypm
cp helpfile.txt /etc/ypm/helpfile.txt
cp repo /etc/ypm/
