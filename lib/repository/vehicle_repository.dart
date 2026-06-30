import "package:ricemoto/models/vehicle_model.dart";
import "package:ricemoto/services/api_client.dart";

/// Vehicle CRUD against the RideMoto backend (`/v1/vehicles`).
class VehicleRepository {
  VehicleRepository({ApiClient? api}) : _api = api ?? ApiClient.instance;

  final ApiClient _api;

  /// Creates a vehicle for the signed-in user and returns it with the
  /// server-assigned id merged back in.
  Future<VehicleModel> create(VehicleModel vehicle) async {
    final dynamic data = await _api.post(
      "/vehicles",
      data: <String, dynamic>{
        "name": vehicle.name,
        if (vehicle.brand.isNotEmpty) "brand": vehicle.brand,
        if (vehicle.plate.isNotEmpty) "licensePlate": vehicle.plate,
        "currentKm": vehicle.currentKm,
      },
    );
    final Map<String, dynamic> body = data as Map<String, dynamic>;
    return VehicleModel(
      name: (body["name"] ?? vehicle.name) as String,
      brand: (body["brand"] ?? vehicle.brand) as String,
      currentKm: (body["currentKm"] ?? vehicle.currentKm) as int,
      plate: (body["licensePlate"] ?? vehicle.plate) as String,
    );
  }

  /// All vehicles owned by / shared with the signed-in user.
  Future<List<VehicleModel>> findAll() async {
    final dynamic data = await _api.get("/vehicles");
    if (data is! List) return <VehicleModel>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> j) => VehicleModel(
              name: (j["name"] ?? "") as String,
              brand: (j["brand"] ?? "") as String,
              currentKm: (j["currentKm"] ?? 0) as int,
              plate: (j["licensePlate"] ?? "") as String,
            ))
        .toList();
  }
}
