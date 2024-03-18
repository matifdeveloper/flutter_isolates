/*
********************************************************************************

    _____/\\\\\\\\\_____/\\\\\\\\\\\\\\\__/\\\\\\\\\\\__/\\\\\\\\\\\\\\\_
    ___/\\\\\\\\\\\\\__\///////\\\/////__\/////\\\///__\/\\\///////////__
    __/\\\/////////\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\\\\\\\\\_____
    _\/\\\\\\\\\\\\\\\_______\/\\\___________\/\\\_____\/\\\///////______
    _\/\\\/////////\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\_____________
    _\/\\\_______\/\\\_______\/\\\________/\\\\\\\\\\\_\/\\\_____________
    _\///________\///________\///________\///////////__\///______________

    Created by Muhammad Atif on 3/18/2024.
    Portfolio https://atifnoori.web.app.
    IsloAI

 *********************************************************************************/

import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Isolates')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Run Heavy Task'),
              onPressed: () => useIsolate(),
              //runHeavyTaskWithOutIsolate(10000000000),
            ),
          ],
        ),
      ),
    );
  }
}

/// Executes a heavy task asynchronously using Isolate.
/// Function spawns an isolate to run a heavy task, receives the result, and logs it.
useIsolate() async {
  // Creates a communication port to receive messages in Dart's Isolate communication mechanism.
  final ReceivePort receivePort = ReceivePort();
  try {
    // Spawn an isolate to run the heavy task.
    await Isolate.spawn(
      runHeavyTaskIWithIsolate,
      [receivePort.sendPort, 10000000000],
    );
  } on Object {
    // Handle failure if the isolate fails to spawn.
    debugPrint('Isolate Failed');
    receivePort.close();
  }
  // Wait for the result from the isolate.
  final response = await receivePort.first;

  // Log the result.
  log('Result: $response');
}

// Description: Runs a heavy task within an Isolate and returns the result.
int runHeavyTaskIWithIsolate(List<dynamic> args) {
  SendPort resultPort = args[0];
  int value = 0;
  // Perform the heavy task.
  for (var i = 0; i < args[1]; i++) {
    value += i;
  }
  // Send the result back to the main isolate.
  Isolate.exit(resultPort, value);
}

// Description: Runs a heavy task without using Isolate and logs the result.
int runHeavyTaskWithOutIsolate(int count) {
  int value = 0;
  // Perform the heavy task.
  for (var i = 0; i < count; i++) {
    value += i;
  }
  // Log the result.
  log(value.toString());
  return value;
}

