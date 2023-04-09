#!/bin/bash
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
mkdir -pv $1/usr/lib/python3.10/site-packages/
pip3 install --target $1/usr/lib/python3.10/site-packages/ --no-index --no-user --find-links dist Markupsafe
