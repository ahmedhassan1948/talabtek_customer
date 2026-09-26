import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class OrderSummary extends StatelessWidget {
  final CartModel cart;

  const OrderSummary({super.key, required this.cart});

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
          Text(
            'ملخص الطلب',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow(theme, 'المجموع الفرعي', cart.subtotal),
          if (cart.deliveryFee > 0)
            _buildSummaryRow(theme, 'رسوم التوصيل', cart.deliveryFee),
          if (cart.discount > 0)
            _buildSummaryRow(theme, 'خصم (${cart.appliedCouponCode ?? ''})', -cart.discount,
              color: theme.colorScheme.successColor),
          _buildSummaryRow(theme, 'الضريبة (15%)', cart.tax, isBold: true),
          Divider(height: 16.h, color: theme.dividerColor),
          _buildSummaryRow(theme, 'المجموع', cart.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, double value, {bool isBold = false, bool isTotal = false, Color? color}) {
    final style = isTotal
        ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary)
        : isBold
            ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)
            : theme.textTheme.bodyMedium;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style?.copyWith(color: theme.colorScheme.onSurface)),
          Text(
            '${value >= 0 ? '' : '-'}${value.abs().toStringAsFixed(2)} ر.س',
            style: style?.copyWith(color: color ?? theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}