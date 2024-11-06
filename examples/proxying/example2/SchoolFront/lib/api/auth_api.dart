import 'dart:async';
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school/service/jwt_work.dart';
import '../dataclasses/config.dart';
import '../dataclasses/user.dart';
import 'api_client.dart';
import 'api_interface.dart';

class AuthApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api/auth'; // Используем конфигурацию
  late final ApiClient _apiClient;

  AuthApi() {
    _apiClient = ApiClient(_baseUrl); // Инициализация ApiClient с базовым URL
  }

  /// Аутентификация пользователя
  Future<String?> authenticateUser(User user) async {
    final response = await _apiClient.postRequest(
      'login',
      {
        'email': user.email,
        'password': user.password,
      },
      headers: {'Content-Type': 'application/json'},
    );

    if (response != null && response.containsKey('jwt')) {
      final jwt = response['jwt']?.toString();
      if (jwt != null) {
        await JwtWork().saveJwt(jwt); // Сохраняем JWT в хранилище
        final decodedToken = JwtDecoder.decode(jwt);
        final email = decodedToken['sub'] as String?;
        return jwt;
      }
    }
    return null;
  }

  /// Регистрация нового пользователя
  Future<String?> registerUser(User newUser) async {
    final response = await _apiClient.postRequest(
      'register',
      {
        'firstName': newUser.firstName,
        'lastName': newUser.lastName,
        'surname': newUser.surname,
        'email': newUser.email,
        'password': newUser.password,
      },
      headers: {'Content-Type': 'application/json'},
    );

    if (response != null && response.containsKey('jwt')) {
      final jwt = response['jwt']?.toString();
      if (jwt != null) {
        await JwtWork().saveJwt(jwt); // Сохраняем JWT
        return jwt;
      }
    }
    return null;
  }

  /// Логаут
  void logout() async {
    await JwtWork().clearJwt(); // Очищаем токен
  }
}
