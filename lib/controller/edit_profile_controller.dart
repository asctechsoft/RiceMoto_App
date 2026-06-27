import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/settings_controller.dart";
import "package:ricemoto/values/app_strings.dart";

/// State for the Edit Profile screen. Seeds its fields from [SettingsController]
/// and writes the edits back on [save].
class EditProfileController extends GetxController {
  final SettingsController _settings = Get.find<SettingsController>();

  late final TextEditingController nameCtrl =
      TextEditingController(text: _settings.fullName.value);
  late final TextEditingController emailCtrl =
      TextEditingController(text: _settings.email.value);

  String get phone => _settings.phoneNumber.value;

  void changePhoto() => Get.snackbar(
        AppStrings.epChangePhoto.tr,
        AppStrings.featureComingSoon.tr,
        snackPosition: SnackPosition.BOTTOM,
      );

  void save() {
    _settings.updateProfile(name: nameCtrl.text, email: emailCtrl.text);
    Get.back<void>();
    Get.snackbar(
      AppStrings.setEditProfile.tr,
      AppStrings.epSaved.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
