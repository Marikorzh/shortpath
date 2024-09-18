import 'package:flutter/material.dart';
import 'package:shortpath/pages/process_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: bottomFloatButton('Start counting process'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Set valid API base URL in order to continue:'),
            Row(
              children: [
                const Icon(Icons.compare_arrows),
                const SizedBox(width: 35),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 100,
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'URL',
                      errorText: _errorText,
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomFloatButton(String text) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          String url = _urlController.text;

          if (!_isValidUrl(url)) {
            setState(() {
              _errorText = 'Некоректний URL';
            });
          } else {
            setState(() {
              _errorText = null;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProcessScreen(url),
              ),
            );
          }
        },
        child: const Center(
          child: Text('Send'),
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.isAbsolute;
  }
}
