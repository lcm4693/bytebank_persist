import 'package:bytebank_persist/database/app_database.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDAO {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  static const String tableSQL = 'CREATE TABLE $_tableName '
      '($_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    // Já faz o auto incremento
    // contactMap['id'] = contact.id;
    contactMap['$_name'] = contact.name;
    contactMap['$_accountNumber'] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();
    for (Map<String, dynamic> map in result) {
      final Contact contact = Contact(
        map['$_id'],
        map['$_name'],
        map['$_accountNumber'],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
