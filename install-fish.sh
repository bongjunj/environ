#! /usr/bin/env bash

set -e

curl -LO https://github.com/fish-shell/fish-shell/releases/download/4.1.2/fish-4.1.2.tar.xz
tar -xvf fish-4.1.2.tar.xz
pushd fish-4.1.2
cmake .
make
sudo make install

