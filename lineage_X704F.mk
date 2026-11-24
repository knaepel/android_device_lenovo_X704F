#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Inherit some common Lineage stuff (tablet, Wi-Fi only)
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Inherit from X704F device
$(call inherit-product, device/lenovo/X704F/device.mk)

PRODUCT_DEVICE := X704F
PRODUCT_NAME := lineage_X704F
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo TB-X704F
PRODUCT_MANUFACTURER := LENOVO

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="hq_msm8953_64-user 7.1.1 NMF26F 1581 release-keys" \
    BuildFingerprint=Lenovo/LenovoTB-X704F/X704F:7.1.1/NMF26F/TB-X704F_S000056_181015_ROW:user/release-keys \
    DeviceProduct=LenovoTB-X704F

