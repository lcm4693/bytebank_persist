import 'package:bytebank_persist/models/contact.dart';

class Transaction {
  final String id;
  final double value;
  final Contact contact;

  Transaction(
    this.id,
    this.value,
    this.contact,
  ) : assert(value > 0);

  @override
  String toString() => 'Transaction(id: $id, value: $value, contact: $contact)';

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'value': value, 'contact': contact.toJson()};

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Transaction && o.value == value && o.contact == contact;
  }

  @override
  int get hashCode => value.hashCode ^ contact.hashCode;
}
