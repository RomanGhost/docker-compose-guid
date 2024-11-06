import 'package:flutter/material.dart';

import '../../api/student_api.dart';
import '../../dataclasses/student.dart';
import '../../widgets/footer.dart';
import '../../widgets/side_menu.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [];
  final StudentApi _studentApi = StudentApi();

  @override
  void initState(){
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<Student> getStudents = await _studentApi.getStudents();


    setState(() {
      students = getStudents;
    });
  }

  Widget _buildBody(){
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student.firstName[0]), // Инициал имени
            ),
            title: Text('${student.firstName} ${student.lastName}'),
            subtitle: Text(student.subject),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Обработка нажатия на ученика
              _showStudentDetails(student);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ученики'),
      ),
      drawer: SideMenu(),
      body: Column(
        children: [
          _buildBody(),
          CustomFooter()
        ],
      ),
    );
  }

  // Метод для отображения деталей ученика
  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Информация об ученике'),
          content: Text('Имя: ${student.firstName}\nФамилия: ${student.lastName}\nEmail: ${student.email}\nИзучаемый предмет:${student.subject}(${student.level})'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
