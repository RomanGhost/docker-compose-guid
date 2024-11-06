import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';
import '../../errors/user_errors.dart';
import '../../widgets/footer.dart';
import '../../widgets/user_forms.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthApi _apiService = AuthApi();
  final UserForms userForms = UserForms.undefined();

  Widget _buildBody(){
    Future<void> _submit() async {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        final newUser;
        try {
          newUser = userForms.getUser(checkPassword: true);
        } on PasswordError {
          _showErrorSnackbar('Слишком легкий пароль');
          return;
        }
        try {
          String? jwt = await _apiService.registerUser(newUser);
          if (jwt != null) {
            // Сохранение JWT в локальное хранилище
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt', jwt);

            final routeName = ModalRoute.of(context)?.settings.arguments;
            if (routeName == '/enroll_subject') {
              Navigator.pushNamed(context, '/enroll_subject');
            } else {
              Navigator.pushNamed(context, '/account');
            }
          } else {
            // Показ ошибки
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Не смогли зарегистрировать')),
            );
          }
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Регистрация с ошибкой: $e')),
          );
        }
      }
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    userForms.buildFirstNameField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    userForms.buildLastNameField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    userForms.buildSurnameField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    userForms.buildEmailNameField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    userForms.buildPasswordField(
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    SizedBox(height: 20),
                    userForms.buildConfirmPasswordField(
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6498E4),
                      ),
                      child: const Text(
                        'Зарегистрироваться',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Column(
        children: [
          _buildBody(),
          CustomFooter()
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
