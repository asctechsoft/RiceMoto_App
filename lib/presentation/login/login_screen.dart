import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/login_controller.dart";
import "package:ricemoto/presentation/widgets/auth_card.dart";
import "package:ricemoto/presentation/widgets/google_button.dart";
import "package:ricemoto/presentation/widgets/illustration_frame.dart";
import "package:ricemoto/presentation/widgets/or_divider.dart";
import "package:ricemoto/presentation/widgets/phone_field.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_assets.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: BackButton(color: AppColors.primary, onPressed: Get.back),
        actions: <Widget>[
          TextButton(
            onPressed: controller.goToRegister,
            child: Text(
              AppStrings.createAccount.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
          child: Column(
            children: <Widget>[
              const IllustrationFrame(
                image: AppAssets.welcome,
                icon: Icons.motorcycle,
                aspectRatio: 1.5,
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.login.tr,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                AppStrings.loginSubtitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              AuthCard(
                children: <Widget>[
                  PhoneField(controller: controller.phoneCtrl),
                  SizedBox(height: 16.h),
                  const OrDivider(),
                  SizedBox(height: 16.h),
                  GoogleButton(onPressed: controller.continueWithGoogle),
                ],
              ),
              SizedBox(height: 20.h),
              Obx(
                () => PrimaryButton(
                  label: AppStrings.login.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: controller.forgotPassword,
                child: Text(
                  AppStrings.forgotPassword.tr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppStrings.noAccountYet.tr,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.goToRegister,
                    child: Text(
                      AppStrings.createNow.tr,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
