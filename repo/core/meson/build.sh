#!/bin/bash
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
mkdir -pv $1/usr/lib/python3.10/site-packages/
pip3 install --target $1/usr/lib/python3.10/site-packages/ --no-index --find-links dist meson

mkdir -pv $1/usr/share/bash-completion/completions
mkdir -pv $1/usr/share/zsh/site-functions

install -vDm644 data/shell-completions/bash/meson $1/usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson $1/usr/share/zsh/site-functions/_meson
