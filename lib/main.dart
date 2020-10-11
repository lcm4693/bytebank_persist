import 'package:bytebank_persist/http/webclient.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/models/transaction.dart';
import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(ByteBankApp());
  // save(Transaction(123.9, Contact(0, 'diego', 1238)));
  // final List<Transaction> transactions = await findAll();
  // print(transactions.toString());
}

class ByteBankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          )),
      home: Dashboard(),
    );
  }
}
