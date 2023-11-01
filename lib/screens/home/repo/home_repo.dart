import 'dart:convert';
import 'dart:developer';

import 'package:map_test/screens/home/model/user_model.dart';
import 'package:map_test/services/network/api_client.dart';
import 'package:map_test/services/network/api_end_points.dart';
import 'package:map_test/services/network/api_helper.dart';
import 'package:map_test/services/network/http_types.dart';

class HomeRepo {
  final ApiHelper apiHelper;
  HomeRepo(this.apiHelper);

  Future<List<User>> fetchUser() async {
    final response = await apiHelper.callApi(
      service: ApiEndPoints.getUsers,
      requestType: HttpRequestType.get,
    );
    // create User model from api response
    if (response['data'] != null) {
      return (response['data'] as List).map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
