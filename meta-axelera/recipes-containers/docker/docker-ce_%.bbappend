FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://0001-docker.service-Drop-the-dependency-from-network-wait.patch;patchdir=src/import \
"
