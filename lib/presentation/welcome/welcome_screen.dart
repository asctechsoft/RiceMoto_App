import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/presentation/widgets/illustration_frame.dart";
import "package:ricemoto/presentation/widgets/language_switcher.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_assets.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_dimens.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Entry point shown after onboarding: pick how to start the app
/// (create an account, sign in, or try it as a guest).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _createAccount() => Get.toNamed(AppRoutes.register);

  void _signIn() => Get.toNamed(AppRoutes.login);

  void _continueAsGuest() => Get.toNamed(AppRoutes.vehicleSetup);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
                  child: const LanguageSwitcher(),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Center(
                  child: const IllustrationFrame(
                    image: AppAssets.welcome,
                    icon: Icons.motorcycle,
                    aspectRatio: 1.15,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppStrings.welcomeTitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.welcomeSubtitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              SizedBox(height: 28.h),
              PrimaryButton(
                label: AppStrings.createAccount.tr,
                onPressed: _createAccount,
              ),
              SizedBox(height: 14.h),
              _SecondaryButton(
                label: AppStrings.signIn.tr,
                onPressed: _signIn,
              ),
              SizedBox(height: 18.h),
              TextButton(
                onPressed: _continueAsGuest,
                child: Text(
                  AppStrings.tryWithoutAccount.tr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.guestDataNote.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.createAccountLaterNote.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined counterpart to [PrimaryButton] — same dimensions, brand outline.
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius.r),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
