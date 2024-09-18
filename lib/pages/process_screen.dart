import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortpath/http/bloc_api/api_event_bloc.dart';
import 'package:shortpath/pages/result_list_screen.dart';

import '../http/bloc_api/api_bloc.dart';
import '../http/bloc_api/api_state_bloc.dart';

class ProcessScreen extends StatefulWidget {
  final String url;
  ProcessScreen(this.url, {super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  int fakeProgress = 0; // Прогрес для симуляції
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFakeLoading();
  }

  void _startFakeLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (fakeProgress < 99) {
        setState(() {
          fakeProgress += 1; // Збільшуємо прогрес на 1
        });
      } else {
        _timer?.cancel(); // Зупиняємо таймер, коли досягаємо 99
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Зупиняємо таймер при виході зі сторінки
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Screen'),
      ),
      body: BlocProvider(
        create: (_) => ApiBloc()..add(FetchApiData(url: widget.url)), // Додаємо подію для завантаження даних
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
                        child: CircularProgressIndicator(value: fakeProgress / 100)),
                    const SizedBox(height: 20),
                    Text('$fakeProgress%', style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ); // Стан завантаження
            } else if (state is ApiLoaded) {
              _timer?.cancel(); // Зупиняємо "несправжнє" завантаження
              return Stack(
                children: [
                  const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'All calculation has finished, you can send your results to server',
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
                                value: 1, // Повний прогрес (100%)
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultListScreen(state.data),
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
              return Center(
                  child: Text('Error: ${state.message}')); // Стан помилки
            }

            return const Center(child: Text('Немає даних')); // Початковий стан
          },
        ),
      ),
    );
  }
}
