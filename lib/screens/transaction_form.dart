import 'dart:async';

import 'package:bytebank_persist/components/progress.dart';
import 'package:bytebank_persist/components/response_dialog.dart';
import 'package:bytebank_persist/components/transaction_auth_dialog.dart';
import 'package:bytebank_persist/http/webclients/transaction_webclient.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/models/transaction.dart';
import 'package:bytebank_persist/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  // final TransactionWebClient _transactionWebClient = TransactionWebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Progress(message: 'Sending...'),
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                      labelText: 'Value',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue[200],
                              style: BorderStyle.solid,
                              width: 1.5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value, widget.contact);

                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                _save(dependencies.transactionWebClient,
                                    transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(TransactionWebClient webClient, Transaction transactionCreated,
      String password, BuildContext context) async {
    Transaction transact =
        await _send(webClient, transactionCreated, password, context);
    await _showSuccessfulMessage(transact, context);
  }

  Future _showSuccessfulMessage(
      Transaction transact, BuildContext context) async {
    if (transact != null) {
      await showDialog(
        context: context,
        builder: (contextSuccess) {
          return SuccessDialog('Successful transaction');
        },
      );
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(
      TransactionWebClient webClient,
      Transaction transactionCreated,
      String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction transact =
        await webClient.save(transactionCreated, password).catchError(
      (e) {
        _showFailureMessage(context, message: 'Timeout submitting the message');
      },
      test: (e) => e is TimeoutException,
    ).catchError(
      (e) {
        _showFailureMessage(context, message: e.message);
      },
      test: (e) => e is HttpException,
    ).catchError((e) {
      _showFailureMessage(context);
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transact;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown Error'}) {
    showDialog(
        context: context,
        builder: (contextFailure) {
          return FailureDialog(message);
        });
  }
}
