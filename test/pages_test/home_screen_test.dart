import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortpath/pages/home_screen.dart';
import 'package:shortpath/pages/process_screen.dart';

void main() {
  testWidgets('Перевірка відображення віджетів', (WidgetTester tester) async {

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Set valid API base URL in order to continue:'), findsOneWidget);

    expect(find.byType(TextField), findsOneWidget);

    expect(find.text('Send'), findsOneWidget);
  });

  testWidgets('Перевірка введення некоректного URL', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    final textField = find.byType(TextField);

    await tester.enterText(textField, 'invalid-url');

    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Некоректний URL'), findsOneWidget);
  });

  testWidgets('Перевірка введення коректного URL та навігація', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    final textField = find.byType(TextField);

    await tester.enterText(textField, 'https://flutter.dev');

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.byType(ProcessScreen), findsOneWidget);
  });
}
