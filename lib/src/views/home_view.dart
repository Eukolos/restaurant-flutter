
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:restaurant_management_system/src/model/customer.dart';
import 'package:restaurant_management_system/src/model/dummy_list.dart';
import 'package:restaurant_management_system/src/widgets/appbar.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';
import 'package:restaurant_management_system/src/widgets/customer_list_on_menu.dart';
import 'package:restaurant_management_system/src/widgets/product_add_on_menu.dart';
import 'package:restaurant_management_system/src/widgets/product_list_on_menu.dart';
import 'package:restaurant_management_system/src/widgets/table_add_or_del.dart';

import '../widgets/table_popup.dart';

class HomeView extends ConsumerStatefulWidget {
  final String title;

  const HomeView({required this.title, super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
  }
  List<Customer> customerNames = Customers().get();


  @override
  Widget build(BuildContext context) {
    int count = 0;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return ProviderScope(
      child: Scaffold(
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color(0xFFFA7070),
                ),
                child: Center(
                  child: Text(
                    'Restaurant Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Masa Ekle/Çıkar'),
                onTap: () {
                  // pop up
                  _showPopupTableAdd(context, count);
                },
              ),
              ListTile(
                title: const Text('Ürün Ekle'),
                onTap: () {
                  _showPopupProductAdd(context, 1);
                },
              ),
              ListTile(
                title: const Text('Ürün Listesi'),
                onTap: () {
                  _showPopupProductList(context, 1);
                },
              ),
              ListTile(
                title: const Text('Müşteri Listesi'),
                onTap: () {
                  _showPopupCustomerList(context, customerNames);
                },
              ),

            ],
          ),
        ),
        key: scaffoldKey,
        appBar: topNavigationBar(context, scaffoldKey),
        body: Consumer(
          builder: (context, read, child) {
            final tableStatusList = ref.watch(tableStatusProvider);
            return tableStatusList.when(
              data: (data) {
                count = data.length;
                return ResponsiveGridList(
                  maxItemsPerRow: 5,
                  horizontalGridMargin: 50,
                  verticalGridMargin: 50,
                  minItemWidth: 100,
                  children: List.generate(
                    data.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _showPopup(context, index, customerNames, (Customer customer) {
                          customerNames.add(customer);
                        });
                        print('Masa ${index + 1} tıklandı');
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: data[index].isAvailable!
                              ? const Color(0xFFA6CF98)
                              : const Color(0xFFFA7070),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Masa ${index + 1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: [
                    Color(0xFFFA7070),
                    Color(0xFFA6CF98),
                  ],
                  strokeWidth: 4.0,
                ),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          },
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, int index, List<Customer> customers, Function(Customer) addCustomerToList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TablePopupWidget(
        index: index,
        customers: customers,
        addCustomerToList: addCustomerToList,

      );
    },
  );
}

void _showPopupProductList(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductListWidgetOnMenu(id: id);
      });
}

void _showPopupCustomerList(BuildContext context, List<Customer> customers) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomerListOnMenu(customers: customers);
      });
}


void _showPopupProductAdd(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductAddWidgetOnMenu(id: id);
      });
}

void _showPopupTableAdd(BuildContext context, int count) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return TableAddOrDelWidget(count: count);
      });
}
