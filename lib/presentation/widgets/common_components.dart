// ignore_for_file: dangling_library_doc_comments
/// Barrel export — import this single file to get all common UI components.
///
/// ```dart
/// import "package:ricemoto/presentation/widgets/common_components.dart";
/// ```
///
/// ## Buttons
/// - [PrimaryButton]       — filled brand button (full-width, loading state)
/// - [SecondaryButton]     — outlined brand button (full-width)
/// - [DestructiveButton]   — red filled button for destructive actions
/// - [GhostButton]         — text-only button with padding
/// - [IconLabelButton]     — outlined button with leading icon
///
/// ## Bottom Sheets
/// - [AppBottomSheet]      — base container; call [AppBottomSheet.show] as helper
/// - [AppOptionSheet]      — radio-style option picker; call [AppOptionSheet.show]
/// - [AppActionSheet]      — icon+title action list; call [AppActionSheet.show]
///
/// ## Dialogs
/// - [AppDialog.confirm]   — cancel + confirm (optional destructive style)
/// - [AppDialog.alert]     — single OK button
/// - [AppDialog.custom]    — fully custom action list
///
/// ## List / Cards
/// - [AppListTile]         — settings-style row (icon, title, value, chevron, switch…)
/// - [AppListCard]         — card wrapper with internal dividers
///
/// ## Section Headers & Dividers
/// - [AppSectionHeader]    — title + optional trailing action
/// - [AppDivider]          — thin divider, optional center label
///
/// ## State Widgets
/// - [AppEmptyState]       — icon + title + subtitle + optional CTA
/// - [AppLoadingState]     — centered spinner with optional message
///
/// ## Auth / Misc
/// - [AuthCard]            — rounded card used on login/register screens
/// - [GoogleButton]        — "Continue with Google" outlined button
/// - [LanguageSwitcher]    — VI/EN toggle pill for onboarding/welcome headers

export "package:ricemoto/presentation/widgets/app_bottom_sheet.dart";
export "package:ricemoto/presentation/widgets/app_buttons.dart";
export "package:ricemoto/presentation/widgets/app_dialog.dart";
export "package:ricemoto/presentation/widgets/app_empty_state.dart";
export "package:ricemoto/presentation/widgets/app_list_tile.dart";
export "package:ricemoto/presentation/widgets/app_section_header.dart";
export "package:ricemoto/presentation/widgets/auth_card.dart";
export "package:ricemoto/presentation/widgets/google_button.dart";
export "package:ricemoto/presentation/widgets/language_switcher.dart";
export "package:ricemoto/presentation/widgets/primary_button.dart";
