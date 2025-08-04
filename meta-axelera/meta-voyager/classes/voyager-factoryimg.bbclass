IMAGE_CMD:voyager-factoryimg() {
    image_name="${IMAGE_BASENAME}-factoryimg"
    dd if=/dev/zero of="${WORKDIR}/${image_name}.ext4" count=0 bs=1M seek=64
    mkfs.ext4 -F "${WORKDIR}/${image_name}.ext4" -L "data"
    mv "${WORKDIR}/${image_name}.ext4" "${IMGDEPLOYDIR}/${image_name}.img"
    chmod 0644 "${IMGDEPLOYDIR}/${image_name}.img"
}

IMAGE_CLASSES += "voyager-factoryimg"
IMAGE_TYPEDEP:wic:append = " voyager-factoryimg"
