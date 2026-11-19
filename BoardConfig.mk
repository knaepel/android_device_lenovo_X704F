#
# SPDX-License-Identifier: Apache-2.0
#

include device/lenovo/msm8953-common/BoardConfigCommon.mk

DEVICE_PATH := device/lenovo/X704F

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8953
TARGET_NO_BOOTLOADER := true

# Display (1200x1920 panel, 10.1")
TARGET_SCREEN_DENSITY := 240

# Kernel (Lenovo's LK expects an appended DTB, see kernel/lenovo/msm8953)
TARGET_KERNEL_CONFIG := tbx704_defconfig
TARGET_KERNEL_VERSION := 4.9
BOARD_KERNEL_CMDLINE += \
    lpm_levels.sleep_disabled=1 printk.devkmsg=on \
    androidboot.usbconfigfs=true \
    androidboot.usbcontroller=7000000.dwc3

# Partitions (sizes from the device's GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 56555429376 # 56555445760 - 16384
BOARD_USES_METADATA_PARTITION := true

# No vendor partition: vendor files live in /system/vendor
TARGET_COPY_OUT_VENDOR := system/vendor

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# No A/B: one set of partitions and a separate recovery partition.
# Android 16 assumes A/B unless this is set explicitly.
AB_OTA_UPDATER := false

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Security patch level of the stock firmware (TrustZone, bootloader)
VENDOR_SECURITY_PATCH := 2018-10-01

# Inherit from the proprietary version
-include vendor/lenovo/X704F/BoardConfigVendor.mk

# Optional local bring-up overrides, not part of the repo
-include device/lenovo/X704F/bringup-board.mk
