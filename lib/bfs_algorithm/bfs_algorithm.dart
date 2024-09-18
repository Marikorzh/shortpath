import 'dart:collection';
import 'package:shortpath/http/model.dart';

List<Map<String, int>> findShortestPath(List<String> field, Coordinates start, Coordinates end) {
  // Напрямки переміщення: вгору, вниз, вліво, вправо
  List<Coordinates> directions = [
    Coordinates( -1, 0),
    Coordinates(1, 0),
    Coordinates(0, -1),
    Coordinates(0, 1),
    Coordinates(-1, -1), // Вліво-вгору
    Coordinates(-1, 1),  // Вправо-вгору
    Coordinates(1, -1),  // Вліво-вниз
    Coordinates(1, 1)
  ];

  int rows = field.length;
  int cols = field[0].length;

  // Черга для BFS
  Queue<List<Coordinates>> queue = Queue();
  queue.add([start]);

  // Відстеження відвіданих клітинок
  Set<Coordinates> visited = {start};

  // BFS
  while (queue.isNotEmpty) {
    List<Coordinates> path = queue.removeFirst();
    Coordinates current = path.last;

    // Якщо досягли кінцевої точки
    if (current == end) {
      return path.map((p) => {"x": p.x, "y": p.y}).toList();
    }

    // Переміщуємося в усіх можливих напрямках
    for (Coordinates direction in directions) {
      int newX = current.x + direction.x;
      int newY = current.y + direction.y;

      if (newX >= 0 && newX < rows && newY >= 0 && newY < cols && field[newX][newY] != 'X') {
        Coordinates next = Coordinates(newX, newY);

        // Якщо клітинка ще не відвідана
        if (!visited.contains(next)) {
          visited.add(next);
          List<Coordinates> newPath = List.from(path)..add(next);
          queue.add(newPath);
        }
      }
    }
  }

  // Якщо шлях не знайдений, повертаємо порожній список
  return [];
}