import 'package:flutter/material.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/data/repositories/order_repository_impl.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderModel? _lastOrder;
  List<OrderModel> _orders = [];
  String? _error;

  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderModel? get lastOrder => _lastOrder;
  List<OrderModel> get orders => _orders;
  String? get error => _error;

  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _setLoading();

    try {
      final result = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );

      _lastOrder = result;

      _checkoutStatus = OrderStatus.success;

      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    }
  }
}
