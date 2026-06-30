import "package:firebase_auth/firebase_auth.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/models/user_model.dart";
import "package:ricemoto/services/api_client.dart";
import "package:ricemoto/services/storage_service.dart";

/// Authentication backed by Firebase Auth + the RideMoto backend.
///
/// Firebase handles the credential check (phone OTP / Google); the resulting
/// Firebase ID token is then exchanged at `POST /v1/auth/firebase` for the
/// backend's own JWT pair, which is persisted for subsequent API calls.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth, ApiClient? api})
      : _auth = auth ?? FirebaseAuth.instance,
        _api = api ?? ApiClient.instance;

  final FirebaseAuth _auth;
  final ApiClient _api;

  /// Whether the most recent sign-in created a brand-new backend account.
  /// Drives [postAuthRoute] (new users go through vehicle setup first).
  bool _isNewUser = false;

  User? get currentUser => _auth.currentUser;

  /// Where to land after a successful sign-in: new accounts go to the one-time
  /// "add your motorcycle" step, returning users straight to Home.
  String get postAuthRoute =>
      _isNewUser ? AppRoutes.vehicleSetup : AppRoutes.home;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException e) onError,
    void Function(UserModel user)? onAutoVerified,
    int? resendToken,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final UserCredential result =
              await _auth.signInWithCredential(credential);
          onAutoVerified?.call(await _exchange(result.user));
        } catch (e) {
          onError(
            e is FirebaseAuthException
                ? e
                : FirebaseAuthException(
                    code: "backend-error",
                    message: e is ApiException ? e.message : e.toString(),
                  ),
          );
        }
      },
      verificationFailed: onError,
      codeSent: (String verificationId, int? token) =>
          onCodeSent(verificationId, token),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserModel> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final UserCredential result = await _auth.signInWithCredential(credential);
    return _exchange(result.user);
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleAuthProvider provider = GoogleAuthProvider()
      ..addScope("email")
      ..setCustomParameters(<String, String>{"prompt": "select_account"});
    final UserCredential result = await _auth.signInWithProvider(provider);
    return _exchange(result.user);
  }

  Future<void> signOut() async {
    try {
      await _api.post("/auth/logout");
    } catch (_) {
      // Best-effort server logout; clear the local session regardless.
    }
    await StorageService.clearTokens();
    await StorageService.setLoggedIn(false);
    await _auth.signOut();
  }

  /// Trades the Firebase ID token for backend JWTs and persists the session.
  Future<UserModel> _exchange(User? user) async {
    final String? idToken = await user?.getIdToken();
    if (idToken == null) {
      throw ApiException("Không lấy được phiên đăng nhập Firebase");
    }

    final dynamic data = await _api.post(
      "/auth/firebase",
      data: <String, dynamic>{"idToken": idToken},
    );
    final Map<String, dynamic> body = data as Map<String, dynamic>;

    await StorageService.setTokens(
      token: body["token"] as String,
      refreshToken: body["refreshToken"] as String,
    );
    await StorageService.setLoggedIn(true);
    _isNewUser = body["isNewUser"] == true;

    final Map<String, dynamic>? u = body["user"] as Map<String, dynamic>?;
    return UserModel(
      fullName: (u?["name"] ?? user?.displayName ?? "") as String,
      email: (u?["email"] ?? user?.email ?? "") as String,
      phone: (u?["phone"] ?? user?.phoneNumber ?? "") as String,
    );
  }
}
