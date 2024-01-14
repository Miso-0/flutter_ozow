import 'package:flutter_ozow/src/data/data_source/ozow_data_source.dart';
import 'package:flutter_ozow/src/domain/entities/ozow_payment.dart';
import 'package:flutter_ozow/src/domain/repository/ozow_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'ozow_repository_test.mocks.dart';

@GenerateMocks([OzowApiDataSource])
void main() {
  late final IOzowDataSource mockOzowDataSource;
  // ignore: unused_local_variable
  late final OzowRepository ozowRepository;
  late final OzowPayment payment;

  setUp(() {
    mockOzowDataSource = MockOzowApiDataSource();
    payment = OzowPayment(
      transactionId: 1000,
      siteCode: 'siteCode',
      privateKey: 'privateKey',
      apiKey: 'apiKey',
      bankRef: 'bankRef',
      amount: 1050.54,
      isTest: true,
      notifyUrl: 'under-flow.info/packages/flutter_ozow',
    );
    ozowRepository = OzowRepository(
      dataSource: mockOzowDataSource,
      payment: payment,
    );
  });

  group('Unit test the ozow repository', () {});
}
