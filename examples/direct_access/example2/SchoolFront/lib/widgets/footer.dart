import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            '© 2024 OpenInc',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
