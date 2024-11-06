import 'package:school/api/api_interface.dart';
import 'package:school/dataclasses/review.dart';
import 'package:school/service/jwt_work.dart';
import '../dataclasses/config.dart';
import 'api_client.dart';

class ReviewApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api/review';
  late final ApiClient _apiClient;

  ReviewApi() {
    _apiClient = ApiClient(_baseUrl); // Инициализация ApiClient
  }

  /// Получение всех отзывов
  Future<List<Review>> getAllReview() async {
    try {
      final result = await _apiClient.getRequest('get_all', headers: {
        'Content-Type': 'application/json',
      });

      if (result != null) {
        List<Review> resultReview = List.empty(growable: true);

        for (var reviewJson in result) {
          Review newReview = Review(
            rate: reviewJson['rate'],
            text: reviewJson['text'],
            source: reviewJson['source'],
            userData: reviewJson['userData'],
          );
          resultReview.add(newReview);
        }
        return resultReview;
      } else {
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching reviews: $e');
      return [];
    }
  }

  /// Добавление нового отзыва
  Future<void> addNewReview(Review review) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    try {
      final result = await _apiClient.postRequest(
        'add',
        review.getJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (result == null) {
        print('Failed to send review');
      }
    } catch (e) {
      print('Error occurred while adding review: $e');
    }
  }
}
