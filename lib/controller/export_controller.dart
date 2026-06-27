import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_strings.dart";

/// Quick date-range presets offered on the Export screen.
enum ExportRange { thisMonth, last3Months, last6Months, thisYear, all }

extension ExportRangeLabel on ExportRange {
  String get labelKey {
    switch (this) {
      case ExportRange.thisMonth:
        return AppStrings.expPresetThisMonth;
      case ExportRange.last3Months:
        return AppStrings.rptPreset3m;
      case ExportRange.last6Months:
        return AppStrings.rptPreset6m;
      case ExportRange.thisYear:
        return AppStrings.expPresetThisYear;
      case ExportRange.all:
        return AppStrings.expPresetAll;
    }
  }
}

/// File format for the export.
enum ExportFormat { pdf, excel, csv }

extension ExportFormatLabel on ExportFormat {
  String get labelKey {
    switch (this) {
      case ExportFormat.pdf:
        return AppStrings.expFormatPdf;
      case ExportFormat.excel:
        return AppStrings.expFormatExcel;
      case ExportFormat.csv:
        return AppStrings.expFormatCsv;
    }
  }
}

/// Backs the Export Data screen: date range (preset or manual), vehicle
/// selection, output format, and the export/share actions. Figures are local
/// stubs — wire the actions to a real exporter when the backend exists.
class ExportController extends GetxController {
  // --- Date range ------------------------------------------------------------

  /// Selected preset, or null when the user picked dates manually.
  final Rxn<ExportRange> preset = Rxn<ExportRange>(ExportRange.thisYear);

  late final Rx<DateTimeRange> dates = rangeFor(ExportRange.thisYear).obs;

  DateTimeRange rangeFor(ExportRange r) {
    final DateTime now = DateTime.now();
    final DateTime end = DateTime(now.year, now.month, now.day);
    switch (r) {
      case ExportRange.thisMonth:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: end);
      case ExportRange.last3Months:
        return DateTimeRange(start: DateTime(end.year, end.month - 3, end.day), end: end);
      case ExportRange.last6Months:
        return DateTimeRange(start: DateTime(end.year, end.month - 6, end.day), end: end);
      case ExportRange.thisYear:
        return DateTimeRange(start: DateTime(now.year, 1, 1), end: end);
      case ExportRange.all:
        return DateTimeRange(start: DateTime(2020, 1, 1), end: end);
    }
  }

  void applyPreset(ExportRange r) {
    preset.value = r;
    dates.value = rangeFor(r);
  }

  void setFrom(DateTime from) {
    if (from.isAfter(dates.value.end)) return;
    preset.value = null;
    dates.value = DateTimeRange(start: from, end: dates.value.end);
  }

  void setTo(DateTime to) {
    if (to.isBefore(dates.value.start)) return;
    preset.value = null;
    dates.value = DateTimeRange(start: dates.value.start, end: to);
  }

  // --- Vehicles --------------------------------------------------------------

  /// Sample vehicle list — replace with the user's real garage.
  final List<String> vehicles = const <String>["Wave Alpha", "Exciter 150"];

  final RxBool allVehicles = true.obs;
  final RxSet<String> selectedVehicles = <String>{}.obs;

  void selectAllVehicles() {
    allVehicles.value = true;
    selectedVehicles.clear();
  }

  void toggleVehicle(String name) {
    allVehicles.value = false;
    if (selectedVehicles.contains(name)) {
      selectedVehicles.remove(name);
    } else {
      selectedVehicles.add(name);
    }
    if (selectedVehicles.isEmpty) allVehicles.value = true;
  }

  bool isVehicleChecked(String name) =>
      !allVehicles.value && selectedVehicles.contains(name);

  // --- Format ----------------------------------------------------------------

  final Rx<ExportFormat> format = ExportFormat.excel.obs;

  void setFormat(ExportFormat value) => format.value = value;

  // --- Estimate (stub) -------------------------------------------------------

  int get estimateCount => 247;
  String get estimateSize => "8,2 MB";

  // --- Actions ---------------------------------------------------------------

  void exportData() => _comingSoon(AppStrings.expExport);

  void shareNow() => _comingSoon(AppStrings.expShare);

  void _comingSoon(String titleKey) => Get.snackbar(
        titleKey.tr,
        AppStrings.featureComingSoon.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
}
