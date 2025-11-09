import 'package:client/features/recommendations/domain/usecases/get_recommendations_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/recommendation_service.dart';
import '../../data/repositories/recommendation_repo_impl.dart';


final recommendationsProvider = FutureProvider.family<List<dynamic>, Map<String, dynamic>>(
  (ref, params) async {
    final client = http.Client();
    final service = RecommendationServiceImpl(client);
    final repo = RecommendationRepositoryImpl(service);
    final usecase = GetRecommendationsUsecase(repo);

    final result = await usecase(params);
    client.close();
    return result;
  },
);
