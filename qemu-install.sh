#!/bin/sh
set -eo pipefail

APP_PREFIX=~/Documents/GitHub/appimage-kubetools
cd $APP_PREFIX
git clone https://gitlab.com/qemu-project/qemu.git 
git submodule init &&git submodule update --recursive
brew install libffi gettext pkg-config autoconf automake pixman libjpeg libpng libusb ninja glib
git checkout 56a11a9b7580b576a9db930667be07f1dd1564d5
curl https://patchwork.kernel.org/series/418581/mbox/ | git am
mkdir build
cd build
./configure --target-list=aarch64-softmmu --enable-hvf --disable-gnutls
make -j8
sudo make install
sudo codesign --entitlements ../accel/hvf/entitlements.plist --force -s - `which qemu-system-aarch64`
