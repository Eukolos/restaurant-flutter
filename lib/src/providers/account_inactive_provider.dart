import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';

final accountInactiveProvider  = FutureProvider.family<void, int>((ref, id) async {
  const String apiUrl = 'http://localhost:8080/table/';

  try {
    final response = await dio.Dio().delete(apiUrl+ id.toString());

    if (response.statusCode == 200) {
      print(response.data.toString());
      ref.refresh(tableStatusProvider);
      ref.refresh(accountProvider(id));
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
});