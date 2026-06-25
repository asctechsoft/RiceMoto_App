/// Fields extracted from a scanned fuel receipt.
///
/// Values are kept as display strings (with units) so they can be shown and
/// edited directly. Replace [FuelReceiptData.demo] with real OCR/AI output
/// once receipt parsing is implemented.
class FuelReceiptData {
  const FuelReceiptData({
    required this.stationName,
    required this.fuelType,
    required this.liters,
    required this.unitPrice,
    required this.totalAmount,
    required this.dateLabel,
    required this.timeLabel,
    this.imagePath,
  });

  final String stationName;
  final String fuelType;
  final String liters;
  final String unitPrice;
  final String totalAmount;
  final String dateLabel;
  final String timeLabel;
  final String? imagePath;

  /// Hardcoded placeholder matching the sample Petrolimex receipt.
  factory FuelReceiptData.demo({String? imagePath}) => FuelReceiptData(
    stationName: "Petrolimex Nguyễn Cư Trinh",
    fuelType: "RON 95-III",
    liters: "2.35 L",
    unitPrice: "24.850đ",
    totalAmount: "58.398đ",
    dateLabel: "10/06/2026",
    timeLabel: "09:15",
    imagePath: imagePath,
  );
}
