import 'package:flutter/material.dart';
import 'package:school/dataclasses/subject.dart';

class SubjectPickerWidget extends StatefulWidget {
  final List<Subject> subjects;
  final String? selectedSubject;
  final ValueChanged<String?> onSubjectSelected;

  const SubjectPickerWidget({
    Key? key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
  }) : super(key: key);

  @override
  _SubjectPickerWidgetState createState() => _SubjectPickerWidgetState();
}

class _SubjectPickerWidgetState extends State<SubjectPickerWidget> {
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    // Устанавливаем первый предмет сразу
    if (widget.subjects.isNotEmpty) {
      _selectedSubject = widget.subjects.first.name;
      widget.onSubjectSelected(_selectedSubject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Выберите предмет"),
      value: _selectedSubject,
      items: _buildDropdownMenuItems(),
      onChanged: (newValue) {
        setState(() {
          _selectedSubject = newValue;
        });
        widget.onSubjectSelected(newValue);
      },
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    return widget.subjects.map((subject) {
      return DropdownMenuItem<String>(
        value: subject.name,
        child: Text(subject.name),
      );
    }).toList();
  }
}
