import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/models/report_model.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// One charted category: a color + its share of the whole (already a percent).
class ChartSlice {
  const ChartSlice({required this.color, required this.value});

  final Color color;
  final int value;
}

// ===========================================================================
// Stacked bar chart — "Chi phí theo tuần / tháng / quý"
// ===========================================================================

/// A grouped/stacked bar chart with a left value axis and bottom labels.
///
/// Each bar stacks fuel (bottom) · repair · supplies (top, rounded). The value
/// axis snaps to a "nice" maximum in 400.000đ steps, matching the design.
class ReportBarChart extends StatelessWidget {
  const ReportBarChart({required this.segments, super.key});

  final List<ReportSegment> segments;

  /// Smallest multiple of 400.000 that fits the tallest bar (min 1.600.000).
  int get _axisMax {
    final int peak = segments.fold(
        0, (int m, ReportSegment s) => s.barTotal > m ? s.barTotal : m);
    const int step = 400000;
    final int snapped = (peak / step).ceil() * step;
    return math.max(snapped, step * 4);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      width: double.infinity,
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(
          segments: segments,
          axisMax: _axisMax,
          labelStyle: AppTextStyles.caption.copyWith(
            fontSize: 10.sp,
            color: AppColors.textHint,
          ),
          xLabelStyle: AppTextStyles.caption.copyWith(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.segments,
    required this.axisMax,
    required this.labelStyle,
    required this.xLabelStyle,
  });

  final List<ReportSegment> segments;
  final int axisMax;
  final TextStyle labelStyle;
  final TextStyle xLabelStyle;

  static const double _gutterLeft = 42;
  static const double _gutterBottom = 22;
  static const int _steps = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final double plotLeft = _gutterLeft;
    final double plotRight = size.width;
    final double plotTop = 4;
    final double plotBottom = size.height - _gutterBottom;
    final double plotHeight = plotBottom - plotTop;
    final double plotWidth = plotRight - plotLeft;

    final Paint grid = Paint()
      ..color = AppColors.chartGrid
      ..strokeWidth = 1;

    // Horizontal gridlines + value labels (top..baseline).
    for (int i = 0; i <= _steps; i++) {
      final double value = axisMax * (1 - i / _steps);
      final double y = plotTop + plotHeight * (i / _steps);
      canvas.drawLine(Offset(plotLeft, y), Offset(plotRight, y), grid);
      if (i < _steps) {
        _text(
          canvas,
          _axisLabel(value),
          labelStyle,
          Offset(plotLeft - 6, y),
          align: _Align.right,
          vCenter: true,
        );
      }
    }

    // Bars.
    final int n = segments.length;
    final double slot = plotWidth / n;
    final double barW = math.min(slot * 0.5, 34);
    final double scale = plotHeight / axisMax;

    for (int i = 0; i < n; i++) {
      final ReportSegment s = segments[i];
      final double cx = plotLeft + slot * (i + 0.5);
      final double left = cx - barW / 2;
      double cursor = plotBottom;

      // bottom -> top: fuel, repair, supplies (rounded top).
      cursor = _drawStack(canvas, left, barW, cursor, s.fuel * scale,
          AppColors.chartFuel, false);
      cursor = _drawStack(canvas, left, barW, cursor, s.repair * scale,
          AppColors.chartRepair, false);
      cursor = _drawStack(canvas, left, barW, cursor, s.supplies * scale,
          AppColors.chartSupplies, true);

      _text(canvas, s.label, xLabelStyle, Offset(cx, plotBottom + 6),
          align: _Align.center);
    }
  }

  /// Draws one stacked segment of height [h] ending at [bottom]; returns the new
  /// (higher) cursor. The top-most segment gets rounded top corners.
  double _drawStack(Canvas canvas, double left, double w, double bottom,
      double h, Color color, bool roundTop) {
    if (h <= 0) return bottom;
    final double top = bottom - h;
    final Paint paint = Paint()..color = color;
    final Radius r = roundTop ? const Radius.circular(5) : Radius.zero;
    final RRect rect = RRect.fromRectAndCorners(
      Rect.fromLTRB(left, top, left + w, bottom),
      topLeft: r,
      topRight: r,
    );
    canvas.drawRRect(rect, paint);
    return top;
  }

  /// Value-axis label: "M" units for large scales (quarter/year), else "K".
  String _axisLabel(double value) {
    if (axisMax >= 4000000) {
      final double m = value / 1000000;
      final String s = m == m.roundToDouble()
          ? m.toStringAsFixed(0)
          : m.toStringAsFixed(1).replaceAll(".", ",");
      return "${s}M";
    }
    return "${formatThousands((value / 1000).round())}K";
  }

  void _text(Canvas canvas, String text, TextStyle style, Offset at,
      {_Align align = _Align.left, bool vCenter = false}) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    double dx = at.dx;
    switch (align) {
      case _Align.left:
        break;
      case _Align.center:
        dx -= tp.width / 2;
      case _Align.right:
        dx -= tp.width;
    }
    final double dy = vCenter ? at.dy - tp.height / 2 : at.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.segments != segments || old.axisMax != axisMax;
}

enum _Align { left, center, right }

// ===========================================================================
// Donut chart — category split with center total
// ===========================================================================

/// A donut ring of [slices] with on-ring percentage labels and the [centerText]
/// (period total) — plus an optional [centerSubtitle] — drawn in the hole.
class ReportDonutChart extends StatelessWidget {
  const ReportDonutChart({
    required this.slices,
    required this.centerText,
    this.centerSubtitle,
    this.size = 132,
    super.key,
  });

  final List<ChartSlice> slices;
  final String centerText;
  final String? centerSubtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: CustomPaint(
        painter: _DonutPainter(
          slices: slices,
          centerText: centerText,
          centerSubtitle: centerSubtitle,
          centerStyle: AppTextStyles.body.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          subtitleStyle: AppTextStyles.caption.copyWith(
            fontSize: 9.sp,
            color: AppColors.textSecondary,
          ),
          pctStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.slices,
    required this.centerText,
    required this.centerSubtitle,
    required this.centerStyle,
    required this.subtitleStyle,
    required this.pctStyle,
  });

  final List<ChartSlice> slices;
  final String centerText;
  final String? centerSubtitle;
  final TextStyle centerStyle;
  final TextStyle subtitleStyle;
  final TextStyle pctStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double thickness = size.width * 0.22;
    final double radius = (size.width - thickness) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final int total =
        slices.fold(0, (int a, ChartSlice s) => a + s.value);
    if (total <= 0) return;

    const double gap = 0.05; // radians between slices
    double start = -math.pi / 2; // 12 o'clock
    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    for (final ChartSlice s in slices) {
      if (s.value <= 0) continue;
      final double sweep = (s.value / total) * (2 * math.pi) - gap;
      arc.color = s.color;
      canvas.drawArc(rect, start + gap / 2, sweep, false, arc);

      // Percentage label centered on the ring band.
      final double mid = start + gap / 2 + sweep / 2;
      final Offset labelPos = center +
          Offset(math.cos(mid) * radius, math.sin(mid) * radius);
      _text(canvas, "${(s.value / total * 100).round()}%", pctStyle, labelPos);

      start += sweep + gap;
    }

    final String? sub = centerSubtitle;
    if (sub == null || sub.isEmpty) {
      _text(canvas, centerText, centerStyle, center);
    } else {
      const double lineGap = 1;
      final TextPainter main = _painter(centerText, centerStyle);
      final TextPainter subTp = _painter(sub, subtitleStyle);
      final double totalH = main.height + lineGap + subTp.height;
      final double top = center.dy - totalH / 2;
      main.paint(canvas, Offset(center.dx - main.width / 2, top));
      subTp.paint(canvas,
          Offset(center.dx - subTp.width / 2, top + main.height + lineGap));
    }
  }

  TextPainter _painter(String text, TextStyle style) => TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

  void _text(Canvas canvas, String text, TextStyle style, Offset center) {
    final TextPainter tp = _painter(text, style);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.centerText != centerText ||
      old.centerSubtitle != centerSubtitle ||
      old.slices != slices;
}
