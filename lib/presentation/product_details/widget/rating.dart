import 'package:flutter/material.dart';

class TitleRatingRow extends StatelessWidget {
  const TitleRatingRow({required this.title, required this.rating, super.key});
  final String title;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            Text(rating.toStringAsFixed(1)),
          ],
        ),
      ],
    );
  }
}
