import 'package:flutter/material.dart';
import 'package:school/dataclasses/review.dart';
import 'package:school/screens/main_page/widgets/home_screen_appbar.dart';

import '../../api/review_api.dart';
import '../../widgets/footer.dart';
import 'home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _profileImageUrl =
      'https://sun9-4.userapi.com/impg/DanbRYak08pujTBy6CJU_9ARqy0cY3WQgbgWLg/ZYMS0X2X_70.jpg?size=1440x2160&quality=95&sign=9ca63dacd74c0d3be5f4f00af54e69f9&type=album';
  List<Review> _reviews = [];
  final ReviewApi _reviewApi = ReviewApi();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<Review> reviews = await _reviewApi.getAllReview();
    setState(() {
      _reviews = reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeScreenBody(
              profileImageUrl: _profileImageUrl,
              reviews: _reviews,
            ),
            CustomFooter()
          ],
        ),
      ),
    );
  }
}
