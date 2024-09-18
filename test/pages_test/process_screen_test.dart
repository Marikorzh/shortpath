import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shortpath/http/bloc_api/api_bloc.dart';
import 'package:shortpath/http/bloc_api/api_event_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortpath/http/model.dart';
import 'package:shortpath/pages/process_screen.dart';
import 'package:http/http.dart' as http;

// Мокаємо клас для HTTP-запитів
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
  });

  // Тестування успішного завантаження даних з API
  testWidgets('Тест симуляції успішного завантаження даних', (WidgetTester tester) async {
    // Створюємо "моканий" API-відповідь
    final mockApiResponse = ApiResponse(
      error: false,
      message: 'Success',
      data: [
        Data(
          id: '1',
          field: ['Test'],
          start: Coordinates(0, 0),
          end: Coordinates(1, 1),
        ),
      ],
    );

    // Мокаємо відповідь сервера
    when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(
        jsonEncode({
          'error': false,
          'message': 'Success',
          'data': [
            {
              'id': '1',
              'field': ['Test'],
              'start': {'x': 0, 'y': 0},
              'end': {'x': 1, 'y': 1},
            }
          ]
        }),
        200,
      ),
    );

    // Запускаємо екран із моканим HTTP-запитом
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => ApiBloc()..add(FetchApiData(url: 'https://valid.url')),
          child: ProcessScreen('https://valid.url'),
        ),
      ),
    );

    // Чекаємо на завантаження
    await tester.pumpAndSettle();

    // Перевіряємо, що показується початковий стан прогресу (0%)
    expect(find.text('0%'), findsOneWidget);

    // Прокручуємо час, щоб симулювати поступове збільшення прогресу
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('1%'), findsOneWidget);

    // Перевіряємо, що 100% прогрес і дані завантажено
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('All calculation has finished, you can send your results to server'), findsOneWidget);
  });

  // Тестування помилки при завантаженні
  testWidgets('Тест симуляції помилки при завантаженні даних', (WidgetTester tester) async {
    // Мокаємо відповідь сервера з помилкою
    when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response('Error', 404),
    );

    // Запускаємо екран
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => ApiBloc()..add(FetchApiData(url: 'https://invalid.url')),
          child: ProcessScreen('https://invalid.url'),
        ),
      ),
    );

    // Чекаємо на рендерінг інтерфейсу
    await tester.pumpAndSettle();

    // Перевіряємо, що показується помилка
    expect(find.textContaining('Error'), findsOneWidget);
  });
}
