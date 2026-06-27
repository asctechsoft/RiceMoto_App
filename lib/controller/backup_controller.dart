import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// How often automatic backups run.
enum BackupFrequency { daily, weekly, monthly }

extension BackupFrequencyLabel on BackupFrequency {
  String get labelKey {
    switch (this) {
      case BackupFrequency.daily:
        return AppStrings.bakFreqDaily;
      case BackupFrequency.weekly:
        return AppStrings.bakFreqWeekly;
      case BackupFrequency.monthly:
        return AppStrings.bakFreqMonthly;
    }
  }
}

/// Backs the Backup & Sync screen. State and figures are local stubs — wire the
/// actions to a real backup service when the backend exists.
class BackupController extends GetxController {
  final RxBool autoBackup = true.obs;
  final RxBool wifiOnly = true.obs;
  final Rx<BackupFrequency> frequency = BackupFrequency.daily.obs;
  final RxBool isBackingUp = false.obs;

  /// Last successful backup, e.g. "Hôm nay · 09:15".
  late final RxString lastBackup =
      "${AppStrings.histToday.tr} · 09:15".obs;

  // Sample stats shown in the summary row.
  int get transactions => 247;
  int get vehicles => 2;
  String get storage => "8,2 MB";

  void toggleAuto(bool value) => autoBackup.value = value;
  void toggleWifi(bool value) => wifiOnly.value = value;
  void setFrequency(BackupFrequency value) => frequency.value = value;

  Future<void> backupNow() async {
    if (isBackingUp.value) return;
    isBackingUp.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    final DateTime now = DateTime.now();
    final String time =
        "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}";
    lastBackup.value = "${AppStrings.histToday.tr} · $time";
    isBackingUp.value = false;
    Get.snackbar(
      AppStrings.setBackup.tr,
      AppStrings.bakDone.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void confirmRestore() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.bakRestoreConfirmTitle.tr),
        content: Text(AppStrings.bakRestoreConfirmMsg.tr),
        actions: <Widget>[
          TextButton(
            onPressed: Get.back,
            child: Text(
              AppStrings.cancel.tr,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                AppStrings.bakRestoreSection.tr,
                AppStrings.featureComingSoon.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text(
              AppStrings.bakRestore.tr,
              style: const TextStyle(color: AppColors.chartRepair),
            ),
          ),
        ],
      ),
    );
  }
}
