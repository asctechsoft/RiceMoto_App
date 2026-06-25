import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/models/expense_model.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/presentation/home/widgets/history_filter_sheet.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// History tab: the user's expenses grouped by month, with a category filter,
/// search, and an advanced filter sheet.
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve (and register if needed) the controller here rather than relying
    // on the route binding: the tab can be built before — or rebuilt after a
    // hot reload that re-ran — that binding, so guard against a missing entry.
    final HistoryController controller = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          const _Header(),
          const _FilterBar(),
          Expanded(
            child: Obx(() {
              final List<MonthGroup> groups = controller.groups;
              if (groups.isEmpty) return const _EmptyState();
              return ExpenseHistoryList(groups: groups);
            }),
          ),
        ],
      ),
    );
  }
}

class _Header extends GetView<HistoryController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 4.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Get.find<HomeController>().changeTab(0),
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              AppStrings.tabHistory.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.historySearch),
            icon:
                const Icon(Icons.search_rounded, color: AppColors.textPrimary),
          ),
          Obx(() {
            final bool active = controller.categories.isNotEmpty ||
                controller.dateRange.value != null ||
                controller.sort.value != HistorySort.newest;
            return _IconWithDot(
              icon: Icons.tune_rounded,
              showDot: active,
              onPressed: () => Get.bottomSheet(
                const HistoryFilterSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// An [IconButton] with a small dot badge (used to flag active filters).
class _IconWithDot extends StatelessWidget {
  const _IconWithDot({
    required this.icon,
    required this.showDot,
    required this.onPressed,
  });

  final IconData icon;
  final bool showDot;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: AppColors.textPrimary),
        ),
        if (showDot)
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterBar extends GetView<HistoryController> {
  const _FilterBar();

  static const List<_FilterOption> _options = <_FilterOption>[
    _FilterOption(AppStrings.histFilterAll, null),
    _FilterOption(AppStrings.histFilterFuel, ExpenseCategory.fuel),
    _FilterOption(AppStrings.histFilterSupplies, ExpenseCategory.supplies),
    _FilterOption(AppStrings.histFilterRepair, ExpenseCategory.repair),
    _FilterOption(AppStrings.histFilterAdmin, ExpenseCategory.admin),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _options.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, int i) {
          final _FilterOption option = _options[i];
          return Obx(
            () => _FilterChip(
              label: option.labelKey.tr,
              selected: controller.isSelected(option.category),
              onTap: () => controller.setFilter(option.category),
            ),
          );
        },
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption(this.labelKey, this.category);

  final String labelKey;
  final ExpenseCategory? category;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selected ? AppColors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.receipt_long_rounded,
              size: 44.w, color: AppColors.textHint),
          SizedBox(height: 10.h),
          Text(
            AppStrings.noDataTitle.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
