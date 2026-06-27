import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_strings.dart";

/// State for the Forgot Password screen. Local stub — swap [submit] for a real
/// password-reset call when the backend exists.
class ForgotPasswordController extends GetxController {
  final TextEditingController phoneCtrl = TextEditingController();
  final RxBool isLoading = false.obs;

  static const String dialCode = "+84";

  bool get _isPhoneValid => phoneCtrl.text.trim().length >= 9;

  Future<void> submit() async {
    if (!_isPhoneValid) {
      Get.snackbar(
        AppStrings.fpTitle.tr,
        AppStrings.phone.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;
    Get.back<void>();
    Get.snackbar(
      AppStrings.fpTitle.tr,
      AppStrings.fpSent.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
