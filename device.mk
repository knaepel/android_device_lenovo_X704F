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

# Camera: Lenovo sensor config with MountAngle 0 (landscape natural orientation)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/camera/camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera_config.xml

# fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom

# LiveDisplay: the display stack has no picture adjustment, system_server
# crashed on IPictureAdjustment.setPictureAdjustment
$(call soong_config_set_bool,livedisplay_sdm,enable_pa,false)

# Blur is too heavy for the Adreno 506 (as on onclite)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0 \
    ro.sf.blurs_are_expensive=0 \
    ro.surface_flinger.supports_background_blur=0 \
    persist.sys.sf.disable_blurs=1

# Tablet features (app widgets, home screen, ...). Launcher3 crashes without
# android.software.app_widgets.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml

# Audio: Lenovo platform info and mixer paths (identical to the stock
# /system/etc/mixer_paths_mtp.xml); ACDB files come from vendor/lenovo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/mixer_paths_mtp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_mtp.xml

# Touchscreen orientation (landscape)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/goodix-ts.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/goodix-ts.idc

# HWUI: the 2019 Adreno GL driver copies glTexSubImage2D data later in its
# own thread; the hardware bitmap uploader frees the source first and apps
# crash in GrallocUploadThread. The Vulkan pipeline does not hit this.
# SurfaceFlinger's GLES RenderEngine samples client buffers through broken
# GPU mappings (read page faults, white frames after the first screen off);
# its Vulkan RenderEngine composes correctly.
PRODUCT_SYSTEM_PROPERTIES += \
    debug.hwui.renderer=skiavk \
    debug.renderengine.backend=skiavkthreaded

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

# Camera (QCamera2 HAL, shims for the Android 7 mm-camera blobs)
PRODUCT_PACKAGES += \
    camera.msm8953 \
    libcamshim \
    libppeiscore_shim

# Inherit from the proprietary version
$(call inherit-product-if-exists, vendor/lenovo/X704F/X704F-vendor.mk)
