#!/usr/bin/env bash


UBUNTU_ARM64='/opt/homebrew/qemu-system-x86_64  \
	-bios /Applications/UTM.app/Contents/Resources/qemu/bios.bin \
	-drive file=/Volumes/Storage/jammy-server-cloudimg-arm64.img  \
	-m 2048 \
	-smp 1 \
	-boot d'

UBUNTU_AMD64='/opt/homebrew/qemu-system-x86_64 \
    -machine type=q35,accel=hvf \
    -smp 2 \
    -hda ubuntu-20.04.1-desktop-amd64.qcow2 \
    -m 4G \
    -vga virtio'

