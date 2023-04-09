#!/bin/bash
PAGE=Letter ./configure --prefix=/usr

make -j1
make DESTDIR=$1 install
