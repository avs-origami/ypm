#!/bin/bash
mkdir -pv $1/usr/lib/python3.10/site-packages/
pip3 install --target $1/usr/lib/python3.10/site-packages/ --no-index $PWD
