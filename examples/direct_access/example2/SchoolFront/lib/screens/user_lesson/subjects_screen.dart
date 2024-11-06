import 'package:flutter/material.dart';
import 'package:school/screens/user_lesson/widgets/subject_card.dart';

import '../../api/subject_api.dart';
import '../../dataclasses/subject.dart';
import '../../widgets/footer.dart';
import '../../widgets/side_menu.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];
  SubjectApi subjectApi = SubjectApi();

  @override
  void initState() {
    super.initState();
    _initializeSubjects();
  }

  void _initializeSubjects() async {
    List<Subject> loadedSubjects = await subjectApi.getUserSubjects();
    setState(() {
      subjects = loadedSubjects;
    });
  }

  void _onCancel(int subjectId) {
    Subject delSubject = subjects.firstWhere((subject) => subject.id == subjectId);
    subjectApi.deleteUserSubject(delSubject);
    setState(() {
      subjects.remove(delSubject);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запись на предмет с ID: $subjectId отменена')),
    );
  }

  Future<void> _onEnrollNew() async {
    Navigator.pushNamed(context, '/enroll_subject');
  }

  Widget _buildBody(int crossAxisCount, double screenWidth){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: subjects.isEmpty
          ? Center(
        child: Text(
          'Нет записанных предметов',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Динамическое количество колонок
          childAspectRatio: 0.75, // Высота/ширина карточки
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.45, // Ограничение ширины карточек на основе ширины экрана
              minWidth: 150, // Минимальная ширина карточки
            ),
            child: SubjectCard(
              subject: subject,
              isEnrolled: true, // Это для записанных предметов
              onCancel: () => _onCancel(subject.id),
              showDropdown: false, // Отключаем выпадающее меню для этого экрана
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана
    double screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Устанавливаем количество колонок в зависимости от ширины экрана
    int crossAxisCount = (screenWidth / 200).floor(); // Минимальная ширина карточки 200 пикселей

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои предметы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onEnrollNew,
          ),
        ],
      ),
      drawer: SideMenu(), // Добавление боковой панели
      body:Column(
        children: [
          _buildBody(crossAxisCount, screenHeight),
          CustomFooter()
        ],
      ),
    );
  }
}
