# ═══════════════════════════════════════════════════════════════════
# YOUSCOUT — MOBILE MVP BUILD PROMPT FOR CLAUDE CODE
# Single-prompt, end-to-end build of Flutter mobile app
# 4 screens · talks to the 3 Spring Boot backend services
# ═══════════════════════════════════════════════════════════════════
#
# HOW TO USE
# ----------
# 1. Make sure the BACKEND MVP is already built and running
#    (the 3 Spring Boot services + docker-compose infrastructure).
# 2. Open Claude Code in an EMPTY directory (e.g. ~/projects/youscout-mobile).
# 3. Paste this entire prompt as your first message.
# 4. Claude Code will build the whole Flutter app and tell you how to run it.
#    Total build time: 15-25 minutes depending on model.
#
# PREREQUISITES BEFORE RUNNING THE APP
# ------------------------------------
# - Flutter SDK 3.22+ installed (`flutter --version`)
# - Android Studio OR Xcode for an emulator (or a physical device)
# - The YouScout backend MVP running on localhost (ports 8081, 8082, 8083)
#
# AFTER THE BUILD
# ---------------
# - `flutter pub get` to install dependencies
# - `flutter run` with an emulator/device connected
# - See README.md for the demo flow
#
# ═══════════════════════════════════════════════════════════════════
#                  COPY EVERYTHING BELOW THIS LINE
# ═══════════════════════════════════════════════════════════════════

# Project: YouScout Mobile MVP (Flutter)

You are building the **mobile MVP for YouScout**, the cross-platform Flutter client for a football talent-discovery social platform. This MVP is the mobile portion of a Software Architecture final project (EFM) at ISMAGI (Morocco), and it must work end-to-end with the existing Spring Boot backend MVP (three services running on localhost:8081, 8082, 8083).

The audience for the code is an architecture professor. The app does not need to be App-Store-ready — it needs to be **architecturally clean**, **runnable on iOS and Android from one codebase**, and **demonstrably exercising all four backend endpoints during the defense demo**.

---

## Scope — Build Exactly This, Nothing More

Build a **Flutter 3.22+ application with 4 screens**:

| Screen | Purpose | Backend Service Used |
|---|---|---|
| **Auth Screen** | Login + Sign Up (tabbed) | `identity-profile-service` (port 8081) |
| **Feed Screen** | Vertical-scroll video feed, TikTok-style | `discovery-service` (port 8083) + `content-service` (8082) for stream URLs |
| **Upload Screen** | Pick a video from gallery + add description, hashtags, skills | `content-service` (port 8082) |
| **Profile Screen** | Show own profile + edit (display name, bio, position, foot) | `identity-profile-service` (port 8081) |

Plus a **bottom navigation bar** with 3 tabs: Feed · Upload · Profile. The Auth screen is shown before login and replaced by the main scaffold after.

**Do NOT build:** chat/messaging, notifications, social graph UI (follow buttons beyond a minimal one on profile), search, scout dashboard, settings, parental consent flow, video recording from camera (we use gallery-pick only — recording adds complexity without architectural value).

---

## Required Technology Stack

- **Framework:** Flutter 3.22+ (Dart 3.4+)
- **State management:** Riverpod 2.x (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`)
- **HTTP:** Dio 5.x (with interceptors for JWT and logging)
- **Persistence:** `flutter_secure_storage` for JWT, `shared_preferences` for non-sensitive prefs
- **Routing:** `go_router` 14.x (declarative, deep-link-ready)
- **Video playback:** `video_player` + `chewie` (Chewie wraps video_player with controls)
- **Image / video picker:** `image_picker` (handles both)
- **Forms:** `flutter_hooks` + `reactive_forms` OR plain `StatefulWidget` (your call — go simpler)
- **JSON:** `freezed` + `json_serializable` for immutable models with codegen
- **Code generation:** `build_runner` (runs `freezed`, `json_serializable`, `riverpod_generator` together)
- **Linting:** `flutter_lints` with strict mode
- **Logging:** `logger` package

No third-party UI kits (no GetWidget, no Velocity_X). Use Material 3 components directly. Less is more — the visual style should be clean and modern, not over-designed.

---

## Architectural Discipline — Mobile-Adapted Hexagonal

The backend uses Hexagonal Architecture; the mobile app uses the Flutter community equivalent: **Clean Architecture in three layers**.

```
lib/
├── main.dart
├── app.dart                       # MaterialApp.router setup, theme, routing
├── core/                          # Cross-cutting: theme, errors, constants
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── error/
│   │   ├── failures.dart          # Domain failure types (NetworkFailure, AuthFailure, ValidationFailure)
│   │   └── exceptions.dart        # Data-layer exceptions
│   ├── network/
│   │   ├── dio_provider.dart      # Dio instance with auth + logging interceptors
│   │   └── api_endpoints.dart     # Centralized backend URLs
│   ├── storage/
│   │   └── secure_storage.dart    # JWT token persistence wrapper
│   └── router/
│       ├── app_router.dart        # GoRouter setup
│       └── routes.dart            # Route name constants
├── features/                      # Feature-first organization (each feature is self-contained)
│   ├── auth/
│   │   ├── domain/                # ── Pure Dart, no Flutter imports, no Dio imports ──
│   │   │   ├── entities/
│   │   │   │   └── user.dart                # @freezed User entity
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart     # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── register_user.dart
│   │   │       ├── login_user.dart
│   │   │       └── get_current_user.dart
│   │   ├── data/                  # ── Implementations + remote / local sources ──
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart          # @freezed with fromJson/toJson
│   │   │   │   ├── register_request.dart
│   │   │   │   └── auth_response.dart
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_providers.dart      # Riverpod providers
│   │       │   └── auth_state.dart          # @freezed AuthState union
│   │       ├── screens/
│   │       │   └── auth_screen.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── register_form.dart
│   ├── feed/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── feed_item.dart           # @freezed FeedItem (videoId, uploaderName, description, skills, streamUrl)
│   │   │   ├── repositories/
│   │   │   │   └── feed_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_feed.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── feed_item_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── feed_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── feed_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── feed_providers.dart
│   │       ├── screens/
│   │       │   └── feed_screen.dart
│   │       └── widgets/
│   │           ├── video_player_card.dart
│   │           └── feed_item_overlay.dart   # Description, uploader, skills overlay on top of video
│   ├── upload/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── upload_request.dart
│   │   │   ├── repositories/
│   │   │   │   └── upload_repository.dart
│   │   │   └── usecases/
│   │   │       ├── upload_video.dart
│   │   │       └── list_skills.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── skill_model.dart
│   │   │   │   └── video_response.dart
│   │   │   ├── datasources/
│   │   │   │   └── content_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── upload_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── upload_providers.dart
│   │       ├── screens/
│   │       │   └── upload_screen.dart
│   │       └── widgets/
│   │           ├── video_preview.dart
│   │           └── skill_selector.dart
│   └── profile/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── profile.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── usecases/
│       │       ├── get_my_profile.dart
│       │       └── update_my_profile.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── profile_model.dart
│       │   ├── datasources/
│       │   │   └── profile_remote_datasource.dart
│       │   └── repositories/
│       │       └── profile_repository_impl.dart
│       └── presentation/
│           ├── providers/
│           │   └── profile_providers.dart
│           ├── screens/
│           │   └── profile_screen.dart
│           └── widgets/
│               └── profile_edit_form.dart
└── shared/                        # Cross-feature widgets and helpers
    ├── widgets/
    │   ├── primary_button.dart
    │   ├── app_text_field.dart
    │   ├── loading_indicator.dart
    │   └── error_view.dart
    └── extensions/
        └── context_extensions.dart
```

### Layer Rules (strict — enforce in every feature)

- **`domain/`** — pure Dart. No Flutter imports. No Dio imports. No `package:json_annotation`. Only `@freezed` and `dartz` (or `Either<Failure, T>`) are allowed externals. Entities, repository interfaces, use cases. The domain knows nothing about how data is fetched or stored.
- **`data/`** — implements `domain/repositories/*` interfaces using `datasources/*`. Models extend or wrap entities with JSON serialization. The data layer is the only place that knows about Dio.
- **`presentation/`** — Flutter widgets + Riverpod providers. Calls use cases (not repositories directly). Maps domain failures into UI states.

**Dependency direction is always inward.** Presentation depends on domain. Data depends on domain. Domain depends on nothing. If you find yourself importing `package:flutter/material.dart` inside `domain/`, you are doing it wrong — refactor.

This matters because the architecture professor will look at the directory tree and ask: *"Where is your business logic?"* The answer must be: *"In `domain/usecases/`, with no framework imports."*

---

## Architectural Patterns to Demonstrate (Visible in Code)

### 1. Clean Architecture / Hexagonal (matches backend ADR-002)
Already covered above. Each feature has `domain/data/presentation`. Domain is pure Dart.

### 2. Repository Pattern (Evans)
Every `data/repositories/*_impl.dart` implements an abstract interface in `domain/repositories/`. Use cases depend on the interface, not the implementation. Riverpod wires the implementation in at runtime.

### 3. Use Case Pattern (Clean Architecture)
Every screen action goes through a use case. The screen calls `LoginUser(authRepository).call(email, password)`, not `authRepository.login(...)` directly. Use cases are tiny single-purpose classes — most are 5-10 lines — but they centralize the orchestration and make screens testable in isolation.

### 4. Either<Failure, Success> for Error Handling
Use the `dartz` package (or hand-roll a small `Either` type). Use cases return `Future<Either<Failure, T>>`. Screens pattern-match on the result. **No try-catch in presentation code.** Failures are surfaced as typed values, not exceptions.

### 5. Riverpod for Dependency Injection + State
Use code generation (`@riverpod`) for providers. Providers wire the dependency tree:
- `dioProvider` → returns configured Dio instance
- `authRemoteDatasourceProvider` → depends on `dioProvider`
- `authRepositoryProvider` → depends on `authRemoteDatasourceProvider`
- `loginUserUseCaseProvider` → depends on `authRepositoryProvider`
- Screen consumes `loginUserUseCaseProvider`

This is **Dependency Inversion at runtime** — the screen depends on a use case abstraction, never on concrete data classes.

### 6. Sealed Unions for UI State (using @freezed)
Every screen has a state class as a sealed union:
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user, String token) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```
Screens pattern-match with `state.when(...)`. This is exhaustive — the compiler forces handling every case. No null checks scattered through the UI.

---

## Backend Integration — Exact Endpoints

The Flutter app must talk to the running backend on **localhost**. Configure base URLs in `lib/core/network/api_endpoints.dart`. For Android emulator, `localhost` is `10.0.2.2`; for iOS simulator, `localhost` works directly. Handle this with a platform check OR document it in the README.

### identity-profile-service (port 8081)
- `POST /api/v1/auth/register` — body `{email, password, displayName}` → returns `{user, token}`
- `POST /api/v1/auth/login` — body `{email, password}` → returns `{user, token}`
- `GET /api/v1/profile/me` — header `Authorization: Bearer <jwt>` → returns user
- `PUT /api/v1/profile/me` — body `{displayName, bio, position, foot}` → returns updated user

### content-service (port 8082)
- `POST /api/v1/videos` — multipart: `file` + `description` + `hashtags` + `skills` → returns video DTO
- `GET /api/v1/videos/{videoId}/stream` — returns `{presignedUrl}` for streaming
- `GET /api/v1/skills` — returns list of skills

### discovery-service (port 8083)
- `GET /api/v1/feed` — header `Authorization: Bearer <jwt>` → returns list of feed items (each with videoId, uploaderName, description, skills)
- `POST /api/v1/internal/follow` — body `{followerId, followeeId}` (used by Profile screen's "Follow" button)

### Cross-Service Flow in the App

The Feed screen's job is composite: it calls `GET /api/v1/feed` on discovery-service to get the list, then for each feed item it calls `GET /api/v1/videos/{videoId}/stream` on content-service to get a presigned stream URL. In the real architecture this would be aggregated by a BFF; in the MVP the mobile client does the aggregation directly. **Document this in code comments** so the professor sees we know what a BFF would have solved.

---

## JWT Handling

- After successful login or registration, store the JWT in `flutter_secure_storage` (keychain on iOS, encrypted shared prefs on Android).
- Dio's `AuthInterceptor` reads the token on every request and attaches it as `Authorization: Bearer <token>`.
- On `401 Unauthorized` responses, clear the token and redirect to the Auth screen via GoRouter.
- On app launch, check if a token exists. If yes, attempt `GET /api/v1/profile/me`. If it succeeds, go to Feed. If 401, go to Auth.

---

## UI / Visual Style

### Color Palette (matches the presentation deck)
- **Primary navy:** `#0B2E4F` (app bar, primary buttons)
- **Football green:** `#0F7B47` (accent, success states, "Follow" button)
- **Warm orange:** `#E07A2A` (sparing — used for the floating upload button)
- **Background:** `#FAFAF6` (off-white)
- **Surface:** White
- **Text primary:** `#1A1A1A` (charcoal)
- **Text secondary:** `#6B6B6B`
- **Dividers:** `#E5E5E5`

Configure Material 3 `ColorScheme` with these. Provide both light theme (primary) and a basic dark theme.

### Typography
Use Material 3 default typography but bump display sizes slightly. Headings should feel editorial — Inter is a great fit; if not available, default to system sans-serif.

### Screens — Visual Direction

- **Auth Screen:** Centered card on the off-white background. Tab bar at top (Login | Sign Up). Form fields with rounded borders. Primary button at the bottom in navy. YouScout logo (just text styled boldly) at the top.

- **Feed Screen:** **Full-screen vertical PageView**, one video per page (TikTok-style). Video fills the screen; overlay at the bottom-left shows uploader name, description, skill chips. A small follow button at the top-right. Auto-play the visible video; pause when scrolled away. Tap to pause/resume.

- **Upload Screen:** Step layout — first a button to pick a video from gallery, then a preview, then form fields (description, hashtags as chips, skills as multi-select chips), then a publish button. Show a progress indicator during upload.

- **Profile Screen:** Avatar circle (initials if no image), name, bio, position, foot, then a list of the user's own videos (just titles for MVP). An "Edit Profile" button that opens a modal sheet with the edit form.

### Bottom Navigation
3 tabs: Feed (home icon) · Upload (plus icon, centered, slightly elevated) · Profile (person icon). Active tab uses navy; inactive uses muted grey.

---

## The End-to-End Demo Flow

The professor will run this flow during the defense. README must explain it clearly.

```
PREREQUISITE: Backend MVP is running.
  - docker-compose up -d (Postgres, Redis, Kafka, MinIO)
  - identity-profile-service running on :8081
  - content-service running on :8082
  - discovery-service running on :8083

1. flutter pub get
2. flutter run (with iOS simulator or Android emulator)
3. App opens to Auth screen
4. Tap "Sign Up" tab → register as Alice (alice@youscout.dev / password123)
5. (In parallel, on a 2nd device/emulator, register Bob)
6. As Alice, go to Profile → tap "Follow" on Bob's profile (use a quick search-by-id field for MVP)
7. As Bob, go to Upload → pick a video from gallery → add description, skills → Publish
8. As Alice, pull-to-refresh the Feed → Bob's video appears, autoplays
```

If running with one emulator, use the cURL commands from the backend README to register Bob and have him upload a video, then run the Flutter app as Alice to see the result. Document this fallback in the mobile README.

---

## README.md Contents

1. **Project overview** — one paragraph about what the app is.
2. **Architecture map** — directory tree explanation with the Clean Architecture layer rules.
3. **Prerequisites** — Flutter 3.22+, iOS Simulator or Android Emulator, **the backend MVP running**.
4. **Setup**:
   - `flutter pub get`
   - `dart run build_runner build --delete-conflicting-outputs` (for code generation)
   - Set the backend base URL if not localhost (in `lib/core/network/api_endpoints.dart`)
   - `flutter run`
5. **The demo flow** — exact steps from above.
6. **Architectural patterns demonstrated** — list with file references:
   - Clean Architecture: `lib/features/*/{domain,data,presentation}`
   - Repository pattern: e.g. `lib/features/auth/domain/repositories/auth_repository.dart` (interface) ↔ `lib/features/auth/data/repositories/auth_repository_impl.dart` (impl)
   - Use case pattern: `lib/features/*/domain/usecases/`
   - Either<Failure, Success>: search for `Either<Failure,` across the codebase
   - Riverpod DI: `lib/features/*/presentation/providers/`
   - Sealed unions: `lib/features/*/presentation/providers/*_state.dart`
7. **Known limitations** — honest list (no chat, no real video transcoding, single-emulator demo limitations, etc.).
8. **What production would add** — service mesh, push notifications via FCM, deep links, offline support, retry policies with backoff, analytics — explicitly listed so the professor sees we know what's missing.

---

## Critical Build Rules

1. **No Flutter imports inside `domain/` packages.** Use cases and entities are pure Dart. If you need `BuildContext` or `Widget`, you're in the wrong layer.
2. **No Dio imports inside `domain/` packages.** Repository interfaces return `Future<Either<Failure, T>>` — they don't know HTTP exists.
3. **Use cases must be single-purpose.** One use case = one verb (`LoginUser`, `GetFeed`, `UploadVideo`, not `AuthManager`).
4. **All HTTP calls go through Dio with the AuthInterceptor.** No direct `http.post()` calls anywhere.
5. **All state is in Riverpod providers.** No `setState` in screens that have business state (`setState` is acceptable for purely-visual local state like "is this text field focused").
6. **`@freezed` for all data classes** — entities, models, states. Immutability is enforced architecturally.
7. **`flutter analyze` must pass with zero warnings.** Use strict linting.
8. **No hardcoded strings in UI files for anything user-facing** that might be localized — use a simple `lib/core/l10n/strings.dart` constants file. (Full i18n setup is out of scope; centralized strings are not.)
9. **Code generation succeeds in one command:** `dart run build_runner build --delete-conflicting-outputs`.

---

## What to Skip (Out of MVP Scope — Do NOT Build)

- Camera-based video recording (gallery pick only)
- Push notifications
- Deep linking
- Offline support / caching
- Comments UI (the backend doesn't have an engagement service in the MVP anyway)
- Likes / ratings UI
- Chat / messaging
- Search screen
- Settings screen
- OAuth2 with Google/Facebook/Apple (username/password is fine)
- Full i18n (just centralize strings in one file)
- App icons / splash screen branding (use defaults)
- Theme toggle
- Animations beyond what Material 3 provides for free
- Tests beyond a single example per layer (one widget test, one use case test, one repository test — to prove the architecture is testable)

If you start building any of these, stop and finish the core scope first.

---

## Execution Plan — Do This in Order

1. **Project skeleton** — `flutter create youscout_mobile --org dev.youscout --platforms ios,android`. Set up `pubspec.yaml` with all dependencies. Configure linting. Create the directory tree.

2. **Core layer** — theme, error types, Dio with interceptors, secure storage, router skeleton.

3. **Auth feature, end-to-end** — domain → data → presentation. Verify register + login work against the running backend.

4. **Routing + bottom nav scaffold** — after login, navigate to main scaffold with bottom tabs. Each tab routes to its screen.

5. **Profile feature** — display + edit own profile. Verify against backend.

6. **Upload feature** — pick video, fill form, submit multipart upload. Verify the video appears in MinIO (via the MinIO console).

7. **Feed feature** — fetch feed, fetch stream URLs, play videos in a vertical PageView. **Verify the full end-to-end flow:** Bob uploads on one client, Alice (following Bob) sees the video on another client (or via cURL-triggered upload).

8. **README.md and architectural documentation** — populate fully.

9. **Final smoke test** — run the demo flow on a real or simulated device, end to end.

---

## Stop Conditions

Stop and ask me before continuing if:
- The Flutter SDK version is incompatible with the chosen packages — propose a working combination.
- A package has been deprecated and a clear successor exists — adopt the successor.
- The scope appears to require more than ~6 hours of model time — propose a smaller scope.

Otherwise, proceed end to end. Don't pause for trivial decisions. Make sensible choices and document them in the README.

---

## Begin

Start by running `flutter create` and setting up `pubspec.yaml`. Verify dependencies resolve. Then build the core layer, then auth, then routing, then the three main features, then docs. Run the demo flow as the final verification.

When complete, report:
- ✅ Files created (top-level summary)
- ✅ `flutter pub get` succeeded
- ✅ `dart run build_runner build` succeeded
- ✅ `flutter analyze` passes with zero issues
- ✅ App runs on iOS simulator AND/OR Android emulator
- ✅ End-to-end demo flow verified (registered, uploaded via backend, saw in feed)
- 📋 Any deviations from this spec and why
- 📋 Known limitations or TODOs

# ═══════════════════════════════════════════════════════════════════
#                  END OF PROMPT
# ═══════════════════════════════════════════════════════════════════
