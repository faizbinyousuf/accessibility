import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_test/screens/home/view_model/home_view_model.dart';
import 'package:map_test/screens/offline_sync/view_model.dart/offline_view_model.dart';
import 'package:provider/provider.dart';

class OfflineSync extends StatefulWidget {
  const OfflineSync({super.key});

  @override
  State<OfflineSync> createState() => _OfflineSyncState();
}

class _OfflineSyncState extends State<OfflineSync> {
  final _newTaskController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<OfflineViewModel>(context, listen: false);
    viewModel.initConnectivity().then((value) =>
        {viewModel.addConnectivitySubscription(), viewModel.fetchTasks()});
  }

  @override
  void dispose() {
    super.dispose();
    _newTaskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OfflineViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Sync Example'),
        actions: [
          IconButton(
            onPressed: () async {
              await viewModel.syncDataWithServer();
            },
            icon: const Icon(Icons.sync),
          )
        ],
      ),
      // create a body with 2 text inputs
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                if (viewModel.connectivityResult ==
                    ConnectivityResult.none) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "No Internet Connection.\nYou are viewing offline data.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                if (viewModel.syncing) ...[
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        SizedBox(height: 10),
                        Text("Syncing data...")
                      ],
                    ),
                  )
                ],
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.tasks.length,
                    itemBuilder: (context, index) {
                      final task = viewModel.tasks[index];
                      return ListTile(
                        title: Text(task.title ?? ""),
                        trailing: task.isCompleted!
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          viewModel.updateTask(task, index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, viewModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    OfflineViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _newTaskController,
              autofocus: true,
              onChanged: (newValue) => viewModel.taskTitle = newValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter task',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await viewModel.addTask();

                  Navigator.of(context).pop();
                  _newTaskController.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
