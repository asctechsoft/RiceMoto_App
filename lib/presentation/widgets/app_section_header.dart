import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// AppSectionHeader — label + optional trailing action used above groups of
// related content (cards, lists, charts).
//
// Usage:
//   AppSectionHeader(title: "Giao dịch gần đây")
//   AppSectionHeader(title: "Chi phí", trailing: TextButton(...))
// ─────────────────────────────────────────────────────────────────────────────

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Optional widget on the right (e.g. a "See all" TextButton).
  final Widget? trailing;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppDivider — thin labeled divider for separating sections.
//
// Usage:
//   AppDivider()
//   AppDivider(label: "hoặc")
// ─────────────────────────────────────────────────────────────────────────────

class AppDivider extends StatelessWidget {
  const AppDivider({this.label, this.margin, super.key});

  final String? label;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets m = margin ?? EdgeInsets.symmetric(vertical: 12.h);
    if (label == null) {
      return Padding(
        padding: m,
        child: const Divider(height: 1, color: AppColors.divider),
      );
    }
    return Padding(
      padding: m,
      child: Row(
        children: <Widget>[
          const Expanded(child: Divider(height: 1, color: AppColors.divider)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              label!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ),
          const Expanded(child: Divider(height: 1, color: AppColors.divider)),
        ],
      ),
    );
  }
}
