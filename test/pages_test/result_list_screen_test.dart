import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shortpath/pages/result_list_screen.dart';
import 'package:shortpath/pages/preview_screen.dart';
import 'package:shortpath/http/model.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('ResultListScreen Tests', () {
    late List<Data> mockData;
    late NavigatorObserver mockObserver;

    setUp(() {
      // Створюємо тестові дані
      mockData = [
        Data(
          id: '1',
          field: ['..X', '.X.', '..X'],
          start: Coordinates(0, 0),
          end: Coordinates(2, 2),
        ),
        Data(
          id: '2',
          field: ['.XX', '...', 'XXX'],
          start: Coordinates(0, 0),
          end: Coordinates(1, 1),
        ),
      ];

      // Мокаємо навігацію
      mockObserver = MockNavigatorObserver();
    });

    // Тест рендерингу списку
    testWidgets('Рендеринг елементів списку', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResultListScreen(mockData),
          navigatorObservers: [mockObserver],
        ),
      );

      // Перевіряємо, що на екрані є елементи списку
      expect(find.byType(ListTile), findsNWidgets(mockData.length));

      // Перевіряємо правильність відображення відформатованого шляху
      expect(find.text('(0,0)->(1,1)->(2,2)'), findsOneWidget);
      expect(find.text('(0,0)->(0,1)->(1,1)'), findsOneWidget);
    });

    // Тест на навігацію при натисканні на елемент
    testWidgets('Перехід до PreviewScreen при натисканні на елемент списку', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResultListScreen(mockData),
          navigatorObservers: [mockObserver],
        ),
      );

      // Перевіряємо наявність елемента списку
      final listItem = find.text('(0,0)->(1,1)->(2,2)');
      expect(listItem, findsOneWidget);

      // Натискаємо на елемент списку
      await tester.tap(listItem);
      await tester.pumpAndSettle(); // Чекаємо на завершення анімацій

      // Перевіряємо, що сталася навігація на PreviewScreen
      verify(() => mockObserver.didPush(any(), any())).called(1);
      expect(find.byType(PreviewScreen), findsOneWidget);
    });
  });
}
