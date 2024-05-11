import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class ProductListWidgetOnMenu extends ConsumerStatefulWidget {
  final int id;
  const ProductListWidgetOnMenu({
    required this.id,
    super.key});

  @override
  ConsumerState createState() => _ProductListWidgetOnMenuState();
}

class _ProductListWidgetOnMenuState extends ConsumerState<ProductListWidgetOnMenu> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(builder: (context, read, child) {
        final productsProvider = ref.watch(productListProvider);

        return productsProvider.when(
          data: (data) {
            return AlertDialog(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('Ürünler'),
              ),
              content: Container(
                width: 750,
                height: 400,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index].name!),
                      subtitle: Text(data[index].category!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 5),
                          const Text('Stock Miktarı: '),
                          Text(
                            '${data[index].stock!}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text('Fiyat:'),
                          const SizedBox(width: 5),
                          Text(
                            '₺${data[index].price!}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 20),


                        ],
                      ),
                    );
                  },
                ),
              ),

            );
          },
          loading: () => const LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [
              Color(0xFFFA7070),
              Color(0xFFA6CF98),
              Color(0xFF324DA2),
              Color(0xFF9662cf),
              Color(0xFFD5B555),
            ],
            strokeWidth: 4.0,
          ),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      }),
    );
  }
}
class PostData {
  final int id;
  final List<Product> products;

  PostData({required this.id, required this.products});
}