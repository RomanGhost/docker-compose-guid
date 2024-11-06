import '../dataclasses/lesson.dart';
import '../dataclasses/teacher_lesson.dart';
import '../service/jwt_work.dart';
import '../dataclasses/config.dart';
import 'api_client.dart';
import 'api_interface.dart';

class LessonApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api/lesson';
  late final ApiClient _apiClient;

  LessonApi() {
    _apiClient = ApiClient(_baseUrl);
  }

  /// Удаление урока
  Future<bool> deleteLesson(int lessonId) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return false;
    }

    final response = await _apiClient.deleteRequest(
      'remove',
      queryParams: {'lessonId': lessonId.toString()},
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response != null) {
      print('Lesson deleted successfully');
      return true;
    }
    return false;
  }

  /// Получение уроков за месяц
  Future<List<Lesson>> getLessonsForMonth(int year, int month) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final response = await _apiClient.getRequest(
      'get_by_month',
      queryParams: {'year': year.toString(), 'month': month.toString()},
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response != null) {
      return (response as List<dynamic>).map((lessonJson) {
        return Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
          status: lessonJson['status'],
        );
      }).toList();
    }
    return List<Lesson>.empty();
  }

  /// Получение всех уроков
  Future<List<Lesson>> getLessons() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final response = await _apiClient.getRequest(
      'get',
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response != null) {
      return response.map((lessonJson) {
        return Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
          status: lessonJson['status'],
        );
      }).toList();
    }
    return List<Lesson>.empty();
  }

  /// Получение следующего урока
  Future<Lesson?> getNextLessons() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final result = await _apiClient.getRequest(
      'get_next',
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (result != null) {
      final lessonJson = result;
      return Lesson(
        id: lessonJson['id'],
        title: lessonJson['subject'],
        time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
        status: lessonJson['status'],
      );
    }
    return null;
  }

  /// Добавление урока
  Future<Lesson?> addLessons(Lesson lesson) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final result = await _apiClient.postRequest(
      'add',
      {
        'subject': lesson.title,
        'status': lesson.status,
        'plainDateTime': lesson.time.toUtc().toIso8601String(),
      },
      headers: {'Authorization': 'Bearer $jwt',  'Content-Type': 'application/json'},
    );

    if (result != null) {
      final lessonJson = result as Map<String, dynamic>;
      return Lesson(
        id: lessonJson['id'],
        title: lessonJson['subject'],
        time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
        status: lessonJson['status'],
      );
    }
    return null;
  }

  /// Получение предложенных уроков для учителя
  Future<List<TeacherLesson>> getProposedLessonsForTeacher() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<TeacherLesson>.empty();
    }

    final result = await _apiClient.getRequest(
      'teacher/get',
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (result != null) {
      return (result as List).map((lessonTeacherJson) {
        final lessonJson = lessonTeacherJson['lessonData'];
        final lesson = Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
          status: lessonJson['status'],
        );
        return TeacherLesson(
          lesson: lesson,
          firstName: lessonTeacherJson['firstName'],
          lastName: lessonTeacherJson['lastName'],
        );
      }).toList();
    }
    return List<TeacherLesson>.empty();
  }

  /// Подтверждение урока для учителя
  Future<TeacherLesson?> approveLesson(int lessonId) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final response = await _apiClient.putRequest(
      'teacher/approve',
      queryParams: {'lessonId': lessonId.toString()},
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response != null) {
      final lessonJson = response['lessonData'];
      final lesson = Lesson(
        id: lessonJson['id'],
        title: lessonJson['subject'],
        time: DateTime.parse(lessonJson['plainDateTime']).toUtc(),
        status: lessonJson['status'],
      );
      return TeacherLesson(
        lesson: lesson,
        firstName: response['firstName'],
        lastName: response['lastName'],
      );
    }
    return null;
  }

  /// Получение всех уроков учителя за месяц
  Future<List<Lesson>> getTeacherLessonsForMonth(int year, int month) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final response = await _apiClient.getRequest(
      'teacher/get_all_lessons_by_month',
      queryParams: {'year': year.toString(), 'month': month.toString()},
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response != null) {
      return (response as List).map((lessonJson) {
        return Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: DateTime.parse(lessonJson['plainDateTime']),
          status: lessonJson['status'],
        );
      }).toList();
    }
    return List<Lesson>.empty();
  }
}
