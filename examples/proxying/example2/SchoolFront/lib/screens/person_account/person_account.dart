import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school/api/user_api.dart';
import 'package:school/errors/jwt_errors.dart';
import 'package:school/widgets/side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dataclasses/user.dart';
import '../../service/jwt_work.dart';
import '../../widgets/footer.dart';
import 'widgets/next_lesson_widget.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserApi _apiService = UserApi();
  User? _userData;

  @override
  void initState() {
    super.initState();
    try {
      _loadUserData();
    }on JwtIsNull catch(e){
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushNamed(context, '/login');
      }
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if(jwt == null) {
      await JwtWork().clearJwt();
      Navigator.pushNamed(context, '/login');
      throw JwtIsNull("Token is not valid");
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    String? email = decodedToken['sub'];

    final user = await _apiService.getUser(email!);
    if(user == null){
      JwtWork().clearJwt();
      Navigator.pushNamed(context, '/login');
    }
    setState(() {
      _userData = user;
    });
  }

  Widget _buildBody(){
    return _userData == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextLessonWidget(),
          const SizedBox(height: 20),
          const Expanded(
            child: Center(
              child: Text(
                'Блок еще в разработке...',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      drawer: const SideMenu(), // Добавление боковой панели
      body: Column(
        children: [
          _buildBody(),
          CustomFooter()
        ],
      ),
    );
  }
}
