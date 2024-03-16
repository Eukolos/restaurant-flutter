import 'package:flutter/material.dart';


AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(

      title: const Text(
        "Restaurant Management System",
        style: TextStyle(
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
    );

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;
  final List<Color> gradientColors;

  const GradientText(
      {required this.text,
        this.fontSize = 40,
        this.letterSpacing = 5,
        this.fontWeight = FontWeight.bold,
        required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: fontWeight,
          color: Colors
              .white, // This color won't be used, as we're using ShaderMask for gradient
        ),
      ),
    );
  }
}