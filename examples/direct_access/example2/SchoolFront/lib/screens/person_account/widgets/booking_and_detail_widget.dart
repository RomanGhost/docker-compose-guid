import 'package:flutter/material.dart';
import 'package:school/api/lesson_api.dart';
import 'package:school/api/subject_api.dart';
import 'package:school/dataclasses/subject.dart';
import 'package:school/screens/person_account/widgets/subject_picker_widget.dart';

import '../../../dataclasses/lesson.dart';


class BookingAndDetailWidget extends StatefulWidget {
  final DateTime day;
  final ValueNotifier<Map<DateTime, List<Lesson>>> lessonsNotifier;
  final ValueChanged<Lesson> onSave;
  final ValueChanged<int> onDelete;
  final bool allowAdding;

  const BookingAndDetailWidget({
    Key? key,
    required this.day,
    required this.lessonsNotifier,
    required this.onSave,
    required this.onDelete,
    required this.allowAdding,
  }) : super(key: key);

  @override
  _BookingAndDetailWidgetState createState() => _BookingAndDetailWidgetState();
}

class _BookingAndDetailWidgetState extends State<BookingAndDetailWidget> {
  SubjectApi subjectApi = SubjectApi();
  List<Subject> _availableSubjects = [];

  final LessonApi _lessonApi = LessonApi();
  String? _selectedSubject;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Инициализация списка доступных предметов
    _initialize();
  }

  void _initialize() async {
    List<Subject> loadedSubjects = await subjectApi.getUserSubjects();
    setState(() {
      _availableSubjects = loadedSubjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildLessonsList(),
          if (widget.allowAdding) _buildLessonForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Уроки на ${_formatDate(widget.day)}",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLessonsList() {
    return ValueListenableBuilder<Map<DateTime, List<Lesson>>>(
      valueListenable: widget.lessonsNotifier,
      builder: (context, lessonsMap, _) {
        final lessons = lessonsMap[widget.day] ?? [];
        return Column(
          children: lessons.map((lesson) => _buildLessonCard(lesson)).toList(),
        );
      },
    );
  }

  Widget _buildLessonCard(Lesson lesson) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: _buildLessonTitle(lesson),
        trailing: _buildDeleteButton(lesson),
      ),
    );
  }

  Widget _buildLessonTitle(Lesson lesson) {
    return Row(
      children: [
        Text(
          '${lesson.status}: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(lesson.status),
          ),
        ),
        Expanded(
          child: Text(
            lesson.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  IconButton? _buildDeleteButton(Lesson lesson) {
    final isPast = widget.day.isBefore(DateTime.now()) && !isSameDay(widget.day, DateTime.now());
    if (isPast) return null;

    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.black87),
      onPressed: () => _deleteLesson(lesson),
    );
  }

  Future<void> _deleteLesson(Lesson lesson) async {
    try {
      final bool success = await _lessonApi.deleteLesson(lesson.id);
      if (success) {
        widget.onDelete(lesson.id);
        _removeLessonFromNotifier(lesson);
      } else {
        _showError('Не удалось удалить урок');
      }
    } catch (e) {
      _showError('Ошибка при удалении урока: ${e.toString()}');
    }
  }

  void _removeLessonFromNotifier(Lesson lesson) {
    final lessons = widget.lessonsNotifier.value[widget.day];
    if (lessons != null) {
      setState(() {
        lessons.removeWhere((l) => l.id == lesson.id);
        widget.lessonsNotifier.value[widget.day] = lessons;
      });
    }
  }

  Widget _buildLessonForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildSubjectPicker(),
        const SizedBox(height: 16),
        _buildTimePicker(),
        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSubjectPicker() {
    return SubjectPickerWidget(
      subjects: _availableSubjects,
      selectedSubject: _selectedSubject, // Передаем выбранный предмет
      onSubjectSelected: (subject) => setState(() {
        _selectedSubject = subject;
      }),
    );
  }


  Widget _buildTimePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedTime != null
                ? "Время: ${_selectedTime!.format(context)}"
                : "Выберите время",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () => _pickTime(),
          child: const Text("Выбрать время"),
        ),
      ],
    );
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveLesson,
      child: const Text("Добавить урок"),
    );
  }

  Future<void> _saveLesson() async {
    if (_selectedSubject == null || _selectedTime == null) {
      _showError("Выберите предмет и время");
      return;
    }

    final lessonDateTime = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newLesson = Lesson(
      title: _selectedSubject!,
      time: lessonDateTime,
      status: "Создан",
    );

    try {
      final addedLesson = await _lessonApi.addLessons(newLesson);
      if (addedLesson != null) {
        widget.onSave(addedLesson);
        _resetForm();
      } else {
        _showError('Не удалось добавить урок');
      }
    } catch (e) {
      _showError('Ошибка при добавлении урока: ${e.toString()}');
    }
  }

  void _resetForm() {
    setState(() {
      _selectedSubject = null;
      _selectedTime = null;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Подтвержден':
        return Colors.green;
      case 'Отменен':
        return Colors.red;
      case 'Создан':
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    int day = date.day;
    int month = date.month;

    String strDay = day.toString();
    if(day < 10){
      strDay = "0$day";
    }

    String strMonth = month.toString();
    if(month < 10){
      strMonth = "0$month";
    }

    return "$strDay.$strMonth.${date.year}";
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
