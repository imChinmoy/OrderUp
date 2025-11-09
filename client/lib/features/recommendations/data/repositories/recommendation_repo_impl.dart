import 'package:client/features/recommendations/data/datasources/recommendation_service.dart';
import 'package:client/features/recommendations/domain/entities/recommendation_entity.dart';
import 'package:client/features/recommendations/domain/repository/recommendation_repo.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationService service;
  RecommendationRepositoryImpl(this.service);

  @override
  Future<List<RecommendationEntity>> fetchRecommendations(Map<String, dynamic> params) async {
    final models = await service.getRecommendations(params);
    return models.map((m) => m.toEntity()).toList();
  }
}
