PCI_COMMIT_ID:axelera-machine = "7e3bb45dc0578026bf98b34a91e2f0241e642d52"
FILE_NAME:axelera-machine = "pci.ids_${PCI_COMMIT_ID}"
SHA256SUM:axelera-machine = "7c26f0140f2194d29a2bb16545c9c69e1d9c0ef6b75f6c4dd37fb6d9b4618ca4"

python do_fetch:append:axelera-machine() {
    import os
    import subprocess

    sha256sum = d.getVar('SHA256SUM')
    file_name = d.getVar('FILE_NAME')
    commit_id = d.getVar('PCI_COMMIT_ID')
    dl_path = os.path.join(d.getVar('DL_DIR'), file_name)
    cmd = f"wget https://raw.githubusercontent.com/pciutils/pciids/{commit_id}/pci.ids -O {dl_path}"
    bb.note(cmd)

    if os.path.exists(dl_path):
        sha256_hash = bb.utils.sha256_file(dl_path)
        if sha256sum == sha256_hash:
            return
        bb.note(f"Checksum mismatch! {sha256_hash} != {sha256sum}.")
        bb.note("Attempting to redownload...")
        os.remove(dl_path)

    bb.note(f"Fetching pci.ids commit_id {commit_id}")
    try:
        subprocess.check_call(cmd.split())
    except subprocess.CalledProcessError as err:
        bb.fatal(f"Failed to download pci.ids v{commit_id}: {err}")

    if not os.path.exists(dl_path):
        bb.fatal(f"${dl_path} does not exist!")

    sha256_hash = bb.utils.sha256_file(dl_path)
    if sha256sum != sha256_hash:
        bb.fatal(f"Checksum mismatch! {sha256_hash} != {sha256sum}")
    return
}

do_configure:prepend:axelera-machine() {
    install -m 0755 "${DL_DIR}"/"${FILE_NAME}" "${WORKDIR}"/"${FILE_NAME}"
    gzip -c "${WORKDIR}"/"${FILE_NAME}" > "${WORKDIR}"/"${FILE_NAME}".gz
}

do_install:append:axelera-machine() {
    if ! zcat "${WORKDIR}"/"${FILE_NAME}".gz | grep -q "^C "; then
        bbfatal "Downloaded ${FILE_NAME} appears to be truncated or invalid (missing class info)."
    fi

    rm -f "${D}${datadir}"/pci.ids*
    install -m 0644 "${WORKDIR}"/"${FILE_NAME}".gz "${D}${datadir}"/pci.ids.gz
}
