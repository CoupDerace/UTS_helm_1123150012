import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_catalog_helm/core/constants/api_constant.dart';
import 'package:uts_catalog_helm/core/services/dio_client.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  // Gunakan in-memory storage untuk memperbaiki bug API backend (dummy data/selalu 250rb/0 item)
  static final List<OrderModel> _localOrders = [];
  static bool _isLoaded = false;

  static Future<void> _loadLocalOrders() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('local_orders_data');
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        _localOrders.clear();
        _localOrders.addAll(jsonList.map((e) => OrderModel.fromJson(e)).toList());
      } catch (e) {
        debugPrint('Error parsing local orders: $e');
      }
    }
    _isLoaded = true;
  }

  static Future<void> _saveLocalOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _localOrders.map((e) => e.toJson()).toList();
    await prefs.setString('local_orders_data', jsonEncode(jsonList));
  }

  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
    required double totalAmount,
    required List<OrderItemModel> items,
  }) async {
    await _loadLocalOrders();
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
    await _saveLocalOrders();
    return newOrder;
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    await _loadLocalOrders();
    return _localOrders;
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    await _loadLocalOrders();
    final order = _localOrders.firstWhere(
      (o) => o.id == orderId, 
      orElse: () => throw Exception('Order tidak ditemukan')
    );
    return order;
  }

  // Method khusus untuk mengupdate status (dipanggil dari OrderProvider)
  Future<void> updateLocalStatus(int orderId, String status) async {
    await _loadLocalOrders();
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
      await _saveLocalOrders();
    }
  }
}
