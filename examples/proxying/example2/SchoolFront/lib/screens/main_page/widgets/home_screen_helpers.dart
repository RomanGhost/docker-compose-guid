import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Функция для открытия URL
Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Не удалось открыть ссылку $url';
  }
}

// Функция для обработки перехода в личный кабинет
Future<void> handlePersonalAccount(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('jwt');

  if (jwt == null || JwtDecoder.isExpired(jwt)) {
    Navigator.pushNamed(context, '/login');
  } else {
    Navigator.pushNamed(context, '/account');
  }
}
