import 'dart:math';

import 'package:flutter/material.dart';
import 'package:map_test/screens/custom_text_rendering/widgets/circle_text.dart';

class CustomTextRendering extends StatefulWidget {
  const CustomTextRendering({super.key});

  @override
  State<CustomTextRendering> createState() => _CustomTextRenderingState();
}

class _CustomTextRenderingState extends State<CustomTextRendering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Text Rendering'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
          ),
          width: 300,
          height: 300,
          child: CircleText(
            radius: 100,
            text:
                'This is a sample text that will be displayed in a circular path',
            textStyle: TextStyle(fontSize: 18, color: Colors.black),
            startAngle: -pi / 2,
          ),
        ),
      ),
    );
  }
}
