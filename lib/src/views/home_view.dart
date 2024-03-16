import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:restaurant_management_system/src/widgets/appbar.dart';
import 'package:restaurant_management_system/src/providers/table_status_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return ProviderScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: topNavigationBar(context, scaffoldKey),
        body: Consumer(
          builder: (context, read, child) {
            final tableStatusList = ref.watch(tableStatusProvider);
            return tableStatusList.when(
              data: (data) => ResponsiveGridList(
                maxItemsPerRow: 5,
                horizontalGridMargin: 50,
                verticalGridMargin: 50,
                minItemWidth: 100,
                children: List.generate(
                  data.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _showPopup(context, index);
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
                          style:
                              const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
void _showPopup(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TablePopupWidget(index: index,);
    },
  );
}

