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
  apiKey:'your-ozow-api-key',
  amount: 50.00,
  isTest: true,
  notifyUrl: 'your-notify-url'
  onComplete: (OzowTransaction? transaction, OzowStatus status) {
    //TODO: Something cool here    
  },
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
| apiKey        | Your Ozow API key. | Yes | String |
| isTest        | Flag to indicate test transactions. | Yes | bool  |
| onComplete    | Callback function for when the transaction is complete. | No  | Function(OzowTransaction?,OzowStatus)? |
| notifyUrl     | URL for notifications. | Yes  | String |
| successUrl    | URL for successful payments. | No  | String? |
| errorUrl      | URL for failed payments. | No  | String? |
| cancelUrl     | URL for cancelled payments. | No  | String? |
| optional1     | Additional optional parameter. | No  | String? |
| optional2     | Additional optional parameter. | No  | String? |
| optional3     | Additional optional parameter. | No  | String? |
| optional4     | Additional optional parameter. | No  | String? |
| optional5     | Additional optional parameter. | No  | String? |

# Handling Ozow Responses

Handling Ozow responses is crucial for merchants to update their backend systems properly. There are two types of responses you'll need to manage:

## Types of Responses

1. Redirect Response
2. Notification Response

For more information, you can visit [Ozow Documentation](https://hub.ozow.com/docs/step-2-process-ozow-response).

## Hash Validation

It's important to validate the received responses to confirm their authenticity. You can do this by generating a hash on your end and comparing it with the one sent by Ozow.

### Hash String Order

The order in which you concatenate the variables to generate the hash string is crucial. Below is a PHP example showing how to generate this hash string based on the variables you've provided:

```php
$hashStr = $siteCode . "ZA" . "ZAR" . $amount . $transactionId . $bank_reference . $customer . $optional1 . $optional2 . $optional3 . $optional4 . $optional5 . $notifyUrl . $successUrl . $errorUrl . $cancelUrl . $isTest . $privateKey;
```

**Note**: Omit any variables that you did not provide on the FlutterOzow widget.

By following these steps, you'll be able to effectively handle and validate Ozow responses in your merchant system.

##### Handling response on your flutter app
Refer to the `example` app

## Examples

For more examples, see the `example` directory.

### Support
<a href="https://www.buymeacoffee.com/misomenze"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width="150" /></a>
## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Miso-0/flutter_ozow/blob/main/flutter_ozow/LICENSE) file for details.
