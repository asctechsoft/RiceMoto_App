/// A motorcycle the user tracks expenses for.
class VehicleModel {
  const VehicleModel({
    required this.name,
    required this.brand,
    this.currentKm = 0,
    this.plate = "",
    this.year = "",
    this.color = "",
    this.purchaseDate = "",
  });

  final String name;
  final String brand;
  final int currentKm;
  final String plate;

  /// Optional details surfaced on the vehicle-detail screen. Empty when the
  /// user hasn't provided them yet (the setup flow only collects the basics).
  final String year;
  final String color;
  final String purchaseDate;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "name": name,
    "brand": brand,
    "current_km": currentKm,
    "plate": plate,
    "year": year,
    "color": color,
    "purchase_date": purchaseDate,
  };

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    name: (json["name"] ?? "") as String,
    brand: (json["brand"] ?? "") as String,
    currentKm: (json["current_km"] ?? 0) as int,
    plate: (json["plate"] ?? "") as String,
    year: (json["year"] ?? "") as String,
    color: (json["color"] ?? "") as String,
    purchaseDate: (json["purchase_date"] ?? "") as String,
  );
}
