# Prenumerata 

A Flutter application for managing personal subscriptions with animated list transitions and clean architecture.

## 📥 Download

### Release APK
The latest release APK is available in the `apk/` folder of this repository.

**[Download APK](./apk/app-release.apk)**

**Installation:**
1. Download the APK file from the apk folder
2. Enable "Install from unknown sources" in your Android settings
3. Install the APK on your Android device (Android 5.0+ required)

## Features

- 📱 **Subscription Management**: Add, update, and delete subscription lists
- 🎨 **Smooth Animations**: Animated list transitions with slide effects
- 📊 **Multiple Lists**: Organize subscriptions into different categories
- 🔄 **Real-time Updates**: Instant UI updates with BLoC state management
- 🎯 **Clean Architecture**: Separation of concerns with domain, data, and presentation layers

## Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and extensions
│   ├── extension/          # Object extensions
│   └── util/              # Utility classes (SnackToast, etc.)
├── domain/                 # Business logic layer
│   ├── entities/          # Data models
│   ├── exceptions/        # Custom exceptions
│   └── repository/        # Repository interfaces
├── data/                  # Data layer (not shown in provided files)
└── features/              # Feature modules
    └── home/
        └── presentation/
            ├── my_sub/    # My Subscriptions feature
            │   └── cubit/ # BLoC state management
            └── widget/    # Reusable widgets
```

## Key Components

### MySubscriptionCubit
The main state management component that handles:
- Loading subscription data from repository
- Managing tab changes with smooth animations
- Adding/updating subscriptions
- Animated list transitions

### Animation System
- **Slide Transitions**: Items slide in from right and out to left
- **Staggered Animations**: Multiple items animate with timing offsets
- **List Synchronization**: Proper handling of item additions and removals




## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- iOS Simulator / Android Emulator or physical device

### Installation

1. Clone the repository:
```bash
git clone https://github.com/manishrelani/Prenumerata.git
cd prenumerata
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

### Adding Subscriptions
1. Tap the "Add" button 
2. Fill in subscription details
3. Save to see smooth animation as item appears

### Managing Lists
1. Use tab navigation to switch between subscription lists
2. Items automatically animate when switching tabs
3. Edit existing subscriptions by tapping on them






