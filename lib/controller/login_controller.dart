import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/controller/otp_verify_controller.dart";
import "package:ricemoto/repository/auth_repository.dart";
import "package:ricemoto/services/api_client.dart";
import "package:ricemoto/values/app_strings.dart";

/// State + actions for the phone-based "Sign in" screen.
class LoginController extends GetxController {
  LoginController(this._authRepository);

  final AuthRepository _authRepository;

  final TextEditingController phoneCtrl = TextEditingController();

  final RxBool isLoading = false.obs;

  static const String dialCode = "+84";

  /// Local digits typed by the user (country code stripped, leading 0 removed).
  String get _digits =>
      phoneCtrl.text.replaceAll(RegExp(r"[^0-9]"), "").replaceFirst(RegExp(r"^0+"), "");

  /// Full E.164 number sent to Firebase, e.g. "+8491...".
  String get _fullPhone => "$dialCode$_digits";

  bool get _isPhoneValid => _digits.length >= 9;

  /// Sends an SMS code, then routes to the OTP screen.
  Future<void> submit() async {
    if (isLoading.value) return;
    if (!_isPhoneValid) {
      _toast(AppStrings.phoneInvalid.tr);
      return;
    }

    isLoading.value = true;
    await _authRepository.verifyPhoneNumber(
      phoneNumber: _fullPhone,
      onCodeSent: (String verificationId, int? resendToken) {
        isLoading.value = false;
        Get.toNamed<void>(
          AppRoutes.otpVerify,
          arguments: OtpArgs(
            verificationId: verificationId,
            phoneNumber: _fullPhone,
            resendToken: resendToken,
          ),
        );
      },
      onError: (FirebaseAuthException e) {
        isLoading.value = false;
        _toast(e.message ?? AppStrings.authFailed.tr);
      },
      onAutoVerified: (_) {
        isLoading.value = false;
        Get.offAllNamed<void>(_authRepository.postAuthRoute);
      },
    );
  }

  Future<void> continueWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await _authRepository.signInWithGoogle();
      isLoading.value = false;
      Get.offAllNamed<void>(_authRepository.postAuthRoute);
    } on ApiException catch (e) {
      isLoading.value = false;
      _toast(e.message);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      // Silent when the user simply dismissed the Google chooser.
      if (e.code != "canceled" && e.code != "web-context-canceled") {
        _toast(e.message ?? AppStrings.authFailed.tr);
      }
    } catch (_) {
      isLoading.value = false;
    }
  }

  void forgotPassword() => Get.toNamed<void>(AppRoutes.forgotPassword);

  /// Switch to the create-account screen (replaces this one in the stack).
  void goToRegister() => Get.offNamed<void>(AppRoutes.register);

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
