# Flutter Ozow

> Ozow links businesses of all sizes in South Africa with 47 million bank account holders to transact simply and securely. Sign up today!

For more information and reference, visit [ozow.com](https://ozow.com/).

**Disclaimer**: The developers of this package are independent and are not affiliated with Ozow. All Ozow images and trademarks are owned by Ozow.



[![pub package](https://img.shields.io/pub/v/flutter_ozow.svg)](https://pub.dev/packages/flutter_ozow)

Flutter_ozow is a Flutter package that simplifies the integration of the Ozow payment gateway into your Flutter apps. Utilizing the [webview_flutter](https://pub.dev/packages/webview_flutter) package, it loads the Ozow payment portal directly within your app for a seamless user experience.

## Features

- **Easy Initialization**: Minimal setup with required parameters.
- **URL Support**: Optional URLs for payment outcomes such as success, error, and cancellation.
- **Extra Parameters**: Allows for additional optional parameters for further customization.
- **In-App Payment**: Built-in WebView for a seamless payment process.

## Requirements

|             | Android        | iOS   |
|-------------|----------------|-------|
| **Support** | SDK 19+ or 20+ | 11.0+ |

```groovy
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

## Installation

To get started, add `flutter_ozow` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_ozow: ^latest_version
```

Run `flutter pub get` to install the package.

## Usage

First, import the package:

```dart
import 'package:flutter_ozow/flutter_ozow.dart';
```

Then, use the `FlutterOzow` widget in your widget tree:

```dart
FlutterOzow(
  transactionId: 'your-transaction-id',
  privateKey: 'your-private-key',
  siteCode: 'your-site-code',
  bankRef: 'bank-reference',
  amount: 50.00,
  isTest: true,
)
```

### Parameters

| Parameter      | Description   | Required  | Type   |
| --------------|---------------|-----------|--------|
| transactionId | Unique transaction ID from your backend. | Yes | Object |
| privateKey    | Your Ozow private key. | Yes | String |
| siteCode      | Your Ozow site code. | Yes | String |
| bankRef       | Reference for the user's bank statement. | Yes | String |
| amount        | Amount to be paid. | Yes | double |
| isTest        | Flag to indicate test transactions. | Yes | bool  |
| notifyUrl     | URL for notifications. | No  | String? |
| successUrl    | URL for successful payments. | No  | String? |
| errorUrl      | URL for failed payments. | No  | String? |
| cancelUrl     | URL for cancelled payments. | No  | String? |
| customName    | Custom name for the transaction. | No  | String? |
| optional1     | Additional optional parameter. | No  | String? |
| optional2     | Additional optional parameter. | No  | String? |
| optional3     | Additional optional parameter. | No  | String? |
| optional4     | Additional optional parameter. | No  | String? |
| optional5     | Additional optional parameter. | No  | String? |

## Examples

For more examples, see the `example` directory.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Miso-0/flutter_ozow/blob/main/flutter_ozow/LICENSE) file for details.
