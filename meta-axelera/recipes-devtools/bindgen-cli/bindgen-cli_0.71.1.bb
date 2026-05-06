SUMMARY = "Automatically generates Rust FFI bindings to C and C++ libraries."
HOMEPAGE = "https://rust-lang.github.io/rust-bindgen/"
LICENSE = "BSD-3-Clause"

LIC_FILES_CHKSUM = "file://LICENSE;md5=0b9a98cb3dcdefcceb145324693fda9b"

inherit rust cargo cargo-update-recipe-crates

SRC_URI += "git://github.com/rust-lang/rust-bindgen.git;protocol=https;branch=main"
SRCREV = "af7fd38d5e80514406fb6a8bba2d407d252c30b9"
S = "${WORKDIR}/git"

require ${BPN}-crates.inc

create_wrapper_bindgen () {
	# Create a wrapper script where extra environment variables are needed
	#
	# These are useful to work around relocation issues, by setting environment
	# variables which point to paths in the filesystem.
	#
	# Usage: create_wrapper FILENAME [[VAR=VALUE]..]

	cmd=$1
	shift

	echo "Generating wrapper script for $cmd"

	mv $cmd $cmd.real
	cmdname=`basename $cmd`
	dirname=`dirname $cmd`
	exportstring=$@
	if [ "${base_prefix}" != "" ]; then
		relpath=`python3 -c "import os; print(os.path.relpath('${D}${base_prefix}', '$dirname'))"`
		exportstring=`echo $@ | sed -e "s:${base_prefix}:\\$realdir/$relpath:g"`
	fi
	cat <<END >$cmd
#!/bin/bash
realpath=\`readlink -fn \$0\`
realdir=\`dirname \$realpath\`
export $exportstring
exec -a "\$0" \$realdir/$cmdname.real "\$@"
END
	chmod +x $cmd
}

do_install:append:class-native() {
	create_wrapper_bindgen ${D}/${bindir}/bindgen LIBCLANG_PATH="${STAGING_LIBDIR_NATIVE}"
}

RDEPENDS:${PN} = "libclang"

BBCLASSEXTEND = "native"
