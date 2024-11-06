import 'package:flutter/material.dart';

import '../../../api/lesson_api.dart';
import '../../../dataclasses/lesson.dart';
import 'Calendar.dart';

class NextLessonWidget extends StatefulWidget {
  @override
  _NextLessonWidgetState createState() => _NextLessonWidgetState();
}

class _NextLessonWidgetState extends State<NextLessonWidget> {
  // static const String datetime = '13:34 23.02';
  static const String goodText = "Хорошего дня😜";
  final lessonWidget = LessonCalendarWidget();
  final LessonApi _lessonApi = LessonApi();
  Lesson? _nextLesson = null;

  @override
  void initState(){
    super.initState();
    _initialize();
  }

  void _initialize() async{
    Lesson? nextLesson = await _lessonApi.getNextLessons();
    setState(() {
      _nextLesson = nextLesson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xFF6498E4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Выровнять текст по левому краю
          children: [
            _buildText("Следующий урок:", 24, Colors.white, FontWeight.w300),
            _buildNextLesson(_nextLesson),
            _buildText(goodText, 20, Colors.white70, FontWeight.bold),
            ExpansionTile(
              title: _buildText("Показать календарь", 20, Colors.white, FontWeight.w200),
              tilePadding: EdgeInsets.zero, // Убираем отступы
              childrenPadding: EdgeInsets.zero, // Убираем отступы для контента внутри
              collapsedBackgroundColor: Colors.transparent, // Убираем фон у заголовка при свернутом состоянии
              backgroundColor: Colors.transparent, // Убираем фон у заголовка при раскрытом состоянии
              collapsedIconColor: Colors.white, // Цвет иконки в свернутом состоянии
              iconColor: Colors.white,
              children: [
                lessonWidget, // Встроенный виджет календаря
              ], // Цвет иконки в раскрытом состоянии
              // dividerColor: Colors.transparent, // Убираем линию
            ),
          ],
        ),
      ),
    );
  }

  Text _buildNextLesson(Lesson? lesson){
    String lessonText = "Следующий урок не найден. Стоит записаться!";
    if (lesson != null) {
      int day = lesson.time.day;
      int month = lesson.time.month;

      String strDay = day.toString();
      if(day < 10){
        strDay = "0$day";
      }

      String strMonth = month.toString();
      if(month < 10){
        strMonth = "0$month";
      }

      lessonText = "${lesson.toString()} $strDay.$strMonth.${lesson.time.year}";
    }
    return _buildText(lessonText, 20, Colors.white, FontWeight.w200);
  }

  Text _buildText(String text, double fontSize, Color color, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }
}
