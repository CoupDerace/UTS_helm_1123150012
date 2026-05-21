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
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;

    final quantity = json['quantity'] as int? ?? 0;

    final apiSubtotal = (json['subtotal'] as num?)?.toDouble() ?? 0.0;

    final subtotal = apiSubtotal > 0 ? apiSubtotal : price * quantity;

    return OrderItemModel(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      price: price,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String notes;
  final String paymentMethod;
  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
  });

factory OrderModel.fromJson(Map<String, dynamic> json) {

    // Ambil list item order
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItemModel.fromJson(e))
        .toList();

    // Hitung total dari subtotal item
    final calculatedTotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );

    // Pakai total API kalau ada
    final apiTotal =
        (json['total_amount'] as num?)?.toDouble() ?? 0.0;

    final total =
        apiTotal > 0
            ? apiTotal
            : calculatedTotal;

    return OrderModel(
      id: json['id'] as int? ?? 0,
      totalAmount: total,
      status: json['status'] as String? ?? 'pending',
      shippingAddress:
          json['shipping_address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      paymentMethod:
          json['payment_method'] as String? ?? '',
      items: items,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
