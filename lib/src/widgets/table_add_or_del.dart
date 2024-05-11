import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restaurant_management_system/src/providers/add_del_table_provider.dart';
import 'package:restaurant_management_system/src/providers/add_product_provider.dart';
import 'package:restaurant_management_system/src/providers/product_list_provider.dart';

import '../models/product.dart';
import '../providers/post_products_provider.dart';
import '../providers/table_status_provider.dart';

class TableAddOrDelWidget extends ConsumerStatefulWidget {
  int count;

  TableAddOrDelWidget({required this.count, super.key});

  @override
  ConsumerState createState() => _TableAddOrDelWidgetState();
}

class _TableAddOrDelWidgetState
    extends ConsumerState<TableAddOrDelWidget> {


  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text('Masa Ekle/Çıkar'),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: 750,
          height: 300,
          child: Column(
            children: [
              Spacer(),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.count > 0) {
                            widget.count = widget.count - 1;
                          }
                        });
                      },
                      child: const Icon(Icons.remove , color: Colors.red, size: 50),
                    ),
                    SizedBox(width: 10),

                    Text(
                      '${widget.count}',
                      style: const TextStyle(fontSize: 35),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.count = widget.count + 1;
                        });
                      },
                      child: const Icon(Icons.add, color: Colors.green, size: 50),
                    ),
                  ],
                ),
              ),


              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA7070),
                    foregroundColor: const Color(0xFFffffff),
                    maximumSize: const Size(300, 50),
                    minimumSize: const Size(300, 50),
                    shadowColor: const Color(0xFF000000),
                  ),



                  onPressed: () {
                    ref.read(addDelTableProvider(widget.count));
                      // Form is valid, perform your action
                      Navigator.pop(context);
                  },
                  child: Text('Masa Ekle/Çıkar', style: GoogleFonts.comfortaa(fontSize: 18)),
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
