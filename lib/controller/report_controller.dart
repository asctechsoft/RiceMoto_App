import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/models/report_model.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// Backs the Reports tab.
///
/// Holds the selected [period] (Month / Quarter / Year / Custom, default Month)
/// and an [offset] into the past (0 == the current period, -1 == the previous
/// one). Custom uses [customRange] instead of [offset]. [data] resolves the
/// selection into a [ReportData] with sample figures — wire this up to a
/// repository once the backend exists. The current month and quarter (offset 0)
/// are seeded to match the reference designs exactly; everything else is derived
/// deterministically so navigation shows stable, varied numbers.
class ReportController extends GetxController {
  final Rx<ReportPeriod> period = ReportPeriod.month.obs;

  /// 0 == current period; only the past is reachable (no future periods).
  final RxInt offset = 0.obs;

  /// Committed window driving the Custom report (null until "Xem báo cáo").
  final Rxn<DateTimeRange> customRange = Rxn<DateTimeRange>();

  /// The window currently shown in the From/To fields & preset chips, before it
  /// is committed with [commitCustom].
  late final Rx<DateTimeRange> draftRange = presetRange(2).obs;

  void setPeriod(ReportPeriod value) {
    if (period.value == value) return;
    period.value = value;
    offset.value = 0;
  }

  void previousPeriod() {
    if (period.value == ReportPeriod.custom) return;
    offset.value -= 1;
  }

  void nextPeriod() {
    if (period.value == ReportPeriod.custom) return;
    if (offset.value < 0) offset.value += 1;
  }

  bool get isCustom => period.value == ReportPeriod.custom;
  bool get canGoPrev => !isCustom;
  bool get canGoNext => !isCustom && offset.value < 0;

  // --- Custom range (draft + commit) ----------------------------------------

  /// Quick-range presets shown as chips: 7d, 30d, 3m, 6m, 1y.
  static const List<String> presetKeys = <String>[
    AppStrings.rptPreset7d,
    AppStrings.rptPreset30d,
    AppStrings.rptPreset3m,
    AppStrings.rptPreset6m,
    AppStrings.rptPreset1y,
  ];

  /// The window for preset [index], ending today.
  DateTimeRange presetRange(int index) {
    final DateTime n = DateTime.now();
    final DateTime end = DateTime(n.year, n.month, n.day);
    switch (index) {
      case 0:
        return DateTimeRange(start: end.subtract(const Duration(days: 6)), end: end);
      case 1:
        return DateTimeRange(start: end.subtract(const Duration(days: 29)), end: end);
      case 2:
        return DateTimeRange(start: DateTime(end.year, end.month - 3, end.day), end: end);
      case 3:
        return DateTimeRange(start: DateTime(end.year, end.month - 6, end.day), end: end);
      default:
        return DateTimeRange(start: DateTime(end.year - 1, end.month, end.day), end: end);
    }
  }

  void applyPreset(int index) => draftRange.value = presetRange(index);

  void setDraftFrom(DateTime from) {
    final DateTimeRange r = draftRange.value;
    if (from.isAfter(r.end)) return;
    draftRange.value = DateTimeRange(start: from, end: r.end);
  }

  void setDraftTo(DateTime to) {
    final DateTimeRange r = draftRange.value;
    if (to.isBefore(r.start)) return;
    draftRange.value = DateTimeRange(start: r.start, end: to);
  }

  /// Apply the drafted range to the report ("Xem báo cáo").
  void commitCustom() => customRange.value = draftRange.value;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Index of the preset matching the current draft, or null for a manual range.
  int? get selectedPreset {
    for (int i = 0; i < presetKeys.length; i++) {
      final DateTimeRange p = presetRange(i);
      if (_sameDay(draftRange.value.start, p.start) &&
          _sameDay(draftRange.value.end, p.end)) {
        return i;
      }
    }
    return null;
  }

  // --- Resolved period -------------------------------------------------------

  DateTime get _now => DateTime.now();

  /// The first day of the month [offset] months before the current month.
  DateTime get _monthDate {
    final DateTime n = _now;
    return DateTime(n.year, n.month + offset.value, 1);
  }

  /// (year, quarter 1..4) for the quarter [offset] quarters before now.
  ({int year, int quarter}) get _quarterDate {
    final DateTime n = _now;
    final int currentQuarter = (n.month - 1) ~/ 3; // 0..3
    final int absolute = n.year * 4 + currentQuarter + offset.value;
    return (year: absolute ~/ 4, quarter: absolute % 4 + 1);
  }

  int get _yearValue => _now.year + offset.value;

  /// The committed Custom window driving the report (defaults to the 3-month
  /// preset until the user commits one with [commitCustom]).
  DateTimeRange get dataRange => customRange.value ?? presetRange(2);

  String _dM(DateTime d) => "${d.day}/${d.month}";
  String _two(int v) => v.toString().padLeft(2, "0");
  String _dMpad(DateTime d) => "${_two(d.day)}/${_two(d.month)}";
  String _dMYpad(DateTime d) => "${_two(d.day)}/${_two(d.month)}/${d.year}";

  /// Header label, e.g. "Tháng 6 · 2026", "Q2 · 2026", "Năm 2026",
  /// "1/6 – 27/6/2026".
  String get periodLabel {
    switch (period.value) {
      case ReportPeriod.month:
        final DateTime d = _monthDate;
        return "${AppStrings.rptPeriodMonth.tr} ${d.month} · ${d.year}";
      case ReportPeriod.quarter:
        final ({int year, int quarter}) q = _quarterDate;
        return "Q${q.quarter} · ${q.year}";
      case ReportPeriod.year:
        return "${AppStrings.rptPeriodYear.tr} $_yearValue";
      case ReportPeriod.custom:
        final DateTimeRange r = dataRange;
        return "${_dMpad(r.start)} – ${_dMYpad(r.end)}";
    }
  }

  /// Secondary line shown under the navigator label (quarter only).
  String get periodSubLabel {
    if (period.value != ReportPeriod.quarter) return "";
    final int first = (_quarterDate.quarter - 1) * 3 + 1;
    return AppStrings.rptQuarterMonths.trParams(<String, String>{
      "from": "$first",
      "to": "${first + 2}",
    });
  }

  /// Total-card heading.
  String get totalTitle {
    switch (period.value) {
      case ReportPeriod.month:
        return AppStrings.rptTotalMonth
            .trParams(<String, String>{"value": "${_monthDate.month}"});
      case ReportPeriod.quarter:
        final ({int year, int quarter}) q = _quarterDate;
        return AppStrings.rptTotalQuarter.trParams(
            <String, String>{"quarter": "${q.quarter}", "year": "${q.year}"});
      case ReportPeriod.year:
        return AppStrings.rptTotalYear
            .trParams(<String, String>{"value": "$_yearValue"});
      case ReportPeriod.custom:
        return AppStrings.rptTotalCustom.tr;
    }
  }

  /// Comparison suffix shown next to the change indicator.
  String get compareLabel {
    switch (period.value) {
      case ReportPeriod.month:
        final DateTime prev =
            DateTime(_monthDate.year, _monthDate.month - 1, 1);
        return AppStrings.rptCompareMonth
            .trParams(<String, String>{"value": "${prev.month}"});
      case ReportPeriod.quarter:
        final ({int year, int quarter}) q = _quarterDate;
        final bool wrap = q.quarter == 1;
        return AppStrings.rptCompareQuarter.trParams(<String, String>{
          "quarter": "${wrap ? 4 : q.quarter - 1}",
          "year": "${wrap ? q.year - 1 : q.year}",
        });
      case ReportPeriod.year:
        return AppStrings.rptCompareYear
            .trParams(<String, String>{"value": "${_yearValue - 1}"});
      case ReportPeriod.custom:
        return AppStrings.rptCompareCustom.tr;
    }
  }

  /// Center subtitle for the donut (quarter only, e.g. "Tổng Q2").
  String? get donutCenterSubtitle {
    if (period.value != ReportPeriod.quarter) return null;
    return AppStrings.rptDonutTotal
        .trParams(<String, String>{"value": "Q${_quarterDate.quarter}"});
  }

  /// Whether the donut/legend should surface the admin slice and amounts.
  /// The Month design keeps a compact 3-category legend; the others are richer.
  bool get showAdminInDonut => period.value != ReportPeriod.month;

  // --- Data ------------------------------------------------------------------

  /// Deterministic per-offset wobble so navigating shows varied — but stable —
  /// numbers without any randomness.
  static const List<double> _factors = <double>[1.0, 0.88, 1.12, 0.95, 1.06];

  double get _factor => _factors[offset.value.abs() % _factors.length];

  ReportData get data {
    switch (period.value) {
      case ReportPeriod.month:
        if (offset.value == 0) return _canonicalMonth();
        return _build(
          baseTotal: (3250000 * _factor).round(),
          chartTitleKey: AppStrings.rptChartByWeek,
          labels: const <String>["T1", "T2", "T3", "T4"],
          weights: const <double>[0.25, 0.40, 0.21, 0.14],
          kmPerLiter: 38.2 * _factor,
        );
      case ReportPeriod.quarter:
        if (offset.value == 0) return _canonicalQuarter();
        final int first = (_quarterDate.quarter - 1) * 3 + 1;
        return _build(
          baseTotal: (9840000 * _factor).round(),
          chartTitleKey: AppStrings.rptChartCompareMonths,
          labels: <String>[
            "${AppStrings.rptPeriodMonth.tr} $first",
            "${AppStrings.rptPeriodMonth.tr} ${first + 1}",
            "${AppStrings.rptPeriodMonth.tr} ${first + 2}",
          ],
          weights: const <double>[0.29, 0.38, 0.33],
          kmPerLiter: 37.4 * _factor,
        );
      case ReportPeriod.year:
        return _build(
          baseTotal: (3250000 * 12 * _factor).round(),
          chartTitleKey: AppStrings.rptChartByQuarter,
          labels: const <String>["Q1", "Q2", "Q3", "Q4"],
          weights: const <double>[0.27, 0.24, 0.23, 0.26],
          kmPerLiter: 36.8 * _factor,
        );
      case ReportPeriod.custom:
        return _buildCustom();
    }
  }

  /// Splits [baseTotal] across [weights] and, within each segment, across the
  /// fixed category ratios. Amounts are rounded to the nearest 1.000đ.
  ReportData _build({
    required int baseTotal,
    required String chartTitleKey,
    required List<String> labels,
    required List<double> weights,
    required double kmPerLiter,
  }) {
    int round1k(num v) => (v / 1000).round() * 1000;

    final List<ReportSegment> segments = <ReportSegment>[];
    for (int i = 0; i < labels.length; i++) {
      final double s = baseTotal * weights[i];
      segments.add(ReportSegment(
        label: labels[i],
        fuel: round1k(s * 0.46),
        repair: round1k(s * 0.34),
        supplies: round1k(s * 0.17),
        admin: round1k(s * 0.03),
      ));
    }

    final int fuel = segments.fold(0, (int a, ReportSegment s) => a + s.fuel);
    final int repair =
        segments.fold(0, (int a, ReportSegment s) => a + s.repair);
    final int supplies =
        segments.fold(0, (int a, ReportSegment s) => a + s.supplies);
    final int admin = segments.fold(0, (int a, ReportSegment s) => a + s.admin);
    final int total = fuel + repair + supplies + admin;

    return ReportData(
      total: total,
      changePercent:
          8 + (offset.value.abs() % 3) * 3 - (offset.value.isOdd ? 14 : 0),
      fuel: fuel,
      repair: repair,
      supplies: supplies,
      admin: admin,
      segments: segments,
      chartTitleKey: chartTitleKey,
      kmPerLiter: double.parse(kmPerLiter.toStringAsFixed(1)),
      kmChange: offset.value.isOdd ? -1.4 : 2.1,
      top: _topFor(total, _periodAnchorDate),
    );
  }

  /// Custom range: buckets by calendar month when it spans 2–8 months
  /// (labeled "Tháng N"), otherwise by week (labeled "d/M").
  ReportData _buildCustom() {
    final DateTimeRange r = dataRange;
    final int days = r.end.difference(r.start).inDays + 1;
    final int monthsSpan =
        (r.end.year - r.start.year) * 12 + (r.end.month - r.start.month) + 1;

    final List<String> labels = <String>[];
    final List<double> weights = <double>[];
    String chartTitleKey;

    if (monthsSpan >= 2 && monthsSpan <= 8) {
      // One bar per calendar month, weighted by days in-range.
      chartTitleKey = AppStrings.rptChartByMonth;
      DateTime cursor = DateTime(r.start.year, r.start.month, 1);
      final DateTime lastMonth = DateTime(r.end.year, r.end.month, 1);
      while (!cursor.isAfter(lastMonth)) {
        final DateTime monthEnd = DateTime(cursor.year, cursor.month + 1, 0);
        final DateTime from = cursor.isBefore(r.start) ? r.start : cursor;
        final DateTime to = monthEnd.isAfter(r.end) ? r.end : monthEnd;
        labels.add("${AppStrings.rptPeriodMonth.tr} ${cursor.month}");
        weights.add((to.difference(from).inDays + 1).toDouble());
        cursor = DateTime(cursor.year, cursor.month + 1, 1);
      }
    } else {
      // Up to 6 weekly-ish columns labeled by the bucket's start date.
      chartTitleKey = AppStrings.rptChartByPeriod;
      const List<double> pattern = <double>[1.0, 1.18, 0.9, 1.22, 0.85, 1.05];
      final int buckets = (days / 7).ceil().clamp(1, 6);
      for (int i = 0; i < buckets; i++) {
        final DateTime d =
            r.start.add(Duration(days: (days * i / buckets).round()));
        labels.add(_dM(d));
        weights.add(pattern[i % pattern.length]);
      }
    }

    final double sum = weights.fold(0, (double a, double b) => a + b);
    for (int i = 0; i < weights.length; i++) {
      weights[i] = weights[i] / sum;
    }

    const int dailyBase = 108000; // ≈ 3.25tr / 30 ngày
    return _build(
      baseTotal: (dailyBase * days / 1000).round() * 1000,
      chartTitleKey: chartTitleKey,
      labels: labels,
      weights: weights,
      kmPerLiter: 37.6,
    );
  }

  /// A representative date for seeding the "top expenses" of the current period.
  DateTime get _periodAnchorDate {
    switch (period.value) {
      case ReportPeriod.month:
        return _monthDate;
      case ReportPeriod.quarter:
        final ({int year, int quarter}) q = _quarterDate;
        return DateTime(q.year, (q.quarter - 1) * 3 + 2, 1);
      case ReportPeriod.year:
        return DateTime(_yearValue, 3, 1);
      case ReportPeriod.custom:
        return dataRange.end;
    }
  }

  /// Sample "top expenses" scaled so the figures look plausible for [total].
  List<ReportTopExpense> _topFor(int total, DateTime anchor) {
    int amt(double f) => ((total * f) / 1000).round() * 1000;
    return <ReportTopExpense>[
      ReportTopExpense(
        title: "Thay lốp sau",
        icon: Icons.build_rounded,
        color: AppColors.chartRepair,
        amount: amt(0.26),
        date: DateTime(anchor.year, anchor.month, 10),
      ),
      ReportTopExpense(
        title: "Bảo dưỡng định kỳ",
        icon: Icons.build_rounded,
        color: AppColors.chartRepair,
        amount: amt(0.19),
        date: DateTime(anchor.year, anchor.month, 18),
      ),
      ReportTopExpense(
        title: "Đổ xăng Petrolimex Q1",
        icon: Icons.local_gas_station_rounded,
        color: AppColors.chartFuel,
        amount: amt(0.11),
        date: DateTime(anchor.year, anchor.month, 5),
      ),
    ];
  }

  /// Exact figures from the reference design (current month).
  ReportData _canonicalMonth() {
    final DateTime d = _monthDate;
    return ReportData(
      total: 3250000,
      changePercent: 12,
      fuel: 1450000,
      repair: 1200000,
      supplies: 600000,
      admin: 0,
      segments: const <ReportSegment>[
        ReportSegment(label: "T1", fuel: 380000, repair: 320000, supplies: 100000),
        ReportSegment(label: "T2", fuel: 560000, repair: 480000, supplies: 260000),
        ReportSegment(label: "T3", fuel: 320000, repair: 250000, supplies: 100000),
        ReportSegment(label: "T4", fuel: 190000, repair: 150000, supplies: 140000),
      ],
      chartTitleKey: AppStrings.rptChartByWeek,
      kmPerLiter: 38.2,
      kmChange: 2.1,
      top: <ReportTopExpense>[
        ReportTopExpense(
          title: "Thay lốp sau",
          icon: Icons.build_rounded,
          color: AppColors.chartRepair,
          amount: 850000,
          date: DateTime(d.year, d.month, 10),
        ),
        ReportTopExpense(
          title: "Bảo dưỡng định kỳ",
          icon: Icons.build_rounded,
          color: AppColors.chartRepair,
          amount: 620000,
          date: DateTime(d.year, d.month, 18),
        ),
        ReportTopExpense(
          title: "Đổ xăng Petrolimex Q1",
          icon: Icons.local_gas_station_rounded,
          color: AppColors.chartFuel,
          amount: 350000,
          date: DateTime(d.year, d.month, 5),
        ),
      ],
    );
  }

  /// Exact figures from the reference design (current quarter).
  ReportData _canonicalQuarter() {
    final String m = AppStrings.rptPeriodMonth.tr;
    final int first = (_quarterDate.quarter - 1) * 3 + 1;
    return ReportData(
      total: 9840000,
      changePercent: 8,
      fuel: 4526000,
      repair: 3345000,
      supplies: 1672000,
      admin: 297000,
      segments: <ReportSegment>[
        ReportSegment(
            label: "$m $first",
            fuel: 1329000,
            repair: 983000,
            supplies: 491000,
            admin: 87000),
        ReportSegment(
            label: "$m ${first + 1}",
            fuel: 1702000,
            repair: 1258000,
            supplies: 629000,
            admin: 111000),
        ReportSegment(
            label: "$m ${first + 2}",
            fuel: 1495000,
            repair: 1104000,
            supplies: 552000,
            admin: 99000),
      ],
      chartTitleKey: AppStrings.rptChartCompareMonths,
      kmPerLiter: 37.8,
      kmChange: 1.6,
      top: _topFor(9840000, _periodAnchorDate),
    );
  }
}
