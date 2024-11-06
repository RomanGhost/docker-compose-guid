import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String _baseUrl;

  ApiClient(this._baseUrl);

  /// Формирует строку с query-параметрами
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// GET запрос
  Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? headers, Map<String, String>? queryParams}) async {
    final url = _buildUri(endpoint, queryParams);
    final response = await http.get(url, headers: headers);
    return _processResponse(response);
  }

  /// POST запрос
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers, Map<String, String>? queryParams}) async {
    final url = _buildUri(endpoint, queryParams);
    final response = await http.post(
        url, headers: headers, body: json.encode(body));
    return _processResponse(response);
  }

  /// PUT запрос
  Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers, Map<
          String,
          String>? queryParams}) async {
    final url = _buildUri(endpoint, queryParams);
    final response = await http.put(
        url, headers: headers, body: json.encode(body));
    return _processResponse(response);
  }

  /// DELETE запрос
  Future<dynamic> deleteRequest(String endpoint,
      {Map<String, String>? headers, Map<String, String>? queryParams, Map<
          String,
          dynamic>? body}) async {
    final url = _buildUri(endpoint, queryParams);
    final response = await http.delete(
        url, headers: headers, body: json.encode(body));
    return _processResponse(response);
  }

  /// Обработка ответа
  dynamic _processResponse(http.Response response) {
    // print("Response ${response.request} with code ${response.statusCode}");
    if (response.statusCode == 200) {
      try {
        final responseBody = response.body;
        return json.decode(responseBody);
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Error with response: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

}
