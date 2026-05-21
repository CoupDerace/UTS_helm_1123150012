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

    final data =
        response.data['data'] as Map<String, dynamic>;

    return OrderModel.fromJson(data);
  }

  @override
  Future<List<OrderModel>> getMyOrders({
    int page = 1,
    int limit = 10,
  }) async {

    final response = await DioClient.instance.get(
      ApiConstant.orders,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> data =
        response.data['data'] ?? [];

    return data
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  @override
  Future<OrderModel> getOrderDetail(
    int orderId,
  ) async {

    final response = await DioClient.instance.get(
      '${ApiConstant.orders}/$orderId',
    );

    final data =
        response.data['data'] as Map<String, dynamic>;

    return OrderModel.fromJson(data);
  }
}