FROM ubuntu:jammy

ENV TOOL_TAG='ArmVirtPkg_Ubuntu_GCC5'

RUN apt update -y \
	&& apt install -y gcc-5 build-essential git uuid-dev iasl nasm \
	&& mkdir -p /src

WORKDIR /src

RUN  git clone https://github.com/tianocore/edk2.git edk2-stable202311 Latest \
	&&  git submodule update --init \
	&&  make -C BaseTools \
	&&  source edksetup.sh

