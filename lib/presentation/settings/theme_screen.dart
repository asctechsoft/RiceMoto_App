import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/settings_controller.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Theme picker (pushed from the Account tab). Light / Dark / System, each with
/// a mini preview. The choice is stored on [SettingsController]; a real dark
/// theme can be wired to [AppThemeChoice] later.
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _Header(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                children: <Widget>[
                  _ThemeOption(
                    controller: controller,
                    choice: AppThemeChoice.light,
                    icon: Icons.wb_sunny_rounded,
                    preview: const _MiniPreview(dark: false),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _ThemeOption(
                    controller: controller,
                    choice: AppThemeChoice.dark,
                    icon: Icons.nightlight_round,
                    preview: const _MiniPreview(dark: true),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _ThemeOption(
                    controller: controller,
                    choice: AppThemeChoice.system,
                    icon: Icons.phone_iphone_rounded,
                    subtitleKey: AppStrings.setThemeSystemDesc,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 4.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              AppStrings.setTheme.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.controller,
    required this.choice,
    required this.icon,
    this.preview,
    this.subtitleKey,
  });

  final SettingsController controller;
  final AppThemeChoice choice;
  final IconData icon;
  final Widget? preview;
  final String? subtitleKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.setTheme(choice),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 24.w, color: AppColors.primary),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    choice.labelKey.tr,
                    style: AppTextStyles.body
                        .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                if (preview != null) ...<Widget>[
                  preview!,
                  SizedBox(width: 14.w),
                ],
                Obx(
                  () => Icon(
                    controller.theme.value == choice
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 22.w,
                    color: controller.theme.value == choice
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
            if (subtitleKey != null) ...<Widget>[
              SizedBox(height: 8.h),
              Text(
                subtitleKey!.tr,
                style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A small stylized phone-screen thumbnail used to illustrate light vs dark.
class _MiniPreview extends StatelessWidget {
  const _MiniPreview({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final Color bg = dark ? const Color(0xFF1A1D1F) : AppColors.background;
    final Color surface = dark ? const Color(0xFF2A2E31) : AppColors.surface;
    final Color line = dark ? const Color(0xFF3A3F43) : AppColors.divider;

    return Container(
      width: 88.w,
      height: 62.h,
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Container(
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            width: double.infinity,
            height: 13.h,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: line),
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: <Widget>[
              _Bar(color: AppColors.primary, width: 18.w),
              SizedBox(width: 4.w),
              _Bar(color: AppColors.chartRepair, width: 14.w),
              SizedBox(width: 4.w),
              _Bar(color: AppColors.chartSupplies, width: 10.w),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 8.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
