import 'package:flutter/material.dart';

class PriceDiscountRow extends StatelessWidget {
  const PriceDiscountRow({
    required this.price,
    super.key,
    this.compareAt,
    this.discount,
  });
  final double price;
  final double? compareAt;
  final int? discount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\$24${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          
          ),
        ),
        if (compareAt != null) ...[
          const SizedBox(width: 8),
          Text(
            '\$24${compareAt!.toStringAsFixed(2)}',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
        ],
        if (discount != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '-$discount%',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
