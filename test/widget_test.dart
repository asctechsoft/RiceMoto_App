// Smoke test for RiceMoto.
//
// The full app boots through dsp_base's commRunApp() which needs platform
// channels (prefs, device info), so it can't be pumped directly in a unit
// test. We assert a lightweight widget instead; expand with mocked bindings
// when integration coverage is needed.

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_test/flutter_test.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";

void main() {
  testWidgets("PrimaryButton renders its label", (WidgetTester tester) async {
    var tapped = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: "Continue",
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Continue"), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton));
    expect(tapped, isTrue);
  });
}
