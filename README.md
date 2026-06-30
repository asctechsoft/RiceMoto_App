# RiceMoto_App

RiceMoto – smart receipt & expense scanning app (Flutter).

## Tech stack

- **Flutter** (Dart) + **GetX** for state management & routing
- **dsp_base** shared module (UI kit, `commRunApp` bootstrap, XML localization, Firebase, ads) — included as a **git submodule**
- **Firebase Auth** — phone (SMS OTP) + Google sign-in
- **RideMoto backend** (NestJS API) — included as a **git submodule** at `backend/`
- **dio** HTTP client for the backend API
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
backend/          # RideMoto NestJS API (git submodule)
```

## App flow

Splash → Onboarding → Welcome → Login/Register (phone OTP **or** Google) →
OTP verify → first-time vehicle setup → Home (5 tabs: Home / History / Scan /
Reports / Settings).

Auth handshake: Firebase verifies the credential → the app exchanges the
Firebase ID token at `POST /v1/auth/firebase` for the backend JWT pair → the
JWT is attached to every later API call (auto-refreshed on 401).

## Getting started

### 1. Clone with submodules (app + dsp_base + backend)

```bash
git clone --recurse-submodules https://github.com/asctechsoft/RiceMoto_App.git
# (or, if already cloned)
git submodule update --init --recursive
```

### 2. Run the backend (`backend/`)

```bash
cd backend
npm install
cp .env.example .env      # fill DATABASE_URL, REDIS_URL, JWT_SECRET,
                          # FIREBASE_SERVICE_ACCOUNT (same Firebase project as the app)
docker-compose up -d      # Postgres + Redis
npx prisma migrate dev
npm run start:dev         # → http://localhost:3000/v1
```

### 3. Point the app at the backend

Edit `lib/configs/api_config.dart` → set `lanHost` to your PC's LAN IP
(`ipconfig` → IPv4), e.g. `192.168.1.12`. Phone and PC must share the network.
Also add that IP to `android/app/src/main/res/xml/network_security_config.xml`
(cleartext http is allowed only for the listed dev hosts).

> Android emulator: set `forceLanHost = false` in `api_config.dart` — it then
> auto-uses `10.0.2.2`. iOS simulator uses `localhost`.

### 4. Run the app

```bash
flutter pub get
flutter run
```

> **Note:** the build needs `android/debug_keystore.properties` (required by
> dsp_base). It is git-ignored — create it locally with the AES keys before
> building. For iOS Firebase, add `GoogleService-Info.plist` and run
> `flutterfire configure`.
>
> Firebase Console: enable **Phone** + **Google** sign-in providers and add the
> app's SHA-1/SHA-256 fingerprints, or auth requests will be rejected.
