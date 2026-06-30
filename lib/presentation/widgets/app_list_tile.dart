import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// AppListTile — settings-style row with icon, title, optional subtitle /
// trailing value / switch / chevron. Mirrors the _SettingRow pattern used in
// SettingsTab but is usable anywhere.
//
// Usage:
//   AppListTile(
//     icon: Icons.language_rounded,
//     title: "Ngôn ngữ",
//     value: "Tiếng Việt",
//     showChevron: true,
//     onTap: () { ... },
//   )
// ─────────────────────────────────────────────────────────────────────────────

class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    this.icon,
    this.iconWidget,
    this.subtitle,
    this.value,
    this.trailing,
    this.showChevron = false,
    this.locked = false,
    this.onTap,
    super.key,
  }) : assert(icon != null || iconWidget != null || true);

  final String title;

  /// Either [icon] or [iconWidget] (custom widget) can be used.
  final IconData? icon;
  final Widget? iconWidget;
  final String? subtitle;

  /// Short value label shown before the chevron (e.g. "Tiếng Việt").
  final String? value;

  /// Fully custom trailing widget (e.g. a Switch).
  final Widget? trailing;
  final bool showChevron;

  /// Locked state: grays out and shows a lock icon instead of the action icon.
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = locked ? AppColors.textHint : AppColors.primary;
    final Color labelColor = locked ? AppColors.textHint : AppColors.textPrimary;

    Widget? leadingIcon;
    if (locked) {
      leadingIcon =
          Icon(Icons.lock_outline_rounded, size: 22.w, color: AppColors.textHint);
    } else if (iconWidget != null) {
      leadingIcon = iconWidget;
    } else if (icon != null) {
      leadingIcon = Icon(icon, size: 22.w, color: iconColor);
    }

    return InkWell(
      onTap: locked ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            if (leadingIcon != null) ...<Widget>[
              leadingIcon,
              SizedBox(width: 14.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  if (subtitle != null && !locked) ...<Widget>[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ],
              ),
            ),
            if (locked)
              Icon(Icons.lock_outline_rounded,
                  size: 18.w, color: AppColors.textHint)
            else ...<Widget>[
              if (value != null)
                Text(
                  value!,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                ),
              if (trailing != null) trailing!,
              if (showChevron) ...<Widget>[
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right_rounded,
                    size: 20.w, color: AppColors.textHint),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppListCard — wraps a list of [AppListTile]s in a branded card with
// internal dividers. Equivalent to the _SettingsCard container.
//
// Usage:
//   AppListCard(
//     children: [
//       AppListTile(...),
//       AppListTile(...),
//     ],
//   )
// ─────────────────────────────────────────────────────────────────────────────

class AppListCard extends StatelessWidget {
  const AppListCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> separated = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      separated.add(children[i]);
      if (i < children.length - 1) {
        separated.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: const Divider(height: 1, color: AppColors.divider),
          ),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: separated),
    );
  }
}
