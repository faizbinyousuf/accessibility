import 'package:uuid/uuid.dart';

class Task {
  String? id;
  String? title;
  bool? isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  Task.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCompleted = json['isCompleted'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}
