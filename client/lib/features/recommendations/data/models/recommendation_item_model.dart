import 'package:client/features/recommendations/domain/entities/recommendation_entity.dart';

class RecommendationItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int deliveryTime;
  final String imageUrl;
  final String category;

  RecommendationItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.deliveryTime,
    required this.imageUrl,
    required this.category,
  });

  factory RecommendationItemModel.fromJson(Map<String, dynamic> json) {
    return RecommendationItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      deliveryTime: json['deliveryTime'] ?? 20,
      imageUrl: json['imageUrl'] ?? "",
      category: json['category'] ?? "",
    );
  }

  RecommendationEntity toEntity() {
    return RecommendationEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      rating: rating,
      deliveryTime: deliveryTime,
      imageUrl: imageUrl,
      category: category,
    );
  }
}
