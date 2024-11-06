import 'package:http/http.dart' as http;

class Api{
  late final String _baseUrl; // Замените на ваш IP
  String? _jwt;

  void logError(String message, http.Response response) {
    print('$message: ${response.statusCode} ${response.body}');
  }
}