import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/camera_scan_controller.dart";
import "package:ricemoto/values/app_strings.dart";

/// Bright accent used for the scanning frame corners.
const Color _scanGreen = Color(0xFF4ADE80);
const Color _controlBg = Color(0x66000000);

class CameraScanScreen extends GetView<CameraScanController> {
  const CameraScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.hasError.value) {
          return _ErrorView(onClose: controller.close);
        }
        if (!controller.isReady.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        return _ScannerView(controller: controller);
      }),
    );
  }
}

class _ScannerView extends StatelessWidget {
  const _ScannerView({required this.controller});

  final CameraScanController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _CameraPreviewFull(controller: controller.camera!),
        // Scanning frame.
        Align(
          alignment: const Alignment(0, -0.18),
          child: SizedBox(
            width: 250.w,
            height: 320.h,
            child: CustomPaint(painter: _ScanCornersPainter()),
          ),
        ),
        // Torch toggle (top-right).
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Obx(
                () => _ControlButton(
                  icon: controller.torchOn.value
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  onTap: controller.toggleTorch,
                  rounded: true,
                  active: controller.torchOn.value,
                ),
              ),
            ),
          ),
        ),
        // Hints + capture controls (bottom).
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppStrings.scanReceiptHint.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppStrings.scanReceiptSubhint.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _ControlButton(
                        icon: Icons.close_rounded,
                        onTap: controller.close,
                      ),
                      _ShutterButton(controller: controller),
                      _ControlButton(
                        icon: Icons.photo_library_rounded,
                        onTap: controller.close,
                        rounded: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-bleed camera preview that fills the screen (center-cropped).
class _CameraPreviewFull extends StatelessWidget {
  const _CameraPreviewFull({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final Size preview = controller.value.previewSize ?? const Size(9, 16);
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        // previewSize is in landscape orientation, so swap width/height.
        width: preview.height,
        height: preview.width,
        child: CameraPreview(controller),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.controller});

  final CameraScanController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.capture,
      child: Container(
        width: 74.w,
        height: 74.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4.w),
        ),
        child: Center(
          child: Obx(
            () => Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(
                  alpha: controller.isCapturing.value ? 0.5 : 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.rounded = false,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool rounded;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: active ? _scanGreen : _controlBg,
          shape: rounded ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: rounded ? BorderRadius.circular(14.r) : null,
        ),
        child: Icon(
          icon,
          color: active ? Colors.black : Colors.white,
          size: 24.w,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.no_photography_rounded,
              color: Colors.white70, size: 56.w),
          SizedBox(height: 16.h),
          Text(
            AppStrings.cameraError.tr,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
          SizedBox(height: 24.h),
          TextButton(
            onPressed: onClose,
            child: Text(
              AppStrings.cancel.tr,
              style: const TextStyle(color: _scanGreen),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints four rounded green brackets at the corners of the scan frame.
class _ScanCornersPainter extends CustomPainter {
  static const double _len = 30;
  static const double _radius = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = _scanGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double w = size.width;
    final double h = size.height;

    // Top-left.
    canvas.drawPath(
      Path()
        ..moveTo(0, _len)
        ..lineTo(0, _radius)
        ..arcToPoint(const Offset(_radius, 0),
            radius: const Radius.circular(_radius))
        ..lineTo(_len, 0),
      paint,
    );
    // Top-right.
    canvas.drawPath(
      Path()
        ..moveTo(w - _len, 0)
        ..lineTo(w - _radius, 0)
        ..arcToPoint(Offset(w, _radius),
            radius: const Radius.circular(_radius))
        ..lineTo(w, _len),
      paint,
    );
    // Bottom-right.
    canvas.drawPath(
      Path()
        ..moveTo(w, h - _len)
        ..lineTo(w, h - _radius)
        ..arcToPoint(Offset(w - _radius, h),
            radius: const Radius.circular(_radius))
        ..lineTo(w - _len, h),
      paint,
    );
    // Bottom-left.
    canvas.drawPath(
      Path()
        ..moveTo(_len, h)
        ..lineTo(_radius, h)
        ..arcToPoint(Offset(0, h - _radius),
            radius: const Radius.circular(_radius))
        ..lineTo(0, h - _len),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ScanCornersPainter oldDelegate) => false;
}
