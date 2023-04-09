#!/bin/bash
./configure --prefix=/usr

make
set +e
make check
set -e
make DESTDIR=$1 install