IMAGE_CMD:voyager-dataimg() {
    image_name="voyager-data"
    dd if=/dev/zero of="${WORKDIR}/${image_name}.ext4" count=0 bs=1M seek=64
    mkfs.ext4 -F "${WORKDIR}/${image_name}.ext4" -L "data"
    mv "${WORKDIR}/${image_name}.ext4" "${IMGDEPLOYDIR}/${image_name}.img"
    chmod 0644 "${IMGDEPLOYDIR}/${image_name}.img"
}

IMAGE_CLASSES += "voyager-dataimg"
IMAGE_TYPEDEP:wic:append = " voyager-dataimg"
