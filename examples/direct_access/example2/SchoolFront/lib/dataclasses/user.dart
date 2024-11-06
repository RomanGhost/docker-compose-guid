import '../errors/user_errors.dart';

class User {
  String _firstName;
  String _lastName;
  String _surname;
  String _email;
  String _password;
  String _role;


  // Constructors
  User.undefined()
      : _firstName = '',
        _lastName = '',
        _surname = '',
        _email = '',
        _password = '',
        _role='USER';

  User({
    required String email,
    String? password,
    required String firstName,
    required String lastName,
    String surname = '',
    String role = 'USER',
  })  : _email = _validateEmail(email),
        _password = password??"", // Assuming password validation is commented out
        _firstName = _validateName(firstName, 'First name'),
        _lastName = _validateName(lastName, 'Last name'),
        _surname = surname,
        _role=role;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get surname => _surname;
  String get email => _email;
  String get password => _password;
  String get role => _role;

  // Setters with validation
  set firstName(String name) {
    _firstName = _validateName(name, 'First name');
  }

  set role(String role) {
    _role = role;
  }


  set lastName(String name) {
    _lastName = _validateName(name, 'Last name');
  }

  set surname(String name) {
    _surname = name;
  }

  set email(String email) {
    _email = _validateEmail(email);
  }

  set password(String password) {
    // If password validation is to be re-enabled:
    // _password = _validatePassword(password);
    _password = password;
  }

  // Private validation methods
  static String _validateName(String name, String fieldName) {
    if (name.length < 3) {
      throw ShortName('$fieldName is less than 3 characters: $name');
    }
    return name;
  }

  static String _validateEmail(String email) {
    final emailPattern = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+$";
    final emailRegex = RegExp(emailPattern);
    final formattedEmail = email.toLowerCase();

    if (!emailRegex.hasMatch(formattedEmail)) {
      throw EmailError('Email is not correct: $formattedEmail');
    }

    return formattedEmail;
  }

// Password validation can be added back here if needed
static String _validatePassword(String password) {
  final passwordPattern = r'^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{6,}$';
  final passwordRegex = RegExp(passwordPattern);

  if (!passwordRegex.hasMatch(password)) {
    throw PasswordError("Password isn't correct");
  }

  return password;
}
}
