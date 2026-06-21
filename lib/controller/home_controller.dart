import "package:get/get.dart";

/// Manages the selected bottom-tab for the Home shell.
///
/// Tab order matches the bottom bar: Home(0), History(1), Reports(2),
/// Settings(3). The center "Scan" button is a standalone action and is
/// intentionally NOT part of this index.
class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;

  void onScanPressed() {
    Get.snackbar(
      "Scan",
      "Camera scanning is not wired up yet.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
