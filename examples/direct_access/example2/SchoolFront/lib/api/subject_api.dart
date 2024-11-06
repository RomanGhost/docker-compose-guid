import 'package:school/dataclasses/subject.dart';
import 'package:school/service/jwt_work.dart';
import '../dataclasses/config.dart';
import 'api_client.dart';
import 'api_interface.dart';

class SubjectApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api';
  late final ApiClient _apiClient;

  SubjectApi() {
    _apiClient = ApiClient(_baseUrl); // Инициализация ApiClient
  }

  /// Получить доступные предметы для пользователя
  Future<List<Subject>> getAvailableSubjects() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Subject>.empty();
    }

    try {
      // Используем метод GET из ApiClient
      final result = await _apiClient.getRequest('subject/get_access_user', headers: {
        'Authorization': 'Bearer $jwt',
      });

      if (result != null) {
        List<Subject> resultLessons = List.empty(growable: true);

        for (var subjectJson in result) {
          Subject newSubject = Subject(
            id: subjectJson['id'],
            name: subjectJson['name'],
            price: subjectJson['price'],
          );
          resultLessons.add(newSubject);
        }
        return resultLessons;
      } else {
        return List<Subject>.empty();
      }
    } catch (e) {
      print('Error occurred while fetching subjects: $e');
      return List<Subject>.empty();
    }
  }

  /// Добавить новый предмет для пользователя
  Future<void> addSubjectUser(Subject subject) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    try {
      // Используем метод POST из ApiClient
      await _apiClient.postRequest('user_subject/add', {
        'id': subject.id,
        'name': subject.name,
        'price': subject.price,
        'level': subject.level,
      }, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      });
    } catch (e) {
      print('Error occurred while adding subject: $e');
    }
  }

  /// Получить предметы пользователя
  Future<List<Subject>> getUserSubjects() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Subject>.empty();
    }

    try {
      // Используем метод GET из ApiClient
      final result =
      await _apiClient.getRequest('user_subject/getuserall', headers: {
        'Authorization': 'Bearer $jwt',
      });

      if (result != null) {
        List<Subject> resultSubjects = List.empty(growable: true);

        for (var subjectJson in result) {
          Subject newSubject = Subject(
            id: subjectJson['id'],
            name: subjectJson['name'],
            price: subjectJson['price'],
            level: subjectJson['level'],
          );
          resultSubjects.add(newSubject);
        }
        return resultSubjects;
      } else {
        return List<Subject>.empty();
      }
    } catch (e) {
      print('Error occurred while fetching user subjects: $e');
      return List<Subject>.empty();
    }
  }

  /// Удалить предмет пользователя
  Future<void> deleteUserSubject(Subject subject) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    try {
      // Используем метод DELETE из ApiClient
      await _apiClient.deleteRequest(
        'user_subject/delete',  // Позиционный аргумент - только один
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: {
          'id': subject.id,
          'name': subject.name,
          'price': subject.price,
          'level': subject.level,
        },
      );
    } catch (e) {
      print('Error occurred while deleting subject: $e');
    }
  }
}
