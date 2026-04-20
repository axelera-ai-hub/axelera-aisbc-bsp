# Simple recipe for using a mainline Linux kernel

LICENSE = "GPL-2.0-only"

inherit kernel kernel-yocto

# As we are using a fully mainline kernel there is no need to clone an
# entire git repository, which would take time and disk space. Downloading
# a tarball is enough. In real cases you might have an internal kernel
# repository with your branches, so it can make sense to fetch from
# there. Or you could be using a mainline kernel with only a few patches on
# top, and in that case downloading a tarball and applying your patches can
# be a good solution.
SRC_URI = "\
    ${KERNELORG_MIRROR}/linux/kernel/v7.x/linux-${PV}.tar.xz \
"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
S = "${UNPACKDIR}/linux-${PV}"

# Bypass the outdated Yocto configcheck that crashes on the 'transitional' keyword
do_kernel_configcheck[noexec] = "1"
