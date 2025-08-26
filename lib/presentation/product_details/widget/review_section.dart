import 'package:flutter/material.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    required this.rating,
    required this.reviewCount,
    required this.reviews,
    super.key,
  });
  final double rating;
  final int reviewCount;
  final List<Map<String, dynamic>> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews & Ratings',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        12.hsb,
        Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            8.wsb,
            ...List.generate(
              5,
              (i) => Icon(
                i < rating.round() ? Icons.star : Icons.star_border,
                color: Colors.green,
                size: 24,
              ),
            ),
            8.wsb,
            Text(
              '$reviewCount Reviews',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        16.hsb,
        ...reviews.map(
          (review) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    (review['avatarUrl'] ?? '') as String,
                  ),
                  radius: 20,
                ),
                12.wsb,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            (review['name'] ?? '') as String,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          8.wsb,
                          ...List.generate(
                            5,
                            (i) =>
                               const  Icon(Icons.star, color: Colors.green, size: 16),
                          ),
                        ],
                      ),
                      Text(
                        (review['date'] ?? '') as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      4.hsb,
                      Text(
                        (review['text'] ?? '') as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      8.hsb,
                      Row(
                        children:
                            // ignore: use_if_null_to_convert_nulls_to_bools
                            ((review['images'] as List<String>?)?.isNotEmpty ==
                                        true
                                    ? review['images'] as List<String>
                                    : [review['productImage'] as String? ?? ''])
                                .map(
                                  (img) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        img,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
