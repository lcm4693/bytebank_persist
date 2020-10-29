import 'package:bytebank_persist/database/dao/contact_dao.dart';
import 'package:bytebank_persist/http/webclients/transaction_webclient.dart';
import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:bytebank_persist/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(ByteBankApp(
    contactDAO: ContactDAO(),
    transactionWebClient: TransactionWebClient(),
  ));
  // save(Transaction(123.9, Contact(0, 'diego', 1238)));
  // final List<Transaction> transactions = await findAll();
  // print(transactions.toString());
}

class ByteBankApp extends StatelessWidget {
  final ContactDAO contactDAO;

  final TransactionWebClient transactionWebClient;

  ByteBankApp({@required this.contactDAO, @required this.transactionWebClient});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      transactionWebClient: transactionWebClient,
      contactDAO: contactDAO,
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.green[900],
            accentColor: Colors.blueAccent[700],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary,
            )),
        home: Dashboard(),
        // debugShowCheckedModeBanner: false,
      ),
    );
  }
}
