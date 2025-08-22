// search_entry_row.dart
import 'package:flutter/material.dart';
import 'package:progros/core/constant/app_stringconst.dart';

class SearchEntryRow extends StatelessWidget {
  const SearchEntryRow({
    required this.onOpenSearch,
    super.key,
    this.onFilterTap,
  });
  final VoidCallback onOpenSearch;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF38B26C);

    return Row(
      children: [
        // search field look
        Expanded(
          child: GestureDetector(
            onTap: onOpenSearch,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 22, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    ApplicationStrings.searchLocation,
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // filter button
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
