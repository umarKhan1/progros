import 'package:flutter/material.dart';

import 'package:progros/models/product_details_model.dart';

class SimilarProductsList extends StatelessWidget {
  // ignore: lines_longer_than_80_chars
  const SimilarProductsList({required this.products, super.key});
  final List<ProductDetailModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar Products',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => SizedBox(
              width: 140,
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        products[i].images.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        products[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
