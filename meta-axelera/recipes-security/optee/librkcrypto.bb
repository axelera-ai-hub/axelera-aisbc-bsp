SUMMARY = "Rockchip Crypto Library and test"
DESCRIPTION = "\
    librkcrypto provides a hardware-based algorithm interface that \
    supports the use of DMA to calculate data, which can be used for \
    various scenarios such as decryption and authentication. \
"
LICENSE = "CLOSED"

inherit cmake

DEPENDS += "optee-rockchip"

SRC_URI = "git://gitea@gitea.amarulasolutions.com:38745/axelera/optee-rockchip;protocol=ssh;branch=master"
SRCREV = "bf8d67f6e8e8b269e0198b45353440ba78c2b881"

S = "${WORKDIR}/git/librkcrypto"

PACKAGES =+ "${PN}-test"
FILES:${PN}-test += "${bindir}/librkcrypto_test"
RDEPENDS:${PN}-test += "${PN}"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""
