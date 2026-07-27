# Copyright (C) 2019, Fuzhou Rockchip Electronics Co., Ltd
# Released under the MIT license (see COPYING.MIT for the terms)

inherit python3-dir

DEPENDS:append = " openssl-native lz4-native ${PYTHON_PN}-native python-native rk-binary-native"

LINUX_VERSION_EXTENSION ?= "-rockchip-${LINUX_KERNEL_TYPE}"

PATCHPATH = "${THISDIR}/${BPN}_${LINUX_VERSION}"
inherit auto-patch

INSANE_SKIP:${PN}-src += "buildpaths"

KCONFIG_MODE ?= "--alldefconfig"

SRC_URI = "file://private_key.pem"

# Make sure we use /usr/bin/env ${PYTHON_PN} for scripts
do_patch:append() {
	for s in `grep -rIl python ${S}/scripts`; do
		sed -i -e '1s|^#!.*python[23]*|#!/usr/bin/env ${PYTHON_PN}|' $s
	done

	# Without this firmware, the kernel fails to build with the following error:
	# Error: file not found: drivers/gpu/arm/bifrost/mali_csffw.bin
	if [ -f "${S}/drivers/gpu/arm/bifrost/mali_csffw.bin" ];then
		install -d ${B}/drivers/gpu/arm/bifrost
		install ${S}/drivers/gpu/arm/bifrost/mali_csffw.bin ${B}/drivers/gpu/arm/bifrost/mali_csffw.bin
	fi
}

do_compile:prepend() {
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

do_compile_kernelmodules:prepend() {
	export PKG_CONFIG_DIR="${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig"
	export PKG_CONFIG_PATH="$PKG_CONFIG_DIR:${STAGING_DATADIR_NATIVE}/pkgconfig"
	export PKG_CONFIG_LIBDIR="$PKG_CONFIG_DIR"
	export PKG_CONFIG_SYSROOT_DIR=""
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${STAGING_LIBDIR_NATIVE}
}

# Hack for rockchip style images
KERNEL_IMAGETYPES:append = \
	"${@' boot.img zboot.img' if d.getVar('ROCKCHIP_KERNEL_IMAGES') == '1' else ''}"
python () {
    if not d.getVar('KERNEL_DEVICETREE'):
        raise bb.parse.SkipPackage('KERNEL_DEVICETREE is not specified!')

    if d.getVar('ROCKCHIP_KERNEL_IMAGES'):
        # Use rockchip stype target, which is '<dts(w/o suffix)>.img'
        d.setVar('KERNEL_IMAGETYPE_FOR_MAKE', ' ' + d.getVar('KERNEL_DEVICETREE').replace('rockchip/', '').replace('.dtb', '.img'));
}

do_kernel_metadata:prepend() {
	# Force regenerating defconfig
	rm -f ${WORKDIR}/defconfig

	# Support defconfig fragments
	cd "${S}/arch/${ARCH}/configs"
	if [ ! -f "${KBUILD_DEFCONFIG}" ]; then
		DEFCONFIGS="rockchip_linux_defconfig ${RK_SOC_FAMILY}_linux.config"
		[ "$KBUILD_DEFCONFIGS" ] || KBUILD_DEFCONFIGS="$DEFCONFIGS"

		echo "Merging $KBUILD_DEFCONFIGS into $KBUILD_DEFCONFIG..."
		cat ${KBUILD_DEFCONFIGS:-$CONFIGS} > ${KBUILD_DEFCONFIG} || true
	fi
	cd -
}

# Link rockchip style images
do_install:prepend() {
	for image in $(ls "${B}/" | grep ".img$"); do
		ln -rsf ${B}/${image} ${B}/arch/${ARCH}/boot/
	done

	if [ "${ROCKCHIP_KERNEL_COMPRESSED}" = "1" ]; then
		if [ -r "${B}/zboot.img" ]; then
			ln -rsf ${B}/zboot.img ${B}/arch/${ARCH}/boot/boot.img
		fi
	fi
}

do_deploy:append() {
	# Create boot.img to bundle ramdisk
	echo "Manually creating boot.img using mkbootimg..."
	${S}/scripts/mkbootimg \
		--kernel ${B}/arch/${ARCH}/boot/Image.lz4 \
		--ramdisk ${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz \
		--second ${B}/resource.img \
		--cmdline "root=PARTUUID=${RK_ROOTDEV_UUID}" \
		-o ${DEPLOYDIR}/boot.img

	# Back up the unsigned image for testing purposes
	echo "Backing up unsigned boot.img as unsigned_boot.img..."
	cp ${DEPLOYDIR}/boot.img ${DEPLOYDIR}/unsigned_boot.img

	# Sign boot.img in order to generate vbmeta
	echo "Adding AVB hash footer to boot.img..."
	nativepython ${STAGING_BINDIR_NATIVE}/avbtool add_hash_footer \
		--image ${DEPLOYDIR}/boot.img \
		--partition_name boot \
		--partition_size 50331648 \
		--algorithm SHA256_RSA2048 \
		--key ${WORKDIR}/private_key.pem

	# Generate vbmeta partition for AVB checking
	echo "Generating standalone vbmeta.img from boot.img descriptors..."
	nativepython ${STAGING_BINDIR_NATIVE}/avbtool make_vbmeta_image \
		--include_descriptors_from_image ${DEPLOYDIR}/boot.img \
		--padding_size 4096 \
		--algorithm SHA256_RSA2048 \
		--key ${WORKDIR}/private_key.pem \
		--output ${DEPLOYDIR}/vbmeta.img
}
