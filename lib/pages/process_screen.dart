import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortpath/http/bloc_api/api_event_bloc.dart';
import 'package:shortpath/pages/result_list_screen.dart';
import 'package:http/http.dart' as http;
import '../http/bloc_api/api_bloc.dart';
import '../http/bloc_api/api_state_bloc.dart';
import '../bfs_algorithm/bfs_algorithm.dart'; // Імпортуємо алгоритм пошуку шляху

class ProcessScreen extends StatefulWidget {
  final String url;
  const ProcessScreen(this.url, {super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  int fakeProgress = 0;
  Timer? _timer;
  List<Map<String, dynamic>> processedData = []; // Зберігаємо оброблені дані

  Future<void> _sendProcessedData() async {
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
  void initState() {
    super.initState();
    _startFakeLoading();
  }

  void _startFakeLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (fakeProgress < 99) {
        setState(() {
          fakeProgress += 1;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Screen'),
      ),
      body: BlocProvider(
        create: (_) => ApiBloc()..add(FetchApiData(url: widget.url)),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(value: fakeProgress / 100),
                    ),
                    const SizedBox(height: 20),
                    Text('$fakeProgress%', style: const TextStyle(fontSize: 20)),
                  ],
                ),
              );
            } else if (state is ApiLoaded) {
              var items = state.data;

              for (var item in items) {
                List<Map<String, int>> path = findShortestPath(item.field.toList(), item.start, item.end);

                String formattedPath = path.map((step) => "(${step['x']},${step['y']})").join("->");

                processedData.add({
                  "id": item.id,
                  "result": {
                    "steps": path,
                    "path": formattedPath,
                  }
                });
              }

              _timer?.cancel();
              return Stack(
                children: [
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All calculations have finished, you can send your results to the server',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '100%',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            value: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _sendProcessedData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultListScreen(items), // Передаємо оброблені дані
                            ),
                          );
                        },
                        child: const Text('Відкрити нову сторінку'),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ApiError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const Center(child: Text('Немає даних'));
          },
        ),
      ),
    );
  }
}
