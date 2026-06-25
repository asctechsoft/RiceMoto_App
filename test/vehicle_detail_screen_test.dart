import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
import "package:ricemoto/models/vehicle_model.dart";
import "package:ricemoto/presentation/vehicle/vehicle_detail_screen.dart";

void main() {
  testWidgets("VehicleDetailScreen builds without overflow at 360dp",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    const VehicleModel vehicle = VehicleModel(
      name: "Wave Alpha",
      brand: "Honda",
      currentKm: 12450,
      plate: "59A1-123.45",
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (_, __) => GetMaterialApp(
          home: Builder(
            builder: (BuildContext context) => ElevatedButton(
              onPressed: () => Get.to<void>(
                () => const VehicleDetailScreen(),
                arguments: vehicle,
              ),
              child: const Text("go"),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("go"));
    await tester.pumpAndSettle();

    expect(find.text("Wave Alpha"), findsWidgets);
  });
}
