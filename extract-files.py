#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Source: Lenovo stock /system (Android 7.1.1). The camera blobs are the
# Android 7 mm-camera stack; the fixups follow device/xiaomi/mido.

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/lenovo/X704F',
    'device/lenovo/msm8953-common/platform/qcom',
    'vendor/lenovo/msm8953-common',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
    # Camera - path fixups (Android 7 used /data/misc/camera, /system/etc)
    'vendor/bin/mm-qcamera-daemon': blob_fixup()
        .binary_regex_replace(b'/data/misc/camera/cam_socket', b'/data/vendor/qcam/cam_socket'),
    'vendor/lib/libmmcamera2_sensor_modules.so': blob_fixup()
        .binary_regex_replace(b'/system/etc/camera', b'/vendor/etc/camera')
        .binary_regex_replace(b'/data/misc/camera/', b'/data/vendor/qcam/'),
    ('vendor/lib/libmmcamera2_cpp_module.so', 'vendor/lib/libmmcamera2_dcrf.so',
     'vendor/lib/libmmcamera2_iface_modules.so', 'vendor/lib/libmmcamera2_imglib_modules.so',
     'vendor/lib/libmmcamera2_mct.so', 'vendor/lib/libmmcamera2_pproc_modules.so',
     'vendor/lib/libmmcamera2_q3a_core.so', 'vendor/lib/libmmcamera2_stats_algorithm.so',
     'vendor/lib/libmmcamera_imglib.so', 'vendor/lib/libmmcamera_pdafcamif.so',
     'vendor/lib/libmmcamera_pdaf.so', 'vendor/lib/libmmcamera_tintless_algo.so',
     'vendor/lib/libmmcamera_tintless_bg_pca_algo.so'): blob_fixup()
        .binary_regex_replace(b'/data/misc/camera/', b'/data/vendor/qcam/'),
    'vendor/lib/libmmcamera_dbg.so': blob_fixup()
        .binary_regex_replace(b'/data/misc/camera/', b'/data/vendor/qcam/')
        .binary_regex_replace(b'persist.camera.debug.logfile', b'persist.vendor.camera.dbglog'),
    'vendor/lib/libmmcamera_tuning.so': blob_fixup()
        .binary_regex_replace(b'/data/misc/camera/', b'/data/vendor/qcam/')
        .remove_needed('libmm-qcamera.so'),
    # Camera - libandroid is not available to vendor
    'vendor/lib/libmmcamera2_stats_modules.so': blob_fixup()
        .binary_regex_replace(b'/data/misc/camera/', b'/data/vendor/qcam/')
        .add_needed('libcamshim.so')
        .remove_needed('libandroid.so'),
    'vendor/lib/libmmcamera_ppeiscore.so': blob_fixup()
        .add_needed('libppeiscore_shim.so')
        .add_needed('libGLESv3.so'),
    # Camera - Android 7 libstdc++
    ('vendor/lib/libchromaflash.so', 'vendor/lib/libmmcamera_hdr_gb_lib.so',
     'vendor/lib/liboptizoom.so', 'vendor/lib/libseemore.so', 'vendor/lib/libtrueportrait.so',
     'vendor/lib/libts_detected_face_hal.so', 'vendor/lib/libts_face_beautify_hal.so',
     'vendor/lib/libubifocus.so'): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    'vendor/lib/libts_face_beautify_hal.so': blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    # Camera - Android 7 blobs call liblog without listing it
    ('vendor/lib/libjpegdhw.so',
     'vendor/lib/libjpegdmahw.so',
     'vendor/lib/libjpegehw.so',
     'vendor/lib/libllvd_smore.so',
     'vendor/lib/libmmcamera2_sensor_modules.so',
     'vendor/lib/libmmcamera_cac3_lib.so',
     'vendor/lib/libmmcamera_dbg.so',
     'vendor/lib/libmmcamera_gc2375.so',
     'vendor/lib/libmmcamera_hdr_gb_lib.so',
     'vendor/lib/libmmcamera_pdaf.so',
     'vendor/lib/libmmcamera_pdafcamif.so',
     'vendor/lib/libmmcamera_tintless_bg_pca_algo.so',
     'vendor/lib/libqomx_jpegdec.so',
     'vendor/lib/libqomx_jpegenc.so',
     'vendor/lib/libqomx_jpegenc_pipe.so'): blob_fixup()
        .add_needed('liblog.so'),
    'vendor/lib/libstdc++_vendor.so': blob_fixup()
        .fix_soname(),
}  # fmt: skip

module = ExtractUtilsModule(
    'X704F',
    'lenovo',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
