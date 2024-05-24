import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/model/customer.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class CustomerListOnMenu extends ConsumerStatefulWidget {
  List<Customer> customers;
  CustomerListOnMenu({
    required this.customers,
    super.key});

  @override
  ConsumerState createState() => _CustomerListWidgetOnMenuState();
}

class _CustomerListWidgetOnMenuState extends ConsumerState<CustomerListOnMenu> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text('Müşteriler'),
      ),
      content: Container(
        width: 750,
        height: 400,
        child: ListView.builder(
          itemCount: widget.customers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${widget.customers[index].name} ${widget.customers[index].surname}',
              ),
              subtitle: Text(
                '${widget.customers[index].email}\n${widget.customers[index].phone}\n${widget.customers[index].address}',
              ),
            );
          },
        ),
      ),

    );
  }
}
