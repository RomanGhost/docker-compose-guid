import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_api.dart';
import '../dataclasses/user.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User? _user; // Переменная для хранения данных пользователя
  final UserApi _apiService = UserApi();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Загрузка данных пользователя при инициализации
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      setState(() {
        _user = User.undefined(); // Устанавливаем неопределенного пользователя
      });
      return;
    }

    final decodedToken = JwtDecoder.decode(jwt);
    final email = decodedToken['sub'] as String?;

    if (email == null) {
      setState(() {
        _user = User.undefined();
      });
      return;
    }

    final user = await _apiService.getUser(email);
    if (user != null) {
      final role = decodedToken['role']['authority'] as String;
      user.role = role;
      setState(() {
        _user = user;
      });
    } else {
      setState(() {
        _user = User.undefined();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF6498E4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user!.firstName.isNotEmpty ? _user!.firstName : 'Guest',
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        _user!.email.isNotEmpty ? _user!.email : 'No email',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      if (_user!.role != 'USER')
                        Text(
                          _user!.role.isNotEmpty ? _user!.role : 'No role',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                    ],
                  ),
                ),
                _buildListTile(
                  icon: Icons.person,
                  title: 'Главная',
                  onTap: () => _navigateTo(context, '/account'),
                ),
                _buildListTile(
                  icon: Icons.settings,
                  title: 'Настройки',
                  onTap: () => _navigateTo(context, '/profile_edit'),
                ),
                _buildListTile(
                  icon: Icons.label,
                  title: 'Предметы',
                  onTap: () => _navigateTo(context, '/user_lesson'),
                ),
                if (_user!.role == 'TEACHER') ...[
                  _buildListTile(
                    icon: Icons.school,
                    title: 'Ученики',
                    onTap: () => _navigateTo(context, '/students'),
                  ),
                  _buildListTile(
                    icon: Icons.book,
                    title: 'Уроки',
                    onTap: () => _navigateTo(context, '/teacher_lesson'),
                  ),
                ],
              ],
            ),
          ),
          _buildListTile(
            icon: Icons.logout,
            title: 'Выйти',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
