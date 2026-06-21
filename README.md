# RiceMoto_App

RiceMoto – smart receipt & expense scanning app (Flutter).

## Tech stack

- **Flutter** (Dart) + **GetX** for state management & routing
- **dsp_base** shared module (UI kit, `commRunApp` bootstrap, XML localization, Firebase, ads) — included as a **git submodule**
- **Firebase** (Android configured via `google-services.json`)
- **flutter_screenutil** responsive design (360×800)

## Project structure

```
lib/
  configs/        # routes, pages (GetX bindings), theme, app config
  controller/     # GetX controllers (splash, onboarding, register, home)
  models/         # data models
  presentation/   # screens & widgets (splash, onboarding, register, home tabs)
  repository/     # data sources (auth)
  services/       # storage / platform services
  utils/          # extensions & helpers
  values/         # colors, dimens, text styles, assets, string keys
  xml_strings/    # localization (en + vi)
  firebase_options.dart
  main.dart
dsp_base/         # shared base module (git submodule)
```

## App flow

Splash → 3-step Onboarding → Register → Home (5 tabs: Home / History / Scan / Reports / Settings)

## Getting started

```bash
# Clone WITH the submodule
git clone --recurse-submodules https://github.com/asctechsoft/RiceMoto_App.git
# (or, if already cloned)
git submodule update --init --recursive

flutter pub get
flutter run
```

> **Note:** the build needs `android/debug_keystore.properties` (required by
> dsp_base). It is git-ignored — create it locally with the AES keys before
> building. For iOS Firebase, add `GoogleService-Info.plist` and run
> `flutterfire configure`.
