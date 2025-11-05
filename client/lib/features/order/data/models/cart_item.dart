class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "price": price,
        "quantity": quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        price: (json["price"] as num).toDouble(),
        quantity: json["quantity"],
      );
}
