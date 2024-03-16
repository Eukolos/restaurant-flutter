import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class ProductListWidget extends ConsumerStatefulWidget {
  final int id;
  const ProductListWidget({
    required this.id,
    super.key});

  @override
  ConsumerState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends ConsumerState<ProductListWidget> {
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
                          const Text('Fiyat:'),
                          const SizedBox(width: 5),
                          Text(
                            '₺${data[index].price!}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 25),
                          const Text('Miktar:'),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (data[index].quantity! > 0) {
                                        data[index].decreaseQuantity();
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                                Text(
                                  '${data[index].quantity!}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      data[index].increaseQuantity();
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(postProductsProvider(PostData(id: widget.id, products: data)));
                    ref.read(tableStatusProvider);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ürünleri Ekle', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Kapat', style: TextStyle(color: Color(0xFFFA7070))),
                ),
              ],
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