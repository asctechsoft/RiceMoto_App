import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Detail view for a single expense category within a report period.
/// Navigate to this screen via [AppRoutes.fuelCategoryDetail], passing the
/// title string (e.g. "Xăng · Tháng 6") as [Get.arguments].
class FuelCategoryDetailScreen extends StatelessWidget {
  const FuelCategoryDetailScreen({super.key});

  // Sample data matching the reference design (current month, fuel category).
  static const List<_EffPoint> _eff = <_EffPoint>[
    _EffPoint("1/6", 39.6),
    _EffPoint("4/6", 38.7),
    _EffPoint("8/6", 41.2),
    _EffPoint("11/6", 39.1),
    _EffPoint("15/6", 35.8),
    _EffPoint("18/6", 39.4),
    _EffPoint("22/6", 38.7),
    _EffPoint("25/6", 37.6),
    _EffPoint("29/6", 37.9),
  ];

  static const List<_WeekBar> _weeks = <_WeekBar>[
    _WeekBar("T1", 380000),
    _WeekBar("T2", 520000),
    _WeekBar("T3", 260000),
    _WeekBar("T4", 290000),
  ];

  static const List<_Fillup> _fillups = <_Fillup>[
    _Fillup("10/06", "Petrolimex Q1", 2.35, 40.8, 350000),
    _Fillup("08/06", "PVOIL Nguyễn Trãi", 3.10, 41.2, 285000),
    _Fillup("15/06", "Petrol Station", 1.95, 35.8, 180000),
    _Fillup("18/06", "COMECO Q3", 3.50, 39.4, 320000),
    _Fillup("22/06", "Petrolimex Q7", 2.80, 38.7, 240000),
    _Fillup("29/06", "Saigon Petro", 2.60, 37.9, 210000),
  ];

  static const double _avgKm = 39.2;
  static const double _bestKm = 41.2;
  static const String _bestDate = "8/6";
  static const double _worstKm = 35.8;
  static const String _worstDate = "15/6";
  static const int _totalCost = 1450000;
  static const double _totalLiters = 45.2;
  static const int _fillCount = 15;

  @override
  Widget build(BuildContext context) {
    final String title = (Get.arguments is String)
        ? Get.arguments as String
        : AppStrings.catFuel.tr;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _ScreenAppBar(title: title),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                children: <Widget>[
                  _SummaryRow(
                    totalCost: _totalCost,
                    totalLiters: _totalLiters,
                    fillCount: _fillCount,
                  ),
                  SizedBox(height: 14.h),
                  _EfficiencyCard(
                    points: _eff,
                    avgKm: _avgKm,
                    bestKm: _bestKm,
                    bestDate: _bestDate,
                    worstKm: _worstKm,
                    worstDate: _worstDate,
                  ),
                  SizedBox(height: 14.h),
                  _WeeklyCard(weeks: _weeks),
                  SizedBox(height: 18.h),
                  _FillupsSection(
                    fillups: _fillups,
                    bestKm: _bestKm,
                    worstKm: _worstKm,
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

// ─────────────────────────────────────────────────────────────────────────────
// AppBar
// ─────────────────────────────────────────────────────────────────────────────

class _ScreenAppBar extends StatelessWidget {
  const _ScreenAppBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 6.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: Get.back,
            icon: Icon(Icons.chevron_left_rounded, size: 28.w),
            color: AppColors.textPrimary,
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

// ─────────────────────────────────────────────────────────────────────────────
// Summary row  (Tổng chi · Tổng lít · Số lần đổ)
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.totalCost,
    required this.totalLiters,
    required this.fillCount,
  });
  final int totalCost;
  final double totalLiters;
  final int fillCount;

  @override
  Widget build(BuildContext context) {
    final String liters =
        totalLiters.toStringAsFixed(1).replaceAll(".", ",");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _StatCell(
              value: formatMoney(totalCost),
              label: AppStrings.fdTotalCost.tr,
              valueColor: AppColors.primary,
            ),
          ),
          _VDivider(),
          Expanded(
            child: _StatCell(
              value: "${liters}L",
              label: AppStrings.fdTotalLiters.tr,
            ),
          ),
          _VDivider(),
          Expanded(
            child: _StatCell(
              value: "$fillCount ${AppStrings.fdTimesUnit.tr}",
              label: AppStrings.fdFillCount.tr,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label, this.valueColor});
  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36.h,
      color: AppColors.divider,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Efficiency card (line chart + best / worst callouts)
// ─────────────────────────────────────────────────────────────────────────────

class _EfficiencyCard extends StatelessWidget {
  const _EfficiencyCard({
    required this.points,
    required this.avgKm,
    required this.bestKm,
    required this.bestDate,
    required this.worstKm,
    required this.worstDate,
  });
  final List<_EffPoint> points;
  final double avgKm;
  final double bestKm;
  final String bestDate;
  final double worstKm;
  final String worstDate;

  String _fmt(double v) => v.toStringAsFixed(1).replaceAll(".", ",");

  @override
  Widget build(BuildContext context) {
    final String avgLabel =
        "${AppStrings.fdAvgLabel.tr}: ${_fmt(avgKm)} ${AppStrings.rptEfficiencyUnit.tr}";
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.fdEfficiencyTitle.tr,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          _EfficiencyChart(
            points: points,
            avgKm: avgKm,
            avgLabel: avgLabel,
            bestKm: bestKm,
            worstKm: worstKm,
          ),
          SizedBox(height: 12.h),
          _InsightRow(
            icon: Icons.arrow_upward_rounded,
            color: AppColors.success,
            labelKey: AppStrings.fdBestFillup,
            value:
                "${_fmt(bestKm)} ${AppStrings.rptEfficiencyUnit.tr} · $bestDate",
          ),
          SizedBox(height: 6.h),
          _InsightRow(
            icon: Icons.arrow_downward_rounded,
            color: _kAmber,
            labelKey: AppStrings.fdWorstFillup,
            value:
                "${_fmt(worstKm)} ${AppStrings.rptEfficiencyUnit.tr} · $worstDate",
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.color,
    required this.labelKey,
    required this.value,
  });
  final IconData icon;
  final Color color;
  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12.w, color: color),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: "${labelKey.tr}: ",
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Line chart widget + painter
// ─────────────────────────────────────────────────────────────────────────────

class _EfficiencyChart extends StatelessWidget {
  const _EfficiencyChart({
    required this.points,
    required this.avgKm,
    required this.avgLabel,
    required this.bestKm,
    required this.worstKm,
  });
  final List<_EffPoint> points;
  final double avgKm;
  final String avgLabel;
  final double bestKm;
  final double worstKm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155.h,
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(
          points: points,
          avgKm: avgKm,
          avgLabel: avgLabel,
          bestKm: bestKm,
          worstKm: worstKm,
          yLabelStyle: AppTextStyles.caption.copyWith(
            fontSize: 10.sp,
            color: AppColors.textHint,
          ),
          xLabelStyle: AppTextStyles.caption.copyWith(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
          avgLabelStyle: AppTextStyles.caption.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: _kAmber,
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.avgKm,
    required this.avgLabel,
    required this.bestKm,
    required this.worstKm,
    required this.yLabelStyle,
    required this.xLabelStyle,
    required this.avgLabelStyle,
  });

  final List<_EffPoint> points;
  final double avgKm;
  final String avgLabel;
  final double bestKm;
  final double worstKm;
  final TextStyle yLabelStyle;
  final TextStyle xLabelStyle;
  final TextStyle avgLabelStyle;

  static const double _gutterLeft = 28;
  static const double _gutterBottom = 20;
  static const double _yMin = 34;
  static const double _yMax = 44;
  static const double _yRange = _yMax - _yMin;
  // steps of 2: 34, 36, 38, 40, 42, 44  (5 intervals, 6 lines)
  static const int _ySteps = 5;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double pLeft = _gutterLeft;
    final double pRight = size.width;
    final double pTop = 6;
    final double pBottom = size.height - _gutterBottom;
    final double pH = pBottom - pTop;
    final double pW = pRight - pLeft;

    double toY(double km) => pBottom - (km - _yMin) / _yRange * pH;
    double toX(int i) =>
        pLeft + pW * i / math.max(1, points.length - 1);

    // Horizontal grid + Y labels
    final Paint gridP = Paint()
      ..color = AppColors.chartGrid
      ..strokeWidth = 1;
    for (int s = 0; s <= _ySteps; s++) {
      final double val = _yMin + s * 2.0;
      final double y = toY(val);
      canvas.drawLine(Offset(pLeft, y), Offset(pRight, y), gridP);
      _text(
        canvas,
        val.round().toString(),
        yLabelStyle,
        Offset(pLeft - 4, y),
        align: _TA.right,
        vCenter: true,
      );
    }

    // Avg dashed line
    final double avgY = toY(avgKm);
    final Paint dashP = Paint()
      ..color = _kAmber
      ..strokeWidth = 1.5;
    _drawDashed(canvas, Offset(pLeft, avgY), Offset(pRight, avgY), dashP);

    // Avg label — placed above the dashed line at right edge
    _text(canvas, avgLabel, avgLabelStyle,
        Offset(pRight, avgY - 14), align: _TA.right);

    // Line path
    final Path path = Path();
    for (int i = 0; i < points.length; i++) {
      final Offset pt = Offset(toX(i), toY(points[i].km));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.chartFuel
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Dots + x labels
    for (int i = 0; i < points.length; i++) {
      final double km = points[i].km;
      final Offset pt = Offset(toX(i), toY(km));
      final bool isBest = km == bestKm;
      final bool isWorst = km == worstKm;
      final Color dotColor = isBest
          ? AppColors.success
          : isWorst
              ? _kAmber
              : AppColors.chartFuel;
      final double r = (isBest || isWorst) ? 5.0 : 3.5;

      // White ring for outline effect
      canvas.drawCircle(pt, r + 1.5,
          Paint()
            ..color = AppColors.surface
            ..style = PaintingStyle.fill);
      canvas.drawCircle(pt, r,
          Paint()
            ..color = dotColor
            ..style = PaintingStyle.fill);

      _text(canvas, points[i].label, xLabelStyle,
          Offset(pt.dx, pBottom + 4), align: _TA.center);
    }
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    const double dash = 5;
    const double gap = 3;
    final double dx = to.dx - from.dx;
    final double dy = to.dy - from.dy;
    final double dist = math.sqrt(dx * dx + dy * dy);
    if (dist == 0) return;
    final double nx = dx / dist;
    final double ny = dy / dist;
    double t = 0;
    bool drawing = true;
    while (t < dist) {
      final double seg = drawing ? dash : gap;
      final double end = math.min(t + seg, dist);
      if (drawing) {
        canvas.drawLine(
          Offset(from.dx + nx * t, from.dy + ny * t),
          Offset(from.dx + nx * end, from.dy + ny * end),
          paint,
        );
      }
      t = end;
      drawing = !drawing;
    }
  }

  void _text(Canvas canvas, String text, TextStyle style, Offset at,
      {_TA align = _TA.left, bool vCenter = false}) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    double dx = at.dx;
    if (align == _TA.center) dx -= tp.width / 2;
    if (align == _TA.right) dx -= tp.width;
    final double dy = vCenter ? at.dy - tp.height / 2 : at.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.points != points || old.avgKm != avgKm;
}

enum _TA { left, center, right }

// ─────────────────────────────────────────────────────────────────────────────
// Weekly cost bar chart card
// ─────────────────────────────────────────────────────────────────────────────

class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard({required this.weeks});
  final List<_WeekBar> weeks;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.rptChartByWeek.tr,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 130.h,
            child: CustomPaint(
              size: Size.infinite,
              painter: _WeekBarPainter(
                weeks: weeks,
                xLabelStyle: AppTextStyles.caption.copyWith(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                valueLabelStyle: AppTextStyles.caption.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekBarPainter extends CustomPainter {
  _WeekBarPainter({
    required this.weeks,
    required this.xLabelStyle,
    required this.valueLabelStyle,
  });

  final List<_WeekBar> weeks;
  final TextStyle xLabelStyle;
  final TextStyle valueLabelStyle;

  static const double _gutterBottom = 22;
  static const double _topPad = 18;

  @override
  void paint(Canvas canvas, Size size) {
    if (weeks.isEmpty) return;
    final int maxVal =
        weeks.fold(0, (int m, _WeekBar b) => b.amount > m ? b.amount : m);
    if (maxVal <= 0) return;

    final double pBottom = size.height - _gutterBottom;
    final double pH = pBottom - _topPad;
    final double slotW = size.width / weeks.length;
    final double barW = math.min(slotW * 0.48, 40);
    final Paint barP = Paint()..color = AppColors.chartFuel;

    for (int i = 0; i < weeks.length; i++) {
      final _WeekBar w = weeks[i];
      final double cx = slotW * (i + 0.5);
      final double barH = w.amount / maxVal * pH;
      final double left = cx - barW / 2;
      final double top = pBottom - barH;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(left, top, left + barW, pBottom),
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
        ),
        barP,
      );

      // Value label above bar
      _text(canvas, formatMoney(w.amount), valueLabelStyle,
          Offset(cx, top - 2), align: _TA.center);

      // X label below
      _text(canvas, w.label, xLabelStyle,
          Offset(cx, pBottom + 5), align: _TA.center);
    }
  }

  void _text(Canvas canvas, String text, TextStyle style, Offset at,
      {_TA align = _TA.left}) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    double dx = at.dx;
    if (align == _TA.center) dx -= tp.width / 2;
    if (align == _TA.right) dx -= tp.width;
    tp.paint(canvas, Offset(dx, at.dy - tp.height));
  }

  @override
  bool shouldRepaint(_WeekBarPainter old) => old.weeks != weeks;
}

// ─────────────────────────────────────────────────────────────────────────────
// All fill-ups list
// ─────────────────────────────────────────────────────────────────────────────

class _FillupsSection extends StatelessWidget {
  const _FillupsSection({
    required this.fillups,
    required this.bestKm,
    required this.worstKm,
  });
  final List<_Fillup> fillups;
  final double bestKm;
  final double worstKm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.fdAllFillups.tr,
          style: AppTextStyles.title.copyWith(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        _Card(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Column(
            children: <Widget>[
              for (int i = 0; i < fillups.length; i++) ...<Widget>[
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const Divider(height: 1, color: AppColors.divider),
                  ),
                _FillupRow(
                  fillup: fillups[i],
                  isBest: fillups[i].kmPerLiter == bestKm,
                  isWorst: fillups[i].kmPerLiter == worstKm,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FillupRow extends StatelessWidget {
  const _FillupRow({
    required this.fillup,
    required this.isBest,
    required this.isWorst,
  });
  final _Fillup fillup;
  final bool isBest;
  final bool isWorst;

  @override
  Widget build(BuildContext context) {
    final String liters =
        fillup.liters.toStringAsFixed(2).replaceAll(".", ",");
    final String km =
        fillup.kmPerLiter.toStringAsFixed(1).replaceAll(".", ",");
    final Color kmColor = isBest
        ? AppColors.success
        : isWorst
            ? _kAmber
            : AppColors.textHint;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 38.w,
            child: Text(
              fillup.dateLabel,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11.sp,
                color: AppColors.textHint,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              fillup.station,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "${liters}L",
                style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
              ),
              Text(
                "$km ${AppStrings.rptEfficiencyUnit.tr}",
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: kmColor,
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          Text(
            formatMoney(fillup.amount),
            style: AppTextStyles.body.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 2.w),
          Icon(
            Icons.chevron_right_rounded,
            size: 18.w,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared card container
// ─────────────────────────────────────────────────────────────────────────────

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
          BoxShadow(
              color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models (private to this file)
// ─────────────────────────────────────────────────────────────────────────────

class _EffPoint {
  const _EffPoint(this.label, this.km);
  final String label;
  final double km;
}

class _WeekBar {
  const _WeekBar(this.label, this.amount);
  final String label;
  final int amount;
}

class _Fillup {
  const _Fillup(
      this.dateLabel, this.station, this.liters, this.kmPerLiter, this.amount);
  final String dateLabel;
  final String station;
  final double liters;
  final double kmPerLiter;
  final int amount;
}

// Shared amber color for worst fill-up + avg line.
const Color _kAmber = Color(0xFFE07A1B);
