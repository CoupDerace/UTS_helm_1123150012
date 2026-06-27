import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/data/repositories/order_repository_impl.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

enum PaymentCheckStatus { idle, checking, paid, failed }

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

  Future<void> fetchMyOrders() async {
    _checkoutStatus = OrderStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _orders = await _repository.getMyOrders();

      _checkoutStatus = OrderStatus.success;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading() {
    _checkoutStatus = OrderStatus.loading;
    _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _checkoutStatus = OrderStatus.error;
    notifyListeners();
  }

  // ── Payment polling ───────────────────────────────────────────

  PaymentCheckStatus _paymentCheckStatus = PaymentCheckStatus.idle;
  PaymentCheckStatus get paymentCheckStatus => _paymentCheckStatus;

  Timer? _pollingTimer;

  /// Mulai polling backend setiap 5 detik untuk memeriksa status pembayaran.
  void startPaymentPolling(int orderId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_paymentCheckStatus == PaymentCheckStatus.paid) {
        stopPaymentPolling();
        return;
      }
      await checkPaymentStatus(orderId);
    });
  }

  void stopPaymentPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Cek status pembayaran dari backend.
  /// Jika order sudah bukan 'pending', set status ke [PaymentCheckStatus.paid].
  Future<void> checkPaymentStatus(int id) async {
    if (_paymentCheckStatus == PaymentCheckStatus.checking) return;

    _paymentCheckStatus = PaymentCheckStatus.checking;
    notifyListeners();

    try {
      final updatedOrder = await _repository.getOrderDetail(id);

      // Update lastOrder agar Order #N tampil dengan ID yang benar
      _lastOrder = updatedOrder;

      // Status selain 'pending' berarti pembayaran sudah dikonfirmasi
      if (updatedOrder.status != 'pending') {
        _paymentCheckStatus = PaymentCheckStatus.paid;
        stopPaymentPolling();
      } else {
        _paymentCheckStatus = PaymentCheckStatus.idle;
      }
    } catch (e) {
      debugPrint('[OrderProvider] checkPaymentStatus error: $e');
      _paymentCheckStatus = PaymentCheckStatus.idle;
    }

    notifyListeners();
  }
}
