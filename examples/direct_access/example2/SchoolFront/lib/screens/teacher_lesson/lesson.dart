import 'package:flutter/material.dart';
import 'package:school/api/lesson_api.dart';
import 'package:school/dataclasses/lesson.dart';
import 'package:school/dataclasses/teacher_lesson.dart';

import '../../widgets/footer.dart';
import '../../widgets/side_menu.dart';

class TeacherLessonsScreen extends StatefulWidget {
  @override
  _TeacherLessonsScreenState createState() => _TeacherLessonsScreenState();
}

class _TeacherLessonsScreenState extends State<TeacherLessonsScreen> {
  final LessonApi _lessonApi = LessonApi();
  List<TeacherLesson> _proposedLessons = [];

  @override
  void initState() {
    super.initState();
    _loadProposedLessons();
  }

  Future<void> _loadProposedLessons() async {
    try {
      final teacherLessons = await _lessonApi.getProposedLessonsForTeacher();
      setState(() {
        _proposedLessons = teacherLessons;
      });
    } catch (e) {
      print('Failed to load proposed lessons: $e');
    }
  }

  void _approveLesson(Lesson lesson) async {
    try {
      final updatedLesson = await _lessonApi.approveLesson(lesson.id);
      if (updatedLesson != null) {
        setState(() {
          // Обновляем статус урока в списке
          for (int i = 0; i < _proposedLessons.length; i++) {
            if (_proposedLessons[i].lesson.id == lesson.id) {
              _proposedLessons[i] = TeacherLesson(
                lesson: updatedLesson.lesson,
                firstName: _proposedLessons[i].firstName,
                lastName: _proposedLessons[i].lastName,
              );
              break;
            }
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lesson approved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve lesson')),
        );
      }
    } catch (e) {
      print('Failed to approve lesson: $e');
    }
  }


  void _rejectLesson(Lesson lesson) async {
    try {
      final success = await _lessonApi.deleteLesson(lesson.id);
      if (success) {
        setState(() {
          _proposedLessons.removeWhere((tl) => tl.lesson.id == lesson.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lesson rejected')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject lesson')),
        );
      }
    } catch (e) {
      print('Failed to reject lesson: $e');
    }
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

  Widget _buildBody(){
    return _proposedLessons.isEmpty
        ? Center(child: Text('No proposed lessons'))
        : ListView.builder(
      itemCount: _proposedLessons.length,
      itemBuilder: (context, index) {
        final teacherLesson = _proposedLessons[index];
        return Card(
          elevation: 4,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  '${teacherLesson.lesson.status}: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(teacherLesson.lesson.status),
                  ),
                ),
                Expanded(
                  child: Text(
                    teacherLesson.lesson.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Date: ${teacherLesson.lesson.time}\n'
                  'Student: ${teacherLesson.firstName} ${teacherLesson.lastName}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => _approveLesson(teacherLesson.lesson),
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _rejectLesson(teacherLesson.lesson),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposed Lessons'),
      ),
      drawer: const SideMenu(),
      body: Column(
        children: [
          _buildBody(),
          CustomFooter()
        ],
      ),
    );
  }
}
