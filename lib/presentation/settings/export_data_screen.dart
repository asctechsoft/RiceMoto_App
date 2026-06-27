import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/export_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Export Data screen (pushed from the Account tab). Lets the user pick a date
/// range, vehicles and a file format, then export or share the result.
class ExportDataScreen extends StatelessWidget {
  const ExportDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExportController controller = Get.isRegistered<ExportController>()
        ? Get.find<ExportController>()
        : Get.put(ExportController());

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
                  _SectionLabel(AppStrings.expRangeSection.tr),
                  SizedBox(height: 10.h),
                  _RangeChips(controller: controller),
                  SizedBox(height: 12.h),
                  _DateFields(controller: controller),
                  SizedBox(height: 20.h),
                  _SectionLabel(AppStrings.expVehicleSection.tr),
                  SizedBox(height: 10.h),
                  _VehicleCard(controller: controller),
                  SizedBox(height: 20.h),
                  _SectionLabel(AppStrings.expFormatSection.tr),
                  SizedBox(height: 10.h),
                  _FormatCard(controller: controller),
                  SizedBox(height: 16.h),
                  _EstimateCard(controller: controller),
                  SizedBox(height: 16.h),
                  PrimaryButton(
                    label: AppStrings.expExport.tr,
                    onPressed: controller.exportData,
                  ),
                  SizedBox(height: 10.h),
                  _ShareButton(controller: controller),
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
              AppStrings.setExport.tr,
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
// Date range
// ---------------------------------------------------------------------------

class _RangeChips extends StatelessWidget {
  const _RangeChips({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ExportRange.values.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, int i) {
          final ExportRange r = ExportRange.values[i];
          return Obx(
            () => _Chip(
              label: r.labelKey.tr,
              selected: controller.preset.value == r,
              onTap: () => controller.applyPreset(r),
            ),
          );
        },
      ),
    );
  }
}

class _DateFields extends StatelessWidget {
  const _DateFields({required this.controller});

  final ExportController controller;

  Future<void> _pick(BuildContext context, {required bool isFrom}) async {
    final DateTime now = DateTime.now();
    final DateTimeRange r = controller.dates.value;
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 6),
      lastDate: now,
      initialDate: isFrom ? r.start : r.end,
      builder: (BuildContext ctx, Widget? child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    if (isFrom) {
      controller.setFrom(picked);
    } else {
      controller.setTo(picked);
    }
  }

  String _fmt(DateTime d) =>
      "${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: <Widget>[
          Expanded(
            child: _DateField(
              prefixKey: AppStrings.expFrom,
              value: _fmt(controller.dates.value.start),
              onTap: () => _pick(context, isFrom: true),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _DateField(
              prefixKey: AppStrings.expTo,
              value: _fmt(controller.dates.value.end),
              onTap: () => _pick(context, isFrom: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.prefixKey,
    required this.value,
    required this.onTap,
  });

  final String prefixKey;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: <Widget>[
            Text(
              "${prefixKey.tr} ",
              style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.calendar_today_rounded,
                size: 15.w, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 12.sp,
            color: selected ? AppColors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vehicles
// ---------------------------------------------------------------------------

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: <Widget>[
          Obx(
            () => _CheckRow(
              label: AppStrings.expAllVehicles.tr,
              checked: controller.allVehicles.value,
              onTap: controller.selectAllVehicles,
            ),
          ),
          for (final String v in controller.vehicles) ...<Widget>[
            const _RowDivider(),
            Obx(
              () => _CheckRow(
                label: v,
                checked: controller.isVehicleChecked(v),
                onTap: () => controller.toggleVehicle(v),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        child: Row(
          children: <Widget>[
            Icon(
              checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 22.w,
              color: checked ? AppColors.primary : AppColors.textHint,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Format
// ---------------------------------------------------------------------------

class _FormatCard extends StatelessWidget {
  const _FormatCard({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < ExportFormat.values.length; i++) ...<Widget>[
            if (i > 0) const _RowDivider(),
            Obx(
              () => _RadioRow(
                label: ExportFormat.values[i].labelKey.tr,
                selected: controller.format.value == ExportFormat.values[i],
                onTap: () => controller.setFormat(ExportFormat.values[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        child: Row(
          children: <Widget>[
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 22.w,
              color: selected ? AppColors.primary : AppColors.textHint,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Estimate + share
// ---------------------------------------------------------------------------

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.description_rounded, size: 26.w, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.expEstimate.trParams(<String, String>{
                "count": "${controller.estimateCount}",
                "size": controller.estimateSize,
              }),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.controller});

  final ExportController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: controller.shareNow,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.ios_share_rounded, size: 18.w, color: AppColors.primary),
        label: Text(
          AppStrings.expShare.tr,
          style: AppTextStyles.button.copyWith(color: AppColors.primary),
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

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

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
      child: child,
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
