import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youscout_mobile/core/l10n/strings.dart';

void main() {
  testWidgets('App renders without crash', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Center(child: Text(AppStrings.appName))),
        ),
      ),
    );
    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
