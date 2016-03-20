include common.mk

export ARCH := arm64
export CROSS_COMPILE := $(LINUX_TC_PREFIX)
export PATH := $(shell pwd)/$(LINUX_TC_PATH):$(PATH)

IMAGE_BIN := $(LINUX_SRC)/arch/arm64/boot/Image
MESON64_ODROIDC2_DTB_BIN := $(LINUX_SRC)/arch/arm64/boot/dts/meson64_odroidc2.dtb
CFG_FILE := $(LINUX_SRC)/.config

.PHONY: all
all: build

.PHONY: clean
clean:
	if test -d "$(LINUX_SRC)"; then $(MAKE) -C $(LINUX_SRC) clean ; fi
	rm -rf $(wildcard $(BOOT_DIR) $(BOOT_DIR).tmp $(MODS_DIR) $(MODS_DIR).tmp)

.PHONY: distclean
distclean:
	rm -rf $(wildcard $(LINUX_TC_DIR) $(LINUX_SRC) $(BOOT_DIR) $(MODS_DIR) $(MODS_DIR).tmp)

$(LINUX_TC_DIR): $(LINUX_TOOLCHAIN)
	mkdir -p $@
	tar xf $(LINUX_TOOLCHAIN) --strip-components=1 -C $@

$(LINUX_TOOLCHAIN):
	wget -O $@ $(LINUX_TOOLCHAIN_URL)
	touch $@

.PHONY: build
build: $(BOOT_DIR) $(MODS_DIR)

$(BOOT_DIR): $(IMAGE_BIN) $(MESON64_ODROIDC2_DTB_BIN)
	if test -d "$@.tmp"; then rm -rf "$@.tmp" ; fi
	if test -d "$@"; then rm -rf "$@" ; fi
	mkdir -p "$@.tmp"
	cp -p $(IMAGE_BIN) "$@.tmp"
	cp -p $(MESON64_ODROIDC2_DTB_BIN) "$@.tmp"
	mv "$@.tmp" $@

$(CFG_FILE): 
	$(MAKE) -C $(LINUX_SRC) odroidc2_defconfig

$(IMAGE_BIN): $(LINUX_TC_DIR) $(LINUX_SRC) $(CFG_FILE)
	$(MAKE) -C $(LINUX_SRC) -j $(LINUX_MAKE_CORES) Image

$(MESON64_ODROIDC2_DTB_BIN): $(CFG_FILE) $(IMAGE_BIN)
	$(MAKE) -C $(LINUX_SRC) -j $(LINUX_MAKE_CORES) dtbs

$(MODS_DIR): $(IMAGE_BIN)
	if test -d "$@.tmp"; then rm -rf "$@.tmp" ; fi
	if test -d "$@";     then rm -rf "$@"     ; fi
	mkdir -p "$@.tmp"
	$(MAKE) -C $(LINUX_SRC) -j $(LINUX_MAKE_CORES) modules
	$(MAKE) -C $(LINUX_SRC) INSTALL_MOD_PATH=$(abspath $(MODS_DIR).tmp) modules_install
	mv "$@.tmp" $@
	touch $@

$(LINUX_SRC):
	git clone --depth=1 $(LINUX_REPO) -b $(LINUX_BRANCH)

