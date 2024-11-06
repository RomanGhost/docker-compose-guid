import 'package:shared_preferences/shared_preferences.dart';

final class JwtWork{
  Future<void> saveJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', jwt);
  }

  Future<String?> getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<void> clearJwt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }
}