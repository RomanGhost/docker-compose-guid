import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/review_api.dart';
import '../../dataclasses/review.dart';
import '../../widgets/footer.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({Key? key}) : super(key: key);

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 0; // Initial rating set to 0
  bool _showUserData = true;
  bool _isAdmin = false; // Flag to check if user is admin
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController(); // Controller for source
  final ReviewApi _reviewApi = ReviewApi();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      print("JWT not found or expired");
    } else {
      final decodedToken = JwtDecoder.decode(jwt);
      final role = decodedToken['role']['authority'] as String;
      setState(() {
        _isAdmin = role == "ADMIN"; // Check if the role is ADMIN
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Написать отзыв'),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildReviewForm(),
            ),
          ),
          CustomFooter()
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderText('Оставьте отзыв', fontSize: 24),
          const SizedBox(height: 20),
          _buildStarRating(),
          const SizedBox(height: 20),
          _buildReviewTextField(),
          if (_isAdmin) ...[
            const SizedBox(height: 20),
            _buildSourceTextField(), // Show source field if admin
          ],
          const SizedBox(height: 20),
          _buildDataShowButton(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, {double fontSize = 22}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1; // Set rating based on tapped star
            });
          },
          child: Stack(
            children: [
              Icon(
                Icons.star,
                color: index < _rating ? _getStarColor(_rating) : Colors.grey,
                size: 30,
              ),
              const Icon(
                Icons.star_border,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        );
      }),
    );
  }

  Color _getStarColor(int index) {
    switch (index) {
      case 1:
        return Colors.red.shade400;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.orangeAccent;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.yellowAccent;
    }
    return Colors.grey;
  }

  Widget _buildReviewTextField() {
    return TextFormField(
      controller: _reviewController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Ваш отзыв',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Напишите свой отзыв здесь...',
      ),
    );
  }

  Widget _buildSourceTextField() {
    return TextFormField(
      controller: _sourceController,
      decoration: InputDecoration(
        labelText: 'Источник (опционально)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Введите источник...',
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitReview,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Отправить',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitReview() async {
    final review = _reviewController.text;
    final source = _isAdmin ? _sourceController.text : ''; // Include source if admin

    // Валидация: проверяем, что введен текст и выбран хотя бы одна звезда
    if (review.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Пожалуйста, заполните текст отзыва и выберите оценку.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Прерываем выполнение, если данные некорректны
    }

    // Создаем новый отзыв
    Review newReview = Review(
      rate: _rating,
      text: review,
      source: source,
      showUserData: _showUserData,
    );

    // Отправляем отзыв через API
    await _reviewApi.addNewReview(newReview);

    // После отправки очищаем форму и сбрасываем рейтинг
    _reviewController.clear();
    _sourceController.clear();
    setState(() {
      _rating = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ваш отзыв был отправлен! Спасибо!'),
      ),
    );
    Navigator.pushNamed(context, "/");
  }

  Widget _buildDataShowButton() {
    return Row(
      children: [
        Checkbox(
          value: _showUserData,
          onChanged: (bool? value) {
            setState(() {
              _showUserData = value ?? false;
            });
          },
        ),
        const SizedBox(width: 10),
        Text(
          "Показывать данные в отзыве",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
      ],
    );
  }
}
