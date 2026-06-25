import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_assets.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_dimens.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Outlined "Continue with Google" button. Shows the Google mark when the
/// asset is present, otherwise a neutral fallback icon.
class GoogleButton extends StatelessWidget {
  const GoogleButton({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius.r),
          ),
        ),
        icon: Image.asset(
          AppAssets.googleLogo,
          width: 20.w,
          height: 20.w,
          errorBuilder: (_, __, ___) => Icon(
            Icons.g_mobiledata_rounded,
            size: 24.w,
            color: AppColors.primary,
          ),
        ),
        label: Text(
          AppStrings.continueWithGoogle.tr,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
