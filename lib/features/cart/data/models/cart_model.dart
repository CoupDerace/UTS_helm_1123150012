class CartProductModel {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['ID'] as int? ?? json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
 
class CartItemModel {
  final int id;
  final int productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
  
  num get subtotal => price * quantity;
}
class CartModel {
  final List<CartItemModel> items;
  final int total;

  CartModel({
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: ((json['items'] ?? []) as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }

double get totalPrice {
  double sum = 0;

  for (final item in items) {
    sum += item.subtotal;
  }

  return sum;
}
}