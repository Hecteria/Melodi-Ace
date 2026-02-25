# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run on Android (emulator or device)
flutter run

# Hot reload (while running)
r

# Hot restart (while running)
R

# Build APK
flutter build apk

# Install dependencies
flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test.dart

# Deploy Firestore rules
firebase deploy --only firestore:rules --project melodi-music-app

# Deploy Storage rules
firebase deploy --only storage --project melodi-music-app
```

## Architecture

Feature-based, with a strict UI/logic separation. Every feature follows:

```
lib/features/{name}/
  data/          # Static const data + Firestore models (no Flutter imports)
  controllers/   # ChangeNotifier state (business logic only)
  presentation/  # StatefulWidget screens (pure UI)
```

### App Boot Sequence

`main.dart` → Firebase.initializeApp → `AuthGate` → `AuthController._init()` → anonymous sign-in + device fingerprint → `AuthScope(AuthController)` wraps `MainShell`

- `AuthGate` (`lib/features/auth/presentation/auth_gate.dart`) switches on `AuthStatus {loading, authenticated, unauthenticated}`.
- `AuthScope` (`lib/core/services/auth_scope.dart`) is an `InheritedNotifier<AuthController>` — access it anywhere via `AuthScope.of(context)`.
- `MainShell` (`lib/shell/main_shell.dart`) renders 5 tabs in an `IndexedStack` driven by `ShellController`.

### State Pattern

Every screen is a `StatefulWidget` that creates its controller in `State` and disposes it in `dispose()`. The `build` method wraps content in `ListenableBuilder(listenable: _controller, ...)`. Controllers are pure `ChangeNotifier`; they do not import Flutter widgets.

```dart
class _FooScreenState extends State<FooScreen> {
  final _controller = FooController();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => /* UI */,
    );
  }
}
```

### Auth & Credit System

- On every launch, `AuthController` auto signs in anonymously (guest flow).
- **Credits live on the device, not the user**: `devices/{fingerprint}` Firestore doc holds `generationCredits`.
- Device fingerprint: Android ID on Android; UUID stored in iOS Keychain (persists reinstalls).
- Anonymous → Google account linking via `AuthController.linkWithGoogle()` → uses `linkWithCredential`, falls back to `signInWithCredential` on conflict.
- After sign-out, the app immediately re-enters guest flow (no unauthenticated state in normal usage).

Access the controller from any widget inside `AuthScope`:
```dart
final auth = AuthScope.of(context);
final credits = auth.generationCredits;
await auth.useCredit();
await auth.linkWithGoogle();
```

## Firebase

- **Project ID**: `melodi-music-app`
- **Firestore region**: eur3 (europe-west)
- **Rules files**: `firestore.rules`, `storage.rules` (always validate before deploying)

### Firestore Collections

| Collection | Key rules |
|---|---|
| `devices/{fingerprint}` | Read allowed when `resource == null` (doc not yet created) OR `currentAuthUid == uid` |
| `users/{uid}` | Any authenticated user can read; only owner can write |
| `tracks/{trackId}` | Any authenticated user can read; owner (`userId`) can write/delete |
| `playlists/{playlistId}` | Owner or public (`isPublic == true`) can read |
| `generations/{genId}` | Owner only; immutable after creation |

### Storage Paths

- `users/{uid}/{fileName}` — profile avatars (image, max 5 MB)
- `tracks/{userId}/{allPaths}` — AI-generated audio (audio, max 50 MB)

## Design System

All colors: `lib/core/theme/app_theme.dart` (`AppColors`)
Font: Spline Sans (via `google_fonts`)

| Token | Value |
|---|---|
| `AppColors.primary` | `#F48C25` (orange) |
| `AppColors.backgroundDark` | `#121212` |
| `AppColors.surfaceDark` | `#1A1A1C` |
| `AppColors.white54` | Secondary text |

Use `Theme.of(context).textTheme.*` for typography; never hardcode font sizes except for minor adjustments.

## Navigation

- Tab navigation: `ShellController.setTab(index)` — tabs are `IndexedStack` children (state preserved).
- Route push (modals/detail screens): standard `Navigator.of(context).push(MaterialPageRoute(...))`.
- `UpgradeScreen` is pushed as a modal route from the Home FAB, not a tab.
- `PlaylistDetailScreen` accepts a `PlaylistInfo` argument and is pushed from multiple screens.

## Code Patterns

### Color opacity — always `withValues`, never `withOpacity`

The entire project uses the newer Flutter API. `withOpacity()` is deprecated and must not be used.

```dart
// Correct
Colors.white.withValues(alpha: 0.08)
AppColors.primary.withValues(alpha: 0.3)

// Wrong — do not use
Colors.white.withOpacity(0.08)
```

### Gradient buttons

Full-width primary action buttons wrap `ElevatedButton` inside `DecoratedBox` to achieve a gradient background (ElevatedButton's `backgroundColor` does not support gradients):

```dart
DecoratedBox(
  decoration: BoxDecoration(
    gradient: const LinearGradient(colors: [...]),
    borderRadius: BorderRadius.circular(16),
  ),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    onPressed: ...,
    child: ...,
  ),
)
```

### `TextEditingController` ownership

`TextEditingController` lives in the **feature controller**, not in the screen's `State`. The screen disposes the feature controller, which in turn disposes the text controller.

```dart
// In feature controller
class FooController extends ChangeNotifier {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

// In screen — do NOT create a separate TextEditingController
TextField(controller: _controller.textController)
```

### `busy` flag for async controllers

Any controller with async operations exposes a `busy` getter; UI shows loading states based on it.

```dart
class FooController extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  Future<void> doSomething() async {
    _setBusy(true);
    try { /* ... */ } finally { _setBusy(false); }
  }

  void _setBusy(bool v) { _busy = v; notifyListeners(); }
}
```

### Tab screen state (IndexedStack)

`MainShell` uses `IndexedStack`, meaning tab screens are **never unmounted** while the shell is alive. Controllers created in a tab screen's `State` constructor persist for the app's lifetime. Do not rely on controller re-initialization when the user switches tabs — use explicit refresh methods instead.

## Static Mock Data vs. Live Firestore

All `lib/features/{name}/data/{name}_data.dart` files (e.g., `HomeData`, `CreationData`, `PlayerData`) contain **static placeholder data** — they are not backed by Firestore. The two Firestore-backed model files are `UserModel` and `DeviceModel`.

When wiring a screen to real backend data, add Firestore streaming/fetching logic to the **controller** (not the data file). The data file either becomes a constants-only file or is replaced by a repository layer.

Data files may import Flutter (`dart:ui` types like `Color`, `IconData`) when their models carry display metadata — this is intentional and not a violation of the architecture.

## Firestore Rules

**Critical pattern:** Any read rule that validates document fields must guard against `resource == null` (the document does not yet exist). Without this, a `snapshots()` listener on a non-existent document always fails with `PERMISSION_DENIED`.

```
// Wrong — crashes when document doesn't exist
allow read: if isAuth() && resource.data.ownerId == request.auth.uid;

// Correct
allow read: if isAuth() && (resource == null || resource.data.ownerId == request.auth.uid);
```

Always validate rules with the Firebase MCP before deploying:
```
firebase_validate_security_rules(type: "firestore", source_file: "firestore.rules")
firebase deploy --only firestore:rules --project melodi-music-app
```

## Key Constraints

- `DeviceService` only supports Android and iOS — throws `UnsupportedError` on other platforms.
- The `createdAt`, `platform`, and `initialCreditsGranted` fields on `devices` documents are immutable (enforced by Firestore rules).
- `UserModel.email` is an empty string for anonymous users (not null).
- `UserModel.plan` defaults to `'starter'` (free tier). Check `auth.userModel?.plan` for premium gating.
- Every anonymous sign-in creates a new `users/{uid}` document — anonymous UIDs are not stable across sign-outs.
