abstract class RecommendationRepository {
  Future<List<dynamic>> fetchRecommendations(Map<String, dynamic> params);
}
