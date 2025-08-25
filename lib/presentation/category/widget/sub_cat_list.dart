// sub_cat_list.dart  (flat, no radius, no shadow)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/models/cat_subcat_model.dart';
import 'package:progros/presentation/category/widget/category_image.dart';

class SubcategoryRail extends StatelessWidget {
  const SubcategoryRail({
    required this.subs,
    required this.selectedId,
    required this.onChanged,
    super.key,
  });
  final List<SubCategory> subs;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 8.w),
      itemCount: subs.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final sc = subs[index];
        final selected = sc.id == selectedId;

        return InkWell(
          onTap: () => onChanged(sc.id),
          child: Row(
            children: [
             
            
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // circle image (no border radius container around it)
                    CategoryImage(
                      imageUrl: sc.image,
                      width: 44.r,
                      height: 44.r,
                      borderRadius: 22.r,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      sc.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(width: 10.w),
               Container(
                width: 4.w,
                height: 60.h,
                color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }
}
