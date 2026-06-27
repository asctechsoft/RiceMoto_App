import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/forgot_password_controller.dart";
import "package:ricemoto/presentation/widgets/auth_card.dart";
import "package:ricemoto/presentation/widgets/phone_field.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Password-recovery screen: collects a phone number and (stub) sends a reset
/// code. Pushed from the Login screen.
class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

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
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_reset_rounded,
                    size: 40.w, color: AppColors.primary),
              ),
              SizedBox(height: 20.h),
              Text(
                AppStrings.fpTitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading
                    .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.h),
              Text(
                AppStrings.fpSubtitle.tr,
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 24.h),
              AuthCard(
                children: <Widget>[
                  PhoneField(controller: controller.phoneCtrl),
                ],
              ),
              SizedBox(height: 20.h),
              Obx(
                () => PrimaryButton(
                  label: AppStrings.fpSubmit.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
