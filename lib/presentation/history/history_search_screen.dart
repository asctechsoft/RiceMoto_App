import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Full-screen search over the expense history. Reuses [HistoryController]
/// (already alive behind the History tab) for the live-filtered results.
class HistorySearchScreen extends StatefulWidget {
  const HistorySearchScreen({super.key});

  @override
  State<HistorySearchScreen> createState() => _HistorySearchScreenState();
}

class _HistorySearchScreenState extends State<HistorySearchScreen> {
  final HistoryController _controller = Get.isRegistered<HistoryController>()
      ? Get.find<HistoryController>()
      : Get.put(HistoryController());
  late final TextEditingController _field =
      TextEditingController(text: _controller.query.value);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _cancel() {
    _controller.setQuery("");
    Get.back<void>();
  }

  void _submit(String term) {
    _controller
      ..setQuery(term)
      ..addRecentSearch(term);
  }

  void _useRecent(String term) {
    _field
      ..text = term
      ..selection = TextSelection.collapsed(offset: term.length);
    _submit(term);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _SearchBar(
              controller: _field,
              onChanged: _controller.setQuery,
              onSubmitted: _submit,
              onCancel: _cancel,
            ),
            Expanded(
              child: Obx(() {
                final bool hasQuery = _controller.query.value.trim().isNotEmpty;
                final List<MonthGroup> groups = _controller.groups;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (!hasQuery && _controller.recentSearches.isNotEmpty)
                      _RecentSearches(
                        terms: _controller.recentSearches,
                        onTap: _useRecent,
                        onClear: _controller.clearRecentSearches,
                      ),
                    Expanded(
                      child: groups.isEmpty
                          ? const _NoResults()
                          : ExpenseHistoryList(groups: groups),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onCancel,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search_rounded,
                      size: 20.w, color: AppColors.textHint),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      textInputAction: TextInputAction.search,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: AppStrings.histSearchHint.tr,
                        hintStyle: AppTextStyles.body
                            .copyWith(color: AppColors.textHint),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (_, TextEditingValue value, __) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged("");
                        },
                        child: Icon(Icons.cancel_rounded,
                            size: 18.w, color: AppColors.textHint),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onCancel,
            child: Text(
              AppStrings.cancel.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.terms,
    required this.onTap,
    required this.onClear,
  });

  final List<String> terms;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                AppStrings.histRecentSearches.tr,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClear,
                child: Text(
                  AppStrings.histClearAll.tr,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: <Widget>[
              for (final String term in terms)
                GestureDetector(
                  onTap: () => onTap(term),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(term, style: AppTextStyles.caption),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.search_off_rounded, size: 44.w, color: AppColors.textHint),
          SizedBox(height: 10.h),
          Text(
            AppStrings.histNoResults.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
