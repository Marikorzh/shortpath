import 'package:flutter_test/flutter_test.dart';
import 'package:shortpath/http/model.dart';
import 'package:shortpath/bfs_algorithm/bfs_algorithm.dart'; // Імпортуємо функцію

void main() {
  group('findShortestPath Tests', () {
    // Тест на знаходження шляху в полі без перешкод
    test('Find path in open field', () {
      List<String> field = [
        '...',
        '...',
        '...',
      ];
      Coordinates start = Coordinates(0, 0);
      Coordinates end = Coordinates(2, 2);

      List<Map<String, int>> result = findShortestPath(field, start, end);
      List<Map<String, int>> expectedPath = [
        {'x': 0, 'y': 0},
        {'x': 1, 'y': 1},
        {'x': 2, 'y': 2},
      ];

      expect(result, equals(expectedPath));
    });

    // Тест на знаходження шляху з перешкодами
    test('Find path with obstacles', () {
      List<String> field = [
        '...',
        '.X.',
        '...',
      ];
      Coordinates start = Coordinates(0, 0);
      Coordinates end = Coordinates(2, 2);

      List<Map<String, int>> result = findShortestPath(field, start, end);
      List<Map<String, int>> expectedPath = [
        {'x': 0, 'y': 0},
        {'x': 1, 'y': 0},
        {'x': 2, 'y': 1},
        {'x': 2, 'y': 2},
      ];

      expect(result, equals(expectedPath));
    });

    // Тест, коли шлях неможливий
    test('No path available', () {
      List<String> field = [
        '...',
        '.X.',
        '.X.',
      ];
      Coordinates start = Coordinates(0, 0);
      Coordinates end = Coordinates(2, 2);

      List<Map<String, int>> result = findShortestPath(field, start, end);

      expect(result, isEmpty); // Перевіряємо, що шлях не знайдено
    });

    // Тест на діагональні переміщення
    test('Find path with diagonal moves', () {
      List<String> field = [
        '.X.',
        'X.X',
        'XX.',
      ];
      Coordinates start = Coordinates(0, 0);
      Coordinates end = Coordinates(2, 2);

      List<Map<String, int>> result = findShortestPath(field, start, end);
      List<Map<String, int>> expectedPath = [
        {'x': 0, 'y': 0},
        {'x': 1, 'y': 1},
        {'x': 2, 'y': 2},
      ];

      expect(result, equals(expectedPath));
    });
  });
}
