import "dart:io" show Platform;

import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

/// Backend (RideMoto NestJS API) connection settings.
///
/// Values are read from `app.env` in the project root (gitignored).
/// Copy `app.env.example` → `app.env` and set [API_HOST] to your PC's LAN IP.
///
/// When [API_HOST] is absent the host falls back per-platform:
///   * Android emulator → 10.0.2.2 (host loopback alias)
///   * iOS Simulator / desktop / web → localhost
class ApiConfig {
  const ApiConfig._();

  static const int _defaultPort = 3000;
  static const String _defaultPrefix = "v1";

  static String get _host {
    final String? envHost = dotenv.maybeGet("API_HOST");
    if (envHost != null && envHost.isNotEmpty) return envHost;
    if (kIsWeb) return "localhost";
    if (Platform.isAndroid) return "10.0.2.2";
    return "localhost";
  }

  static int get _port {
    final String? raw = dotenv.maybeGet("API_PORT");
    return int.tryParse(raw ?? "") ?? _defaultPort;
  }

  static String get baseUrl => "http://$_host:$_port/$_defaultPrefix";
}
