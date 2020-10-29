import 'package:bytebank_persist/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return a value when create a transaction', () {
    final Transaction transaction = new Transaction(null, 200, null);
    expect(transaction.value, 200);
  });

  test(
      'Should display an error when create a transaction with value less than zero',
      () {
    expect(() => Transaction(null, 0, null), throwsAssertionError);
  });
}
