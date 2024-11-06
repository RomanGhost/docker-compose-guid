import 'package:flutter/material.dart';

import '../dataclasses/user.dart';
import '../errors/user_errors.dart';

class UserForms {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String getFirstName() => _firstNameController.text;
  String getLastName() => _lastNameController.text;
  String getSurname() => _surnameController.text;
  String getEmail() => _emailController.text;
  String getPassword() => _passwordController.text;
  String getConfirmPassword() => _confirmPasswordController.text;

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  UserForms(User user) {
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _surnameController.text = user.surname;
  }

  UserForms.undefined() {
    _emailController.text = "";
    _firstNameController.text = "";
    _lastNameController.text = "";
    _surnameController.text = "";
  }

  User getUser({bool checkPassword = false}) {
    User newUser = User.undefined();
    newUser.email = _emailController.text;
    newUser.firstName = _firstNameController.text;
    newUser.lastName = _lastNameController.text;
    newUser.surname = _surnameController.text;
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text) {
      newUser.password = _passwordController.text;
    } else {
      if (checkPassword) throw PasswordError("Пароли не совпадают");
    }
    return newUser;
  }

  User getUserLogin() {
    User loginUser = User.undefined();
    loginUser.email = _emailController.text;
    loginUser.password = _passwordController.text;

    return loginUser;
  }

  Widget buildFirstNameField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'Имя',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите имя';
        }
        if (value.length < 3) {
          return 'Имя должно быть не менее 3 символов';
        }
        return null;
      },
      autofillHints: [AutofillHints.givenName], // Автозаполнение имени
    );
  }

  Widget buildLastNameField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'Фамилия',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите фамилию';
        }
        if (value.length < 3) {
          return 'Фамилия должна быть не менее 3 символов';
        }
        return null;
      },
      autofillHints: [AutofillHints.familyName], // Автозаполнение фамилии
    );
  }

  Widget buildSurnameField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _surnameController,
      decoration: InputDecoration(
        labelText: 'Отчество',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 3) {
          return 'Отчество должно быть не менее 3 символов';
        }
        return null;
      },
      autofillHints: [AutofillHints.middleName], // Автозаполнение отчества (не всегда поддерживается)
    );
  }

  Widget buildEmailNameField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите email';
        }
        final emailPattern = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+$";
        final emailRegex = RegExp(emailPattern);
        if (!emailRegex.hasMatch(value)) {
          return 'Некорректный email';
        }
        return null;
      },
      autofillHints: [AutofillHints.email], // Автозаполнение email
    );
  }

  Widget buildPasswordField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Пароль',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите пароль';
        }
        if (value.length < 6) {
          return 'Пароль должен быть не менее 6 символов';
        }
        return null;
      },
      autofillHints: [AutofillHints.newPassword], // Автозаполнение нового пароля
    );
  }

  Widget buildConfirmPasswordField({void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Подтверждение пароля',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (_passwordController.text != value) {
          return 'Пароли не совпадают';
        }
        return null;
      },
      autofillHints: [AutofillHints.password], // Автозаполнение подтверждения пароля
    );
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    return form != null && form.validate();
  }
}
