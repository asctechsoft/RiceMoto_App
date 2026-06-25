import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/presentation/home/tabs/home_tab.dart";
import "package:ricemoto/presentation/home/tabs/placeholder_tab.dart";
import "package:ricemoto/presentation/home/widgets/home_bottom_bar.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      const HomeTab(),
      PlaceholderTab(title: AppStrings.tabHistory.tr, icon: Icons.access_time_rounded),
      PlaceholderTab(title: AppStrings.tabReports.tr, icon: Icons.bar_chart_rounded),
      PlaceholderTab(title: AppStrings.tabAccount.tr, icon: Icons.person_outline_rounded),
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
