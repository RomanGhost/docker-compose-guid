class Config {
  static const String baseUrl = String.fromEnvironment('BACKEND_API_URL', defaultValue: 'http://localhost:8080');
}
