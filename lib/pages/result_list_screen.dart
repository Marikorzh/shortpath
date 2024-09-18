import 'package:flutter/material.dart';
import 'package:shortpath/pages/preview_screen.dart';
import '../bfs_algorithm/bfs_algorithm.dart';
import '../http/model.dart';

class ResultListScreen extends StatefulWidget {
  final List<Data> item;
  const ResultListScreen(this.item, {super.key});

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> processedData = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
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
