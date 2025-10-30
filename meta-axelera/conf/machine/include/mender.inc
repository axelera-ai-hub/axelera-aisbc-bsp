#############################
# Mender-specific settings.
#############################

BOOTENV_SIZE = "0x20000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1 = "0x5400000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2 = "0x5420000"
MENDER_UBOOT_STORAGE_INTERFACE = "mmc"
MENDER_UBOOT_STORAGE_DEVICE = "0"
MENDER_ROOTFS_PART_A_NUMBER = "6"
MENDER_ROOTFS_PART_B_NUMBER = "7"
MENDER_DATA_PART_SIZE_MB = "128"
AXELERA_MENDER_FACTORY_PART_SIZE_MB = "128"

# Total size for BOTH partitions. 4096 == 2048 Megabytes (2 Gigabytes) per rootfs.
MENDER_STORAGE_TOTAL_SIZE_MB = "4096"

# Do not add padding.
IMAGE_OVERHEAD_FACTOR = "1.0"

# There is an fstab provided in recipes-core/base-files/files/
ROOTFS_POSTPROCESS_COMMAND:remove = "mender_update_fstab_file;"

# Data partition
MENDER_DATA_PART_NUMBER ?= "9"
