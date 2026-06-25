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
