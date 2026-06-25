import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/models/expense_model.dart";

/// Ordering options offered by the filter sheet.
enum HistorySort { newest, oldest, highest }

/// Backs the History tab, its search screen, and its filter sheet.
///
/// Holds the expense list (currently seeded with sample data — wire this up to
/// a repository once the backend exists) plus the active filter state: a free
/// text [query], a set of [categories] (empty == all), an optional [dateRange],
/// and a [sort] order. [groups] applies all of them and returns the entries
/// grouped by month with per-month totals computed from the entries.
class HistoryController extends GetxController {
  /// Active categories. Empty means "all". The quick chips set exactly one (or
  /// clear); the filter sheet can toggle several.
  final RxSet<ExpenseCategory> categories = <ExpenseCategory>{}.obs;

  /// Free-text search over the expense title. Empty means no text filter.
  final RxString query = "".obs;

  /// Inclusive date window, or null for no date filter.
  final Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();

  final Rx<HistorySort> sort = HistorySort.newest.obs;

  /// Recently used search terms, most-recent first.
  final RxList<String> recentSearches = <String>[
    "Petrol Station",
    "Oil Change",
    "Wave Alpha",
    "Parking",
    "RON 95",
    "Tire Repair",
    "Bike Wash",
  ].obs;

  late final List<ExpenseModel> _all = _seed();

  // --- Quick category chips -------------------------------------------------

  /// Whether the quick chip for [category] (null == "All") is the active one.
  bool isSelected(ExpenseCategory? category) => category == null
      ? categories.isEmpty
      : categories.length == 1 && categories.contains(category);

  /// Quick chip tap: `null` clears to "All", otherwise selects just [category].
  void setFilter(ExpenseCategory? category) {
    if (category == null) {
      categories.clear();
    } else {
      categories
        ..clear()
        ..add(category);
    }
  }

  // --- Filter sheet ---------------------------------------------------------

  void applyFilters({
    required Set<ExpenseCategory> categories,
    required DateTimeRange? dateRange,
    required HistorySort sort,
  }) {
    this.categories.assignAll(categories);
    this.dateRange.value = dateRange;
    this.sort.value = sort;
  }

  void resetFilters() {
    categories.clear();
    dateRange.value = null;
    sort.value = HistorySort.newest;
  }

  // --- Search ---------------------------------------------------------------

  void setQuery(String value) => query.value = value;

  /// Records [term] as a recent search (deduped, most-recent first, capped).
  void addRecentSearch(String term) {
    final String trimmed = term.trim();
    if (trimmed.isEmpty) return;
    recentSearches
      ..removeWhere((String s) => s.toLowerCase() == trimmed.toLowerCase())
      ..insert(0, trimmed);
    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }
  }

  void clearRecentSearches() => recentSearches.clear();

  // --- Derived data ---------------------------------------------------------

  /// Entries matching every active filter, grouped by calendar month. Months
  /// are ordered per [sort]; entries within a month follow the same order.
  List<MonthGroup> get groups {
    final String q = query.value.trim().toLowerCase();
    final Set<ExpenseCategory> cats = categories.toSet();
    final DateTimeRange? range = dateRange.value;
    final HistorySort order = sort.value;

    Iterable<ExpenseModel> items = _all;
    if (q.isNotEmpty) {
      items = items
          .where((ExpenseModel e) => e.title.toLowerCase().contains(q));
    }
    if (cats.isNotEmpty) {
      items = items.where((ExpenseModel e) => cats.contains(e.category));
    }
    if (range != null) {
      final DateTime start =
          DateTime(range.start.year, range.start.month, range.start.day);
      final DateTime end = DateTime(
          range.end.year, range.end.month, range.end.day, 23, 59, 59);
      items = items.where((ExpenseModel e) =>
          !e.dateTime.isBefore(start) && !e.dateTime.isAfter(end));
    }

    final Map<String, MonthGroup> byMonth = <String, MonthGroup>{};
    for (final ExpenseModel e in items) {
      final String key = "${e.dateTime.year}-${e.dateTime.month}";
      (byMonth[key] ??=
              MonthGroup(year: e.dateTime.year, month: e.dateTime.month))
          .entries
          .add(e);
    }

    final List<MonthGroup> groups = byMonth.values.toList();
    final bool ascending = order == HistorySort.oldest;
    groups.sort((MonthGroup a, MonthGroup b) {
      final int c = a.year != b.year
          ? a.year.compareTo(b.year)
          : a.month.compareTo(b.month);
      return ascending ? c : -c;
    });
    for (final MonthGroup g in groups) {
      g.entries.sort((ExpenseModel a, ExpenseModel b) {
        switch (order) {
          case HistorySort.newest:
            return b.dateTime.compareTo(a.dateTime);
          case HistorySort.oldest:
            return a.dateTime.compareTo(b.dateTime);
          case HistorySort.highest:
            final int c = b.amount.compareTo(a.amount);
            return c != 0 ? c : b.dateTime.compareTo(a.dateTime);
        }
      });
    }
    return groups;
  }

  /// Sample expenses. The "today" entry is dated relative to [DateTime.now] so
  /// the row correctly shows "Hôm nay"; the rest are fixed historical dates.
  static List<ExpenseModel> _seed() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day, 8, 15);
    return <ExpenseModel>[
      ExpenseModel(
        title: "Petrol Station",
        category: ExpenseCategory.fuel,
        icon: Icons.local_gas_station_rounded,
        amount: 350000,
        dateTime: today,
      ),
      ExpenseModel(
        title: "Oil Change",
        category: ExpenseCategory.repair,
        icon: Icons.opacity_rounded,
        amount: 150000,
        dateTime: DateTime(2026, 6, 10, 10, 30),
      ),
      ExpenseModel(
        title: "Tire Repair",
        category: ExpenseCategory.repair,
        icon: Icons.tire_repair,
        amount: 200000,
        dateTime: DateTime(2026, 6, 8, 14, 45),
      ),
      ExpenseModel(
        title: "Bike Wash",
        category: ExpenseCategory.admin,
        icon: Icons.local_car_wash_rounded,
        amount: 50000,
        dateTime: DateTime(2026, 6, 5, 9, 20),
      ),
      ExpenseModel(
        title: "Parking",
        category: ExpenseCategory.admin,
        icon: Icons.local_parking_rounded,
        amount: 30000,
        dateTime: DateTime(2026, 6, 3, 12, 10),
      ),
      ExpenseModel(
        title: "Petrol Station",
        category: ExpenseCategory.fuel,
        icon: Icons.local_gas_station_rounded,
        amount: 320000,
        dateTime: DateTime(2026, 5, 28, 8, 40),
      ),
      ExpenseModel(
        title: "Spare Parts",
        category: ExpenseCategory.supplies,
        icon: Icons.build_rounded,
        amount: 450000,
        dateTime: DateTime(2026, 5, 20, 15, 0),
      ),
      ExpenseModel(
        title: "Engine Oil",
        category: ExpenseCategory.supplies,
        icon: Icons.water_drop_rounded,
        amount: 180000,
        dateTime: DateTime(2026, 5, 14, 11, 15),
      ),
    ];
  }
}

/// One month's worth of expenses, used to render a section in the list.
class MonthGroup {
  MonthGroup({required this.year, required this.month});

  final int year;
  final int month;
  final List<ExpenseModel> entries = <ExpenseModel>[];

  int get total =>
      entries.fold(0, (int sum, ExpenseModel e) => sum + e.amount);
}
