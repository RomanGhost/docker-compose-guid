import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 60,
    title: const Text('Репетитор английского языка'),
    actions: [
      ElevatedButton(
        onPressed: ()=> Navigator.pushNamed(context, '/login'),
        child: const Text('Личный кабинет'),
      ),
    ],
  );
}
