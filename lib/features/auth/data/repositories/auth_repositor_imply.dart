import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/constants/api_constant.dart';
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstant.verifyToken,
      data: {'firebase_token': firebaseToken},
    );


    final data = response.data['data'] as Map<String, dynamic>;
    return data['access_token'] as String;
  }
}