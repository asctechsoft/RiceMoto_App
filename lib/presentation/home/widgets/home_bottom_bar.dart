import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// Bottom navigation bar with a floating center "Scan" FAB via BottomAppBar
/// + CircularNotchedRectangle notch. Pair with FloatingActionButtonLocation
/// .centerDocked in the Scaffold.
class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({required this.controller, super.key});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.shadow,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 8,
      padding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72.h,
          child: Row(
            children: <Widget>[
              _NavItem(
                controller: controller,
                index: 0,
                icon: Icons.home_rounded,
                labelKey: AppStrings.tabHome,
              ),
              _NavItem(
                controller: controller,
                index: 1,
                icon: Icons.access_time_rounded,
                labelKey: AppStrings.tabHistory,
              ),
              // Center slot: notch area + Scan label at bottom
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      AppStrings.tabScan.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              _NavItem(
                controller: controller,
                index: 2,
                icon: Icons.bar_chart_rounded,
                labelKey: AppStrings.tabReports,
              ),
              _NavItem(
                controller: controller,
                index: 3,
                icon: Icons.settings_outlined,
                labelKey: AppStrings.tabAccount,
              ),
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
        final bool selected = controller.currentIndex.value == index;
        final Color color =
            selected ? AppColors.primary : AppColors.navInactive;
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
