import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/models/expense_model.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Advanced filter sheet for the History tab: vehicle, date range, expense
/// categories (multi-select) and sort order. Edits a local draft and commits
/// it to [HistoryController] on "Apply".
class HistoryFilterSheet extends StatefulWidget {
  const HistoryFilterSheet({super.key});

  @override
  State<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<HistoryFilterSheet> {
  final HistoryController _controller = Get.find<HistoryController>();

  late Set<ExpenseCategory> _categories;
  late DateTime _start;
  late DateTime _end;
  late HistorySort _sort;
  late String _vehicle;

  /// Whether the date window should be used as a filter. The fields always show
  /// a sensible default (current month), but we only filter by date once the
  /// user actually picks one — so toggling a category alone doesn't silently
  /// hide other months.
  late bool _dateActive;

  static const List<ExpenseCategory> _allCategories = <ExpenseCategory>[
    ExpenseCategory.fuel,
    ExpenseCategory.supplies,
    ExpenseCategory.repair,
    ExpenseCategory.admin,
    ExpenseCategory.other,
  ];

  @override
  void initState() {
    super.initState();
    _categories = _controller.categories.toSet();
    final DateTimeRange? range = _controller.dateRange.value;
    final DateTime now = DateTime.now();
    _start = range?.start ?? DateTime(now.year, now.month);
    _end = range?.end ?? DateTime(now.year, now.month + 1, 0);
    _dateActive = range != null;
    _sort = _controller.sort.value;
    _vehicle = _allVehiclesLabel;
  }

  String get _allVehiclesLabel => AppStrings.histFilterAllVehicles.tr;

  List<String> get _vehicleOptions {
    final String? name = StorageService.vehicle?.name;
    return <String>[
      _allVehiclesLabel,
      if (name != null && name.isNotEmpty) name,
    ];
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime initial = isStart ? _start : _end;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      _dateActive = true;
      if (isStart) {
        _start = picked;
        if (_end.isBefore(_start)) _end = _start;
      } else {
        _end = picked;
        if (_start.isAfter(_end)) _start = _end;
      }
    });
  }

  void _toggleCategory(ExpenseCategory category) {
    setState(() {
      if (!_categories.add(category)) _categories.remove(category);
    });
  }

  void _reset() {
    final DateTime now = DateTime.now();
    setState(() {
      _categories = <ExpenseCategory>{};
      _start = DateTime(now.year, now.month);
      _end = DateTime(now.year, now.month + 1, 0);
      _dateActive = false;
      _sort = HistorySort.newest;
      _vehicle = _allVehiclesLabel;
    });
  }

  void _apply() {
    _controller.applyFilters(
      categories: _categories,
      dateRange: _dateActive ? DateTimeRange(start: _start, end: _end) : null,
      sort: _sort,
    );
    Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: <Widget>[
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Text(
                      AppStrings.histFilterTitle.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.close_rounded,
                        size: 24.w, color: AppColors.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _Label(
                icon: Icons.two_wheeler_rounded,
                text: AppStrings.histFilterVehicle.tr,
              ),
              SizedBox(height: 8.h),
              _VehicleDropdown(
                value: _vehicle,
                options: _vehicleOptions,
                onChanged: (String v) => setState(() => _vehicle = v),
              ),
              SizedBox(height: 18.h),
              _Label(
                icon: Icons.calendar_today_rounded,
                text: AppStrings.histFilterDateRange.tr,
              ),
              SizedBox(height: 8.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _DateField(
                      date: _start,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text("—", style: AppTextStyles.body),
                  ),
                  Expanded(
                    child: _DateField(
                      date: _end,
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _Label(
                icon: Icons.sell_rounded,
                text: AppStrings.histFilterExpenseType.tr,
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: <Widget>[
                  for (final ExpenseCategory c in _allCategories)
                    _ToggleChip(
                      label: c.labelKey.tr,
                      selected: _categories.contains(c),
                      onTap: () => _toggleCategory(c),
                    ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(AppStrings.histFilterTypeHint.tr,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
              SizedBox(height: 18.h),
              _Label(
                icon: Icons.swap_vert_rounded,
                text: AppStrings.histFilterSort.tr,
              ),
              SizedBox(height: 10.h),
              Row(
                children: <Widget>[
                  _SortChip(
                    label: AppStrings.histSortNewest.tr,
                    selected: _sort == HistorySort.newest,
                    onTap: () => setState(() => _sort = HistorySort.newest),
                  ),
                  SizedBox(width: 8.w),
                  _SortChip(
                    label: AppStrings.histSortOldest.tr,
                    selected: _sort == HistorySort.oldest,
                    onTap: () => setState(() => _sort = HistorySort.oldest),
                  ),
                  SizedBox(width: 8.w),
                  _SortChip(
                    label: AppStrings.histSortHighest.tr,
                    selected: _sort == HistorySort.highest,
                    onTap: () => setState(() => _sort = HistorySort.highest),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                children: <Widget>[
                  Expanded(child: _ResetButton(onTap: _reset)),
                  SizedBox(width: 12.w),
                  Expanded(flex: 2, child: _ApplyButton(onTap: _apply)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16.w, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _VehicleDropdown extends StatelessWidget {
  const _VehicleDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          style: AppTextStyles.body,
          items: <DropdownMenuItem<String>>[
            for (final String o in options)
              DropdownMenuItem<String>(value: o, child: Text(o)),
          ],
          onChanged: (String? v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String label = "${date.day.toString().padLeft(2, "0")}/"
        "${date.month.toString().padLeft(2, "0")}/${date.year}";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body),
            ),
            Icon(Icons.calendar_today_rounded,
                size: 16.w, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (selected) ...<Widget>[
              SizedBox(width: 6.w),
              Icon(Icons.check_circle_rounded,
                  size: 16.w, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.background,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          AppStrings.histReset.tr,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(AppStrings.histApply.tr, style: AppTextStyles.button),
      ),
    );
  }
}
