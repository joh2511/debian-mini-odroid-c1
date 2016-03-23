DIST ?= jessie
DIST_URL := http://http.debian.net/debian/
DIST_ARCH := arm64

ifneq ($(findstring $(DIST),jessie stable),)
# ROOT_DEV is needed for jessie, it will cause boot.ini to boot from /dev/mmcblk0p2 rather than from UUID.
# For some reason, booting by UUID is broken with jessie...
ROOT_DEV := /dev/mmcblk0p2
endif

IMAGE_MB ?= 2048
BOOT_MB ?= 32
ROOT_MB=$(shell expr $(IMAGE_MB) - $(BOOT_MB))

BOOT_DIR := boot
MODS_DIR := mods
ROOTFS_DIR := rootfs
RAMDISK_FILE := uInitrd
IMAGE_FILE := sdcard-$(DIST).img

UBOOT_TOOLCHAIN := gcc-linaro-4.9-2014.11-x86_64_aarch64-elf.tar.xz
UBOOT_TOOLCHAIN_URL := http://releases.linaro.org/14.11/components/toolchain/binaries/aarch64-none-elf/$(UBOOT_TOOLCHAIN)
UBOOT_TC_DIR := uboot_tc
UBOOT_TC_PATH := $(UBOOT_TC_DIR)/gcc-linaro-4.9-2014.11-x86_64_aarch64-elf/bin
UBOOT_TC_PREFIX = aarch64-none-elf-
UBOOT_REPO := https://github.com/hardkernel/u-boot.git
UBOOT_BRANCH := odroidc2-v2015.01
UBOOT_SRC := u-boot

LINUX_TOOLCHAIN := gcc-linaro-4.9-2014.11-x86_64_aarch64-linux-gnu.tar.xz
LINUX_TOOLCHAIN_URL := http://releases.linaro.org/14.11/components/toolchain/binaries/aarch64-linux-gnu/$(LINUX_TOOLCHAIN)
LINUX_TC_DIR := linux_tc
LINUX_TC_PATH := $(LINUX_TC_DIR)/bin
LINUX_TC_PREFIX := aarch64-linux-gnu-
LINUX_MAKE_CORES := 4
LINUX_REPO := https://github.com/hardkernel/linux.git
LINUX_BRANCH := odroidc2-3.14.y
LINUX_SRC := linux

