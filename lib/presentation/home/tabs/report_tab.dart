import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/report_controller.dart";
import "package:ricemoto/models/report_model.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/presentation/home/widgets/report_charts.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Reports tab: a spending summary for the selected period (Month / Quarter /
/// Year / Custom). The body adapts per period — the quarter view swaps the
/// category grid for month cards and adds a "highest month" insight, while the
/// others show the category grid, an efficiency stat and the top expenses.
class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve (and register if needed) the controller here rather than via a
    // route binding — the tab can be built before/after a hot reload re-runs it.
    final ReportController controller = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : Get.put(ReportController());

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          const _Header(),
          _PeriodTabs(controller: controller),
          Expanded(
            child: Obx(() {
              final ReportData data = controller.data;
              final ReportPeriod period = controller.period.value;
              final bool isQuarter = period == ReportPeriod.quarter;
              final bool isCustom = period == ReportPeriod.custom;
              return ListView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                children: <Widget>[
                  if (isCustom) ...<Widget>[
                    _CustomControls(controller: controller),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        controller.periodLabel,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ] else ...<Widget>[
                    _PeriodNavigator(controller: controller),
                    SizedBox(height: 14.h),
                  ],
                  if (data.isEmpty)
                    const _EmptyState()
                  else ...<Widget>[
                    _TotalCard(controller: controller, data: data),
                    SizedBox(height: 14.h),
                    if (isQuarter)
                      _MonthCards(data: data)
                    else
                      _CategoryGrid(data: data),
                    SizedBox(height: 14.h),
                    _ChartCard(data: data),
                    SizedBox(height: 14.h),
                    _DonutCard(controller: controller, data: data),
                    SizedBox(height: 14.h),
                    if (isQuarter)
                      _InsightCard(controller: controller, data: data)
                    else ...<Widget>[
                      _EfficiencyCard(controller: controller, data: data),
                      SizedBox(height: 18.h),
                      _TopExpenses(data: data),
                    ],
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header + segmented period control
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          SizedBox(width: 40.w),
          Expanded(
            child: Text(
              AppStrings.tabReports.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({required this.controller});

  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: ReportPeriod.values.map((ReportPeriod p) {
            return Expanded(
              child: Obx(() {
                final bool selected = controller.period.value == p;
                return GestureDetector(
                  onTap: () => controller.setPeriod(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        p.labelKey.tr,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13.sp,
                          color: selected
                              ? AppColors.white
                              : AppColors.textSecondary,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PeriodNavigator extends StatelessWidget {
  const _PeriodNavigator({required this.controller});

  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    final String sub = controller.periodSubLabel;
    return Row(
      children: <Widget>[
        _NavArrow(
          icon: Icons.chevron_left_rounded,
          enabled: controller.canGoPrev,
          onTap: controller.previousPeriod,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                controller.periodLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body
                    .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
              if (sub.isNotEmpty) ...<Widget>[
                SizedBox(height: 2.h),
                Text(sub, style: AppTextStyles.caption.copyWith(fontSize: 11.sp)),
              ],
            ],
          ),
        ),
        _NavArrow(
          icon: Icons.chevron_right_rounded,
          enabled: controller.canGoNext,
          onTap: controller.nextPeriod,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Custom-range controls: From/To fields, quick presets, "View report" button
// ---------------------------------------------------------------------------

class _CustomControls extends StatelessWidget {
  const _CustomControls({required this.controller});

  final ReportController controller;

  Future<void> _pick(BuildContext context, {required bool isFrom}) async {
    final DateTime now = DateTime.now();
    final DateTimeRange draft = controller.draftRange.value;
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDate: isFrom ? draft.start : draft.end,
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
      controller.setDraftFrom(picked);
    } else {
      controller.setDraftTo(picked);
    }
  }

  String _fmt(DateTime d) =>
      "${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Obx(() => _DateField(
              labelKey: AppStrings.rptFrom,
              value: _fmt(controller.draftRange.value.start),
              highlighted: true,
              onTap: () => _pick(context, isFrom: true),
            )),
        SizedBox(height: 10.h),
        Obx(() => _DateField(
              labelKey: AppStrings.rptTo,
              value: _fmt(controller.draftRange.value.end),
              highlighted: false,
              onTap: () => _pick(context, isFrom: false),
            )),
        SizedBox(height: 12.h),
        SizedBox(
          height: 34.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ReportController.presetKeys.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, int i) => Obx(
              () => _PresetChip(
                label: ReportController.presetKeys[i].tr,
                selected: controller.selectedPreset == i,
                onTap: () => controller.applyPreset(i),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        PrimaryButton(
          label: AppStrings.rptViewReport.tr,
          onPressed: controller.commitCustom,
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.labelKey,
    required this.value,
    required this.highlighted,
    required this.onTap,
  });

  final String labelKey;
  final String value;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 64.w,
          child: Text(
            labelKey.tr,
            style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color:
                      highlighted ? AppColors.primary : AppColors.divider,
                  width: highlighted ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      value,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.calendar_today_rounded,
                      size: 17.w, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider),
          ),
          child: Icon(
            icon,
            size: 22.w,
            color: enabled ? AppColors.textPrimary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Total card
// ---------------------------------------------------------------------------

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.controller, required this.data});

  final ReportController controller;
  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final bool up = data.changePercent >= 0;
    return _Card(
      child: Column(
        children: <Widget>[
          Text(
            controller.totalTitle,
            style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            formatMoney(data.total),
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 14.w,
                color: up ? AppColors.success : AppColors.error,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  "${data.changePercent.abs().round()}% ${controller.compareLabel}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: up ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month cards (quarter only)
// ---------------------------------------------------------------------------

class _MonthCards extends StatelessWidget {
  const _MonthCards({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final List<ReportSegment> months = data.segments;
    return Row(
      children: <Widget>[
        for (int i = 0; i < months.length; i++) ...<Widget>[
          if (i > 0) SizedBox(width: 10.w),
          Expanded(
            child: _MonthCard(
              segment: months[i],
              highlight: i == months.length - 1,
            ),
          ),
        ],
      ],
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({required this.segment, required this.highlight});

  final ReportSegment segment;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final String short = segment.label.replaceFirst(
        "${AppStrings.rptPeriodMonth.tr} ", "T");
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.divider,
          width: highlight ? 1.4 : 1,
        ),
        boxShadow: highlight
            ? null
            : const <BoxShadow>[
                BoxShadow(
                    color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
              ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            short,
            style: AppTextStyles.caption.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatMoney(segment.total),
              style: AppTextStyles.body.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: highlight ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category grid (2 x 2)
// ---------------------------------------------------------------------------

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final List<_CategoryCellData> cells = <_CategoryCellData>[
      _CategoryCellData(AppStrings.histFilterFuel, Icons.local_gas_station_rounded,
          AppColors.chartFuel, data.fuel, data.percentOf(data.fuel)),
      _CategoryCellData(AppStrings.histFilterRepair, Icons.build_rounded,
          AppColors.chartRepair, data.repair, data.percentOf(data.repair)),
      _CategoryCellData(AppStrings.histFilterSupplies, Icons.inventory_2_rounded,
          AppColors.chartSupplies, data.supplies, data.percentOf(data.supplies)),
      _CategoryCellData(AppStrings.histFilterAdmin, Icons.assignment_rounded,
          AppColors.chartAdmin, data.admin, data.percentOf(data.admin)),
    ];

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _CategoryCell(data: cells[0])),
            SizedBox(width: 12.w),
            Expanded(child: _CategoryCell(data: cells[1])),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(child: _CategoryCell(data: cells[2])),
            SizedBox(width: 12.w),
            Expanded(child: _CategoryCell(data: cells[3])),
          ],
        ),
      ],
    );
  }
}

class _CategoryCellData {
  const _CategoryCellData(
      this.labelKey, this.icon, this.color, this.amount, this.percent);

  final String labelKey;
  final IconData icon;
  final Color color;
  final int amount;
  final int percent;
}

class _CategoryCell extends StatelessWidget {
  const _CategoryCell({required this.data});

  final _CategoryCellData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border(left: BorderSide(color: data.color, width: 4)),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(data.icon, size: 19.w, color: data.color),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.labelKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                ),
                SizedBox(height: 3.h),
                Text(
                  formatMoney(data.amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${data.percent}%",
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stacked bar chart card
// ---------------------------------------------------------------------------

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.chartTitleKey.tr,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 4.h,
            children: <Widget>[
              _LegendDot(color: AppColors.chartFuel, label: AppStrings.catFuel.tr),
              _LegendDot(
                  color: AppColors.chartRepair,
                  label: AppStrings.histFilterRepair.tr),
              _LegendDot(
                  color: AppColors.chartSupplies,
                  label: AppStrings.histFilterSupplies.tr),
            ],
          ),
          SizedBox(height: 12.h),
          ReportBarChart(segments: data.segments),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 9.w,
          height: 9.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Donut card
// ---------------------------------------------------------------------------

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.controller, required this.data});

  final ReportController controller;
  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final bool showAdmin = controller.showAdminInDonut;
    final List<_DonutLegend> legend = <_DonutLegend>[
      _DonutLegend(AppColors.chartFuel,
          showAdmin ? AppStrings.histFilterFuel : AppStrings.catFuel, data.fuel),
      _DonutLegend(
          AppColors.chartRepair,
          showAdmin ? AppStrings.histFilterRepair : AppStrings.catRepair,
          data.repair),
      _DonutLegend(
          AppColors.chartSupplies, AppStrings.histFilterSupplies, data.supplies),
      if (showAdmin)
        _DonutLegend(
            AppColors.chartAdmin, AppStrings.histFilterAdmin, data.admin),
    ];
    final int chartTotal =
        legend.fold(0, (int a, _DonutLegend l) => a + l.value);

    return _Card(
      child: Row(
        children: <Widget>[
          ReportDonutChart(
            slices: <ChartSlice>[
              ChartSlice(color: AppColors.chartFuel, value: data.fuel),
              ChartSlice(color: AppColors.chartRepair, value: data.repair),
              ChartSlice(color: AppColors.chartSupplies, value: data.supplies),
              if (showAdmin)
                ChartSlice(color: AppColors.chartAdmin, value: data.admin),
            ],
            centerText: formatMoney(data.total),
            centerSubtitle: controller.donutCenterSubtitle,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              children: legend.map((_DonutLegend l) {
                final int pct =
                    chartTotal == 0 ? 0 : (l.value / chartTotal * 100).round();
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 11.w,
                        height: 11.w,
                        decoration:
                            BoxDecoration(color: l.color, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          l.labelKey.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(fontSize: 12.5.sp),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "$pct%",
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (showAdmin) ...<Widget>[
                        SizedBox(width: 8.w),
                        Text(
                          formatMoney(l.value),
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutLegend {
  const _DonutLegend(this.color, this.labelKey, this.value);

  final Color color;
  final String labelKey;
  final int value;
}

// ---------------------------------------------------------------------------
// Insight card (quarter only)
// ---------------------------------------------------------------------------

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.controller, required this.data});

  final ReportController controller;
  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final ReportSegment peak = data.peakSegment;

    // Largest charted category across the quarter, for the subtitle.
    String topCatKey = AppStrings.catFuel;
    int topCatValue = data.fuel;
    if (data.repair > topCatValue) {
      topCatKey = AppStrings.catRepair;
      topCatValue = data.repair;
    }
    if (data.supplies > topCatValue) {
      topCatKey = AppStrings.histFilterSupplies;
      topCatValue = data.supplies;
    }

    final String title = AppStrings.rptInsightPeakTitle.trParams(<String, String>{
      "month": peak.label,
      "amount": formatMoney(peak.total),
    });
    final String sub = AppStrings.rptInsightPeakSub.trParams(<String, String>{
      "cat": topCatKey.tr.toLowerCase(),
      "pct": "${data.percentOf(topCatValue)}",
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.insights_rounded, size: 22.w, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sub,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Efficiency card
// ---------------------------------------------------------------------------

class _EfficiencyCard extends StatelessWidget {
  const _EfficiencyCard({required this.controller, required this.data});

  final ReportController controller;
  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final bool up = data.kmChange >= 0;
    final String value = data.kmPerLiter.toStringAsFixed(1).replaceAll(".", ",");
    final String delta =
        data.kmChange.abs().toStringAsFixed(1).replaceAll(".", ",");
    return _Card(
      child: Row(
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.speed_rounded, size: 24.w, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      AppStrings.rptEfficiencyUnit.tr,
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: <Widget>[
                    Icon(
                      up
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 13.w,
                      color: up ? AppColors.success : AppColors.error,
                    ),
                    SizedBox(width: 2.w),
                    Flexible(
                      child: Text(
                        "$delta ${controller.compareLabel}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: up ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top expenses
// ---------------------------------------------------------------------------

class _TopExpenses extends StatelessWidget {
  const _TopExpenses({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.rptTopTitle.tr,
          style: AppTextStyles.title.copyWith(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        _Card(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Column(
            children: <Widget>[
              for (int i = 0; i < data.top.length; i++) ...<Widget>[
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const Divider(height: 1, color: AppColors.divider),
                  ),
                _TopRow(rank: i + 1, item: data.top[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.rank, required this.item});

  final int rank;
  final ReportTopExpense item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      child: Row(
        children: <Widget>[
          Container(
            width: 24.w,
            height: 24.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$rank",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(item.icon, size: 18.w, color: item.color),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(_formatDate(item.date), style: AppTextStyles.caption),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            formatMoney(item.amount),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 2.w),
          Icon(Icons.chevron_right_rounded, size: 18.w, color: AppColors.textHint),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year}";
}

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Column(
        children: <Widget>[
          Icon(Icons.bar_chart_rounded, size: 48.w, color: AppColors.textHint),
          SizedBox(height: 12.h),
          Text(
            AppStrings.rptNoData.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
