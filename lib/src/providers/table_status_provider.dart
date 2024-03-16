import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/table_status.dart';

final tableStatusProvider  = FutureProvider<List<TableStatus>>((ref) async {
  const String apiUrl = 'http://localhost:8080/table/status';

  try {
    final response = await dio.Dio().get(apiUrl);

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => TableStatus.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to fetch data: $e');
  }
});