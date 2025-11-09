import 'package:client/features/recommendations/domain/entities/recommendation_entity.dart';

abstract class RecommendationRepository {
  Future<List<RecommendationEntity>> fetchRecommendations(Map<String, dynamic> params);
}
