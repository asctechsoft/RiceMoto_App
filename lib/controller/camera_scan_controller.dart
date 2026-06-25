import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/models/fuel_receipt_data.dart";
import "package:ricemoto/presentation/scan/receipt_review_sheet.dart";
import "package:ricemoto/values/app_strings.dart";

/// Drives the live camera preview on the receipt-scanning screen.
class CameraScanController extends GetxController {
  CameraController? camera;

  final RxBool isReady = false.obs;
  final RxBool hasError = false.obs;
  final RxBool torchOn = false.obs;
  final RxBool isCapturing = false.obs;

  /// True while the AI-processing screen is shown (after capture, before the
  /// review sheet). The captured photo path drives its preview.
  final RxBool isProcessing = false.obs;
  final RxString processingImagePath = "".obs;

  /// How long the AI-processing screen stays up before the result sheet.
  /// TODO: drive this off the real OCR/AI call instead of a fixed delay.
  static const Duration _processingDuration = Duration(milliseconds: 2500);

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        hasError.value = true;
        return;
      }
      final CameraDescription back = cameras.firstWhere(
        (CameraDescription c) =>
            c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final CameraController controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
      );
      camera = controller;
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      isReady.value = true;
    } on CameraException {
      hasError.value = true;
    }
  }

  Future<void> toggleTorch() async {
    final CameraController? c = camera;
    if (c == null || !isReady.value) return;
    torchOn.toggle();
    await c.setFlashMode(torchOn.value ? FlashMode.torch : FlashMode.off);
  }

  Future<void> capture() async {
    final CameraController? c = camera;
    if (c == null || !isReady.value || isCapturing.value) return;
    isCapturing.value = true;
    try {
      final XFile shot = await c.takePicture();
      await c.pausePreview();
      await _runProcessing(shot.path);
    } on CameraException {
      hasError.value = true;
    } finally {
      isCapturing.value = false;
    }
  }

  /// Shows the AI-processing screen, simulates the read, then opens the review.
  Future<void> _runProcessing(String imagePath) async {
    processingImagePath.value = imagePath;
    isProcessing.value = true;
    await Future<void>.delayed(_processingDuration);
    isProcessing.value = false;
    _showReview(imagePath);
  }

  void _showReview(String imagePath) {
    // TODO: replace the hardcoded demo data with real OCR/AI extraction.
    Get.bottomSheet<void>(
      ReceiptReviewSheet(
        data: FuelReceiptData.demo(imagePath: imagePath),
        onSave: _onReviewSaved,
        onRescan: _onReviewRescan,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _onReviewRescan() {
    Get.back<void>(); // close the review sheet
    camera?.resumePreview();
  }

  void _onReviewSaved(FuelReceiptData edited) {
    // TODO: persist the expense once an expense store/model exists.
    Get.back<void>(); // close the review sheet
    Get.back<void>(); // close the camera screen → back to home
    Get.snackbar(
      AppStrings.addReceiptTitle.tr,
      AppStrings.expenseSaved.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void close() => Get.back<void>();

  @override
  void onClose() {
    camera?.dispose();
    super.onClose();
  }
}
