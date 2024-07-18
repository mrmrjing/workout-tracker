# Gym Workout Tracker App

This repository contains the Flutter project for the Gym Workout Tracker App, designed to help users track their fitness routines efficiently. This document provides instructions on setting up the development environment and running the application.

## Getting Started

Follow these instructions to set up your development environment and run the application on your local machine.

### Prerequisites

Ensure you have the following installed on your system:

- Flutter SDK
- Android Studio (includes Android SDK & Android Emulator)
- Xcode (for macOS users, for iOS development)
- CocoaPods (for managing iOS dependencies)

### Installation

### 1. **Flutter SDK**

Download and install the Flutter SDK from the [Flutter official site](https://flutter.dev/docs/get-started/install). Set the Flutter SDK path in your system's environment variables.

Example for macOS:

```bash
bashCopy code
export PATH="$PATH:/path/to/flutter/bin"
```

Add this line to your `~/.zshrc` or `~/.bash_profile` depending on your shell.

### 2. **Android Studio**

Download and install Android Studio from [here](https://developer.android.com/studio). During installation, ensure that the Android SDK, Android command-line tools, Android SDK Platform-tools, and Android Emulators are installed.

### 3. **Xcode (macOS)**

Install Xcode from the Mac App Store and ensure it is updated to the latest version. Configure Xcode command-line tools by running:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 4. **CocoaPods**

Install CocoaPods, which is required for iOS project dependencies management:

```bash
sudo gem install cocoapods
# or using Homebrew
brew install cocoapods
```

### Configuration

After installing the prerequisites, configure the Flutter environment:

```bash
flutter config --android-sdk <path-to-android-sdk>
flutter doctor
```

Accept the Android licenses by running: 

```bash 
flutter doctor --android-licenses
```

### Launching Simulators
### Android Simulator
Open Android Studio, go to AVD Manager, select your desired virtual device, and click Start.

### iOS Simulator
Open Xcode, select your Open Developer Tool > Simulator. Select your preferred device. 

### Running the Project

To run the project, first clone the repository and navigate to the project directory:

```bash
git clone https://github.com/mrmrjing/workout-tracker.git
cd workout_tracker
```

Then, execute the following command to run the app:

```bash
flutter run

```

### Validation

To ensure everything is set up correctly, run:

```bash
flutter doctor -v

```

This command checks your environment and displays a report to the terminal. Ensure that there are no issues in the sections relevant to the platforms you intend to develop for.
