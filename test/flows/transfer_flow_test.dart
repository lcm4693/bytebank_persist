import 'package:bytebank_persist/components/response_dialog.dart';
import 'package:bytebank_persist/components/transaction_auth_dialog.dart';
import 'package:bytebank_persist/main.dart';
import 'package:bytebank_persist/models/contact.dart';
import 'package:bytebank_persist/models/transaction.dart';
import 'package:bytebank_persist/screens/contacts_list.dart';
import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:bytebank_persist/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../matchers/matchers.dart';
import '../mock/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should test a transfer to a contact',
      (WidgetTester tester) async {
    final mockContactDAO = MockContactDAO();
    final mockTransactionWebClient = MockTransactionWebClient();

    await tester.pumpWidget(ByteBankApp(
      contactDAO: mockContactDAO,
      transactionWebClient: mockTransactionWebClient,
    ));

    final dashboard = find.byType(Dashboard);

    expect(dashboard, findsOneWidget);

    final Contact contact = Contact(0, 'Diego', 1000);

    when(mockContactDAO.findAll())
        .thenAnswer((realInvocation) async => [contact]);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactList = find.byType(ContactsList);

    expect(contactList, findsOneWidget);

    verify(mockContactDAO.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Diego' &&
            widget.contact.accountNumber == 1000;
      }
      return false;
    });

    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Diego');
    expect(contactName, findsOneWidget);

    final accountNumber = find.text('1000');
    expect(accountNumber, findsOneWidget);

    final textField = find.byWidgetPredicate((widget) {
      if (textFieldMatcher(widget, 'Value')) {
        return true;
      }
      return false;
    });

    expect(textField, findsOneWidget);

    await tester.enterText(textField, '200');

    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);

    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword = find.byKey(chaveCampoSenha);
    expect(textFieldPassword, findsOneWidget);

    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(Transaction(null, 200, contact), '1000'))
        .thenAnswer((_) async => Transaction(null, 200, contact));

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);

    final okButton = find.widgetWithText(FlatButton, 'Ok');
    expect(okButton, findsOneWidget);

    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactListBack = find.byType(ContactsList);
    expect(contactListBack, findsOneWidget);
  });
}
