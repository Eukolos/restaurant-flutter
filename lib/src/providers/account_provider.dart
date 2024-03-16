import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/account.dart';

final accountProvider  = FutureProvider.family<Account, int>((ref, id) async {
  const String apiUrl = 'http://localhost:8080/table/active-account/';

  try {
    final response = await dio.Dio().get(apiUrl+ id.toString());

    if (response.statusCode == 200) {
      print(response.data.toString());
      return Account.fromJson(response.data);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
});