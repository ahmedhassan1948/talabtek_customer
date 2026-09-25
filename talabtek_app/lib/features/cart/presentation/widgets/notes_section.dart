import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class NotesSection extends StatelessWidget {
  final Function(String) onDeliveryNoteChanged;
  final Function(String) onRestaurantNoteChanged;
  final String? initialDeliveryNote;
  final String? initialRestaurantNote;

  const NotesSection({
    super.key,
    required this.onDeliveryNoteChanged,
    required this.onRestaurantNoteChanged,
    this.initialDeliveryNote,
    this.initialRestaurantNote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.note_outlined,
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'ملاحظات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Restaurant Note
          Text(
            'ملاحظات للمطعم',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            initialValue: initialRestaurantNote,
            maxLines: 2,
            onChanged: onRestaurantNoteChanged,
            decoration: InputDecoration(
              hintText: 'مثال: بدون بصل، صلصة على الجانب، ناضج جيداً...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.restaurant_outlined,
                  size: 20.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Delivery Note
          Text(
            'ملاحظات للسائق',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            initialValue: initialDeliveryNote,
            maxLines: 2,
            onChanged: onDeliveryNoteChanged,
            decoration: InputDecoration(
              hintText: 'مثال: اتصل عند الوصول، اترك الطلب عند الباب، الكود 1234...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 20.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}