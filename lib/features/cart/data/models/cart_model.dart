class CartProductModel {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

}
