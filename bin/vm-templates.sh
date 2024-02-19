#!/usr/bin/env bash
SCRIPT_DIR=$(realpath `dirname $0`)
QEMU_DIR=${SCRIPT_DIR:?}/qemu
CLOUDINIT_DIR=$(realpath ${SCRIPT_DIR:?}/../cloud-init)
BIOS_DIR=/opt/homebrew/Cellar/qemu/8.2.1/share/qemu
BIOS_DIR=/Applications/UTM.app/Contents/Resources/qemu
BIOS_DIR=$(realpath "${SCRIPT_DIR:?}/../bios")
IMGS_DIR=/Volumes/Storage/vms/cloud-images
DISK_DIR=/Volumes/Storage/vms/DISKS
DEFAULT_MEMORY=2048
DEFAULT_VCPU=1

echo SCRIPT_DIR: $SCRIPT_DIR
echo QEMU_DIR: $QEMU_DIR
echo BIOS_DIR: $BIOS_DIR
echo CLOUDINIT_DIR: $CLOUDINIT_DIR

# Usage: create_disk base_image.img output_image.qcow2
function create_disk () {
	BASE_IMAGE=$1
	OUTPUT_IMAGE=$2
	printf 'Using IMGS_DIR:\n\t%s\n\n' "${IMGS_DIR}"

	set -x 
	qemu-img create \
		-F qcow2 -f qcow2 \
		-o backing_file="${IMGS_DIR:?}/${BASE_IMAGE:?}" "${DISK_DIR:?}/${OUTPUT_IMAGE:?}"
	set +x
}

function vmboot_x64 () {
	VM_DISK=$1
	VM_MEMORY=$2
	VM_CPU=$3
	BIOS_PATH=${BIOS_DIR:?}/bios.bin
	MACHINE_TYPE=q35
	CLOUDINIT_ISO=init.iso

	set -x
	cd $BIOS_DIR
	${QEMU_DIR}/qemu-system-x86_64 \
		-bios ${BIOS_PATH:?} -machine ${MACHINE_TYPE} \
		-drive file=${DISK_DIR:?}/${VM_DISK:?},if=virtio \
		${CLOUDINIT_ISO:+--cdrom ${CLOUDINIT_DIR:?}/$CLOUDINIT_ISO} \
		-m ${VM_MEMORY:-$DEFAULT_MEMORY}
	set +x
}

function vmboot_aarch64 () {
	VM_DISK=$1
	VM_MEMORY=$2
	VM_CPU=$3
	BIOS_PATH=${BIOS_DIR:?}/edk2-aarch64-secure-code.fd
	MACHINE_TYPE=virt
	CLOUDINIT_ISO=init.iso

	set -x
	cd $BIOS_DIR
	${QEMU_DIR}/qemu-system-aarch64 \
		-bios ${BIOS_PATH:?} -machine ${MACHINE_TYPE} \
		-drive file=${DISK_DIR:?}/${VM_DISK:?},if=virtio \
		--cdrom ${CLOUDINIT_DIR:?}/${CLOUDINIT_ISO:?} \
		-m ${VM_MEMORY:-$DEFAULT_MEMORY} \
	set +x
}

create_disk jammy-server-cloudimg-amd64.img ubuntu-jammy-x86_64.qcow2
vmboot_x64 ubuntu-jammy-x86_64.qcow2

#create_disk jammy-server-cloudimg-arm64.img ubuntu-jammy-aarch64.qcow2
#vmboot_aarch64 ubuntu-jammy-aarch64.qcow2
