import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/shared/providers/cart_provider.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';

class CartBottomSheet extends StatelessWidget {
  final VoidCallback onCheckout;
  final double maxHeight;

  const CartBottomSheet({
    super.key,
    required this.onCheckout,
    this.maxHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    return Container(
      height: maxHeight.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Cart Summary
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Column(
                children: [
                  // Items Count and Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${cartProvider.itemCount} ${_getItemText(cartProvider.itemCount)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'المجموع الفرعي: ${cart.subtotal.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      // View Cart Button
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                        icon: Icon(Icons.shopping_cart_outlined, size: 20.w),
                        label: Text('عرض السلة'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  // Delivery Fee & Discount
                  if (cart.deliveryFee > 0 || cart.discount > 0) ...[
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (cart.deliveryFee > 0)
                          _buildInfoRow(theme, 'التوصيل', '+${cart.deliveryFee.toStringAsFixed(2)} ر.س'),
                        if (cart.discount > 0)
                          _buildInfoRow(theme, 'خصم', '-${cart.discount.toStringAsFixed(2)} ر.س', 
                            color: theme.colorScheme.successColor),
                      ],
                    ),
                  ],
                  
                  // Estimated Total
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المجموع المتوقع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '${cart.total.toStringAsFixed(2)} ر.س',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Checkout Button
                  CustomButton(
                    text: 'إتمام الطلب',
                    onPressed: onCheckout,
                    isLoading: false,
                    height: 50,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _getItemText(int count) {
    if (count == 1) return 'صنف';
    if (count == 2) return 'صنفين';
    if (count <= 10) return 'أصناف';
    return 'صنف';
  }
}

class CartBottomSheetExpanded extends StatefulWidget {
  final VoidCallback onCheckout;

  const CartBottomSheetExpanded({super.key, required this.onCheckout});

  @override
  State<CartBottomSheetExpanded> createState() => _CartBottomSheetExpandedState();
}

class _CartBottomSheetExpandedState extends State<CartBottomSheetExpanded> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سلة التسوق (${cartProvider.itemCount})',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!cartProvider.isEmpty)
                      TextButton(
                        onPressed: () => _showClearCartDialog(context, cartProvider),
                        child: Text(
                          'إفراغ السلة',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              Divider(height: 1, color: theme.dividerColor),
              
              // Restaurant Info
              if (!cartProvider.isEmpty) ...[
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.restaurant_outlined,
                          size: 24.w,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.restaurantName ?? 'مطعم',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${cart.items.length} أصناف',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (cart.deliveryFee > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.warningColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'توصيل ${cart.deliveryFee.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.warningColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor),
              ],
              
              // Items List
              Expanded(
                child: cartProvider.isEmpty
                    ? _buildEmptyCart(theme)
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.all(16.w),
                        itemCount: cart.items.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return _buildCartItem(context, item, cartProvider);
                        },
                      ),
              ),
              
              // Summary & Checkout
              if (!cartProvider.isEmpty) ...[
                Divider(height: 1, color: theme.dividerColor),
                _buildOrderSummary(context, cart),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: CustomButton(
                    text: 'الانتقال للدفع - ${cart.total.toStringAsFixed(2)} ر.س',
                    onPressed: widget.onCheckout,
                    height: 52,
                    borderRadius: 12,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64.w,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'سلتك فارغة',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'أضف أصنافاً من المطاعم لتبدأ طلبك',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel item, CartProvider provider) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60.w,
              height: 60.w,
              child: Image.network(
                item.productImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.colorScheme.surfaceVariant,
                  child: Icon(Icons.fastfood_outlined, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Product Info
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
                if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    item.specialInstructions!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (item.selectedOptions.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 2.h,
                    children: item.selectedOptions.map((opt) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${opt.valueName} ${opt.price > 0 ? '+${opt.price.toStringAsFixed(2)}' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '${item.unitPrice.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    // Quantity Selector
                    _buildQuantitySelector(context, item, provider),
                  ],
                ),
              ],
            ),
          ),
          
          // Remove Button
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20.w, color: theme.colorScheme.error),
            onPressed: () => provider.removeItem(item.id),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, CartItemModel item, CartProvider provider) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 18.w),
            onPressed: item.quantity > 1 
                ? () => provider.updateQuantity(item.id, item.quantity - 1)
                : null,
            constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.w),
            padding: EdgeInsets.zero,
          ),
          Text(
            '${item.quantity}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 18.w),
            onPressed: () => provider.updateQuantity(item.id, item.quantity + 1),
            constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.w),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartModel cart) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
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

  void _showClearCartDialog(BuildContext context, CartProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إفراغ السلة'),
        content: Text('هل أنت متأكد من إفراغ السلة؟ سيتم إزالة جميع الأصناف.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              provider.clearCart();
              Navigator.pop(context);
            },
            child: Text('تأكيد', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}