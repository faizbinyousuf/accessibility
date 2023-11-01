import 'package:hive/hive.dart';

class HiveManager {
  static late Box _box;

  static Future<void> initialize() async {
    _box = await Hive.openBox('tasksBox');
  }

  static Box get box {
    if (_box == null) {
      throw Exception(
          'Hive box has not been initialized. Call HiveBox.initialize() first.');
    }
    return _box;
  }
}
