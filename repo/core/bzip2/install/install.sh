#!/bin/bash
mkdir -pv $1/usr/lib
mkdir -pv $1/usr/bin

cp -av libbz2.so.* $1/usr/lib
cp -v libbz2.so.1.0.8 $1/usr/lib/libbz2.so

cp -v bzip2-shared $1/usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  cp -v bzip2 $1$i
done

rm -fv $1/usr/lib/libbz2.a
