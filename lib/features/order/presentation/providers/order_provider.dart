import 'package:flutter/material.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  error,
}

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository =
      OrderRepositoryImpl();

  OrderStatus _checkoutStatus =
      OrderStatus.initial;

  OrderModel? _lastOrder;

  List<OrderModel> _orders = [];

  String? _error;
}