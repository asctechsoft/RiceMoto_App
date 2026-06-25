import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/models/expense_model.dart";
import "package:ricemoto/presentation/home/tabs/history_tab.dart";

void main() {
  setUp(() {
    Get.put<HomeController>(HomeController());
    Get.put<HistoryController>(HistoryController());
  });

  tearDown(Get.reset);

  Widget wrap() => ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (_, __) => const GetMaterialApp(
          home: Scaffold(body: HistoryTab()),
        ),
      );

  testWidgets("renders month sections and entries without overflow",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text("Petrol Station"), findsWidgets);
    expect(find.text("Spare Parts"), findsOneWidget);
  });

  testWidgets("category filter restricts the list", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    Get.find<HistoryController>().setFilter(ExpenseCategory.supplies);
    await tester.pumpAndSettle();

    expect(find.text("Spare Parts"), findsOneWidget);
    expect(find.text("Petrol Station"), findsNothing);
  });

  group("HistoryController filtering", () {
    List<ExpenseModel> flatten(HistoryController c) =>
        c.groups.expand((MonthGroup g) => g.entries).toList();

    test("search query matches titles case-insensitively", () {
      final HistoryController c = Get.find<HistoryController>();
      c.setQuery("spare");
      final List<ExpenseModel> items = flatten(c);
      expect(items, isNotEmpty);
      expect(items.every((ExpenseModel e) => e.title == "Spare Parts"), isTrue);
    });

    test("date range limits results to the window", () {
      final HistoryController c = Get.find<HistoryController>();
      c.applyFilters(
        categories: <ExpenseCategory>{},
        dateRange: DateTimeRange(
          start: DateTime(2026, 5),
          end: DateTime(2026, 5, 31),
        ),
        sort: HistorySort.newest,
      );
      final List<ExpenseModel> items = flatten(c);
      expect(items, isNotEmpty);
      expect(items.every((ExpenseModel e) => e.dateTime.month == 5), isTrue);
    });

    test("highest sort orders entries by amount within a month", () {
      final HistoryController c = Get.find<HistoryController>();
      c.applyFilters(
        categories: <ExpenseCategory>{},
        dateRange: DateTimeRange(
          start: DateTime(2026, 5),
          end: DateTime(2026, 5, 31),
        ),
        sort: HistorySort.highest,
      );
      final MonthGroup may = c.groups.single;
      expect(may.entries.first.amount, 450000);
    });

    test("recent searches dedupe and move to front", () {
      final HistoryController c = Get.find<HistoryController>();
      c.addRecentSearch("Oil Change");
      expect(c.recentSearches.first, "Oil Change");
      expect(
        c.recentSearches.where((String s) => s == "Oil Change").length,
        1,
      );
    });
  });
}
