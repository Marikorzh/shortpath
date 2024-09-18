import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shortpath/http/bloc_api/api_bloc.dart';
import 'package:shortpath/http/bloc_api/api_event_bloc.dart';
import 'package:shortpath/http/bloc_api/api_state_bloc.dart';
import 'package:shortpath/http/model.dart';

import 'api_service_test.mocks.dart';  // Імпортуємо згенеровані моки

void main() {
  late ApiBloc apiBloc;
  late MockApiBloc mockApiService;

  setUp(() {
    mockApiService = MockApiBloc();  // Ініціалізуємо мок-сервіс
    apiBloc = ApiBloc();  // Ініціалізуємо BloC
  });

  tearDown(() {
    apiBloc.close();  // Закриваємо BloC після кожного тесту
  });

  group('ApiBloc tests', () {
    final mockData = ApiResponse(
      error: false,
      message: "OK",
      data: [
        Data(
          id: "7d785c38-cd54-4a98-ab57-44e50ae646c1",
          field: [".X.", ".X.", "..."],
          start: Coordinates( 2,  1),
          end: Coordinates( 0,  2),
        )
      ],
    );

    blocTest<ApiBloc, ApiState>(
      'emits [ApiLoading, ApiLoaded] when data is fetched successfully',
      build: () {
        when(mockApiService.fetchData('https://flutter.webspark.dev/flutter/api')).thenAnswer((_) async => mockData); // Мокаємо успішний виклик
        return ApiBloc();
      },
      act: (bloc) => bloc.add(FetchApiData()),  // Додаємо подію
      expect: () => [
        ApiLoading(),  // Очікуємо стан завантаження
        ApiLoaded(data: mockData.data),  // Потім успішний стан з даними
      ],
    );

    blocTest<ApiBloc, ApiState>(
      'emits [ApiLoading, ApiError] when fetch fails',
      build: () {
        when(mockApiService.fetchData('https://flutter.webspark.dev/flutter/api')).thenThrow(Exception('Failed to fetch data'));  // Мокаємо помилку
        return ApiBloc();
      },
      act: (bloc) => bloc.add(FetchApiData()),
      expect: () => [
        ApiLoading(),
        ApiError(message: 'Failed to fetch data: Exception: Failed to fetch data'),  // Очікуємо помилку
      ],
    );
  });
}
