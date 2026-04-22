import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
    required this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['ID'] ?? json['id'] ?? 0) as int,

      name: (json['Name'] ??
              json['name'] ??
              '') as String,

      description: (json['Description'] ??
              json['description'] ??
              '') as String,

      price: ((json['Price'] ??
                  json['price'] ??
                  0) as num)
              .toDouble(),

      stock: (json['Stock'] ??
              json['stock'] ??
              0) as int,

      category: (json['Category'] ??
              json['category'] ??
              '') as String,

      imageUrl: (json['ImageURL'] ??
              json['image_url'] ??
              '') as String,

      isActive: (json['IsActive'] ??
              json['is_active'] ??
              true) as bool,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        stock,
        category,
        imageUrl,
        isActive,
      ];
}