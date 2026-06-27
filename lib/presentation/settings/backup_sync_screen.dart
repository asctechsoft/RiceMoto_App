import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/backup_controller.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Backup & Sync screen (pushed from the Account tab). Shows backup status,
/// storage stats, automatic-backup preferences, and a restore action.
class BackupSyncScreen extends StatelessWidget {
  const BackupSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BackupController controller = Get.isRegistered<BackupController>()
        ? Get.find<BackupController>()
        : Get.put(BackupController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _Header(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: <Widget>[
                  _StatusCard(controller: controller),
                  SizedBox(height: 14.h),
                  _StatsRow(controller: controller),
                  SizedBox(height: 20.h),
                  _SectionLabel(AppStrings.bakAutoSection.tr),
                  SizedBox(height: 10.h),
                  _AutoCard(controller: controller),
                  SizedBox(height: 20.h),
                  _SectionLabel(AppStrings.bakRestoreSection.tr),
                  SizedBox(height: 10.h),
                  _RestoreButton(controller: controller),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.bakRestoreDesc.tr,
                    style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
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
              AppStrings.setBackup.tr,
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

// ---------------------------------------------------------------------------
// Status card
// ---------------------------------------------------------------------------

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});

  final BackupController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.cloud_done_rounded, size: 44.w, color: AppColors.primary),
          SizedBox(height: 10.h),
          Text(
            AppStrings.bakStatusDone.tr,
            style: AppTextStyles.title.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 4.h),
          Obx(
            () => Text(
              AppStrings.bakLast
                  .trParams(<String, String>{"value": controller.lastBackup.value}),
              style: AppTextStyles.caption,
            ),
          ),
          SizedBox(height: 14.h),
          Obx(
            () => GestureDetector(
              onTap: controller.backupNow,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: controller.isBackingUp.value
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppStrings.bakBackingUp.tr,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        AppStrings.bakBackupNow.tr,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.controller});

  final BackupController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: <Widget>[
          _Stat(value: "${controller.transactions}", label: AppStrings.bakStatTransactions.tr),
          const _StatDivider(),
          _Stat(value: "${controller.vehicles}", label: AppStrings.bakStatVehicles.tr),
          const _StatDivider(),
          _Stat(value: controller.storage, label: AppStrings.bakStatStorage.tr),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: AppTextStyles.title.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34.h, color: AppColors.divider);
  }
}

// ---------------------------------------------------------------------------
// Automatic-backup preferences
// ---------------------------------------------------------------------------

class _AutoCard extends StatelessWidget {
  const _AutoCard({required this.controller});

  final BackupController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: <Widget>[
          _Row(
            icon: Icons.autorenew_rounded,
            label: AppStrings.bakAuto.tr,
            trailing: Obx(
              () => Switch.adaptive(
                value: controller.autoBackup.value,
                onChanged: controller.toggleAuto,
                activeTrackColor: AppColors.primary,
              ),
            ),
          ),
          const _RowDivider(),
          _Row(
            icon: Icons.wifi_rounded,
            label: AppStrings.bakWifiOnly.tr,
            trailing: Obx(
              () => Switch.adaptive(
                value: controller.wifiOnly.value,
                onChanged: controller.toggleWifi,
                activeTrackColor: AppColors.primary,
              ),
            ),
          ),
          const _RowDivider(),
          Obx(
            () => _Row(
              icon: Icons.schedule_rounded,
              label: AppStrings.bakFrequency.tr,
              value: controller.frequency.value.labelKey.tr,
              showChevron: true,
              onTap: () => _pickFrequency(context),
            ),
          ),
        ],
      ),
    );
  }

  void _pickFrequency(BuildContext context) {
    Get.bottomSheet(
      _FrequencySheet(controller: controller),
      backgroundColor: Colors.transparent,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.showChevron = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22.w, color: AppColors.primary),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
            if (trailing != null) trailing!,
            if (showChevron) ...<Widget>[
              SizedBox(width: 6.w),
              Icon(Icons.chevron_right_rounded,
                  size: 20.w, color: AppColors.textHint),
            ],
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: const Divider(height: 1, color: AppColors.divider),
    );
  }
}

// ---------------------------------------------------------------------------
// Restore
// ---------------------------------------------------------------------------

class _RestoreButton extends StatelessWidget {
  const _RestoreButton({required this.controller});

  final BackupController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.confirmRestore,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.chartRepair.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.chartRepair.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.restore_rounded, size: 20.w, color: AppColors.chartRepair),
            SizedBox(width: 8.w),
            Text(
              AppStrings.bakRestoreCta.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.chartRepair,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _FrequencySheet extends StatelessWidget {
  const _FrequencySheet({required this.controller});

  final BackupController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
            SizedBox(height: 14.h),
            Text(
              AppStrings.bakChooseFrequency.tr,
              style: AppTextStyles.title.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            for (final BackupFrequency f in BackupFrequency.values)
              Obx(
                () => InkWell(
                  onTap: () {
                    controller.setFrequency(f);
                    Get.back<void>();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            f.labelKey.tr,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: controller.frequency.value == f
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: controller.frequency.value == f
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (controller.frequency.value == f)
                          Icon(Icons.check_rounded,
                              size: 20.w, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
