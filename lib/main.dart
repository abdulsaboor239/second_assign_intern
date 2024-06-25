import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Handling Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<String> getFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  Future<void> writeToFile(String filename, List<String> data) async {
    try {
      final path = await getFilePath(filename);
      final file = File(path);
      final sink = file.openWrite();
      for (String line in data) {
        sink.writeln(line);
      }
      await sink.flush();
      await sink.close();
    } catch (e) {
      print('An error occurred while writing to the file: $e');
    }
  }

  Future<List<String>> readFromFile(String filename) async {
    try {
      final path = await getFilePath(filename);
      final file = File(path);
      return await file.readAsLines();
    } catch (e) {
      print('An error occurred while reading the file: $e');
      return [];
    }
  }

  Future<void> processFileData(String inputFilename, String outputFilename) async {
    try {
      final data = await readFromFile(inputFilename);
      final reversedData = data.map((line) => line.split('').reversed.join()).toList();
      await writeToFile(outputFilename, reversedData);
    } catch (e) {
      print('An error occurred while processing the file data: $e');
    }
  }

  void testFunctions() async {
    final inputFilename = 'input.txt';
    const outputFilename = 'output.txt';
    final data = [
      "Apple",
      "Banana",
      "Cherry",
      "Date",
      "Coconut",
      "Fig",
      "Grape",
      "Honeydew",
      "Mango",
      "Orange"
    ];

    // Test writeToFile
    await writeToFile(inputFilename, data);

    // Test readFromFile
    final readData = await readFromFile(inputFilename);
    assert(readData.join(',') == data.join(','), 'Expected $data but got $readData');

    // Test processFileData
    await processFileData(inputFilename, outputFilename);
    final reversedData = data.map((line) => line.split('').reversed.join()).toList();
    final readReversedData = await readFromFile(outputFilename);
    assert(readReversedData.join(',') == reversedData.join(','), 'Expected $reversedData but got $readReversedData');

    print('All tests passed.');
  }

  @override
  Widget build(BuildContext context) {
    testFunctions(); // This is just for demonstration purposes. Usually, you'd call this in response to a user action.

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Handling Demo'),
      ),
      body: const Center(
        child: Text('Check console for test results.'),
      ),
    );
  }
}
