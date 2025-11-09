class MenuModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool isAvailable;

  MenuModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      price: (json["price"] ?? 0).toDouble(),
      imageUrl: json["imageUrl"] ?? "",
      isAvailable: json["isAvailable"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "price": price,
    "imageUrl": imageUrl,
    "isAvailable": isAvailable,
  };
}
