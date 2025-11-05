class MenuItemEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isTrending;
  final String? category;

  MenuItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isTrending = false,
    this.category,
  });
}
