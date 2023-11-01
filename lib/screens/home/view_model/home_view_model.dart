import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:map_test/screens/home/model/user_model.dart';
import 'package:map_test/screens/home/repo/home_repo.dart';
import 'package:map_test/services/network/api_client.dart';
import 'package:map_test/services/network/api_helper.dart';

class HomeViewModel with ChangeNotifier {
  final apiClient = ApiClient();
  late final apiHelper = ApiHelper(apiClient);
  late final homeRepo = HomeRepo(apiHelper);

  bool _isLoading = false;
  get isLoading => this._isLoading;
  set isLoading(value) => this._isLoading = value;

  List<User> _users = [];
  List<User> get users => this._users;

  set users(List<User> value) => this._users = value;
  String? _userName;
  String? _job;
  String? get userName => this._userName;

  set userName(String? value) => this._userName = value;

  get job => this._job;

  set job(value) => this._job = value;

  Future<void> getUsers() async {
    try {
      _isLoading = true;
      notifyListeners();

      _users = await homeRepo.fetchUser();
      log(users.toString());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
