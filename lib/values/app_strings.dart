/// Translation keys. Values live in `lib/xml_strings/values*/strings.xml`
/// and are resolved at runtime via GetX `.tr` (loaded by [CommLocalize]).
///
/// Usage: `AppStrings.appName.tr`
class AppStrings {
  const AppStrings._();

  static const String appName = "app_name";

  // Onboarding
  static const String onboardTitle1 = "onboard_title_1";
  static const String onboardDesc1 = "onboard_desc_1";
  static const String onboardTitle2 = "onboard_title_2";
  static const String onboardDesc2 = "onboard_desc_2";
  static const String onboardTitle3 = "onboard_title_3";
  static const String onboardDesc3 = "onboard_desc_3";
  static const String skip = "skip";
  static const String next = "next";
  static const String getStarted = "get_started";
  static const String illustrationPlaceholder = "illustration_placeholder";

  // Welcome (post-onboarding entry point)
  static const String welcomeTitle = "welcome_title";
  static const String welcomeSubtitle = "welcome_subtitle";
  static const String tryWithoutAccount = "try_without_account";
  static const String guestDataNote = "guest_data_note";
  static const String createAccountLaterNote = "create_account_later_note";

  // Auth — shared
  static const String orDivider = "or_divider";
  static const String continueWithGoogle = "continue_with_google";

  // Register / Create account
  static const String createAccount = "create_account";
  static const String registerSubtitle = "register_subtitle";
  static const String fullName = "full_name";
  static const String email = "email";
  static const String phone = "phone";
  static const String password = "password";
  static const String register = "register";
  static const String alreadyHaveAccount = "already_have_account";
  static const String signIn = "sign_in";
  static const String agreePrefix = "agree_prefix";
  static const String termsOfService = "terms_of_service";
  static const String agreeMiddle = "agree_middle";
  static const String privacyPolicy = "privacy_policy";

  // Login
  static const String login = "login";
  static const String loginSubtitle = "login_subtitle";
  static const String forgotPassword = "forgot_password";
  static const String noAccountYet = "no_account_yet";
  static const String createNow = "create_now";

  // Vehicle setup
  static const String addVehicleTitle = "add_vehicle_title";
  static const String addVehicleSubtitle = "add_vehicle_subtitle";
  static const String vehicleName = "vehicle_name";
  static const String vehicleNameHint = "vehicle_name_hint";
  static const String vehicleBrand = "vehicle_brand";
  static const String brandOther = "brand_other";
  static const String currentKm = "current_km";
  static const String currentKmHint = "current_km_hint";
  static const String kmUnit = "km_unit";
  static const String licensePlate = "license_plate";
  static const String licensePlateHint = "license_plate_hint";
  static const String enterApp = "enter_app";
  static const String addInfoLater = "add_info_later";

  // Vehicle detail
  static const String updateKm = "update_km";
  static const String vehicleTabInfo = "vehicle_tab_info";
  static const String vehicleTabHistory = "vehicle_tab_history";
  static const String vehicleTabSupplies = "vehicle_tab_supplies";
  static const String vehicleTabReminders = "vehicle_tab_reminders";
  static const String vehicleTabMembers = "vehicle_tab_members";
  static const String vehicleFieldBrand = "vehicle_field_brand";
  static const String vehicleFieldModel = "vehicle_field_model";
  static const String vehicleFieldYear = "vehicle_field_year";
  static const String vehicleFieldColor = "vehicle_field_color";
  static const String vehicleFieldCurrentKm = "vehicle_field_current_km";
  static const String vehicleFieldPurchaseDate = "vehicle_field_purchase_date";
  static const String vehicleStatTotalSpending = "vehicle_stat_total_spending";
  static const String vehicleStatFuelCount = "vehicle_stat_fuel_count";
  static const String vehicleStatKmPerLiter = "vehicle_stat_km_per_liter";

  // Tabs
  static const String tabHome = "tab_home";
  static const String tabHistory = "tab_history";
  static const String tabScan = "tab_scan";
  static const String tabReports = "tab_reports";
  static const String tabAccount = "tab_account";

  // History
  static const String histSectionMonth = "hist_section_month";
  static const String histToday = "hist_today";
  static const String histFilterAll = "hist_filter_all";
  static const String histFilterFuel = "hist_filter_fuel";
  static const String histFilterSupplies = "hist_filter_supplies";
  static const String histFilterRepair = "hist_filter_repair";
  static const String histFilterAdmin = "hist_filter_admin";
  static const String histFilterOther = "hist_filter_other";

  // History — search
  static const String histSearchHint = "hist_search_hint";
  static const String histRecentSearches = "hist_recent_searches";
  static const String histClearAll = "hist_clear_all";
  static const String histNoResults = "hist_no_results";

  // History — filter sheet
  static const String histFilterTitle = "hist_filter_title";
  static const String histFilterVehicle = "hist_filter_vehicle";
  static const String histFilterAllVehicles = "hist_filter_all_vehicles";
  static const String histFilterDateRange = "hist_filter_date_range";
  static const String histFilterExpenseType = "hist_filter_expense_type";
  static const String histFilterTypeHint = "hist_filter_type_hint";
  static const String histFilterSort = "hist_filter_sort";
  static const String histSortNewest = "hist_sort_newest";
  static const String histSortOldest = "hist_sort_oldest";
  static const String histSortHighest = "hist_sort_highest";
  static const String histReset = "hist_reset";
  static const String histApply = "hist_apply";

  // Home
  static const String greeting = "greeting";
  static const String totalSpending = "total_spending";
  static const String recentTransactions = "recent_transactions";
  static const String seeAll = "see_all";
  static const String monthYear = "month_year";
  static const String guestBanner = "guest_banner";
  static const String myVehicle = "my_vehicle";
  static const String guestBadge = "guest_badge";
  static const String vehicleActive = "vehicle_active";
  static const String totalCostMonth = "total_cost_month";
  static const String catFuel = "cat_fuel";
  static const String catRepair = "cat_repair";
  static const String catOil = "cat_oil";
  static const String noDataTitle = "no_data_title";
  static const String noDataSubtitle = "no_data_subtitle";
  static const String recordNow = "record_now";
  static const String currencyUnit = "currency_unit";

  // Reports
  static const String rptPeriodMonth = "rpt_period_month";
  static const String rptPeriodQuarter = "rpt_period_quarter";
  static const String rptPeriodYear = "rpt_period_year";
  static const String rptPeriodCustom = "rpt_period_custom";
  static const String rptTotalMonth = "rpt_total_month";
  static const String rptTotalQuarter = "rpt_total_quarter";
  static const String rptTotalYear = "rpt_total_year";
  static const String rptTotalCustom = "rpt_total_custom";
  static const String rptCompareMonth = "rpt_compare_month";
  static const String rptCompareQuarter = "rpt_compare_quarter";
  static const String rptCompareYear = "rpt_compare_year";
  static const String rptCompareCustom = "rpt_compare_custom";
  static const String rptQuarterMonths = "rpt_quarter_months";
  static const String rptMonthShort = "rpt_month_short";
  static const String rptChartByWeek = "rpt_chart_by_week";
  static const String rptChartByMonth = "rpt_chart_by_month";
  static const String rptChartCompareMonths = "rpt_chart_compare_months";
  static const String rptChartByQuarter = "rpt_chart_by_quarter";
  static const String rptChartByPeriod = "rpt_chart_by_period";
  static const String rptFrom = "rpt_from";
  static const String rptTo = "rpt_to";
  static const String rptViewReport = "rpt_view_report";
  static const String rptPreset7d = "rpt_preset_7d";
  static const String rptPreset30d = "rpt_preset_30d";
  static const String rptPreset3m = "rpt_preset_3m";
  static const String rptPreset6m = "rpt_preset_6m";
  static const String rptPreset1y = "rpt_preset_1y";
  static const String rptDonutTotal = "rpt_donut_total";
  static const String rptEfficiencyUnit = "rpt_efficiency_unit";
  static const String rptTopTitle = "rpt_top_title";
  static const String rptInsightPeakTitle = "rpt_insight_peak_title";
  static const String rptInsightPeakSub = "rpt_insight_peak_sub";
  static const String rptCustomHint = "rpt_custom_hint";
  static const String rptNoData = "rpt_no_data";

  // Settings / Account
  static const String setGuestTitle = "set_guest_title";
  static const String setGuestSubtitle = "set_guest_subtitle";
  static const String setProtectTitle = "set_protect_title";
  static const String setProtectDesc = "set_protect_desc";
  static const String setLockedHint = "set_locked_hint";
  static const String setEditProfile = "set_edit_profile";
  static const String setPremiumTitle = "set_premium_title";
  static const String setPremiumDesc = "set_premium_desc";
  static const String setPremiumCta = "set_premium_cta";
  static const String setNotifications = "set_notifications";
  static const String setBackup = "set_backup";
  static const String setBackupSynced = "set_backup_synced";
  static const String setBackupSyncing = "set_backup_syncing";
  static const String setExport = "set_export";
  static const String setLanguage = "set_language";
  static const String setTheme = "set_theme";
  static const String setTerms = "set_terms";
  static const String setLogout = "set_logout";
  static const String setDelete = "set_delete";
  static const String setLangVi = "set_lang_vi";
  static const String setLangEn = "set_lang_en";
  static const String setThemeLight = "set_theme_light";
  static const String setThemeDark = "set_theme_dark";
  static const String setThemeSystem = "set_theme_system";
  static const String setThemeSystemDesc = "set_theme_system_desc";
  static const String setChooseLanguage = "set_choose_language";
  static const String setChooseTheme = "set_choose_theme";
  static const String setLogoutConfirmTitle = "set_logout_confirm_title";
  static const String setLogoutConfirmMsg = "set_logout_confirm_msg";
  static const String setDeleteConfirmTitle = "set_delete_confirm_title";
  static const String setDeleteConfirmMsg = "set_delete_confirm_msg";

  // Backup & Sync screen
  static const String bakStatusDone = "bak_status_done";
  static const String bakLast = "bak_last";
  static const String bakBackupNow = "bak_backup_now";
  static const String bakStatTransactions = "bak_stat_transactions";
  static const String bakStatVehicles = "bak_stat_vehicles";
  static const String bakStatStorage = "bak_stat_storage";
  static const String bakAutoSection = "bak_auto_section";
  static const String bakAuto = "bak_auto";
  static const String bakWifiOnly = "bak_wifi_only";
  static const String bakFrequency = "bak_frequency";
  static const String bakFreqDaily = "bak_freq_daily";
  static const String bakFreqWeekly = "bak_freq_weekly";
  static const String bakFreqMonthly = "bak_freq_monthly";
  static const String bakChooseFrequency = "bak_choose_frequency";
  static const String bakRestoreSection = "bak_restore_section";
  static const String bakRestoreCta = "bak_restore_cta";
  static const String bakRestoreDesc = "bak_restore_desc";
  static const String bakRestoreConfirmTitle = "bak_restore_confirm_title";
  static const String bakRestoreConfirmMsg = "bak_restore_confirm_msg";
  static const String bakRestore = "bak_restore";
  static const String bakBackingUp = "bak_backing_up";
  static const String bakDone = "bak_done";

  // Export data screen
  static const String expRangeSection = "exp_range_section";
  static const String expPresetThisMonth = "exp_preset_this_month";
  static const String expPresetThisYear = "exp_preset_this_year";
  static const String expPresetAll = "exp_preset_all";
  static const String expFrom = "exp_from";
  static const String expTo = "exp_to";
  static const String expVehicleSection = "exp_vehicle_section";
  static const String expAllVehicles = "exp_all_vehicles";
  static const String expFormatSection = "exp_format_section";
  static const String expFormatPdf = "exp_format_pdf";
  static const String expFormatExcel = "exp_format_excel";
  static const String expFormatCsv = "exp_format_csv";
  static const String expEstimate = "exp_estimate";
  static const String expExport = "exp_export";
  static const String expShare = "exp_share";

  // Premium / IAP screen
  static const String iapPremiumSuffix = "iap_premium_suffix";
  static const String iapFeature1 = "iap_feature_1";
  static const String iapFeature2 = "iap_feature_2";
  static const String iapFeature3 = "iap_feature_3";
  static const String iapFeature4 = "iap_feature_4";
  static const String iapFeature5 = "iap_feature_5";
  static const String iapFeature6 = "iap_feature_6";
  static const String iapFeature7 = "iap_feature_7";
  static const String iapFeature8 = "iap_feature_8";
  static const String iapPlanMonthly = "iap_plan_monthly";
  static const String iapPlanYearly = "iap_plan_yearly";
  static const String iapBadgeSave = "iap_badge_save";
  static const String iapCta = "iap_cta";
  static const String iapFooter = "iap_footer";

  // Edit profile
  static const String epChangePhoto = "ep_change_photo";
  static const String epPhoneLocked = "ep_phone_locked";
  static const String epSaved = "ep_saved";

  // Forgot password
  static const String fpTitle = "fp_title";
  static const String fpSubtitle = "fp_subtitle";
  static const String fpSubmit = "fp_submit";
  static const String fpSent = "fp_sent";

  // Terms & Privacy
  static const String termsUpdated = "terms_updated";
  static const String termsS1Title = "terms_s1_title";
  static const String termsS1Body = "terms_s1_body";
  static const String termsS2Title = "terms_s2_title";
  static const String termsS2Body = "terms_s2_body";
  static const String termsS3Title = "terms_s3_title";
  static const String termsS3Body = "terms_s3_body";
  static const String termsS4Title = "terms_s4_title";
  static const String termsS4Body = "terms_s4_body";
  static const String termsS5Title = "terms_s5_title";
  static const String termsS5Body = "terms_s5_body";

  // Add-receipt bottom sheet & permissions
  static const String addReceiptTitle = "add_receipt_title";
  static const String addReceiptSubtitle = "add_receipt_subtitle";
  static const String captureReceipt = "capture_receipt";
  static const String captureReceiptDesc = "capture_receipt_desc";
  static const String chooseFromGallery = "choose_from_gallery";
  static const String chooseFromGalleryDesc = "choose_from_gallery_desc";
  static const String cancel = "cancel";
  static const String permissionNeededTitle = "permission_needed_title";
  static const String permissionDenied = "permission_denied";
  static const String permissionPermanentlyDenied = "permission_permanently_denied";
  static const String openSettings = "open_settings";
  static const String featureComingSoon = "feature_coming_soon";

  // Camera scan
  static const String scanReceiptHint = "scan_receipt_hint";
  static const String scanReceiptSubhint = "scan_receipt_subhint";
  static const String cameraError = "camera_error";

  // AI processing (after capture, before result)
  static const String processingTitle = "processing_title";
  static const String processingSubtitle = "processing_subtitle";

  // Receipt review (extracted details)
  static const String aiScanResult = "ai_scan_result";
  static const String reviewTitle = "review_title";
  static const String reviewSubtitle = "review_subtitle";
  static const String fieldStationName = "field_station_name";
  static const String fieldFuelType = "field_fuel_type";
  static const String fieldLiters = "field_liters";
  static const String fieldUnitPrice = "field_unit_price";
  static const String fieldTotalAmount = "field_total_amount";
  static const String scannedAt = "scanned_at";
  static const String rescan = "rescan";
  static const String save = "save";
  static const String expenseSaved = "expense_saved";
}
