import 'dart:convert';
import 'package:school/api/api_interface.dart';
import 'package:school/dataclasses/student.dart';
import 'package:school/service/jwt_work.dart';
import '../dataclasses/config.dart';
import 'api_client.dart';

class StudentApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api/student/teacher';
  late final ApiClient _apiClient;

  StudentApi() {
    _apiClient = ApiClient(_baseUrl); // Инициализация ApiClient
  }

  /// Получение всех студентов
  Future<List<Student>> getStudents() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return [];
    }

    try {
      // Используем ApiClient для выполнения GET-запроса
      final result = await _apiClient.getRequest('get_all', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      });

      if (result != null) {
        final List<Student> resultList = [];

        for (Map<String, dynamic> studentJson in result) {
          Student newStudent = Student(
            id: studentJson['id'],
            firstName: studentJson['firstName'],
            lastName: studentJson['lastName'],
            email: studentJson['email'],
            subject: studentJson['subject'],
            level: studentJson['level']
          );
          resultList.add(newStudent);
        }
        return resultList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching students: $e');
      return [];
    }
  }
}
