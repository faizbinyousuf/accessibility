import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_test/screens/offline_sync/model/task_model.dart';
import 'package:map_test/services/file_services/file_service.dart';
import 'package:map_test/services/hive_manager.dart';
import 'package:uuid/uuid.dart';

class OfflineViewModel with ChangeNotifier {
  Uuid _uuid = Uuid();
  bool _isLoading = false;
  bool get isLoading => this._isLoading;

  set isLoading(bool value) => this._isLoading = value;
  List<dynamic> users = [];
  List<Task> _tasks = [];
  List<Task> get tasks => this._tasks;

  set tasks(List<Task> value) => this._tasks = value;

  String? _taskTitle;
  String? get taskTitle => this._taskTitle;
  set taskTitle(String? value) => this._taskTitle = value;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  ConnectivityResult get connectivityResult => this._connectivityResult;

  set connectivityResult(ConnectivityResult value) =>
      this._connectivityResult = value;

  FileService fileService = FileService();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  StreamSubscription<ConnectivityResult> get connectivitySubscription =>
      this._connectivitySubscription;

  set connectivitySubscription(StreamSubscription<ConnectivityResult> value) =>
      this._connectivitySubscription = value;

  final taskBox = HiveManager.box;
  bool _syncing = false;
  bool get syncing => this._syncing;

  set syncing(bool value) => this._syncing = value;
  Future<dynamic> initConnectivity() async {
    try {
      _connectivityResult = await _connectivity.checkConnectivity();
      log('connection result: $_connectivityResult');
    } catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(_connectivityResult);
  }

  addConnectivitySubscription() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityResult = result;

    log('connection status in update method: $_connectivityResult');
    notifyListeners();
  }

  //fetch tasks from mock data
  Future<void> fetchTasks() async {
    try {
      _isLoading = true;
      if (isOnline()) {
        /// mock a delay of 1 second
        await Future.delayed(const Duration(seconds: 1), () async {
          final tasksList = await fileService.readJsonData();
          log('tasks from server (json file): $tasksList');
          if (tasksList != null && tasksList.isNotEmpty) {
            //convert map to Task object
            _tasks =
                tasksList.map((taskMap) => Task.fromJson(taskMap)).toList();
            await saveTasksOffline(tasksList);
          }
        });
      } else {
        _tasks = await readTasksFromHive();
        log('tasks from hive: $_tasks');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error fetching tasks: $e');
      _isLoading = false;
    }
  }

  // read tasks from Hive

  Future<List<Task>> readTasksFromHive() async {
    List tasksFromHive = taskBox.values.toList();
    // List<Map<dynamic, dynamic>> tasksFromJson = tasksFromHive;
    log('tasks from hive read function: ${tasksFromHive}');
    // Convert Map entries to Task objects
    final mappedTaskList = tasksFromHive.map((taskMap) {
      return Task.fromJson(taskMap);
    }).toList();

    return mappedTaskList;
  }

  Future<void> saveTasksOffline(List<Map<String, dynamic>> taskMapList) async {
    try {
      // Get the current tasks from Hive
      final List existingTasks = taskBox.values.toList();

      // Filter out tasks that don't already exist in Hive
      final List<Map<dynamic, dynamic>> newTasks = taskMapList.where((newTask) {
        return !existingTasks
            .any((existingTask) => existingTask['id'] == newTask['id']);
      }).toList();

      // Add only the new tasks to Hive
      await taskBox.addAll(newTasks);

      // await taskBox.putAll(taskMap);
      log('Tasks saved successfully');
    } catch (e) {
      log('Tasks save failed $e');
    }
  }

  // update task status
  Future<void> updateTask(Task task, int index) async {
    task.isCompleted = !task.isCompleted!;

    if (isOnline()) {
      // Update server.json
      await fileService.modifyAndSaveJsonData(task.id!, task.toJson());
      // Update task in hive also
      final Map<dynamic, dynamic> taskMap = task.toJson();
      await taskBox.putAt(index, taskMap);
    } else {
      final Map<dynamic, dynamic> taskMap = task.toJson();
      await taskBox.putAt(index, taskMap);
    }

    notifyListeners();
  }

  // Add a new task

  Future<void> addTask() async {
    if (isOnline()) {
      final task = Task(
        id: _uuid.v4(),
        title: _taskTitle ?? '',
        isCompleted: false,
      );
      _tasks.add(task);
      // update server.json file with the new task
      await fileService.addNewTask(task.toJson());
      // update hive with the new task
      await taskBox.add(task.toJson());
    } else {
      await addTaskOffline();
    }

    notifyListeners();
  }

  // Add task offline
  Future<void> addTaskOffline() async {
    final task = Task(
      id: _uuid.v4(),
      title: _taskTitle ?? '',
      isCompleted: false,
    );

    await taskBox.add(task.toJson());
    _tasks.add(task);
    notifyListeners();
  }

  bool isOnline() {
    return _connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncDataWithServer() async {
    _syncing = true;
    notifyListeners();
    try {
      // mock a delay of 1 second for syncing data

      if (isOnline()) {
        await Future.delayed(const Duration(seconds: 1));
        // Read data fro hive
        final tasksInHive = await readTasksFromHive();
        // Convert the data to a format that can be sent to the server (server.json)
        final dataToSync = tasksInHive.map((task) => task.toJson()).toList();

        //iterate through dataToSync and sync changes in task

        for (final data in dataToSync) {
          await fileService.modifyAndSaveJsonData(data['id'], data);
        }

        // read latest data from server.json
        final data = await fileService.readJsonData();
        log('data after sync in json: $data');
        if (data != null) {
          final serverTasks =
              data.map((taskMap) => Task.fromJson(taskMap)).toList();
          // Find new tasks that are in Hive but not in server.json
          final newTasks = tasksInHive.where((task) =>
              !serverTasks.any((serverTask) => serverTask.id == task.id));
          // Add new tasks from Hive to the server data
          for (final newTask in newTasks) {
            await fileService.addNewTask(newTask.toJson());
          }
        }

        // read latest data from server.json
        final dataAfterSync = await fileService.readJsonData();
        _tasks =
            dataAfterSync!.map((taskMap) => Task.fromJson(taskMap)).toList();
        // save data back in hive
        //await saveTasksOffline(data!);
      } else {
        Fluttertoast.showToast(
          msg: 'No internet connection',
        );
      }
    } catch (e) {
      _syncing = false;
      notifyListeners();
      log('Error syncing data with server: $e');
    }

    _syncing = false;
    notifyListeners();
  }
}
