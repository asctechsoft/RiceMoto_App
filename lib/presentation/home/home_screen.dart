import "package:flutter/material.dart";
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
    final tabs = <Widget>[
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
      bottomNavigationBar: HomeBottomBar(controller: controller),
    );
  }
}
