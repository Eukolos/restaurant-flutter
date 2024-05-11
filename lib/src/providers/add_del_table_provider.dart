import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/product.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';
import 'package:restaurant_management_system/src/widgets/product_list.dart';

final addDelTableProvider = FutureProvider.family<void, int>((ref, int) async {
  String apiUrl = 'http://localhost:8080/table/qua/$int';

  try {
    final dio.Dio client = dio.Dio();

    print("++++++++++ " + apiUrl);
    final response = await client.put(apiUrl);
    print(response.statusCode);




    if (response.statusCode == 200) {
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

