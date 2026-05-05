#!/bin/bash
set -euo pipefail

SUITE=trixie
ARCH=arm64
ROOTDIR=${1:-/tmp/rootfs}
KEYRING="/usr/share/keyrings/debian-archive-keyring.gpg"
MIRRORS=( http://deb.debian.org/debian)

PACKAGES=(
  init udev sudo vim apt file zstd parted fdisk dosfstools iputils-ping isc-dhcp-client
  wget curl ca-certificates systemd systemd-sysv psmisc ethtool iproute2 openssh-server
  openssh-client patchelf htop util-linux lshw keyutils locales wpasupplicant net-tools
  gnupg glmark2-es2-wayland libwayland-server0 alsa-utils libpulse0 libgl1 libva2 
  libvdpau1
 )
# Optional: VizionViewer related packages
# gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libclutter-gst-3.0-0 libpython3.13 
# libdw1 libunwind8 python3-opencv


#echo "Packages to install: $(IFS=,; echo "${PACKAGES[*]}")"

echo "sources.list: ${MIRRORS[@]}"

# echo "$(IFS=,; echo "${PACKAGES[*]}")"

mmdebstrap \
  --arch=$ARCH \
  --aptopt='Acquire::Retries=5' \
  --aptopt='Acquire::http::Timeout=30' \
  --aptopt='Acquire::https::Timeout=30' \
  --aptopt='APT::Get::Assume-Yes=true' \
  --aptopt='DPkg::Options::=--force-confnew' \
  --aptopt='Acquire::Languages="none"' \
  --skip=download/bytecode \
  --variant=standard \
  --components=main,contrib \
  --keyring="$KEYRING" \
  --mode=auto \
  --include="$(IFS=,; echo "${PACKAGES[*]}")" \
  "$SUITE" \
  "$ROOTDIR" \
  "${MIRRORS[@]}"

