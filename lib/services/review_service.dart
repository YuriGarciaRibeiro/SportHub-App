import 'package:sporthub/core/app_export.dart';
import 'package:sporthub/core/constants/api_config.dart';
import 'package:sporthub/core/http/http_client_manager.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final _httpClient = HttpClientManager().client;

  Future<void> submitEstablishmentReview({String? establishmentId, int? rating, String? comment}) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiConfig.reviewsEndpoint),
        body: {
          'targetId': establishmentId,
          'targetType': 1,
          'rating': rating,
          'comment': comment,
        },
      );
      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode != 204) {
        debugPrint('Failed to submit review: ${response.body}');
        throw Exception('Failed to submit review');
      }
      debugPrint('Review submitted successfully');

    } catch (e) {
      debugPrint('Error submitting review: $e');
      throw Exception('Error submitting review: $e');
    }
  }


}

// "targetId": "",
//   "targetType": 1,
//   "rating": 1,
//   "comment": ""
