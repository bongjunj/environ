set -e

curl -LO https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz
tar -xvf fish-3.7.1.tar.xz
cd fish-3.7.1
cmake .
make
sudo make install
