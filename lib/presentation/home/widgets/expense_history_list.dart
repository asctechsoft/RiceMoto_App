import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/models/expense_model.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Renders expense [MonthGroup]s as the month-sectioned card list shared by the
/// History tab and the History search screen.
class ExpenseHistoryList extends StatelessWidget {
  const ExpenseHistoryList({required this.groups, this.padding, super.key});

  final List<MonthGroup> groups;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
      itemCount: groups.length,
      itemBuilder: (_, int i) => _MonthSection(group: groups[i]),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.group});

  final MonthGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _MonthHeader(group: group),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < group.entries.length; i++) ...<Widget>[
                  if (i > 0)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const Divider(height: 1, color: AppColors.divider),
                    ),
                  _ExpenseRow(entry: group.entries[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.group});

  final MonthGroup group;

  @override
  Widget build(BuildContext context) {
    final String label = AppStrings.histSectionMonth.trParams(<String, String>{
      "month": group.month.toString(),
      "year": group.year.toString(),
    });
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            formatMoney(group.total),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.entry});

  final ExpenseModel entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(entry.icon, size: 22.w, color: AppColors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  formatWhen(entry.dateTime),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              formatMoney(entry.amount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.chevron_right_rounded,
              size: 20.w, color: AppColors.textHint),
        ],
      ),
    );
  }
}

/// Formats an amount in VND, e.g. `350000` -> "350.000đ".
String formatMoney(int amount) =>
    "${formatThousands(amount)}${AppStrings.currencyUnit.tr}";

/// Subtitle line: "Hôm nay · 08:15" for today, otherwise "10/6/2026 · 10:30".
String formatWhen(DateTime dt) {
  final DateTime now = DateTime.now();
  final bool isToday =
      dt.year == now.year && dt.month == now.month && dt.day == now.day;
  final String date =
      isToday ? AppStrings.histToday.tr : "${dt.day}/${dt.month}/${dt.year}";
  final String time =
      "${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}";
  return "$date · $time";
}

/// Formats an integer with "." thousand separators (e.g. 350000 -> "350.000").
String formatThousands(int value) {
  final String digits = value.toString();
  final StringBuffer out = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(".");
    out.write(digits[i]);
  }
  return out.toString();
}
