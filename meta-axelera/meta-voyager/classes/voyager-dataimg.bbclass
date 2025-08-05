# This is needed for the rockchip-image.bbclass that only processes .img
# files and mender creates a .dataimg file.
# Name the image "voyager-data.img to avoid having to change the wic file.
IMAGE_CMD:dataimg:append() {
    cd "${IMGDEPLOYDIR}"
    mv "${IMGDEPLOYDIR}/${IMAGE_NAME}.dataimg" "${IMGDEPLOYDIR}/voyager-data.img"
}
