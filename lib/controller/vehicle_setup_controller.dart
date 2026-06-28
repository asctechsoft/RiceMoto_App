import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/models/vehicle_model.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_strings.dart";

/// Collects the basic info for the user's first motorcycle (guest entry flow).
class VehicleSetupController extends GetxController {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController kmCtrl = TextEditingController();
  final TextEditingController plateCtrl = TextEditingController();

  /// Brand presets shown as chips (a localized "Other" is appended in the UI).
  static const List<String> brands = <String>[
    "Honda",
    "Yamaha",
    "Suzuki",
    "Piaggio",
  ];

  final RxString selectedBrand = brands.first.obs;
  final RxBool isLoading = false.obs;

  void selectBrand(String brand) => selectedBrand.value = brand;

  Future<void> submit() async {
    final String name = nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        AppStrings.addVehicleTitle.tr,
        AppStrings.vehicleName.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Keep digits only — the field may contain "12.000" / "12,000".
      final int km =
          int.tryParse(kmCtrl.text.replaceAll(RegExp(r"[^0-9]"), "")) ?? 0;
      await StorageService.setVehicle(
        VehicleModel(
          name: name,
          brand: selectedBrand.value,
          currentKm: km,
          plate: plateCtrl.text.trim(),
        ),
      );
      // Reset before navigation — Get.offAllNamed disposes this controller,
      // so any Rx update in a finally block would write to a disposed object.
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.home);
    } catch (_) {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    kmCtrl.dispose();
    plateCtrl.dispose();
    super.onClose();
  }
}
