do_download_latest_pciids() {
    bbplain "Executing custom task to fetch latest pci.ids.gz"
    wget -O ${WORKDIR}/pci.ids.gz.latest https://pci-ids.ucw.cz/v2.2/pci.ids.gz
}

addtask do_download_latest_pciids after do_unpack before do_install

do_install:append() {
    if ! zcat ${WORKDIR}/pci.ids.gz.latest | grep -q "^C "; then
        bbfatal "Downloaded pci.ids.gz appears to be truncated or invalid (missing class info)."
    fi

    rm -f ${D}${datadir}/pci.ids*

    install -m 0644 ${WORKDIR}/pci.ids.gz.latest ${D}${datadir}/pci.ids.gz
}
