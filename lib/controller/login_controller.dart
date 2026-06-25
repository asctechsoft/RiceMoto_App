import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/repository/auth_repository.dart";
import "package:ricemoto/values/app_strings.dart";

/// State + actions for the phone-based "Sign in" screen.
class LoginController extends GetxController {
  LoginController(this._authRepository);

  final AuthRepository _authRepository;

  final TextEditingController phoneCtrl = TextEditingController();

  final RxBool isLoading = false.obs;

  static const String dialCode = "+84";

  bool get _isPhoneValid => phoneCtrl.text.trim().length >= 9;

  Future<void> submit() async {
    if (!_isPhoneValid) {
      _toast(AppStrings.phone.tr);
      return;
    }
    await _run(() => _authRepository.loginWithPhone(
          phone: "$dialCode${phoneCtrl.text.trim()}",
        ));
  }

  Future<void> continueWithGoogle() =>
      _run(_authRepository.continueWithGoogle);

  // TODO: wire a password-recovery flow once the backend exists.
  void forgotPassword() => _toast(AppStrings.forgotPassword.tr);

  /// Switch to the create-account screen (replaces this one in the stack).
  void goToRegister() => Get.offNamed(AppRoutes.register);

  Future<void> _run(Future<void> Function() action) async {
    isLoading.value = true;
    try {
      await action();
      Get.offAllNamed(AppRoutes.home);
    } finally {
      isLoading.value = false;
    }
  }

  void _toast(String message) => Get.snackbar(
        AppStrings.login.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
