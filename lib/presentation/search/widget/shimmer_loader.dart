import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchShimmerLoader extends StatelessWidget {

  const SearchShimmerLoader({
    super.key,
    required this.width,
    // ignore: always_put_required_named_parameters_first
    required this.height,
    this.borderRadius,
  });
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
