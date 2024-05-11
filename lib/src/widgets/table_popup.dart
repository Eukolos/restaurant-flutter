import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/models/account.dart';
import 'package:restaurant_management_system/src/providers/account_inactive_provider.dart';
import 'package:restaurant_management_system/src/widgets/product_list.dart';

import '../providers/account_provider.dart';

class TablePopupWidget extends ConsumerStatefulWidget {
  final int index;

  const TablePopupWidget({
    required this.index,
    super.key,
  });

  @override
  ConsumerState createState() => _TablePopupWidgetState();
}

class _TablePopupWidgetState extends ConsumerState<TablePopupWidget> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {

    return ProviderScope(
      child: Consumer(builder: (context, read, child) {
        final productsProvider = ref.watch(accountProvider(widget.index + 1));
        return productsProvider.when(
          data: (data) {
            double tax = data.totalPrice! * 0.20;
            double totalPrice = data.totalPrice! + tax;

            // order list to list
            List<Order> orders = data.orders!.map((e) => e!).toList();
            return AlertDialog(

              title: Text('Masa ${widget.index + 1}'),
              titlePadding: const EdgeInsets.only(top: 30, left: 80, right: 20),
              content: SizedBox(
                width: 800, // Set a specific width for the content
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 400,
                          width: 300,
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('${orders[index].name}'),
                                subtitle: Text(
                                    '${orders[index].category?.replaceAll('_', ' ') ?? ''}',
                                    style: const TextStyle(fontSize: 10)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('x${orders[index].amount}'),
                                    SizedBox(width: 20),
                                    Text('₺ ${orders[index].price}.'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                isEditing
                                    ? SizedBox(
                                        width: 200,
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Müşteri Adı',
                                          ),
                                          onChanged: (value) {
                                            data.customerName = value;
                                          },
                                        ),
                                      )
                                    : Text(data!.customerName),
                                IconButton(
                                    onPressed: () {
                                      setState(() {

                                        isEditing = !isEditing;
                                      });
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                            Text('Matrah: ₺${data!.totalPrice}'),
                            Text('KDV: ₺ ${tax.roundToDouble()}'),
                            Text('Toplam: ₺ ${totalPrice.roundToDouble()}'),
                            Text(
                                'Masa Durumu: ${data.isActive! ? 'Açık' : 'Kapalı'} '),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          _showPopup(context, widget.index);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(150, 75),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.green, size: 25),
                            Text('Ürün Ekle',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        )),
                    TextButton(
                      onPressed: () {
                        if (widget.index == 0) {
                          ref.read(accountInactiveProvider(1));
                        } else {
                          ref.read(accountInactiveProvider(widget.index + 1));
                        }
                        data.customerName = 'Müşteri Adı';
                        Navigator.of(context).pop();
                        print('Masa  + 1 tıklandı');
                      },
                      child: const Text('Hesap Kapat',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    print('Masa  + 1 tıklandı');
                  },
                  child: const Text('Kapat',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
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

void _showPopup(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductListWidget(id: id);
      });
}
