import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class ProductListWidget extends ConsumerStatefulWidget {
  final int id;

  const ProductListWidget({required this.id, super.key});

  @override
  ConsumerState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends ConsumerState<ProductListWidget> {
  List<Product> products = [];
  List<Product> foundProducts = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final productsProvider = ref.watch(productListProvider);

      return productsProvider.when(
        data: (data) {
          // Initialize the products list when data is fetched
          if (products.isEmpty) {
            products = data;
            foundProducts = data;
          }

          void runFilter(String enteredKeyword) {
            List<Product> results;
            if (enteredKeyword.isEmpty) {
              results = products;
            } else {
              results = products
                  .where((product) =>
              product.name != null &&
                  product.name!
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()))
                  .toList();
            }

            setState(() {
              foundProducts = results;
            });
          }

          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  const Text('Ürünler'),
                  TextField(
                    onChanged: (value) => runFilter(value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.black12),
                      hintText: 'Ara',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 20.0),
                      disabledBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              width: 750,
              height: 400,
              child: ListView.builder(
                itemCount: foundProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(foundProducts[index].name!),
                    subtitle: Text(foundProducts[index].category!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 5),
                        const Text('Stock Miktarı: '),
                        Text(
                          '${foundProducts[index].stock!}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text('Fiyat:'),
                        const SizedBox(width: 5),
                        Text(
                          '₺${foundProducts[index].price!}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 20),
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
                                    if (foundProducts[index].quantity! > 0) {
                                      foundProducts[index].decreaseQuantity();
                                    }
                                  });
                                },
                                child: const Icon(Icons.remove),
                              ),
                              Text(
                                '${foundProducts[index].quantity!}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    foundProducts[index].increaseQuantity();
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
                  ref.read(postProductsProvider(
                      PostData(id: widget.id, products: products)));
                  ref.read(tableStatusProvider);
                  Navigator.of(context).pop();
                },
                child: const Text('Ürünleri Ekle',
                    style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat',
                    style: TextStyle(color: Color(0xFFFA7070))),
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
    });
  }
}

class PostData {
  final int id;
  final List<Product> products;

  PostData({required this.id, required this.products});
}
