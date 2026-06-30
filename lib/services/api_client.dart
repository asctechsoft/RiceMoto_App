import "package:dio/dio.dart";
import "package:get/get.dart" hide Response;
import "package:ricemoto/configs/api_config.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_strings.dart";

/// A failed API call, carrying a user-facing [message] (already localized) and
/// the HTTP [statusCode] when one is available.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Thin Dio wrapper around the RideMoto backend.
///
/// Responsibilities:
///   * Prefix every request with [ApiConfig.baseUrl].
///   * Attach the stored `Bearer` token.
///   * Unwrap the backend's `{ data: ... }` envelope.
///   * Transparently refresh the JWT once on a 401 and retry.
///   * Translate transport/server failures into [ApiException].
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        contentType: "application/json",
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final String token = StorageService.token;
          if (token.isNotEmpty && !options.headers.containsKey("Authorization")) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
        onError: _onError,
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  bool _isRefreshing = false;

  // --- Verb helpers (return the unwrapped `data` payload) --------------------

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => _dio.post<dynamic>(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put<dynamic>(path, data: data));

  Future<dynamic> delete(String path) =>
      _send(() => _dio.delete<dynamic>(path));

  Future<dynamic> _send(Future<Response<dynamic>> Function() call) async {
    try {
      final Response<dynamic> res = await call();
      final dynamic body = res.data;
      if (body is Map<String, dynamic> && body.containsKey("data")) {
        return body["data"];
      }
      return body;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // --- 401 refresh-and-retry -------------------------------------------------

  Future<void> _onError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final bool isAuthCall = e.requestOptions.path.contains("/auth/");
    final bool unauthorized = e.response?.statusCode == 401;

    if (unauthorized && !isAuthCall && StorageService.refreshToken.isNotEmpty) {
      final bool refreshed = await _refresh();
      if (refreshed) {
        try {
          final RequestOptions opts = e.requestOptions
            ..headers["Authorization"] = "Bearer ${StorageService.token}";
          final Response<dynamic> retry = await _dio.fetch<dynamic>(opts);
          return handler.resolve(retry);
        } catch (_) {
          // fall through to surface the original error
        }
      }
    }
    handler.next(e);
  }

  Future<bool> _refresh() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    try {
      final String rt = StorageService.refreshToken;
      if (rt.isEmpty) return false;
      // Bare Dio so this request skips the interceptors (avoids recursion).
      final Response<dynamic> res =
          await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post<dynamic>(
        "/auth/refresh",
        data: <String, dynamic>{"refreshToken": rt},
      );
      final dynamic data = (res.data as Map<String, dynamic>?)?["data"];
      if (data is! Map<String, dynamic>) return false;
      await StorageService.setTokens(
        token: data["token"] as String,
        refreshToken: data["refreshToken"] as String,
      );
      return true;
    } catch (_) {
      await StorageService.clearTokens();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // --- Error translation -----------------------------------------------------

  ApiException _toApiException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(AppStrings.errTimeout.tr);
      case DioExceptionType.connectionError:
        return ApiException(AppStrings.errNoConnection.tr);
      default:
        break;
    }

    final int? code = e.response?.statusCode;
    if (code == 401) {
      return ApiException(AppStrings.errSession.tr, statusCode: 401);
    }

    final dynamic data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic message = data["message"];
      if (message is List && message.isNotEmpty) {
        return ApiException(message.first.toString(), statusCode: code);
      }
      if (message is String && message.isNotEmpty) {
        return ApiException(message, statusCode: code);
      }
    }
    return ApiException(AppStrings.errGeneric.tr, statusCode: code);
  }
}
