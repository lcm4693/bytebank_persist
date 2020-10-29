class Contact {
  final int id;
  final String name;
  final int accountNumber;

  Contact(
    this.id,
    this.name,
    this.accountNumber,
  );

  @override
  String toString() =>
      'Contact(id: $id, name: $name, accountNumber: $accountNumber)';

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'accountNumber': accountNumber,
      };

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Contact && o.name == name && o.accountNumber == accountNumber;
  }

  @override
  int get hashCode => name.hashCode ^ accountNumber.hashCode;
}
