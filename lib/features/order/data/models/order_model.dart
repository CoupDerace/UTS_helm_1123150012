import 'package:flutter/foundation.dart';

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
    debugPrint('[OrderItemModel] parsing item: $json');
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = json['quantity'] as int? ?? 0;

    return OrderItemModel(
      productId:
          json['product_id'] as int? ?? json['id'] as int? ?? 0,
      productName:
          json['product_name'] as String? ??
          json['name'] as String? ??
          json['title'] as String? ??
          '',
      price: price,
      quantity: quantity,
      subtotal:
          (json['subtotal'] as num?)?.toDouble() ?? (price * quantity),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  // pending | processing | shipped | delivered | cancelled

  final String shippingAddress;
  final String notes;

  final String paymentMethod;
  // gopay | bank_transfer | transfer_bank | virtual_account | global_institute_pay

  final String? gopayDeeplink;
  final String? vaNumber;

  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,

    this.gopayDeeplink,
    this.vaNumber,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    debugPrint('[OrderModel] parsing order: $json');

    final rawItems = json['items'] as List<dynamic>? ?? [];

    final items = rawItems
        .where((e) => e != null)
        .map(
          (e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();

    // Handle berbagai kemungkinan nama field total dari backend
    final totalAmount =
        (json['total_amount'] as num?)?.toDouble() ??
        (json['total'] as num?)?.toDouble() ??
        (json['grand_total'] as num?)?.toDouble() ??
        // Kalau tidak ada field total, hitung dari items
        items.fold<double>(0.0, (sum, item) => sum + item.subtotal);

    // Handle berbagai kemungkinan nama field status
    final status =
        json['status'] as String? ??
        json['payment_status'] as String? ??
        json['order_status'] as String? ??
        'pending';

    // Handle berbagai kemungkinan nama field payment method
    final paymentMethod =
        json['payment_method'] as String? ??
        json['method'] as String? ??
        json['payment_type'] as String? ??
        '';

    debugPrint('[OrderModel] totalAmount=$totalAmount, status=$status, paymentMethod=$paymentMethod');

    return OrderModel(
      id: json['id'] as int? ?? 0,
      totalAmount: totalAmount,
      status: status,
      shippingAddress: json['shipping_address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      paymentMethod: paymentMethod,
      gopayDeeplink: json['gopay_deeplink'] as String?,
      vaNumber: json['va_number'] as String?,
      items: items,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  OrderModel copyWith({
    int? id,
    double? totalAmount,
    String? status,
    String? shippingAddress,
    String? notes,
    String? paymentMethod,
    String? gopayDeeplink,
    String? vaNumber,
    List<OrderItemModel>? items,
    String? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      gopayDeeplink: gopayDeeplink ?? this.gopayDeeplink,
      vaNumber: vaNumber ?? this.vaNumber,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'notes': notes,
      'payment_method': paymentMethod,
      'gopay_deeplink': gopayDeeplink,
      'va_number': vaNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
    };
  }
}
