#!/bin/bash
perl Makefile.PL

make
make DESTDIR=$1 install
