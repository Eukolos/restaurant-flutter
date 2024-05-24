import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/model/customer.dart';
import 'package:restaurant_management_system/src/models/account.dart';
import 'package:restaurant_management_system/src/providers/account_inactive_provider.dart';
import 'package:restaurant_management_system/src/widgets/product_list.dart';
import '../providers/account_provider.dart';

class TablePopupWidget extends ConsumerStatefulWidget {
  final int index;
  List<Customer> customers;
  Function(Customer) addCustomerToList;

  TablePopupWidget({
    required this.addCustomerToList,
    required this.customers,
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
      child: Consumer(builder: (context, ref, child) {
        final productsProvider = ref.watch(accountProvider(widget.index + 1));
        return productsProvider.when(
          data: (data) {
            data.date = DateTime.now();
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
                                  style: const TextStyle(fontSize: 10),
                                ),
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
                            // clock like 12:00 22.12.2024 from DateTime
                            Text(
                              'Sipariş Tarihi:   ${data.date!.hour}:${data.date!.minute}   ${data.date!.day}.${data.date!.month}.${data.date!.year}',
                            ),
                            SizedBox(height: 40),

                            Container(
                              height: 50,
                              width: 200,
                              child: TextButton(
                                onPressed: () async {
                                  final newCustomer = await showDialog<Customer>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddCustomer(widget: widget);
                                      }
                                  );
                                  if (newCustomer != null) {
                                    setState(() {
                                      widget.customers.add(newCustomer);
                                    });
                                  }
                                },
                                child: const Text('Yeni Müşteri Ekle'),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 50,
                              child: DropdownButtonFormField(
                                items: widget.customers.map((Customer value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text("${value.name} ${value.surname}"  ?? ''),
                                  );
                                }).toList(),
                                hint: data.customer == null
                                    ? const Text('Müşteri Seçiniz')
                                    : Text("${data.customer!.name} ${data.customer!.surname}" ?? '', style: const TextStyle(color: Colors.black)),
                                onChanged: (value) {
                                  setState(() {
                                    data.customer = value;
                                  });
                                },
                              ),
                            ),
                            Text('Matrah: ₺${data.totalPrice}'),
                            Text('KDV: ₺ ${tax.roundToDouble()}'),
                            Text('Toplam: ₺ ${totalPrice.roundToDouble()}'),
                            Text(
                                'Masa Durumu: ${data.isActive! ? 'Açık' : 'Kapalı'}'),

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
                          Text(
                            'Ürün Ekle',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await showDialog(context: context, builder:
                          (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Hesap Kapat'),
                              content: const Text('Hesap kapatılsın mı?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    ref.read(accountInactiveProvider(widget.index + 1));

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Nakit Kapat',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),TextButton(
                                  onPressed: () {
                                    ref.read(accountInactiveProvider(widget.index + 1));

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Kredi Kartı ile Kapat',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        Navigator.of(context).pop();
                        print('Masa ${widget.index + 1} tıklandı');
                      },
                      child: const Text(
                        'Hesap Kapat',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    print('Masa ${widget.index + 1} tıklandı');
                  },
                  child: const Text(
                    'Kapat',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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

class AddCustomer extends StatefulWidget {
  AddCustomer({
    super.key,
    required this.widget,
  });

  final TablePopupWidget widget;

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  @override
  Widget build(BuildContext context) {
    Customer data = Customer();
    return AlertDialog(
      title: const Text('Yeni Müşteri Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Müşteri Adı',
            ),
            onChanged: (value) {
              data.name = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Müşteri Soyadı',
            ),
            onChanged: (value) {
              data.surname = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Müşteri E-posta',
            ),
            onChanged: (value) {
              data.email = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Müşteri Telefon',
            ),
            onChanged: (value) {
              data.phone = value;
            },
          ),
          SizedBox(
            width: 250,
            child: TextField(
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Müşteri Adres',
              ),
              onChanged: (value) {
                data.address = value;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(data);
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

void _showPopup(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ProductListWidget(id: id);
    },
  );
}
