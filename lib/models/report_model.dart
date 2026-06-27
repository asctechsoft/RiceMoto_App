import "package:flutter/material.dart";
import "package:ricemoto/values/app_strings.dart";

/// The time granularities offered by the Reports tab header.
enum ReportPeriod { month, quarter, year, custom }

/// Translation key for the segmented-control label of a period.
extension ReportPeriodLabel on ReportPeriod {
  String get labelKey {
    switch (this) {
      case ReportPeriod.month:
        return AppStrings.rptPeriodMonth;
      case ReportPeriod.quarter:
        return AppStrings.rptPeriodQuarter;
      case ReportPeriod.year:
        return AppStrings.rptPeriodYear;
      case ReportPeriod.custom:
        return AppStrings.rptPeriodCustom;
    }
  }
}

/// One column of the stacked bar chart ("T1", "Tháng 4", "Q1", …).
///
/// [fuel] / [repair] / [supplies] are the charted (stacked) categories; [admin]
/// is a small bucket included in the column [total] (and the month-card total)
/// but intentionally left out of the bar — it has its own slice in the donut.
class ReportSegment {
  const ReportSegment({
    required this.label,
    required this.fuel,
    required this.repair,
    required this.supplies,
    this.admin = 0,
  });

  final String label;
  final int fuel;
  final int repair;
  final int supplies;
  final int admin;

  /// Stacked height of the bar (excludes admin).
  int get barTotal => fuel + repair + supplies;

  /// Full spending for the column, used by the quarter month-cards.
  int get total => barTotal + admin;
}

/// A single row in the "Chi phí lớn nhất" (top expenses) list.
class ReportTopExpense {
  const ReportTopExpense({
    required this.title,
    required this.icon,
    required this.color,
    required this.amount,
    required this.date,
  });

  final String title;
  final IconData icon;
  final Color color;
  final int amount;
  final DateTime date;
}

/// All figures needed to render the Reports tab for one resolved period.
class ReportData {
  const ReportData({
    required this.total,
    required this.changePercent,
    required this.fuel,
    required this.repair,
    required this.supplies,
    required this.admin,
    required this.segments,
    required this.chartTitleKey,
    required this.kmPerLiter,
    required this.kmChange,
    required this.top,
  });

  /// Grand total for the period, in VND đồng.
  final int total;

  /// Percentage change vs. the previous period (positive == up).
  final double changePercent;

  final int fuel;
  final int repair;
  final int supplies;
  final int admin;

  /// Bars for the stacked chart (weeks / months / quarters).
  final List<ReportSegment> segments;

  /// Translation key for the chart heading.
  final String chartTitleKey;

  /// Fuel efficiency for the period, km per liter.
  final double kmPerLiter;

  /// Change in efficiency vs. the previous period (positive == better).
  final double kmChange;

  final List<ReportTopExpense> top;

  bool get isEmpty => total <= 0;

  int get maxSegmentBarTotal =>
      segments.fold(0, (int m, ReportSegment s) => s.barTotal > m ? s.barTotal : m);

  /// [amount] as a percentage of [total], rounded to a whole number.
  int percentOf(int amount) =>
      total == 0 ? 0 : (amount / total * 100).round();

  /// The segment (month) with the highest total — used by the quarter insight.
  ReportSegment get peakSegment => segments.reduce(
      (ReportSegment a, ReportSegment b) => b.total > a.total ? b : a);
}
