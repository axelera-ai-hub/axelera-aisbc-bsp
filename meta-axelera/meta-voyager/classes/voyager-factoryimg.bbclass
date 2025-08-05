# This is needed for the rockchip-image.bbclass that only processes .img
# files and mender creates a .factoryimg file.
# Name the image "voyager-factory.img to avoid having to change the wic file.
IMAGE_CLASSES += "mender-factoryimg"

IMAGE_CMD:factoryimg:append() {
    cd "${IMGDEPLOYDIR}"
    mv "${IMGDEPLOYDIR}/${IMAGE_NAME}.factoryimg" "${IMGDEPLOYDIR}/voyager-factory.img"
}
