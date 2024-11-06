import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school/api/lesson_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../dataclasses/lesson.dart';
import 'booking_and_detail_widget.dart';

class LessonCalendarWidget extends StatefulWidget {
  @override
  _LessonCalendarWidgetState createState() => _LessonCalendarWidgetState();
}

class _LessonCalendarWidgetState extends State<LessonCalendarWidget> {
  final ValueNotifier<Map<DateTime, List<Lesson>>> _lessonsNotifier = ValueNotifier({});
  final ValueNotifier<DateTime> _selectedDayNotifier = ValueNotifier(DateTime.now());
  DateTime _focusedDay = DateTime.now();
  final LessonApi _lessonApi = LessonApi();

  @override
  void initState() {
    super.initState();
    _initializeLessonsForMonth(_focusedDay); // Инициализация только для текущего месяца
  }

  /// Инициализация уроков для выбранного месяца.
  void _initializeLessonsForMonth(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    String role = "USER";
    if(jwt == null || JwtDecoder.isExpired(jwt)){
      print("jwt not found");
    }
    else {
      final decodedToken = JwtDecoder.decode(jwt);
      final email = decodedToken['sub'] as String?;
      role = decodedToken['role']['authority'] as String;
    }
    try {
      final lessons;
      if(role == "TEACHER"){
        lessons = await _lessonApi.getTeacherLessonsForMonth( date.year, date.month);
      }else {
        lessons = await _lessonApi.getLessonsForMonth(
            date.year, date.month); // Запрос уроков за месяц
      }

      _lessonsNotifier.value = _groupLessonsByDate(lessons);
    } catch (e) {
      print('Failed to initialize lessons for month: $e');
    }
  }

  /// Группировка уроков по датам.
  Map<DateTime, List<Lesson>> _groupLessonsByDate(List<Lesson> lessons) {
    final resultLessons = <DateTime, List<Lesson>>{};
    for (var lesson in lessons) {
      final date = DateTime.utc(lesson.time.year, lesson.time.month, lesson.time.day);
      resultLessons[date] = (resultLessons[date] ?? [])..add(lesson);
    }
    return resultLessons;
  }

  /// Получение уроков для определенного дня.
  List<Lesson> _getLessonsForDay(DateTime day) => _lessonsNotifier.value[day] ?? [];

  /// Обработка выбора дня в календаре.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDayNotifier.value = selectedDay;
    setState(() {
      // Если выбранный день находится в другом месяце, загружаем уроки для этого месяца
      if (focusedDay.month != _focusedDay.month || focusedDay.year != _focusedDay.year) {
        _initializeLessonsForMonth(focusedDay);
      }
      _focusedDay = focusedDay;
    });
    _showBookingAndDetailWidget(selectedDay);
  }

  /// Обработка изменения страницы в календаре.
  void _onPageChanged(DateTime focusedDay) {
    // Если изменился месяц, загружаем уроки для нового месяца
    if (focusedDay.month != _focusedDay.month || focusedDay.year != _focusedDay.year) {
      setState(() {
        _focusedDay = focusedDay;
      });
      _initializeLessonsForMonth(focusedDay);
    }
  }

  /// Отображение модального окна с деталями и возможностью бронирования.
  void _showBookingAndDetailWidget(DateTime day) {
    final allowAdding = day.isAfter(DateTime.now()) || _isSameDay(day, DateTime.now());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BookingAndDetailWidget(
        day: day,
        lessonsNotifier: _lessonsNotifier,
        onSave: (lesson) => _addLesson(day, lesson),
        onDelete: (index) => _deleteLesson(day, index),
        allowAdding: allowAdding,
      ),
    );
  }

  /// Удаление урока.
  void _deleteLesson(DateTime day, int lessonId) {
    final lessons = _lessonsNotifier.value[day];
    if (lessons != null) {
      final lessonIndex = lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        setState(() {
          lessons.removeAt(lessonIndex);
          if (lessons.isEmpty) {
            _lessonsNotifier.value.remove(day);
          }
          _lessonsNotifier.value = Map.from(_lessonsNotifier.value); // Уведомление слушателей
        });
      }
    }
  }

  /// Добавление нового урока.
  void _addLesson(DateTime day, Lesson lesson) {
    final lessons = _lessonsNotifier.value[day] ?? [];
    lessons.add(lesson);
    _lessonsNotifier.value = {
      ..._lessonsNotifier.value,
      day: lessons,
    };
  }

  @override
  void dispose() {
    _lessonsNotifier.dispose();
    _selectedDayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDayNotifier,
      builder: (context, selectedDay, _) {
        return ValueListenableBuilder<Map<DateTime, List<Lesson>>>(
          valueListenable: _lessonsNotifier,
          builder: (context, lessonMap, __) {
            return TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
              onDaySelected: _onDaySelected,
              onPageChanged: _onPageChanged, // Обработка смены месяца
              eventLoader: _getLessonsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: _buildCalendarStyle(),
              headerStyle: _buildHeaderStyle(),
            );
          },
        );
      },
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return const CalendarStyle(
      markerDecoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.circle,
      ),
      defaultTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      weekendTextStyle: TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      todayTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      todayDecoration: BoxDecoration(
        color: Color(0xFFFFA726),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFF66BB6A),
        shape: BoxShape.circle,
      ),

    );
  }

  HeaderStyle _buildHeaderStyle() {
    return const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
