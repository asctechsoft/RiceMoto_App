import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// Bottom navigation bar with a raised center "Scan" button.
///
/// The four tabs map to [HomeController.currentIndex] (0..3). The center
/// Scan button triggers [HomeController.onScanPressed] and is not a tab.
class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({required this.controller, super.key});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: <Widget>[
              _NavItem(controller: controller, index: 0, icon: Icons.home_rounded, labelKey: AppStrings.tabHome),
              _NavItem(controller: controller, index: 1, icon: Icons.access_time_rounded, labelKey: AppStrings.tabHistory),
              _ScanButton(onPressed: controller.onScanPressed),
              _NavItem(controller: controller, index: 2, icon: Icons.bar_chart_rounded, labelKey: AppStrings.tabReports),
              _NavItem(controller: controller, index: 3, icon: Icons.settings_rounded, labelKey: AppStrings.tabSettings),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.controller,
    required this.index,
    required this.icon,
    required this.labelKey,
  });

  final HomeController controller;
  final int index;
  final IconData icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final selected = controller.currentIndex.value == index;
        final color = selected ? AppColors.primary : AppColors.navInactive;
        return InkWell(
          onTap: () => controller.changeTab(index),
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: color, size: 24.w),
              SizedBox(height: 4.h),
              Text(
                labelKey.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.photo_camera_rounded, color: AppColors.white, size: 26.w),
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.tabScan.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
