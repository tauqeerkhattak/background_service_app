import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;
  bool isRunning = true;
  final service = FlutterBackgroundService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Service App'),
        centerTitle: true,
      ),
      floatingActionButton: _floatingActionButton(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Isolate have incremented counter this many times!',
            ),
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data!;
                return Text(
                  'Counter: ${data['counter'] ?? 'Counter not available'}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(
        isRunning ? Icons.pause : Icons.play_arrow,
      ),
      onPressed: () async {
        final temp = await service.isRunning();
        if (temp) {
          service.invoke('stopService');
          setState(() {
            isRunning = false;
          });
        } else {
          service.startService().then((value) {
            if (value) {
              setState(() {
                isRunning = true;
              });
            }
          });
        }
      },
    );
  }
}
