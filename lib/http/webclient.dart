import 'dart:convert';

import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('====Request====');
    print('url: ${data.baseUrl}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('====Response====');
    print('url: ${data.url}');
    print('status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }
}

final String baseURL = 'http://192.168.0.26:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Client client = HttpClientWithInterceptor.build(
    interceptors: [LoggingInterceptor()],
  );
  final Response response =
      await client.get(baseURL).timeout(Duration(seconds: 5));

  final List<dynamic> decodedJson = jsonDecode(response.body);

  final List<Transaction> transactions = List();

  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Transaction transaction = Transaction(
        transactionJson['value'],
        Contact(
          0,
          transactionJson['contact']['name'],
          transactionJson['contact']['accountNumber'],
        ));
    transactions.add(transaction);
  }

  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber,
    }
  };

  final String transactionJSON = jsonEncode(transactionMap);

  final Response response = await post(baseURL,
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJSON);

  Map<String, dynamic> json = jsonDecode(response.body);

  return Transaction(
      json['value'],
      Contact(
        0,
        json['contact']['name'],
        json['contact']['accountNumber'],
      ));
}
