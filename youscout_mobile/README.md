# YouScout Mobile

Flutter MVP for the YouScout football talent discovery platform. Players upload highlight clips; scouts browse a TikTok-style feed of the best talent.

## Demo flow

1. **Register / Login** — auth screen with tabbed login + sign-up forms
2. **Feed** — vertical `PageView` of video cards with chewie player; swipe to advance
3. **Upload** — pick a video from the gallery, tag skills and player details, submit to content-service
4. **Profile** — view your public profile card; edit display name, bio, position, and preferred foot

## Architecture

```
lib/
├── main.dart               # ProviderContainer bootstraps auth, then runs app
├── app.dart                # MaterialApp.router wired to GoRouter
├── core/
│   ├── error/              # Failure + AppException types
│   ├── l10n/               # AppStrings — all user-facing strings in one place
│   ├── network/            # Dio + AuthInterceptor + LoggingInterceptor
│   ├── router/             # go_router with auth-guard redirect
│   ├── storage/            # flutter_secure_storage wrapper
│   └── theme/              # AppColors, AppTheme
├── features/
│   ├── auth/               # Register, login, session restore
│   ├── feed/               # Discovery feed (identity-service follows + content-service stream)
│   ├── profile/            # View + edit own profile
│   └── upload/             # Video pick + upload to content-service
└── shared/
    ├── extensions/         # BuildContext helpers
    └── widgets/            # PrimaryButton, AppTextField, LoadingIndicator, ErrorView
```

Each feature follows **Clean Architecture**:

| Layer           | Responsibility                                              |
|----------------|-------------------------------------------------------------|
| `domain/`      | Pure Dart entities, repository interfaces, use-case classes |
| `data/`        | Dio data sources, freezed JSON models, repository impls     |
| `presentation/`| Riverpod notifiers + state, screens, widgets                |

## Key patterns

- **State management**: `StateNotifier` / `AsyncNotifier` via Riverpod 2.x (no codegen)
- **Immutable models**: freezed 3.x — all data-layer models are `abstract class … with _$…`; union types (e.g. `AuthState`) are `sealed class`
- **Error handling**: `Either<Failure, T>` (dartz) propagated from repository to use case; presentation unwraps with `.fold()`
- **Routing**: go_router 14.x with `redirect` + `refreshListenable` driven by auth state
- **Video playback**: `video_player` + `chewie`; each card pauses when it leaves the viewport
- **JWT auth**: Dio `AuthInterceptor` reads token from `flutter_secure_storage` and injects `Authorization: Bearer …` on every request

## Backend services

| Service                   | Port | Responsibility                           |
|--------------------------|------|------------------------------------------|
| identity-profile-service | 8081 | Auth (register/login) + profile CRUD     |
| content-service          | 8082 | Video upload + stream URL generation     |
| discovery-service        | 8083 | Personalised feed (follow graph)         |

The Android emulator routes `10.0.2.2` to the host machine's `localhost`; iOS simulator uses `localhost` directly. `ApiEndpoints` switches automatically via `Platform.isAndroid`.

## Setup

### Prerequisites

- Flutter 3.35+ / Dart 3.9+
- Backend running locally (see `/README.md` in the repo root)

### Run

```bash
# From youscout_mobile/
flutter pub get
dart run build_runner build   # regenerate freezed + json_serializable files
flutter run                   # pick a connected device / emulator
```

### Regenerate code after model changes

```bash
dart run build_runner build
```

### Analyse

```bash
flutter analyze   # should report: No issues found!
```

### Test

```bash
flutter test
```
