import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// AppBottomSheet — branded base container.
//
// Usage:
//   AppBottomSheet.show(
//     child: MyContent(),
//     title: "Chọn ngôn ngữ",
//   );
//
// Or compose the widget directly inside another sheet:
//   AppBottomSheet(title: "...", child: ...)
// ─────────────────────────────────────────────────────────────────────────────

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.child,
    this.title,
    this.subtitle,
    this.showHandle = true,
    this.padding,
    super.key,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showHandle;
  final EdgeInsets? padding;

  /// Show this sheet via [Get.bottomSheet].
  static Future<T?> show<T>({
    required Widget child,
    String? title,
    String? subtitle,
    bool showHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return Get.bottomSheet<T>(
      AppBottomSheet(
        title: title,
        subtitle: subtitle,
        showHandle: showHandle,
        child: child,
      ),
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding ?? EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (showHandle) ...<Widget>[
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              if (title != null) ...<Widget>[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                ),
                if (subtitle != null) ...<Widget>[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
                  ),
                ],
                SizedBox(height: 16.h),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppOptionSheet — radio-style picker sheet (language, sort, frequency, …)
//
// Usage:
//   AppOptionSheet.show(
//     title: "Chọn ngôn ngữ",
//     options: [
//       AppSheetOption(label: "Tiếng Việt", selected: true, onTap: () {...}),
//       AppSheetOption(label: "English",    selected: false, onTap: () {...}),
//     ],
//   );
// ─────────────────────────────────────────────────────────────────────────────

class AppSheetOption {
  const AppSheetOption({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final IconData? icon;
}

class AppOptionSheet extends StatelessWidget {
  const AppOptionSheet({
    required this.options,
    this.title,
    super.key,
  });

  final String? title;
  final List<AppSheetOption> options;

  static Future<void> show({
    required List<AppSheetOption> options,
    String? title,
  }) {
    return Get.bottomSheet<void>(
      AppOptionSheet(title: title, options: options),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            if (title != null) ...<Widget>[
              SizedBox(height: 16.h),
              Text(
                title!,
                style: AppTextStyles.title.copyWith(fontSize: 16.sp),
              ),
            ],
            SizedBox(height: 8.h),
            for (final AppSheetOption opt in options) _OptionRow(option: opt),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final AppSheetOption option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back<void>();
        option.onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            if (option.icon != null) ...<Widget>[
              Icon(
                option.icon,
                size: 20.w,
                color: option.selected ? AppColors.primary : AppColors.textHint,
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                option.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight:
                      option.selected ? FontWeight.w700 : FontWeight.w400,
                  color: option.selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (option.selected)
              Icon(Icons.check_rounded, size: 20.w, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppActionSheet — icon+title+subtitle action list (like ReceiptSourceSheet).
//
// Usage:
//   AppActionSheet.show(
//     title: "Thêm hóa đơn",
//     subtitle: "Chọn cách thêm",
//     actions: [
//       AppSheetAction(icon: Icons.camera_alt_rounded, title: "Chụp", subtitle: "...", onTap: () {...}),
//     ],
//     showCancel: true,
//   );
// ─────────────────────────────────────────────────────────────────────────────

class AppSheetAction {
  const AppSheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
}

class AppActionSheet extends StatelessWidget {
  const AppActionSheet({
    required this.actions,
    this.title,
    this.subtitle,
    this.showCancel = true,
    this.cancelLabel = "Hủy",
    super.key,
  });

  final List<AppSheetAction> actions;
  final String? title;
  final String? subtitle;
  final bool showCancel;
  final String cancelLabel;

  static Future<void> show({
    required List<AppSheetAction> actions,
    String? title,
    String? subtitle,
    bool showCancel = true,
    String cancelLabel = "Hủy",
  }) {
    return Get.bottomSheet<void>(
      AppActionSheet(
        actions: actions,
        title: title,
        subtitle: subtitle,
        showCancel: showCancel,
        cancelLabel: cancelLabel,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              if (title != null) ...<Widget>[
                SizedBox(height: 18.h),
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
              if (subtitle != null) ...<Widget>[
                SizedBox(height: 4.h),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
              SizedBox(height: 20.h),
              for (int i = 0; i < actions.length; i++) ...<Widget>[
                _ActionTile(action: actions[i]),
                if (i < actions.length - 1) SizedBox(height: 12.h),
              ],
              if (showCancel) ...<Widget>[
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: Get.back,
                  child: Text(
                    cancelLabel,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final AppSheetAction action;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = action.iconColor ?? AppColors.primary;
    return InkWell(
      onTap: () {
        Get.back<void>();
        action.onTap();
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(action.icon, color: iconColor, size: 24.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    action.title,
                    style:
                        AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (action.subtitle != null) ...<Widget>[
                    SizedBox(height: 2.h),
                    Text(action.subtitle!, style: AppTextStyles.caption),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22.w, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
