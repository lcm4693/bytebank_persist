import 'package:bytebank_persist/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  )),
              TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: RaisedButton(
                      onPressed: () {
                        final String name = _nameController.text;
                        final int account =
                            int.tryParse(_accountNumberController.text);
                        final Contact contact = Contact(name, account);

                        Navigator.pop(context, contact);
                      },
                      child: Text('Create'),
                    ),
                  ))
            ],
          )),
    );
  }
}
