IMAGE_FSTYPES = "cpio.gz"
IMAGE_CLASSES = "dm-verity-img"
IMAGE_ROOTFS_SIZE = "8192"

AXE_DM_VERITY = "${@bb.utils.contains('DISTRO_FEATURES', 'voyager-dm-verity', '1', '0', d)}"

deploy_verity_hash() {
    if [ "${AXE_DM_VERITY}" = "1" ]; then
        install -D -m 0644 \
            ${STAGING_VERITY_DIR}/${DM_VERITY_IMAGE}.${DM_VERITY_IMAGE_TYPE}.verity.env \
            ${IMAGE_ROOTFS}${datadir}/misc/dm-verity.env
    else
        rm -f ${IMAGE_ROOTFS}${datadir}/misc/dm-verity.env
    fi
}
