import "package:ricemoto/models/user_model.dart";
import "package:ricemoto/services/storage_service.dart";

/// Handles authentication concerns. Currently a local stub — swap the bodies
/// for real API/Firebase calls when the backend is ready.
class AuthRepository {
  /// Create a new account with a phone number.
  Future<UserModel> registerWithPhone({required String phone}) async {
    // Simulate a network round-trip.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final user = UserModel(fullName: "", email: "", phone: phone);
    await StorageService.setLoggedIn(true);
    return user;
  }

  /// Sign in an existing account with a phone number.
  Future<UserModel> loginWithPhone({required String phone}) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final user = UserModel(fullName: "", email: "", phone: phone);
    await StorageService.setLoggedIn(true);
    return user;
  }

  /// Sign in / sign up with Google.
  Future<UserModel> continueWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final user = const UserModel(fullName: "", email: "");
    await StorageService.setLoggedIn(true);
    return user;
  }
}
