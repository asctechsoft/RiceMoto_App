import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Artwork frame that shows [image] when the asset is present, otherwise a
/// neutral default placeholder — so real illustrations can be dropped in later
/// without touching the layout.
class IllustrationFrame extends StatelessWidget {
  const IllustrationFrame({
    required this.image,
    required this.icon,
    this.aspectRatio = 0.95,
    super.key,
  });

  final String image;
  final IconData icon;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.12),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _Placeholder(icon: icon),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
            child: Icon(icon, size: 34.w, color: AppColors.primary),
          ),
          SizedBox(height: 14.h),
          Text(
            AppStrings.illustrationPlaceholder.tr,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
