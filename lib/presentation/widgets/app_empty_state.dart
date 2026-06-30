import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// AppEmptyState — icon + title + subtitle + optional CTA button.
// Centered in its parent by default.
//
// Usage:
//   AppEmptyState(
//     icon: Icons.receipt_long_outlined,
//     title: "Chưa có dữ liệu",
//     subtitle: "Bắt đầu ghi chi phí đầu tiên",
//     actionLabel: "Ghi ngay",
//     onAction: () { ... },
//   )
// ─────────────────────────────────────────────────────────────────────────────

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    this.icon,
    this.iconWidget,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    super.key,
  });

  final IconData? icon;

  /// Use [iconWidget] for a custom SVG / image illustration instead of an icon.
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Defaults to [AppColors.primary] with low opacity background.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Color ic = iconColor ?? AppColors.primary;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (iconWidget != null)
              iconWidget!
            else if (icon != null) ...<Widget>[
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: ic.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36.w, color: ic.withValues(alpha: 0.7)),
              ),
            ],
            SizedBox(height: 20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...<Widget>[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...<Widget>[
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppLoadingState — centered spinner, used while async data is loading.
//
// Usage:
//   AppLoadingState()
//   AppLoadingState(message: "Đang tải...")
// ─────────────────────────────────────────────────────────────────────────────

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2.6,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...<Widget>[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.body
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
