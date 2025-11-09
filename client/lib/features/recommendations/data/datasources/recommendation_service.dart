import 'dart:convert';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:client/features/recommendations/data/models/recommendation_item_model.dart';
import 'package:http/http.dart' as http;

abstract class RecommendationService {
  Future<List<RecommendationItemModel>> getRecommendations(
    Map<String, dynamic> params,
  );
}

class RecommendationServiceImpl implements RecommendationService {
  final http.Client client;
  RecommendationServiceImpl(this.client);

  @override
  @override
  Future<List<RecommendationItemModel>> getRecommendations(
    Map<String, dynamic> params,
  ) async {
    final session = await HiveSessionStorage().getSession();
    final token = session?.token ?? "";

    final url = Uri.parse("${ApiConfig.baseUrl}/ml/recommend");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "Category": params['category'],
        "Group_Size": params['groupSize'],
        "Rating": params['rating'],
        "Avg_Spend": params['budget'],
        "Delivery_Time": params['deliveryTime'],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("ML model failed: ${response.body}");
    }

    final decoded = jsonDecode(response.body);

    final rec = decoded["recommendations"];
    if (rec == null || rec["Top_Items"] == null) return [];

    final items = rec["Top_Items"] as List;

    return items.map((item) {
      return RecommendationItemModel(
        id: item["Item_Name"],
        name: item["Item_Name"],
        description: "Recommended drink based on your preference",
        price: item["price"]?.toDouble() ?? 0.0,
        rating: item["prob"] * 5,
        deliveryTime: 20,
        imageUrl: item["imageUrl"] ?? "",
        category: rec["Category"],
      );
    }).toList();
  }
}
