DISTROOVERRIDES:append = ":mender-systemd"
INHERIT:append = " mender-full"

# Mender creates an image for the data partition with a bootstrap file.
IMAGE_FSTYPES:append = " dataimg factoryimg"
MENDER_FEATURES_ENABLE:append = " mender-uboot mender-growfs-data"
MENDER_FEATURES_DISABLE:append = " mender-grub mender-image-uefi mender-auth-install"

MENDER_ARTIFACT_NAME = "voyager-${DISTRO_VERSION}"

IMAGE_TYPEDEP:wic:append = " dataimg factoryimg mender"
