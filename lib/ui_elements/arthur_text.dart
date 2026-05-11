import 'package:flutter/material.dart';



Widget arthurText(String text) =>
    Text(text, style: TextStyle(
    color: Color(0xFF000000)));

Widget arthurButton({required VoidCallback onPressed, required child}) =>
    Container(
      padding: EdgeInsets.all(4),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: TextButton.styleFrom(backgroundColor: Color(0xFF20801E), side: BorderSide(width: 2.2)),
      ),
    );
