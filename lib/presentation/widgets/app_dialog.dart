import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_dimens.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// AppDialog — branded alert / confirm dialog.
//
// Static helpers:
//   AppDialog.confirm(...)   — cancel + confirm (with optional destructive style)
//   AppDialog.alert(...)     — single OK button
//   AppDialog.custom(...)    — fully custom action list
// ─────────────────────────────────────────────────────────────────────────────

class AppDialog {
  const AppDialog._();

  /// Two-button confirm dialog.
  ///
  /// [onConfirm] is called after the dialog closes.
  /// Set [destructive] = true to color the confirm button red.
  static Future<void> confirm({
    required String title,
    required String message,
    String confirmLabel = "Xác nhận",
    String cancelLabel = "Hủy",
    VoidCallback? onConfirm,
    bool destructive = false,
  }) {
    return Get.dialog<void>(
      _AppDialogWidget(
        title: title,
        message: message,
        actions: <_DialogAction>[
          _DialogAction(
            label: cancelLabel,
            color: AppColors.textSecondary,
            onTap: Get.back,
          ),
          _DialogAction(
            label: confirmLabel,
            color: destructive ? AppColors.error : AppColors.primary,
            fontWeight: FontWeight.w700,
            onTap: () {
              Get.back<void>();
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }

  /// Single-button informational dialog.
  static Future<void> alert({
    required String title,
    required String message,
    String okLabel = "OK",
    VoidCallback? onOk,
  }) {
    return Get.dialog<void>(
      _AppDialogWidget(
        title: title,
        message: message,
        actions: <_DialogAction>[
          _DialogAction(
            label: okLabel,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            onTap: () {
              Get.back<void>();
              onOk?.call();
            },
          ),
        ],
      ),
    );
  }

  /// Fully custom action list.
  static Future<void> custom({
    required String title,
    required String message,
    required List<AppDialogAction> actions,
  }) {
    return Get.dialog<void>(
      _AppDialogWidget(title: title, message: message, actions: actions),
    );
  }
}

// Exported so callers can pass custom actions to [AppDialog.custom].
class AppDialogAction {
  const AppDialogAction({
    required this.label,
    required this.onTap,
    this.color,
    this.fontWeight,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final FontWeight? fontWeight;
}

// Internal shorthand.
typedef _DialogAction = AppDialogAction;

class _AppDialogWidget extends StatelessWidget {
  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String message;
  final List<_DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(height: 1, color: AppColors.divider),
            Row(
              children: <Widget>[
                for (int i = 0; i < actions.length; i++) ...<Widget>[
                  if (i > 0)
                    Container(width: 1, height: 46.h, color: AppColors.divider),
                  Expanded(
                    child: TextButton(
                      onPressed: actions[i].onTap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        actions[i].label,
                        style: AppTextStyles.body.copyWith(
                          color: actions[i].color ?? AppColors.primary,
                          fontWeight:
                              actions[i].fontWeight ?? FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
