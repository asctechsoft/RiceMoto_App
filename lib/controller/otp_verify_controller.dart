import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:ricemoto/repository/auth_repository.dart";
import "package:ricemoto/services/api_client.dart";
import "package:ricemoto/values/app_strings.dart";

/// Navigation payload handed to the OTP screen from login / register.
class OtpArgs {
  const OtpArgs({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  /// Identifier returned by `verifyPhoneNumber`, needed to build the credential.
  final String verificationId;

  /// Full E.164 number (e.g. "+8491...") — shown in the subtitle and reused on
  /// resend.
  final String phoneNumber;

  /// Token that lets a resend reuse the same verification session.
  final int? resendToken;
}

/// Drives the SMS code-entry screen: validates the 6-digit code, completes the
/// Firebase sign-in, and manages the resend cooldown.
class OtpVerifyController extends GetxController {
  OtpVerifyController(this._authRepository);

  final AuthRepository _authRepository;

  final TextEditingController codeCtrl = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxBool isLoading = false.obs;

  /// Mirror of [codeCtrl] so the box UI can react to typing.
  final RxString code = "".obs;

  /// Seconds left before "Resend" becomes tappable again (0 = ready).
  final RxInt secondsLeft = 0.obs;

  late String _verificationId;
  late String phoneNumber;
  int? _resendToken;
  Timer? _timer;

  static const int codeLength = 6;
  static const int resendCooldown = 60;

  bool get canResend => secondsLeft.value == 0;

  @override
  void onInit() {
    super.onInit();
    final OtpArgs args = Get.arguments as OtpArgs;
    _verificationId = args.verificationId;
    phoneNumber = args.phoneNumber;
    _resendToken = args.resendToken;
    codeCtrl.addListener(() => code.value = codeCtrl.text);
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    secondsLeft.value = resendCooldown;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (secondsLeft.value <= 1) {
        secondsLeft.value = 0;
        t.cancel();
      } else {
        secondsLeft.value -= 1;
      }
    });
  }

  /// Verify the entered code and complete sign-in.
  Future<void> verify() async {
    final String smsCode = codeCtrl.text.trim();
    if (smsCode.length < codeLength) {
      _toast(AppStrings.otpInvalid.tr);
      return;
    }
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await _authRepository.signInWithSmsCode(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      isLoading.value = false;
      Get.offAllNamed<void>(_authRepository.postAuthRoute);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      _toast(
        e.code == "invalid-verification-code"
            ? AppStrings.otpWrong.tr
            : (e.message ?? AppStrings.authFailed.tr),
      );
    } on ApiException catch (e) {
      isLoading.value = false;
      _toast(e.message);
    }
  }

  /// Request a fresh code (only when the cooldown has elapsed).
  Future<void> resend() async {
    if (!canResend) return;
    _startCountdown();
    await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      resendToken: _resendToken,
      onCodeSent: (String verificationId, int? token) {
        _verificationId = verificationId;
        _resendToken = token;
        _toast(AppStrings.otpResent.tr);
      },
      onError: (FirebaseAuthException e) =>
          _toast(e.message ?? AppStrings.authFailed.tr),
      onAutoVerified: (_) => Get.offAllNamed<void>(_authRepository.postAuthRoute),
    );
  }

  void _toast(String message) => Get.snackbar(
        AppStrings.otpTitle.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

  @override
  void onClose() {
    _timer?.cancel();
    codeCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
