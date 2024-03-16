import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/product.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';

final productListProvider  = FutureProvider<List<Product>>((ref) async {
  const String apiUrl = 'http://localhost:8080/product';

  try {
    final response = await dio.Dio().get(apiUrl);

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      ref.refresh(tableStatusProvider);

    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
});