import "dart:convert";

import "package:dsp_base/convenience_imports.dart";
import "package:ricemoto/models/vehicle_model.dart";

/// Thin wrapper around dsp_base [PrefAssist] for app-specific keys.
class StorageService {
  const StorageService._();

  static const String _kOnboardingSeen = "ricemoto_onboarding_seen";
  static const String _kLoggedIn = "ricemoto_logged_in";
  static const String _kVehicle = "ricemoto_vehicle";

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
}
