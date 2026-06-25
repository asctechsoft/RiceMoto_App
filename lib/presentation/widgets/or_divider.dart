import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Horizontal "or" separator used between phone and social sign-in options.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            AppStrings.orDivider.tr,
            style: AppTextStyles.caption,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
