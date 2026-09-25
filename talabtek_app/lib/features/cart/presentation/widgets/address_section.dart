import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class AddressSection extends StatelessWidget {
  final DeliveryAddressModel? currentAddress;
  final Function(DeliveryAddressModel) onAddressChanged;
  final VoidCallback onChangeAddress;

  const AddressSection({
    super.key,
    this.currentAddress,
    required this.onAddressChanged,
    required this.onChangeAddress,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.location_on_outlined,
                      size: 20.w,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'عنوان التوصيل',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: onChangeAddress,
                icon: Icon(Icons.edit_outlined, size: 18.w),
                label: Text('تغيير'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (currentAddress != null)
            _buildAddressCard(context, currentAddress!)
          else
            _buildNoAddress(context),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, DeliveryAddressModel address) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getLabelColor(address.label).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  address.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getLabelColor(address.label),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'افتراضي',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address.recipientName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            address.fullAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (address.building.isNotEmpty || address.floor.isNotEmpty || address.apartment.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              _buildAddressDetails(address),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (address.landmark.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 14.w,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'بجوار: ${address.landmark}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoAddress(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_location_outlined,
            size: 24.w,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لا يوجد عنوان محدد',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'اضغط لإضافة عنوان التوصيل',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onChangeAddress,
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Color _getLabelColor(String label) {
    switch (label) {
      case 'المنزل': return Colors.blue;
      case 'العمل': return Colors.green;
      case 'أخرى': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _buildAddressDetails(DeliveryAddressModel address) {
    final parts = <String>[];
    if (address.building.isNotEmpty) parts.add('مبنى: ${address.building}');
    if (address.floor.isNotEmpty) parts.add('دور: ${address.floor}');
    if (address.apartment.isNotEmpty) parts.add('شقة: ${address.apartment}');
    return parts.join(' • ');
  }
}