import 'package:client/features/recommendations/data/datasources/recommendation_service.dart';
import 'package:client/features/recommendations/domain/repository/recommendation_repo.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationService service;
  RecommendationRepositoryImpl(this.service);

  @override
  Future<List<dynamic>> fetchRecommendations(Map<String, dynamic> params) {
    return service.getRecommendations(params);
  }
}
