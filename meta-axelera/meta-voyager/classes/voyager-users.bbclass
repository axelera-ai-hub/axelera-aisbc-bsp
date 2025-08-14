inherit extrausers

# Force gid 1000 to ensure that the Ubuntu user in the docker container,
# and the axelera group on the host have the same GID. This allows permissions
# between the Ubuntu user in the docker container to be shared between the host
# and the container.
EXTRA_USERS_PARAMS = "\
  groupadd docker; \
  groupadd -g 1000 axelera; \
"

PASSWORD:itx-3588j = "\$1\$moraR.7A\$pfg9OHFPwNoI0xsrPGsHX/"
PASSWORD:antelao-3588 = "\$1\$fK445h2M\$JFznFB4S6TEAxsGSd/jXE/"

EXTRA_USERS_PARAMS += " useradd -m -p '${PASSWORD}' -g axelera -G axelera,docker,video,input ${WESTON_USER}; "
EXTRA_USERS_PARAMS += " usermod -p '\$1\$duJ3gRL2\$Ixot1IIHoh.8B9HqKn1D./' root; "


do_create_mount_points() {
    mkdir -p ${IMAGE_ROOTFS}/data
    mkdir -p ${IMAGE_ROOTFS}/factory
}

do_change_home_ownerships() {
    chown -R "${WESTON_USER}":axelera "${IMAGE_ROOTFS}/home/${WESTON_USER}"
    chmod 0775 "${IMAGE_ROOTFS}/home/${WESTON_USER}"
}

ROOTFS_POSTPROCESS_COMMAND:append = " do_change_home_ownerships; do_create_mount_points; "
