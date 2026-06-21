import "package:ricemoto/models/user_model.dart";
import "package:ricemoto/services/storage_service.dart";

/// Handles authentication concerns. Currently a local stub — swap the
/// body of [register] for a real API/Firebase call when the backend is ready.
class AuthRepository {
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Simulate a network round-trip.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final user = UserModel(fullName: fullName, email: email, phone: phone);
    await StorageService.setLoggedIn(true);
    return user;
  }
}
