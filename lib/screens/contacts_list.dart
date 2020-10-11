import 'package:bytebank_persist/components/centered_message.dart';
import 'package:bytebank_persist/components/progress.dart';
import 'package:bytebank_persist/database/dao/contact_dao.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/screens/contact_form.dart';
import 'package:bytebank_persist/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactsListState();
  }
}

class ContactsListState extends State<ContactsList> {
  final ContactDAO _dao = ContactDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transfer'),
        ),
        body: FutureBuilder<List<Contact>>(
          initialData: List(),
          future: _dao.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                debugPrint('None');
                break;
              case ConnectionState.waiting:
                debugPrint('Waiting');
                return Progress(
                  message: 'Waiting',
                );
                break;
              case ConnectionState.active:
                // Normalmente usado em streams
                debugPrint('Active');
                break;
              case ConnectionState.done:
                debugPrint('Done');
                final List<Contact> contacts = snapshot.data;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contact contact = contacts[index];
                    return _ContactItem(
                      contact,
                      onClick: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TransactionForm(contact)));
                      },
                    );
                  },
                  itemCount: contacts.length,
                );
                break;
            }

            return CenteredMessage('Unknown error');
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ContactForm();
            })).then((value) {
              setState(() {
                widget.createState();
              });
            });
          },
          child: Icon(Icons.add),
        ));
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(this.contact, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: onClick,
      title: Text(
        contact.name,
        style: TextStyle(fontSize: 24.0),
      ),
      subtitle: Text(
        contact.accountNumber.toString(),
        style: TextStyle(fontSize: 16.0),
      ),
    ));
  }
}
