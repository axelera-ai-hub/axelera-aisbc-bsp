IMAGE_CMD:voyager-updateimg() {
  mender-artifact write module-image \
    -T mender-update \
    -n "voyager-${DISTRO_VERSION}" \
    -t "${MENDER_DEVICE_TYPE}" \
    -m "${IMGDEPLOYDIR}"/"${IMAGE_NAME}"-voyager-update-manifest.json \
    -f "${IMGDEPLOYDIR}"/"${IMAGE_NAME}"-voyager-update-files.tar.zst \
    -o ${IMGDEPLOYDIR}/${IMAGE_NAME}.mender

  ln -sf "${IMAGE_NAME}".mender \
    "${IMGDEPLOYDIR}"/"${IMAGE_LINK_NAME}".mender
}

do_create_update_tarball() {
  BOOT_IMAGE="boot.img"
  VBMETA_IMAGE="vbmeta.img"
  ROOT_IMAGE="${IMAGE_NAME}.${DM_VERITY_IMAGE_TYPE}.verity"

  rm -rf "${IMGDEPLOYDIR}"/update-files
  mkdir -p "${IMGDEPLOYDIR}"/update-files

  cp -dH "${IMGDEPLOYDIR}"/"${ROOT_IMAGE}" "${IMGDEPLOYDIR}"/update-files/
  cp -dH "${DEPLOY_DIR_IMAGE}"/"${BOOT_IMAGE}" "${IMGDEPLOYDIR}"/update-files/
  cp -dH "${DEPLOY_DIR_IMAGE}"/"${VBMETA_IMAGE}" "${IMGDEPLOYDIR}"/update-files/

  jq -n \
    --arg boot "${BOOT_IMAGE}" \
    --arg root "${ROOT_IMAGE}" \
    --arg vbmeta "${VBMETA_IMAGE}" \
    '{boot: $boot, root: $root, vbmeta: $vbmeta}' \
    > "${IMGDEPLOYDIR}"/update-files/contents.json

  cd "${IMGDEPLOYDIR}"
  tar --use-compress-program="zstd --threads=${BB_NUMBER_THREADS}" \
    -cf "${IMAGE_NAME}"-voyager-update-files.tar.zst \
    -C "${IMGDEPLOYDIR}"/update-files \
    .

  cd -
  ln -sf "${IMAGE_NAME}"-voyager-update-files.tar.zst \
    "${IMGDEPLOYDIR}"/"${IMAGE_LINK_NAME}"-voyager-update-files.tar.zst

  rm -rf "${IMGDEPLOYDIR}"/update-files
}

do_write_mender_manifest () {
  jq -n \
    --arg image_name "${IMAGE_NAME}-voyager-update-files.tar.zst" \
    '{files: [{name: $image_name, type: "file"}]}' \
      > ${IMGDEPLOYDIR}/"${IMAGE_NAME}"-voyager-update-manifest.json

  ln -sf "${IMAGE_NAME}"-voyager-update-manifest.json \
    "${IMGDEPLOYDIR}"/"${IMAGE_LINK_NAME}"-voyager-update-manifest.json
}

do_image_voyager_updateimg[depends] += "\
    ${PN}:do_image_ext4 \
    virtual/kernel:do_deploy \
    jq-native:do_populate_sysroot \
"

do_image_voyager_updateimg[prefuncs] += " do_create_update_tarball do_write_mender_manifest"
