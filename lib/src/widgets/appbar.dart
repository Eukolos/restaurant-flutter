import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(

      title:  Text(
        "Restaurant Management System",
        style: GoogleFonts.comfortaa(
          //gradient color 222831
          color: Color(0xff222831),
          fontSize: 30,
          letterSpacing: 4.0,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      shadowColor: Colors.grey,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            key.currentState!.openEndDrawer();
          },
        ),
        SizedBox(width: 10)
      ],
    );


