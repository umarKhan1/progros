class ProductDetailModel {
  ProductDetailModel({
    required this.images,
    required this.title,
    required this.rating,
    required this.price,
    required this.description,
    required this.reviews,
    this.compareAt,
    this.discount,
  });
  final List<String> images;
  final String title;
  final double rating;
  final double price;
  final double? compareAt;
  final int? discount;
  final String description;
  final List<String> reviews;

  // ignore: prefer_constructors_over_static_methods
  static ProductDetailModel mock() => ProductDetailModel(
    images: [
      'https://via.placeholder.com/300',
      'https://via.placeholder.com/300',
    ],
    title: 'Sample Product',
    rating: 4.5,
    price: 29.99,
    compareAt: 39.99,
    discount: 25,
    description:
        'This is a sample product description. It can be long or short.',
    reviews: ['Great product!', 'Loved it!', 'Would buy again.'],
  );

  static List<ProductDetailModel> mockList() => [mock(), mock()];
}
