// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter_ozow/src/data/providers/ozow_provider.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'ozow_api_test.mocks.dart';

// @GenerateMocks([Dio, BaseOptions])
// void main() {
//   late final Dio mockDio;
//   late final IOzowDataSource ozowDataSource;

//   setUpAll(() {
//     mockDio = MockDio();
//     ozowDataSource = OzowApiDataSource(dio: mockDio);
//   });

//   group('Test the Ozow API Data source', () {
//     test('should return a newly generated payment link', () async {
//       //arrange
//       const path = 'https://api.ozow.com/postpaymentrequest';
//       const expectedLink = 'https://pay.ozow.com/pay/xxxxxx';

//       final json = jsonEncode({});

//       final mockOptions = MockBaseOptions();
//       when(mockOptions.headers).thenReturn({});
//       when(mockDio.options).thenReturn(mockOptions);
//       when(mockDio.post(path, data: json)).thenAnswer(
//         (_) async => Response(
//           data: {
//             'url': 'https://pay.ozow.com/pay/xxxxxx',
//             'transactionId': 'xxxxxx',
//             'message': 'message',
//           },
//           statusCode: 200,
//           requestOptions: RequestOptions(path: path),
//         ),
//       );

//       //act
//       final actual = await ozowDataSource.generateLink(
//         payment: {},
//         apiKey: 'xxx-xxx-xxx-xxx',
//       );

//       //assert
//       expectLater(actual, expectedLink);

//       verify(mockDio.post(path, data: anyNamed('data'))).called(1);
//     });
//   });
// }
