import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/presentation/home/tabs/history_tab.dart";
import "package:ricemoto/presentation/home/tabs/home_tab.dart";
import "package:ricemoto/presentation/home/tabs/report_tab.dart";
import "package:ricemoto/presentation/home/tabs/settings_tab.dart";
import "package:ricemoto/presentation/home/widgets/home_bottom_bar.dart";
import "package:ricemoto/values/app_colors.dart";

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      const HomeTab(),
      const HistoryTab(),
      const ReportTab(),
      const SettingsTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: tabs,
        ),
      ),
      floatingActionButton: _ScanFab(onPressed: controller.onScanPressed),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: HomeBottomBar(controller: controller),
    );
  }
}

class _ScanFab extends StatelessWidget {
  const _ScanFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: Icon(Icons.photo_camera_rounded, size: 28.w),
    );
  }
}
