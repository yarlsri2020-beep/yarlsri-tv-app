# YARLSRI TV Flutter App (Android + iOS)

This source package includes the official user-provided logo, a splash screen, branded home dashboard, bottom navigation, WebView website access, retry/error state, and share functionality.

## Setup

1. Install Flutter and Android Studio (for Android); Xcode on macOS (for iOS).
2. Run `flutter create --platforms=android,ios yarlsri_tv` in a working directory.
3. Copy this package's `lib/`, `assets/`, and `pubspec.yaml` into the generated `yarlsri_tv` project.
4. Run `flutter pub get` and `flutter run`.
5. Android release: `flutter build apk --release`.
6. iOS release (macOS/Xcode, signing required): `flutter build ios --release`.

## Platform setup

- Ensure Android `android/app/src/main/AndroidManifest.xml` has `<uses-permission android:name="android.permission.INTERNET" />` directly under `<manifest>`.
- Set Android launcher icon and iOS AppIcon using `assets/images/app_icon.png` (e.g. with `flutter_launcher_icons`, or via native asset catalogs).
- Configure bundle/application IDs, app display name, signing, and store privacy disclosures before publishing.
- Some embedded live players, autoplay and fullscreen behavior may require additional site/player changes or native streaming integration.

## IMPORTANT

The constants `liveUrl`, `newsUrl`, and `videosUrl` currently point to the homepage, not verified section URLs. Replace them with correct URLs from the website or a licensed streaming endpoint. This is source code, not a compiled APK/IPA. Store acceptance is not guaranteed; add native value and test on devices.


## Live TV (v1.2)
The Live TV tab now uses `video_player` with the supplied HTTPS HLS `.m3u8` URL. It supports play/pause, mute, retry, and pausing when the app goes to the background. Stream playback has **not** been verified on a physical Android/iOS device.

To create a full Flutter project (this ZIP contains the app source/assets, not generated platform folders):
```sh
flutter create yarlsri_tv
# Copy lib/, assets/, pubspec.yaml from this package into the generated project
flutter pub get
flutter run
flutter build apk --release
```

For iOS, use macOS with Xcode and test on a real device before distribution. Ensure AndroidManifest.xml includes `<uses-permission android:name="android.permission.INTERNET" />` (typically present in debug templates but should be explicitly added to main manifest for release). App icons and signing/store submission require separate configuration.
