import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_management_system/src/models/product.dart';
import 'package:restaurant_management_system/src/providers/account_provider.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';
import 'package:restaurant_management_system/src/widgets/product_list.dart';

final postProductsProvider = FutureProvider.family<void, PostData>((ref, postData) async {
  const String apiUrl = 'http://localhost:8080/table/';

  try {
    final dio.Dio client = dio.Dio();
    // deep copy of postData.products
    List<Product> products = List<Product>.from(postData.products);
    products.removeWhere((element) => element.quantity == 0);

    // products to productPostDatas
    List<ProductPostData> productPostDatas = products.map((product) => ProductPostData(product: product)).toList();

    String tableId = ( postData.id + 1 ).toString();
    List<Map<String, dynamic>> productsJson = productPostDatas.map((product) => product.toJson()).toList();


    final response = await client.post(apiUrl + tableId, data:productsJson);


    if (response.statusCode == 200) {
      products.forEach((product) => product.quantity = 0);
      ref.refresh(productListProvider);
      ref.refresh(tableStatusProvider);
      ref.refresh(accountProvider(postData.id + 1));

    } else {
      throw Exception('Failed to post data');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to post data: $e');
  }
});

class ProductPostData {
  int? productId;
  double? amount;

  ProductPostData({Product? product}) {
    productId = product?.id;
    amount = product?.quantity?.toDouble();
  }

  ProductPostData.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productId'] = productId;
    data['amount'] = amount;
    return data;
  }
}
