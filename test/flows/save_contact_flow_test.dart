import 'package:bytebank_persist/main.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/screens/contact_form.dart';
import 'package:bytebank_persist/screens/contacts_list.dart';
import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mock/mocks.dart';

void main() {
  testWidgets('Should save a contact', (WidgetTester tester) async {
    final mockContactDAO = MockContactDAO();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(ByteBankApp(
      contactDAO: mockContactDAO,
      transactionWebClient: mockTransactionWebClient,
    ));

    final dashboard = find.byType(Dashboard);

    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));

    await tester.tap(transferFeatureItem);
    await tester.pumpAndSettle();

    final contactList = find.byType(ContactsList);

    expect(contactList, findsOneWidget);

    verify(mockContactDAO.findAll()).called(1);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);

    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final fullNameText = find.byWidgetPredicate(
        (Widget widget) => textFieldMatcher(widget, 'Full Name'));

    expect(fullNameText, findsOneWidget);

    await tester.enterText(fullNameText, 'Diego');

    final accountNumberText = find.byWidgetPredicate(
        (Widget widget) => textFieldMatcher(widget, 'Account Number'));

    expect(accountNumberText, findsOneWidget);

    await tester.enterText(accountNumberText, '1000');

    final createButton = find.widgetWithText(RaisedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDAO.save(Contact(0, 'Diego', 1000))).called(1);

    final contactsListBack = find.byType(ContactsList);

    expect(contactsListBack, findsOneWidget);

    verify(mockContactDAO.findAll()).called(1);
  });
}
