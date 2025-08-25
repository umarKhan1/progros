import 'package:flutter/material.dart';
import 'package:progros/core/constant/app_image_const.dart';

class AddressHeader extends StatelessWidget {
  const AddressHeader({
    required this.title,
    required this.address,
    super.key,
    this.onTap,
    this.onBagTap,
  });
  final String title;
  final String address;
  final VoidCallback? onTap;
  final VoidCallback? onBagTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // left icon
              Image.asset(
                ApplicationImagesStrings.location,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              // title and address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address.length > 40 ? address.substring(0, 40) : address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // bag icon
              InkResponse(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: onBagTap,
                radius: 20,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 22,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
