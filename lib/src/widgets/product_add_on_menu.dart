import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/providers/add_product_provider.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class ProductAddWidgetOnMenu extends ConsumerStatefulWidget {
  final int id;

  const ProductAddWidgetOnMenu({required this.id, super.key});

  @override
  ConsumerState createState() => _ProductAddWidgetOnMenuState();
}

class _ProductAddWidgetOnMenuState
    extends ConsumerState<ProductAddWidgetOnMenu> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Product product = Product(
      id: 0,
      name: '',
      category: 'BREAKFAST',
      price: 0,
      stock: 0,
    );
    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text('Ürün Ekle'),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: 750,
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ürün Adı',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          product.name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir ürün adı giriniz';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        value: product.category,
                        items: [
                          DropdownMenuItem(
                            value: 'BREAKFAST',
                            child: Text('Kahvaltı'),
                          ),
                          DropdownMenuItem(
                            value: 'FAST_FOOD',
                            child: Text('Fast Food'),
                          ),
                          DropdownMenuItem(
                            value: 'BEVERAGE',
                            child: Text('İçecek'),
                          ),
                          DropdownMenuItem(
                            value: 'DESSERT',
                            child: Text('Tatlı'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              product.category = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fiyat',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir fiyat giriniz';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Lütfen geçerli bir pozitif sayı giriniz';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            product.price = int.parse(value);
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Stok',
                          border: OutlineInputBorder(
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir stok miktarı giriniz';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return 'Lütfen geçerli bir pozitif sayı giriniz';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            product.stock = int.parse(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA7070),
                    foregroundColor: const Color(0xFFffffff),
                    maximumSize: const Size(200, 50),
                    minimumSize: const Size(200, 50),
                    shadowColor: const Color(0xFF000000),
                  ),



                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(addProductProvider(product));
                      // Form is valid, perform your action
                      Navigator.pop(context);
                    }
                    product = Product(
                      id: 0,
                      name: '',
                      category: 'BREAKFAST',
                      price: 0,
                      stock: 0,
                    );
                  },
                  child: Text('Ekle', style: GoogleFonts.comfortaa(fontSize: 18)),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
