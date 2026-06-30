import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/otp_verify_controller.dart";
import "package:ricemoto/presentation/widgets/illustration_frame.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_assets.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// SMS code-entry screen reached after `verifyPhoneNumber` sends a code.
class OtpVerifyScreen extends GetView<OtpVerifyController> {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: BackButton(color: AppColors.primary, onPressed: Get.back),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            children: <Widget>[
              const IllustrationFrame(
                image: AppAssets.welcome,
                icon: Icons.sms_outlined,
                aspectRatio: 1.6,
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.otpTitle.tr,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "${AppStrings.otpSubtitle.tr} ${controller.phoneNumber}",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 28.h),
              const _OtpBoxes(),
              SizedBox(height: 28.h),
              Obx(
                () => PrimaryButton(
                  label: AppStrings.otpVerify.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verify,
                ),
              ),
              SizedBox(height: 16.h),
              const _ResendRow(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Six-cell code display backed by a single transparent [TextField] that owns
/// focus and input — reliable cursor/paste behaviour without per-cell focus
/// juggling.
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes();

  @override
  Widget build(BuildContext context) {
    final OtpVerifyController c = Get.find<OtpVerifyController>();
    const int len = OtpVerifyController.codeLength;

    return GestureDetector(
      onTap: () => c.focusNode.requestFocus(),
      child: Stack(
        children: <Widget>[
          Obx(() {
            final String value = c.code.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(len, (int i) {
                final bool filled = i < value.length;
                final bool active = i == value.length;
                return _Cell(
                  char: filled ? value[i] : "",
                  active: active,
                );
              }),
            );
          }),
          // Transparent input layer capturing the actual keystrokes.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: c.codeCtrl,
                focusNode: c.focusNode,
                autofocus: true,
                showCursor: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(height: 0.1),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(len),
                ],
                onChanged: (String v) {
                  if (v.length == len) c.verify();
                },
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.char, required this.active});

  final String char;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 56.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.divider,
          width: active ? 1.6 : 1,
        ),
      ),
      child: Text(
        char,
        style: AppTextStyles.heading.copyWith(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// "Resend code" action with a live countdown while on cooldown.
class _ResendRow extends StatelessWidget {
  const _ResendRow();

  @override
  Widget build(BuildContext context) {
    final OtpVerifyController c = Get.find<OtpVerifyController>();
    return Obx(() {
      if (!c.canResend) {
        return Text(
          "${AppStrings.otpResendIn.tr} ${c.secondsLeft.value}s",
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        );
      }
      return TextButton(
        onPressed: c.resend,
        child: Text(
          AppStrings.otpResend.tr,
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    });
  }
}
