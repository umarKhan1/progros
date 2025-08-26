import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionReadMore extends StatefulWidget {
  const DescriptionReadMore({required this.description, super.key});
  final String description;

  @override
  State<DescriptionReadMore> createState() => _DescriptionReadMoreState();
}

class _DescriptionReadMoreState extends State<DescriptionReadMore> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final maxLines = expanded ? null : 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          maxLines: maxLines,
          overflow: expanded ? null : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[800])
        ),
        TextButton(
          onPressed: () => setState(() => expanded = !expanded),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            expanded ? 'Read Less' : 'Read More',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
