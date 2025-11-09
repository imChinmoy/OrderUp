class RecommendationEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int deliveryTime;
  final String imageUrl;
  final String category;

  RecommendationEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.deliveryTime,
    required this.imageUrl,
    required this.category,
  });
}
