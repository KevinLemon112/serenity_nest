# SerenityNest

SerenityNest is a Flutter application that provides mental health help.

## Features

- [Meditation]
- [Journaling]
- [Quote of the Day]
- [Resources]

## Getting Started

To get started with SerenityNest, follow these steps:

1. Clone this repository to your local machine.
2. Make sure you have Flutter installed. If not, follow the [Flutter installation instructions](https://flutter.dev/docs/get-started/install).
3. Install dependencies by running: 'npm install' and 'flutter pub get'
4. Add your Firebase configuration file (`google-services.json` for Android) to the `android/app` directory. Follow the [Firebase setup instructions](https://firebase.google.com/docs/flutter/setup) for more details.
5. Run the app: 'flutter run'

## Additional Setup

If you plan to release your app to the Google Play Store, make sure to:

- Configure Firebase Authentication and add both the debug and release SHA-1 keys to your Firebase project settings for Google Sign-In. Follow the [Firebase Authentication setup instructions](https://firebase.google.com/docs/auth) for more details.
- Set up your app's metadata and icons in the `android/app/src/main` directory.
- Follow the [Google Play Console release management](https://developer.android.com/studio/publish) guide for preparing and releasing your app.

## Contributing

Contributions are welcome! If you have any ideas for new features, find any bugs, or want to improve the code, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
