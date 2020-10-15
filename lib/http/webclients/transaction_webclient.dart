import 'dart:convert';
import 'package:bytebank_persist/http/webclient.dart';
import 'package:bytebank_persist/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseURL);

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJSON = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 2));

    final Response response = await client.post(baseURL,
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJSON);

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw new HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return TransactionWebClient._statusCodeResponses[statusCode];
    }

    return 'Unknown error';
  }

  static Map<int, String> _statusCodeResponses = {
    400: 'There was an error submitting a transaction',
    401: 'Authentication failed',
    409: 'Transaction already exists'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
