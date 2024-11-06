import 'package:flutter/material.dart';
import 'package:school/screens/user_lesson/widgets/subject_card.dart';
import '../../api/subject_api.dart';
import '../../dataclasses/subject.dart';
import '../../widgets/footer.dart';

class EnrollNewSubjectScreen extends StatefulWidget {
  @override
  _EnrollNewSubjectScreenState createState() => _EnrollNewSubjectScreenState();
}

class _EnrollNewSubjectScreenState extends State<EnrollNewSubjectScreen> {
  List<Subject> availableSubjects = [];
  SubjectApi subjectApi = SubjectApi();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<Subject> loadedSubjects = await subjectApi.getAvailableSubjects();
    setState(() {
      availableSubjects = loadedSubjects;
    });
  }

  Widget _buildBody(int crossAxisCount){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          // childAspectRatio: 1/2, //isMobile ? 1 / 1 : 3 / 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: availableSubjects.length,
        itemBuilder: (context, index) {
          final subject = availableSubjects[index];
          return SubjectCard(
            subject: subject,
            isEnrolled: false, // Предмет ещё не записан
            onEnroll: () {
              subjectApi.addSubjectUser(subject);
              Navigator.pushNamed(context, '/user_lesson');
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =(screenWidth ~/ 300)+1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись на предмет'),
      ),
      body: Column(
        children: [
          _buildBody(crossAxisCount),
          CustomFooter()
        ],
      ),
    );
  }
}
