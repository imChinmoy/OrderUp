import '../entities/recommendation_entity.dart';
import '../repository/recommendation_repo.dart';


class GetRecommendationsUsecase {
  final RecommendationRepository repo;
  GetRecommendationsUsecase(this.repo);

  Future<List<dynamic>> call(Map<String, dynamic> params) {
    return repo.fetchRecommendations(params);
  }
}