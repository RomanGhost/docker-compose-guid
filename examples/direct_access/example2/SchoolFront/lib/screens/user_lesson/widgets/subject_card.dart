import 'package:flutter/material.dart';
import '../../../dataclasses/subject.dart';

class SubjectCard extends StatefulWidget {
  final Subject subject;
  final bool isEnrolled;
  final Function()? onCancel;
  final Function()? onEnroll;
  final bool showDropdown; // Новый параметр для управления отображением выпадающего меню

  const SubjectCard({
    Key? key,
    required this.subject,
    this.isEnrolled = false,
    this.onCancel,
    this.onEnroll,
    this.showDropdown = true, // По умолчанию выпадающее меню отображается
  }) : super(key: key);

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  Widget _buildLevelDropdownOrText() {
    if (widget.showDropdown) {
      return Container(
        width: 120, // Fixed width for the dropdown menu
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            labelText: 'Уровень',
            labelStyle: TextStyle(fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: TextStyle(fontSize: 12), // Font size inside dropdown
          value: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].contains(widget.subject.level)
              ? widget.subject.level
              : 'A1', // Устанавливаем уровень по умолчанию, если текущий уровень невалидный
          items: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
              .map((level) => DropdownMenuItem<String>(
            value: level,
            child: Text(level),
          ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.subject.level = value; // Update the subject level
              });
            }
          },
        ),
      );
    } else {
      // Если выпадающее меню не нужно, отображаем просто текст
      return Text(
        'Уровень: ${widget.subject.level}',
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: Text(
              'Вы уверены, что хотите отменить запись на предмет "${widget.subject.name}"? (Все будущие предметы удалятся)'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldDelete && widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.subject.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Цена: ${widget.subject.price}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            _buildLevelDropdownOrText(), // Заменяем выпадающее меню или текстом
            const SizedBox(height: 16),
            widget.isEnrolled
                ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[200],
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () => _showDeleteConfirmationDialog(context),
              icon: const Icon(
                Icons.cancel,
                size: 17,
                color: Colors.white,
              ),
              label: const Text(
                'Отменить',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6498E4),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              onPressed: widget.onEnroll,
              child: const Text(
                'Записаться',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
