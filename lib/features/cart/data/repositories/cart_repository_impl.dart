import 'package:uts_catalog_helm/core/constants/api_constant.dart';
import 'package:uts_catalog_helm/core/services/dio_client.dart';
import 'package:uts_catalog_helm/features/cart/data/models/cart_model.dart';
import 'package:uts_catalog_helm/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  @override
  Future<CartModel> getCart() async {
    final response = await DioClient.instance.get(ApiConstant.cart);
    final data = response.data['data'] as Map<String, dynamic>;
    return CartModel.fromJson(data);
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    await DioClient.instance.post(
      ApiConstant.cart,
      data: {'product_id': productId, 'quantity': quantity},
    );
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity) async {
    await DioClient.instance.put(
      '${ApiConstant.cart}/$cartItemId', // /v1/cart/1
      data: {'quantity': quantity},
    );
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    await DioClient.instance.delete('${ApiConstant.cart}/$cartItemId');
  }

  @override
  Future<void> clearCart() async {
    await DioClient.instance.delete(ApiConstant.cart);
  }
}
