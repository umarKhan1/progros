import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.image,
    required this.size,
    required this.price,
    required this.categoryId,
    required this.subCategoryId,
    this.compareAt,
    this.isTrending = false,
    this.isBestDeal = false,
  });

  final String id;
  final String title;
  final String image;
  final String size;
  final double price;
  final double? compareAt;
  final bool isTrending;
  final bool isBestDeal;
  final String categoryId;
  final String subCategoryId;

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    size,
    price,
    compareAt,
    isTrending,
    isBestDeal,
    categoryId,
    subCategoryId,
  ];
}
