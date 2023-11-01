import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileService {
  Future<void> saveJsonData() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = File('${documentsDirectory.path}/server.json');

    // Check if the file already exists
    if (await filePath.exists()) {
      log('File already exists. Data not saved.');
    } else {
      // Convert the JSON data to a string
      final jsonString = jsonEncode(dummyData);

      // Write the JSON data to the file
      await filePath.writeAsString(jsonString);
      log('Data saved to server.json');
    }
  }

  Future<List<Map<String, dynamic>>?> readJsonData() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = File('${documentsDirectory.path}/server.json');

    // Check if the file exists
    if (await filePath.exists()) {
      try {
        final jsonString = await filePath.readAsString();
        final jsonData = jsonDecode(jsonString);
        if (jsonData is List) {
          return jsonData.cast<Map<String, dynamic>>();
        }
      } catch (e) {
        log('Error reading or parsing JSON: $e');
      }
    } else {
      log('File does not exist.');
    }

    return null;
  }

  Future<void> modifyAndSaveJsonData(
    String itemId,
    Map<dynamic, dynamic> updatedData,
  ) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = File('${documentsDirectory.path}/server.json');

    // Check if the file exists
    if (await filePath.exists()) {
      try {
        // Read the JSON data from the file
        final jsonString = await filePath.readAsString();
        final jsonData = jsonDecode(jsonString);

        if (jsonData != null) {
          // Find the index of the item to be updated
          final index = jsonData.indexWhere((item) => item['id'] == itemId);

          if (index != -1) {
            // Update the item with the new data
            jsonData[index]['title'] = updatedData['title'];
            jsonData[index]['isCompleted'] = updatedData['isCompleted'];

            // Convert the updated JSON data back to a string
            final updatedJsonString = jsonEncode(jsonData);

            // Write the updated JSON data back to the file, overwriting the existing file
            await filePath.writeAsString(updatedJsonString);
            log('Item with ID $itemId has been updated in server.json');
          } else {
            log('Item with ID $itemId not found in server.json');
          }
        } else {
          log('Invalid JSON format in server.json');
        }
      } catch (e) {
        log('Error reading, modifying, or saving JSON: $e');
      }
    } else {
      log('File does not exist.');
    }
  }

  Future<void> addNewTask(Map<dynamic, dynamic> newTask) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = File('${documentsDirectory.path}/server.json');

    if (await filePath.exists()) {
      try {
        // Read the current data from the server.json file
        final jsonString = await filePath.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);

        // Add the new task to the data
        jsonData.add(newTask);

        // Convert the updated data back to a string
        final updatedJsonString = jsonEncode(jsonData);

        // Write the updated JSON data back to the server.json file
        await filePath.writeAsString(updatedJsonString);
        log('New task has been added to server.json');
      } catch (e) {
        log('Error reading or updating server.json: $e');
      }
    } else {
      log('File does not exist.');
    }
  }
}

final List<Map<String, dynamic>> dummyData = [
  {"id": Uuid().v4(), "title": "Task 1", "isCompleted": true},
  {"id": Uuid().v4(), "title": "Task 2", "isCompleted": false},
  {"id": Uuid().v4(), "title": "Task 3", "isCompleted": false},
  {"id": Uuid().v4(), "title": "Task 4", "isCompleted": false},
];
