#!/bin/bash
make DESTDIR=$1 install &&
install -vdm755 $1/etc/ssl/local
