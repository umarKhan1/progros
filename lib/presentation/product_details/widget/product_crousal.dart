import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  const ProductImageCarousel({required this.images, super.key});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) =>
            Image.network(images[index], fit: BoxFit.cover),
      ),
    );
  }
}
