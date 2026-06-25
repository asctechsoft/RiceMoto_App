import "dart:io";
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Full-screen "AI is reading your receipt" state, shown after the photo is
/// captured and before the [ReceiptReviewSheet] result appears.
///
/// Purely presentational + animated; the controller decides how long it stays
/// on screen.
class ReceiptProcessingView extends StatefulWidget {
  const ReceiptProcessingView({required this.imagePath, super.key});

  /// Path to the just-captured receipt photo, shown as a small preview card.
  final String imagePath;

  @override
  State<ReceiptProcessingView> createState() => _ReceiptProcessingViewState();
}

class _ReceiptProcessingViewState extends State<ReceiptProcessingView>
    with TickerProviderStateMixin {
  late final AnimationController _spin;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFFFF),
            Color(0xFFEFF6F1),
            Color(0xFFE6F2EA),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.h),
            _ReceiptThumb(imagePath: widget.imagePath),
            const Spacer(),
            _AiPulse(spin: _spin, pulse: _pulse),
            const Spacer(),
            Text(
              AppStrings.processingTitle.tr,
              style: AppTextStyles.heading.copyWith(fontSize: 22.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.processingSubtitle.tr,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: 36.h),
            const _Dots(),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}

/// Small tilted preview of the captured receipt with a soft shadow.
class _ReceiptThumb extends StatelessWidget {
  const _ReceiptThumb({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final File file = File(imagePath);
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        width: 96.w,
        height: 132.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: file.existsSync()
            ? Image.file(file, fit: BoxFit.cover)
            : Center(
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 40.w,
                  color: AppColors.textHint,
                ),
              ),
      ),
    );
  }
}

/// Concentric rings + rotating arc + pulsing glow with a sparkle in the center.
class _AiPulse extends StatelessWidget {
  const _AiPulse({required this.spin, required this.pulse});

  final AnimationController spin;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    final double size = 220.w;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[spin, pulse]),
        builder: (BuildContext context, _) {
          final double glow = 0.25 + 0.35 * pulse.value;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Faint outer rings + rotating sweep.
              Transform.rotate(
                angle: spin.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _RingsPainter(),
                ),
              ),
              // Glowing core.
              Container(
                width: 86.w,
                height: 86.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: glow),
                      blurRadius: 36.r,
                      spreadRadius: 6.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 34.w,
                  color: AppColors.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Two static faint rings plus one bright rotating arc (the parent rotates it).
class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double r = size.width / 2;

    final Paint faint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.primary.withValues(alpha: 0.14);
    canvas.drawCircle(center, r - 2, faint);
    canvas.drawCircle(center, r * 0.72, faint);

    // Bright rotating arc on the middle ring.
    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: <Color>[
          AppColors.primary.withValues(alpha: 0),
          AppColors.primaryLight,
          AppColors.primary,
        ],
        stops: const <double>[0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r * 0.72));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.72),
      -math.pi / 2,
      math.pi * 1.1,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingsPainter oldDelegate) => false;
}

/// Three decorative progress dots; the middle one is the active accent.
class _Dots extends StatelessWidget {
  const _Dots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int i) {
        final bool active = i == 1;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: active ? 9.w : 7.w,
          height: active ? 9.w : 7.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }
}
