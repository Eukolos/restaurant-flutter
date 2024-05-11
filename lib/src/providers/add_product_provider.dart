import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/product.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';
import 'package:restaurant_management_system/src/widgets/product_list.dart';

final addProductProvider = FutureProvider.family<void, Product>((ref, product) async {
  const String apiUrl = 'http://localhost:8080/product';

  try {
    final dio.Dio client = dio.Dio();


    final response = await client.post(apiUrl, data: product.toJson());
    print(response.statusCode);




    if (response.statusCode == 201) {
      ref.refresh(productListProvider);
      ref.refresh(tableStatusProvider);

    } else {
      throw Exception('Failed to post data');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to post data: $e');
  }
});

