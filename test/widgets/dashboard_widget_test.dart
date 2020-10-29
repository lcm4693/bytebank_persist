import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matchers.dart';

void main() {
  group('When dashboard is opened', () {
    testWidgets('Should display the main image', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Dashboard(),
      ));
      final mainImage = find.byType(Image);
      expect(mainImage, findsOneWidget);
    });

    testWidgets('Should display the first feature',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Dashboard(),
      ));

      final transferFeatureItem = find.byWidgetPredicate((Widget widget) {
        return featureItemMatcher(widget, 'Transfer', Icons.monetization_on);
      });

      expect(transferFeatureItem, findsOneWidget);
    });

    testWidgets('Should display the transaction feed feature',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Dashboard(),
      ));
      // final firstFeature = find.byType(FeatureItem);
      final transactionFeedFeatureItem =
          find.byWidgetPredicate((Widget widget) {
        return featureItemMatcher(
            widget, 'Transaction feed', Icons.description);
      });

      expect(transactionFeedFeatureItem, findsOneWidget);
    });
  });
}
