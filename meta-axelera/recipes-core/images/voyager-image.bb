# Build a simple, minimal root filesystem.
#
# This recipe is a simplified form of core-image-minimal.

SUMMARY = "A simple, minimal image"

IMAGE_INSTALL = "packagegroup-core-boot dropbear"

IMAGE_LINGUAS = " "

# Some partitons, e.g. trust, are allowed to be optional.
do_fixup_wks[depends] += " \
        virtual/kernel:do_deploy \
        virtual/bootloader:do_deploy \
"
do_fixup_wks() {
        [ -f "${WKS_FULL_PATH}" ] || return

        IMAGES=$(grep -o "[^=]*\.img" "${WKS_FULL_PATH}")

        for image in ${IMAGES};do
                if [ ! -f "${DEPLOY_DIR_IMAGE}/${image}" ];then
                        echo "${image} not provided, ignoring it."
                        sed -i "/file=${image}/d" "${WKS_FULL_PATH}"
                fi
        done
}
addtask do_fixup_wks after do_write_wks_template before do_image_wic

IMAGE_INIT_MANAGER  = "systemd"

inherit core-image
