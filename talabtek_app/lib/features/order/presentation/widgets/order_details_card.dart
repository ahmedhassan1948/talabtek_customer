import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/features/order/presentation/screens/order_tracking_screen.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/shared/widgets/cached_image.dart'

class OrderDetailsCard extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
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
                  Icons.receipt_outlined,
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'تفاصيل الطلب',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Order Items
          ...order.items.map((item) => _buildOrderItem(context, item)),
          
          SizedBox(height: 12.h),
          Divider(color: theme.dividerColor),
          SizedBox(height: 12.h),
          
          // Price Breakdown
          _buildPriceRow(theme, 'المجموع الفرعي', order.subtotal),
          _buildPriceRow(theme, 'رسوم التوصيل', order.deliveryFee),
          _buildPriceRow(theme, 'الضريبة (15%)', order.tax, isBold: true),
          if (order.discount > 0)
            _buildPriceRow(theme, 'خصم', -order.discount, color: theme.colorScheme.successColor),
          Divider(height: 16.h, color: theme.dividerColor),
          _buildPriceRow(theme, 'المجموع', order.total, isTotal: true),
          
          SizedBox(height: 16.h),
          Divider(color: theme.dividerColor),
          SizedBox(height: 12.h),
          
          // Payment Method
          Row(
            children: [
              Icon(
                Icons.payment_outlined,
                size: 20.w,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 12.w),
              Text(
                'طريقة الدفع: ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                _getPaymentMethodName(order.paymentMethod),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          if (order.restaurantNote != null && order.restaurantNote!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildNoteRow(context, 'ملاحظة للمطعم', order.restaurantNote!, Icons.restaurant_outlined),
          ],
          
          if (order.driverNote != null && order.driverNote!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildNoteRow(context, 'ملاحظة للسائق', order.driverNote!, Icons.local_shipping_outlined),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemModel item) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedImage(
              imageUrl: item.productImage,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.selectedOptions.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    item.selectedOptions.map((o) => o.valueName).join('، '),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ر.س',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(item.unitPrice * item.quantity).toStringAsFixed(2)} ر.س',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(ThemeData theme, String label, double value, {bool isBold = false, bool isTotal = false, Color? color}) {
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

  Widget _buildNoteRow(BuildContext context, String label, String note, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.w, color: theme.colorScheme.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  note,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'cash': return 'نقداً عند الاستلام';
      case 'mada': return 'مدى';
      case 'visa': return 'Visa / Mastercard';
      case 'apple_pay': return 'Apple Pay';
      case 'google_pay': return 'Google Pay';
      case 'wallet': return 'المحفظة الإلكترونية';
      default: return method;
    }
  }
}