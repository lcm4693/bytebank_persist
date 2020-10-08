import 'package:bytebank_persist/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: ListView(
          children: <Widget>[
            Card(
                child: ListTile(
              title: Text(
                'Diego',
                style: TextStyle(fontSize: 24.0),
              ),
              subtitle: Text(
                '12',
                style: TextStyle(fontSize: 16.0),
              ),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ContactForm();
            })).then((value) => {debugPrint(value.toString())});
          },
          child: Icon(Icons.add),
        ));
  }
}
