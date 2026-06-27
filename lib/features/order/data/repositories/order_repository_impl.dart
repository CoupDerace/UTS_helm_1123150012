import 'package:flutter/foundation.dart';
import 'package:uts_catalog_helm/core/constants/api_constant.dart';
import 'package:uts_catalog_helm/core/services/dio_client.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    final response = await DioClient.instance.post(
      ApiConstant.checkout,
      data: {
        'shipping_address': shippingAddress,
        'notes': notes ?? '',
        'payment_method': paymentMethod,
      },
    );

    // DEBUG: lihat raw response dari backend
    debugPrint('[OrderRepo] checkout raw response: ${response.data}');

    final responseBody = response.data;
    // Coba ambil dari 'data', kalau null coba langsung dari root
    final data = responseBody['data'] ?? responseBody['order'] ?? responseBody;
    if (data == null) {
      throw Exception('Checkout gagal: data kosong');
    }

    debugPrint('[OrderRepo] checkout data field: $data');
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    final response = await DioClient.instance.get(
      ApiConstant.orders,
      queryParameters: {'page': page, 'limit': limit},
    );

    final List<dynamic> data = response.data['data'] ?? [];

    return data
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    final response = await DioClient.instance.get(
      '${ApiConstant.orders}/$orderId',
    );

    // DEBUG: lihat raw response
    debugPrint('[OrderRepo] getOrderDetail raw response: ${response.data}');

    final responseBody = response.data;
    final data = responseBody['data'] ?? responseBody['order'] ?? responseBody;

    if (data == null) {
      throw Exception('Order tidak ditemukan');
    }

    debugPrint('[OrderRepo] getOrderDetail data field: $data');
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }
}
