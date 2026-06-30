import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/settings_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Account tab (logged-in): profile summary, Premium upsell, preference rows
/// (notifications, backup, export, language, theme, terms) and the logout /
/// delete-account actions.
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          const _Header(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: <Widget>[
                _Profile(controller: controller),
                SizedBox(height: 18.h),
                if (controller.isLoggedIn)
                  _PremiumCard(controller: controller)
                else
                  _ProtectCard(controller: controller),
                SizedBox(height: 18.h),
                _SettingsCard(
                  controller: controller,
                  locked: !controller.isLoggedIn,
                ),
                if (controller.isLoggedIn) ...<Widget>[
                  SizedBox(height: 20.h),
                  _DangerActions(controller: controller),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: Text(
        AppStrings.tabAccount.tr,
        textAlign: TextAlign.center,
        style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile
// ---------------------------------------------------------------------------

class _Profile extends StatelessWidget {
  const _Profile({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final bool guest = !controller.isLoggedIn;
    final Color tint = guest ? AppColors.textHint : AppColors.primary;
    return Column(
      children: <Widget>[
        Container(
          width: 84.w,
          height: 84.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tint.withValues(alpha: 0.10),
            border: Border.all(color: AppColors.surface, width: 3),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3)),
            ],
          ),
          child: Icon(Icons.person_rounded, size: 46.w, color: tint),
        ),
        SizedBox(height: 12.h),
        if (guest)
          Text(
            AppStrings.setGuestTitle.tr,
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
          )
        else
          Obx(
            () => Text(
              controller.fullName.value,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        SizedBox(height: 3.h),
        if (guest)
          Text(
            AppStrings.setGuestSubtitle.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          )
        else
          Obx(
            () => Text(
              controller.phoneNumber.value,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
        if (!guest) ...<Widget>[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: controller.editProfile,
            child: Text(
              AppStrings.setEditProfile.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Premium upsell
// ---------------------------------------------------------------------------

class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.workspace_premium_rounded,
                size: 26.w, color: AppColors.guestBanner),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        AppStrings.setPremiumTitle.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.star_rounded,
                        size: 15.w, color: AppColors.guestBanner),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.setPremiumDesc.tr,
                  style: AppTextStyles.caption.copyWith(color: AppColors.white70),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: controller.upgradePremium,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                AppStrings.setPremiumCta.tr,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Guest: protect-your-data upsell
// ---------------------------------------------------------------------------

class _ProtectCard extends StatelessWidget {
  const _ProtectCard({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.divider),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.cloud_done_rounded, size: 42.w, color: AppColors.primary),
          SizedBox(height: 10.h),
          Text(
            AppStrings.setProtectTitle.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            AppStrings.setProtectDesc.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            label: AppStrings.createAccount.tr,
            onPressed: controller.goToRegister,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: controller.goToLogin,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                AppStrings.login.tr,
                style: AppTextStyles.button.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings list
// ---------------------------------------------------------------------------

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.controller, this.locked = false});

  final SettingsController controller;

  /// Guest mode: notifications / backup / export are gated behind an account.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: <Widget>[
          if (locked) ...<Widget>[
            _SettingRow(
              icon: Icons.notifications_none_rounded,
              label: AppStrings.setNotifications.tr,
              locked: true,
              onTap: controller.lockedTap,
            ),
            const _RowDivider(),
            _SettingRow(
              icon: Icons.sync_rounded,
              label: AppStrings.setBackup.tr,
              locked: true,
              onTap: controller.lockedTap,
            ),
            const _RowDivider(),
            _SettingRow(
              icon: Icons.ios_share_rounded,
              label: AppStrings.setExport.tr,
              locked: true,
              onTap: controller.lockedTap,
            ),
          ] else ...<Widget>[
            _SettingRow(
              icon: Icons.notifications_none_rounded,
              label: AppStrings.setNotifications.tr,
              trailing: Obx(
                () => Switch.adaptive(
                  value: controller.notifications.value,
                  onChanged: controller.toggleNotifications,
                  activeTrackColor: AppColors.primary,
                ),
              ),
            ),
            const _RowDivider(),
            Obx(
              () => _SettingRow(
                icon: Icons.sync_rounded,
                label: AppStrings.setBackup.tr,
                subtitle: controller.lastSyncKey.value.tr,
                showChevron: true,
                onTap: controller.backupSync,
              ),
            ),
            const _RowDivider(),
            _SettingRow(
              icon: Icons.ios_share_rounded,
              label: AppStrings.setExport.tr,
              showChevron: true,
              onTap: controller.exportData,
            ),
          ],
          const _RowDivider(),
          Obx(
            () => _SettingRow(
              icon: Icons.language_rounded,
              label: AppStrings.setLanguage.tr,
              value: controller.languageLabelKey.tr,
              showChevron: true,
              onTap: () => _pickLanguage(context),
            ),
          ),
          const _RowDivider(),
          Obx(
            () => _SettingRow(
              icon: Icons.palette_outlined,
              label: AppStrings.setTheme.tr,
              value: controller.theme.value.labelKey.tr,
              showChevron: true,
              onTap: controller.openTheme,
            ),
          ),
          const _RowDivider(),
          _SettingRow(
            icon: Icons.description_outlined,
            label: AppStrings.setTerms.tr,
            showChevron: true,
            onTap: controller.openTerms,
          ),
        ],
      ),
    );
  }

  void _pickLanguage(BuildContext context) {
    Get.bottomSheet(
      _OptionSheet(
        titleKey: AppStrings.setChooseLanguage,
        options: <_Option>[
          _Option(
            labelKey: AppStrings.setLangVi,
            selected: controller.languageCode.value == "vi",
            onTap: () => controller.setLanguage(const Locale("vi")),
          ),
          _Option(
            labelKey: AppStrings.setLangEn,
            selected: controller.languageCode.value == "en",
            onTap: () => controller.setLanguage(const Locale("en", "US")),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }

}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.value,
    this.trailing,
    this.showChevron = false,
    this.locked = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final bool showChevron;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = locked ? AppColors.textHint : AppColors.primary;
    final Color labelColor =
        locked ? AppColors.textHint : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: <Widget>[
            Icon(locked ? Icons.lock_outline_rounded : icon,
                size: 22.w, color: iconColor),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  if (subtitle != null && !locked) ...<Widget>[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ],
              ),
            ),
            if (locked)
              Icon(Icons.lock_outline_rounded,
                  size: 18.w, color: AppColors.textHint)
            else ...<Widget>[
              if (value != null)
                Text(
                  value!,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                ),
              if (trailing != null) trailing!,
              if (showChevron) ...<Widget>[
                SizedBox(width: 6.w),
                Icon(Icons.chevron_right_rounded,
                    size: 20.w, color: AppColors.textHint),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: const Divider(height: 1, color: AppColors.divider),
    );
  }
}

// ---------------------------------------------------------------------------
// Logout / delete
// ---------------------------------------------------------------------------

class _DangerActions extends StatelessWidget {
  const _DangerActions({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: controller.confirmLogout,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              AppStrings.setLogout.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: controller.confirmDelete,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              AppStrings.setDelete.tr,
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable option picker sheet
// ---------------------------------------------------------------------------

class _Option {
  const _Option({
    required this.labelKey,
    required this.selected,
    required this.onTap,
  });

  final String labelKey;
  final bool selected;
  final VoidCallback onTap;
}

class _OptionSheet extends StatelessWidget {
  const _OptionSheet({required this.titleKey, required this.options});

  final String titleKey;
  final List<_Option> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              titleKey.tr,
              style: AppTextStyles.title.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            for (final _Option option in options)
              InkWell(
                onTap: () {
                  Get.back();
                  option.onTap();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          option.labelKey.tr,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: option.selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: option.selected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (option.selected)
                        Icon(Icons.check_rounded,
                            size: 20.w, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
