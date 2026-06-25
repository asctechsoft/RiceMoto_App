import "package:dsp_base/convenience_imports.dart";
import "package:dsp_base/values/permission.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:permission_handler/permission_handler.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/models/vehicle_model.dart";
import "package:ricemoto/presentation/home/widgets/receipt_source_sheet.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// Manages the selected bottom-tab for the Home shell.
///
/// Tab order matches the bottom bar: Home(0), History(1), Reports(2),
/// Account(3). The center "Add expense" button is a standalone action and is
/// intentionally NOT part of this index.
class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// The locally-stored vehicle, if the user has set one up.
  VehicleModel? get vehicle => StorageService.vehicle;

  /// True when the user is browsing without an account (guest entry flow).
  bool get isGuest => StorageService.hasVehicle && !StorageService.isLoggedIn;

  /// Current month label, e.g. "Tháng 6, 2025".
  String get monthLabel {
    final DateTime now = DateTime.now();
    return AppStrings.monthYear.trParams(<String, String>{
      "month": now.month.toString(),
      "year": now.year.toString(),
    });
  }

  void changeTab(int index) => currentIndex.value = index;

  void goToRegister() => Get.toNamed(AppRoutes.register);

  /// Opens the "add a receipt" source picker.
  void onScanPressed() {
    Get.bottomSheet(
      ReceiptSourceSheet(
        onCamera: () => _addReceipt(PermissionTypes.camera),
        onGallery: () => _addReceipt(PermissionTypes.photos),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  /// Requests the relevant permission, then continues to the (WIP) capture flow.
  Future<void> _addReceipt(PermissionTypes type) async {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    final PermissionResult result =
        await PermissionUtils.requestPermission(type);
    switch (result) {
      case PermissionResult.granted:
      case PermissionResult.limited:
      case PermissionResult.provisional:
        if (type == PermissionTypes.camera) {
          Get.toNamed(AppRoutes.cameraScan);
        } else {
          // TODO: open the image picker and parse the selected receipt.
          Get.snackbar(
            AppStrings.addReceiptTitle.tr,
            AppStrings.featureComingSoon.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      case PermissionResult.permanentlyDenied:
      case PermissionResult.restricted:
        _showSettingsDialog();
      case PermissionResult.denied:
      case PermissionResult.unknown:
        Get.snackbar(
          AppStrings.permissionNeededTitle.tr,
          AppStrings.permissionDenied.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.permissionNeededTitle.tr),
        content: Text(AppStrings.permissionPermanentlyDenied.tr),
        actions: <Widget>[
          TextButton(
            onPressed: Get.back,
            child: Text(
              AppStrings.cancel.tr,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text(AppStrings.openSettings.tr),
          ),
        ],
      ),
    );
  }
}
