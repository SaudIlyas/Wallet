# Wallet

**An offline personal finance app for keeping track of everyday income and expenses.**

Built with Flutter, Wallet brings transaction tracking, cashflow summaries, and local database backups into a simple interface with light and dark themes. Start without creating an online account, choose your preferred currency, and organize transactions using categories that fit your life.

[Releases](https://github.com/SaudIlyas/Wallet/releases) · [Report an issue](https://github.com/SaudIlyas/Wallet/issues)

## Features

- **Income and expense tracking** — add transactions with an amount, title, account, category, date, time, and notes.
- **Transaction management** — review, edit, and delete saved entries.
- **Cashflow overview** — view income, expenses, and net cashflow, with a date-range filter for transaction history.
- **Currency selection** — search 39 currencies by name or code during setup. Your selection is used when displaying amounts.
- **Personal categories** — select suggested categories or add your own, then use them in the transaction picker.
- **Local storage** — store transactions on your device using Isar Community, without an online account.
- **Backup and restore** — export an `.isar` database backup through the system file picker and restore expenses from a saved backup.
- **Light and dark themes** — switch appearance from Settings.

## Getting started

1. Open Wallet and choose **Offline account**.
2. Import an existing Wallet backup, or continue without importing.
3. Search for and select your currency.
4. Select your categories and optionally add custom categories.
5. Tap **Finish** to save your preferences and open the dashboard.

Setup preferences are saved between launches. Currency selection controls formatting; it does not convert transaction amounts or fetch exchange rates.

## Data and backups

Wallet stores transactions locally and has no built-in cloud synchronization. Export backups regularly, especially before uninstalling the app, clearing app storage, or moving to another device.

In **Settings → Backup & Restore**:

- **Create Backup** opens the system save dialog and exports a timestamped `.isar` file.
- **Restore Backup** lets you select an existing `.isar` backup. Its expenses replace the current expense collection; this is not a merge.

Backups contain transaction data. Currency, category preferences, and theme settings are stored separately and are not included in the database backup. Backup files are not encrypted by this export feature; keep them somewhere private.

## Run from source

Android is the primary development target. The repository includes Flutter platform folders for iOS, macOS, Windows, Linux, and web, but their presence does not imply that all platforms are supported or release-tested.

### Prerequisites

- Flutter **3.44.9**, the current development SDK, with its bundled Dart SDK.
- Android SDK tools and an Android device or emulator.
- A JDK compatible with the project's Gradle wrapper. The current wrapper is **Gradle 9.1.0**, which supports JDK 25.
- On Windows, Developer Mode enabled for Flutter plugin symlink support.

The current Android configuration uses AGP **9.0.1** and Kotlin Gradle Plugin **2.3.20**. With Flutter 3.44.9, keep the existing `android.builtInKotlin=false` and `android.newDsl=false` compatibility settings.

### Installation

```sh
git clone https://github.com/SaudIlyas/Wallet.git
cd Wallet
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Run the code-generation command again after changing Isar collection models. Configure machine-specific SDK paths locally; do not commit `android/local.properties`.

## Build an Android release

Before distributing a public build, choose a permanent Android application ID and configure your own release signing key. The current project still uses the placeholder `com.example.wallet` application ID and debug signing for its release build type.

Follow Flutter's [Android signing instructions](https://docs.flutter.dev/deployment/android#sign-the-app), keep signing credentials out of Git, and retain the same signing key for future app updates.

Once signing is configured:

```sh
flutter build apk --release
```

The universal APK is written to:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Attach the APK to a [GitHub Release](https://github.com/SaudIlyas/Wallet/releases), rather than committing it to the source repository. A GitHub release asset can be uploaded even though APK files are excluded by `.gitignore`.

The app version is defined in `pubspec.yaml` as `version: 1.0.0+1`: `1.0.0` is the display version and `1` is the build number. Increase the build number for subsequent Android releases.

## Project structure

```text
lib/
├── components/       Reusable interface components and settings
├── database/         Expense persistence, backup, and restore
├── helper/           Amount formatting and conversion helpers
├── models/           Expense model, generated schema, and preferences
├── theme/            Light and dark theme configuration
├── first_setup.dart  Currency and category onboarding
├── add_transaction.dart
├── home_page.dart
└── main.dart
```

### Built with

| Component | Purpose |
| --- | --- |
| Flutter & Dart | Application and interface |
| Isar Community | Local transaction database |
| Provider | Expense and theme state |
| Shared Preferences | Setup preferences and theme persistence |
| File Picker | Backup export and file selection |
| intl | Currency and date formatting |

## Feedback and contributions

Bug reports and focused improvements are welcome. When reporting an issue, include your device, Android version, app version, reproduction steps, and relevant error output. Remove personal financial information from screenshots and logs before sharing them.

For changes to database models or backup behavior, describe how existing saved data is preserved.

## License

No license file is currently included in this repository. A license should be added before granting general permission to reuse or redistribute the code.