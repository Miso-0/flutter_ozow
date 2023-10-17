/// Flutter Ozow - Ozow Payment Gateway Integration for Flutter Apps
///
/// A Flutter package that provides a simple and straightforward way to
/// integrate Ozow payment gateway into your Flutter application. This package
/// utilizes the [webview_flutter] package to load Ozow's payment portal within
/// a WebView, thereby offering an in-app payment experience.
///
/// ## Features:
/// - Easy initialization with minimal required parameters.
/// - Support for optional URLs to handle payment outcomes (Success, Error, Cancel).
/// - Additional optional parameters for further customization.
/// - Built-in WebView to facilitate the payment process.
///
/// ## Getting Started
/// To use this package, add `flutter_ozow` as a dependency in your pubspec.yaml file.
///
/// ```yaml
/// dependencies:
///   flutter:
///     sdk: flutter
///   flutter_ozow:
/// ```
///
/// ## Usage
/// Import the package and use `FlutterOzow` widget where you need it:
///
/// ```dart
/// import 'package:flutter_ozow/flutter_ozow.dart';
///
/// // In your widget tree
/// FlutterOzow(
///   transactionId: 'your-transaction-id',
///   privateKey: 'your-private-key',
///   siteCode: 'your-site-code',
///   bankRef: 'bank-reference',
///   amount: 50.0,
///   isTest: true,
/// )
/// ```
///
/// For more detailed usage instructions, check the `README.md` file.
///
library flutter_ozow;

// Exports the main widget
// export 'src/domain/banks.dart';
export 'src/domain/ozow_status.dart';
export 'src/domain/ozow_transaction.dart';
export 'src/presentation/flutter_ozow.dart';
