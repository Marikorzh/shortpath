import 'package:flutter/material.dart';
import 'package:shortpath/pages/preview_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../bfs_algorithm/bfs_algorithm.dart';
import '../http/model.dart';

class ResultListScreen extends StatefulWidget {
  final List<Data> item;
  final String url;
  const ResultListScreen(this.item, this.url, {super.key});

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {

  Future<void> _sendProcessedData(List<Map<String, dynamic>> processedData) async {
    final url = Uri.parse('https://flutter.webspark.dev/flutter/api');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(processedData),
    );

    if (response.statusCode == 200) {
      print('Дані успішно відправлені');
    } else {
      print('Помилка: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> processedData = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {

              _sendProcessedData(processedData);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.item.length,
        itemBuilder: (context, index) {
          var item = widget.item[index];

          List<Map<String, int>> path = findShortestPath(item.field.toList(), item.start, item.end);

          String formattedPath = path.map((step) => "(${step['x']},${step['y']})").join("->");

          processedData.add({
            "id": item.id,
            "result": {
              "steps": path,
              "path": formattedPath,
            }
          });

          return ListTile(
            title: Text(
              formattedPath,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                    item.field.toList(),
                    path,
                    item.start,
                    item.end,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
