# Class to create the "factoryimg" type, which contains the factory partition as a raw
# filesystem.

inherit mender-bootstrap-artifact

IMAGE_CMD:factoryimg() {
    force_flag="-F"
    root_dir_flag="-d ${_MENDER_ROOTFS_COPY_FACTORY}"
    volume_label_flag="-L"

    dd if=/dev/zero of="${WORKDIR}/factory.ext4" count=0 bs=1M seek=${AXELERA_MENDER_FACTORY_PART_SIZE_MB}
    mkfs.ext4 \
        $force_flag \
        "${WORKDIR}/factory.ext4" \
        $root_dir_flag \
        $volume_label_flag "factory"

    chmod 0644 "${WORKDIR}/factory.ext4"
    mv "${WORKDIR}/factory.ext4" "${IMGDEPLOYDIR}/${IMAGE_NAME}.factoryimg"
}

python do_copy_rootfs_factory() {
    from oe.path import copyhardlinktree

    _from = os.path.realpath(os.path.join(d.getVar("IMAGE_ROOTFS"), "factory"))
    _to = os.path.realpath(os.path.join(d.getVar("WORKDIR"), "factory.copy.%s" % d.getVar('BB_CURRENTTASK')))

    copyhardlinktree(_from, _to)

    d.setVar('_MENDER_ROOTFS_COPY_FACTORY', _to)
}

python do_delete_copy_rootfs_factory() {
    import subprocess

    copy_dir = d.getVar('_MENDER_ROOTFS_COPY_FACTORY')

    subprocess.check_call(["rm", "-rf", copy_dir])
}

fakeroot do_install_bootstrap_artifact_factory () {
    if [ -e "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.bootstrap-artifact" ]; then
        install -d "${_MENDER_ROOTFS_COPY_FACTORY}/mender/"
        install -m 0400 "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.bootstrap-artifact" "${_MENDER_ROOTFS_COPY_FACTORY}/mender/bootstrap.mender"
    fi
}

# We need the factory contents intact.
do_image_factoryimg[respect_exclude_path] = "0"

do_image_factoryimg[depends] += "${@bb.utils.contains_any('MENDER_FACTORY_PART_FSTYPE_TO_GEN', 'ext2 ext3 ext4','e2fsprogs-native:do_populate_sysroot','',d)}"

do_image_factoryimg[prefuncs] += " do_copy_rootfs_factory do_install_bootstrap_artifact_factory"
do_image_factoryimg[postfuncs] += " do_delete_copy_rootfs_factory"

IMAGE_TYPEDEP:factoryimg:append = " bootstrap-artifact"
