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

  // Register
  static const String createAccount = "create_account";
  static const String registerSubtitle = "register_subtitle";
  static const String fullName = "full_name";
  static const String email = "email";
  static const String phone = "phone";
  static const String password = "password";
  static const String register = "register";
  static const String alreadyHaveAccount = "already_have_account";
  static const String signIn = "sign_in";

  // Tabs
  static const String tabHome = "tab_home";
  static const String tabHistory = "tab_history";
  static const String tabScan = "tab_scan";
  static const String tabReports = "tab_reports";
  static const String tabSettings = "tab_settings";

  // Home
  static const String greeting = "greeting";
  static const String totalSpending = "total_spending";
  static const String recentTransactions = "recent_transactions";
  static const String seeAll = "see_all";
}
