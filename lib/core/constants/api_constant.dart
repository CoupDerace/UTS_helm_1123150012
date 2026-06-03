class ApiConstant {
  static const String baseUrl = 'http://192.168.100.180:8080/v1';
  static const String verifyToken = '/auth/verify-token';
  static const String products = '/products';
  static const String cart = '/carts';
  static const String orders = '/orders';
  static const String checkout = '/checkout';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
