class OrderItemModel {
final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

factory OrderItemModel.fromJson(Map<String, dynamic> json) {

    final price =
        (json['price'] as num?)?.toDouble() ?? 0.0;

    final quantity =
        json['quantity'] as int? ?? 0;

    final apiSubtotal =
        (json['subtotal'] as num?)?.toDouble() ?? 0.0;

    final subtotal =
        apiSubtotal > 0
            ? apiSubtotal
            : price * quantity;

    return OrderItemModel(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      price: price,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}