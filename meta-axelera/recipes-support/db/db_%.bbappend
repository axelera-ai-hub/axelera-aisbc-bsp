# many configure tests are failing with gcc-14
CFLAGS:axelera-machine += "-Wno-error=implicit-int -Wno-error=implicit-function-declaration"
BUILD_CFLAGS:axelera-machine += "-Wno-error=implicit-int -Wno-error=implicit-function-declaration"
