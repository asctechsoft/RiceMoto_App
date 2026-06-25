/// A motorcycle the user tracks expenses for.
class VehicleModel {
  const VehicleModel({
    required this.name,
    required this.brand,
    this.currentKm = 0,
    this.plate = "",
  });

  final String name;
  final String brand;
  final int currentKm;
  final String plate;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "name": name,
    "brand": brand,
    "current_km": currentKm,
    "plate": plate,
  };

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    name: (json["name"] ?? "") as String,
    brand: (json["brand"] ?? "") as String,
    currentKm: (json["current_km"] ?? 0) as int,
    plate: (json["plate"] ?? "") as String,
  );
}
