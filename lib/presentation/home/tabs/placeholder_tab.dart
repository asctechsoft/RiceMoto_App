import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Simple empty-state scaffold reused by the History / Reports / Settings tabs
/// until their real content is implemented.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44.w, color: AppColors.primary),
            ),
            SizedBox(height: 20.h),
            Text(title, style: AppTextStyles.title),
            SizedBox(height: 8.h),
            Text(
              "Coming soon",
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
