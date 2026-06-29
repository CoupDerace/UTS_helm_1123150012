import 'package:flutter/foundation.dart';
import 'package:uts_catalog_helm/core/constants/api_constant.dart';
import 'package:uts_catalog_helm/core/services/dio_client.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  // Gunakan in-memory storage untuk memperbaiki bug API backend (dummy data/selalu 250rb/0 item)
  static final List<OrderModel> _localOrders = [];

  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
    required double totalAmount,
    required List<OrderItemModel> items,
  }) async {
    // Bypassing API backend karena mengembalikan order dummy.
    final newId = _localOrders.length + 1;
    
    final newOrder = OrderModel(
      id: newId,
      totalAmount: totalAmount,
      status: 'pending',
      shippingAddress: shippingAddress,
      notes: notes ?? '',
      paymentMethod: paymentMethod,
      items: items,
      createdAt: DateTime.now().toIso8601String(),
      vaNumber: paymentMethod == 'virtual_account' ? '8808${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}' : null,
    );

    _localOrders.insert(0, newOrder);
    return newOrder;
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    return _localOrders;
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    final order = _localOrders.firstWhere(
      (o) => o.id == orderId, 
      orElse: () => throw Exception('Order tidak ditemukan')
    );
    return order;
  }

  // Method khusus untuk mengupdate status (dipanggil dari OrderProvider)
  void updateLocalStatus(int orderId, String status) {
    final index = _localOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _localOrders[index];
      _localOrders[index] = OrderModel(
        id: old.id,
        totalAmount: old.totalAmount,
        status: status,
        shippingAddress: old.shippingAddress,
        notes: old.notes,
        paymentMethod: old.paymentMethod,
        items: old.items,
        createdAt: old.createdAt,
        gopayDeeplink: old.gopayDeeplink,
        vaNumber: old.vaNumber,
      );
    }
  }
}
