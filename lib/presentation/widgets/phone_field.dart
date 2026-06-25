import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Phone number input with a leading country-code selector (Vietnam only for
/// now). Matches the auth screens' single-field design.
class PhoneField extends StatelessWidget {
  const PhoneField({
    required this.controller,
    this.dialCode = "+84",
    this.flag = "🇻🇳",
    this.onTapCountry,
    super.key,
  });

  final TextEditingController controller;
  final String dialCode;
  final String flag;
  final VoidCallback? onTapCountry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: onTapCountry,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(flag, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    dialCode,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.w,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 24.h, color: AppColors.divider),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: AppStrings.phone.tr,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
