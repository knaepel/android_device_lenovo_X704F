#
# SPDX-License-Identifier: Apache-2.0
#

# Shipped with Android 7.1.1
PRODUCT_SHIPPING_API_LEVEL := 25

# Inherit from msm8953-common
$(call inherit-product, device/lenovo/msm8953-common/msm8953.mk)

# Dalvik heap (3/4 GB RAM tablet)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# Screen
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1200
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.X704F.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.X704F.rc

# fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom

# LiveDisplay: the display stack has no picture adjustment, system_server
# crashed on IPictureAdjustment.setPictureAdjustment
$(call soong_config_set_bool,livedisplay_sdm,enable_pa,false)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Optional local bring-up settings (adb key), not part of the repo
-include $(LOCAL_PATH)/bringup.mk

# Keystore: software KeyMint and Gatekeeper for bring-up.
# TODO: replace with the TrustZone keymaster (Lenovo keystore.msm8953.so).
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service.nonsecure \
    com.android.hardware.gatekeeper.nonsecure

# Inherit from the proprietary version
$(call inherit-product-if-exists, vendor/lenovo/X704F/X704F-vendor.mk)
