FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-clc-Fix-deprecated-lookupTarget-for-newer-LLVM.patch"

# Replace the compound big.LITTLE flag with a Clang-friendly one just for Mesa
TUNE_CCARGS:remove = "-mcpu=cortex-a76.cortex-a55+crypto"
TUNE_CCARGS:append = " -mcpu=cortex-a76+crypto"
