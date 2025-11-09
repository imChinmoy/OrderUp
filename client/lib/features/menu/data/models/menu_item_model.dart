import '../../domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  MenuItemModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    bool isTrending = false,
    required bool isAvailable,
    required String? category,
  }) : super(
         id: id,
         name: name,
         description: description,
         price: price,
         imageUrl: imageUrl,
         isTrending: isTrending,
         isAvailable: isAvailable,
       );

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      isTrending: json['isTrending'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isTrending': isTrending,
      'isAvailable': isAvailable,
      'category': category,
    };
  }
}
