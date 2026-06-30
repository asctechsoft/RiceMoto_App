import "dart:convert";

import "package:dsp_base/convenience_imports.dart";
import "package:ricemoto/models/vehicle_model.dart";

/// Thin wrapper around dsp_base [PrefAssist] for app-specific keys.
class StorageService {
  const StorageService._();

  static const String _kOnboardingSeen = "ricemoto_onboarding_seen";
  static const String _kLoggedIn = "ricemoto_logged_in";
  static const String _kVehicle = "ricemoto_vehicle";
  static const String _kToken = "ricemoto_token";
  static const String _kRefreshToken = "ricemoto_refresh_token";

  static bool get onboardingSeen => PrefAssist.getBoolean(_kOnboardingSeen);

  static Future<void> setOnboardingSeen(bool value) =>
      PrefAssist.setBoolean(_kOnboardingSeen, value);

  static bool get isLoggedIn => PrefAssist.getBoolean(_kLoggedIn);

  static Future<void> setLoggedIn(bool value) =>
      PrefAssist.setBoolean(_kLoggedIn, value);

  /// The locally-stored vehicle, or null if none has been set up yet.
  static VehicleModel? get vehicle {
    final String raw = PrefAssist.getString(_kVehicle);
    if (raw.isEmpty) return null;
    return VehicleModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static bool get hasVehicle => PrefAssist.getString(_kVehicle).isNotEmpty;

  static Future<void> setVehicle(VehicleModel value) =>
      PrefAssist.setString(_kVehicle, jsonEncode(value.toJson()));

  // --- Backend session (JWT) -------------------------------------------------

  /// The backend access token (app JWT), empty when signed out.
  static String get token => PrefAssist.getString(_kToken);

  static String get refreshToken => PrefAssist.getString(_kRefreshToken);

  static bool get hasToken => token.isNotEmpty;

  static Future<void> setTokens({
    required String token,
    required String refreshToken,
  }) async {
    await PrefAssist.setString(_kToken, token);
    await PrefAssist.setString(_kRefreshToken, refreshToken);
  }

  static Future<void> clearTokens() async {
    await PrefAssist.setString(_kToken, "");
    await PrefAssist.setString(_kRefreshToken, "");
  }
}
