# CareLink

India's health companion — a single place for records, management, and care coordination.

CareLink brings together Patient records, Hospital Management System and Doctor's Portal into one intuitive experience designed for all users across India.

## Our Idea

CareLink started with a simple observation: managing healthcare records of patients, hospital inventory, & staff records across multiple clinics, and changing providers is fragmented and stressful. Our mission is to simplify that journey by creating a unified, secure health ledger that lives with all the three - patients, doctors & hospitals — not behind multiple portals.


## Quick Links

- **App name:** Healthcare Plus
- **Tagline:** Smart, Secure Health Management — Anywhere, Anytime

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application in development:
```bash
flutter run
```

## **Index of Contexts**

- **android:** Android-specific project and build configuration
- **ios:** iOS project, CocoaPods and Xcode configuration
- **lib:** Main Dart source code
  - **core:** Core services and utilities (auth, storage, network)
  - **presentation:** UI screens and widgets
  - **routes:** App routing definitions and navigation
  - **theme:** Theme and styling configuration
  - **widgets:** Reusable UI components
- **assets:** Images, fonts, and static assets
- **build:** Generated build artifacts
- **pubspec.yaml:** Dependency and asset configuration

Refer to the project folders for detailed implementations and generated outputs.

## 📁 Project Structure (overview)

```
healthcare_plus/
├── android/            # Android configuration & Gradle files
├── ios/                # iOS configuration & Xcode files
├── lib/                # Dart source code
│   ├── core/           # Core utilities and services
│   ├── presentation/   # UI screens and widgets
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```

## 🧩 Adding Routes

To add new routes to the application, update `lib/routes/app_routes.dart` and register the Widget builder for the new route.

Example:

```dart
import 'package:flutter/material.dart';
// import your screen widgets here

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
  };
}
```

## 🎨 Theming

Access the current theme via `Theme.of(context)` and use `theme.colorScheme` for consistent colors across light/dark modes.

## 📱 Responsive Design

This app uses responsive helpers (e.g., Sizer) for adapting layouts across devices.

## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🙏 Acknowledgments

- Built with Flutter & Dart
- Styled with Material Design

Built with ❤️
