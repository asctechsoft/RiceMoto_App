import "package:flutter_screenutil/flutter_screenutil.dart";

/// Spacing / radius scale. Values are in logical px against the
/// 360x800 design size used by dsp_base; call `.w` / `.h` / `.r`
/// at the use-site for responsive sizing.
class AppDimens {
  const AppDimens._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const double radius = 12;
  static const double radiusLarge = 20;

  static const double bottomBarHeight = 64;
  static const double scanButtonSize = 58;

  // Convenience responsive getters.
  static double get pagePadding => 20.w;
}
