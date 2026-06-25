import "package:flutter/material.dart";
import "package:ricemoto/values/app_strings.dart";

/// High-level buckets used to filter the History list. The labels shown in the
/// filter chips live in `strings.xml` (see `AppStrings.histFilter*`).
enum ExpenseCategory { fuel, supplies, repair, admin, other }

/// Translation key for a category's chip label.
extension ExpenseCategoryLabel on ExpenseCategory {
  String get labelKey {
    switch (this) {
      case ExpenseCategory.fuel:
        return AppStrings.histFilterFuel;
      case ExpenseCategory.supplies:
        return AppStrings.histFilterSupplies;
      case ExpenseCategory.repair:
        return AppStrings.histFilterRepair;
      case ExpenseCategory.admin:
        return AppStrings.histFilterAdmin;
      case ExpenseCategory.other:
        return AppStrings.histFilterOther;
    }
  }
}

/// A single recorded expense rendered as one row in the History tab.
class ExpenseModel {
  const ExpenseModel({
    required this.title,
    required this.category,
    required this.icon,
    required this.amount,
    required this.dateTime,
  });

  /// Merchant / expense name, e.g. "Petrol Station".
  final String title;

  /// Bucket the entry belongs to (drives the category filter).
  final ExpenseCategory category;

  /// Leading-circle icon. Stored per entry because items in the same category
  /// can use different glyphs (e.g. "Oil Change" vs "Tire Repair").
  final IconData icon;

  /// Amount in VND đồng, e.g. `350000`.
  final int amount;

  /// When the expense was recorded.
  final DateTime dateTime;
}
