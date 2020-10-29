import 'package:bytebank_persist/database/dao/contact_dao.dart';
import 'package:bytebank_persist/http/webclients/transaction_webclient.dart';
import 'package:mockito/mockito.dart';

class MockContactDAO extends Mock implements ContactDAO {}

class MockTransactionWebClient extends Mock implements TransactionWebClient {}
