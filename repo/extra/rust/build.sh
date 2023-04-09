#!/bin/bash
if command -v rustup &> /dev/null
then
    rustup update
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
    mv rustup_init.sh /etc/ypm/cache/rustup-init.sh
    sh /etc/ypm/cache/rustup-init.sh
fi
