import "package:flutter/material.dart";

/// Central color palette for RiceMoto.
///
/// Brand color is a deep "rice-field" green taken from the design.
class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF1F7A4D);
  static const Color primaryDark = Color(0xFF14592F);
  static const Color primaryLight = Color(0xFF3E9E6C);

  // Surfaces
  static const Color background = Color(0xFFF4F6F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9AA0A6);

  // Nav / states
  static const Color navInactive = Color(0xFF9AA0A6);
  static const Color divider = Color(0xFFE6E8EB);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF2E7D32);

  // Guest-mode banner (amber)
  static const Color guestBanner = Color(0xFFF5C84A);
  static const Color guestBannerText = Color(0xFF5A4500);

  // Report / chart palette
  static const Color chartFuel = Color(0xFF1B6E45); // Xăng — deep green
  static const Color chartRepair = Color(0xFFE0A23A); // Sửa chữa — amber
  static const Color chartSupplies = Color(0xFF4C90D9); // Vật tư — blue
  static const Color chartAdmin = Color(0xFF9AA0A6); // Hành chính — grey
  static const Color chartGrid = Color(0xFFEDEFF1);

  // Misc
  static const Color shadow = Color(0x1A000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color black = Color(0xFF000000);
}
