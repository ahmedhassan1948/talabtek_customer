import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class PaymentSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;
  final VoidCallback onWalletTap;

  const PaymentSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.onWalletTap,
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
                  Icons.payment_outlined,
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'طريقة الدفع',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(
            children: AppConstants.paymentMethods.map((method) {
              final methodId = method['id'] as String;
              final isEnabled = method['enabled'] as bool;
              final isSelected = selectedPaymentMethod == methodId;
              
              if (!isEnabled) return const SizedBox.shrink();
              
              return _buildPaymentOption(context, method, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, Map<String, dynamic> method, bool isSelected) {
    final theme = Theme.of(context);
    final methodId = method['id'] as String;
    final methodName = method['name'] as String;
    final methodIcon = method['icon'] as String;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () => onPaymentMethodChanged(methodId),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Radio Button
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              
              // Icon
              _buildMethodIcon(context, methodIcon),
              SizedBox(width: 12.w),
              
              // Name
              Expanded(
                child: Text(
                  methodName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              
              // Badge for wallet
              if (methodId == 'wallet')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'متاح',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodIcon(BuildContext context, String iconName) {
    final theme = Theme.of(context);
    IconData iconData;
    Color color = theme.colorScheme.onSurfaceVariant;
    
    switch (iconName) {
      case 'payments':
        iconData = Icons.payments_outlined;
        break;
      case 'credit_card':
        iconData = Icons.credit_card_outlined;
        color = Colors.blue;
        break;
      case 'apple':
        iconData = Icons.apple;
        color = Colors.black;
        break;
      case 'android':
        iconData = Icons.android;
        color = Colors.green;
        break;
      case 'account_balance_wallet':
        iconData = Icons.account_balance_wallet_outlined;
        color = theme.colorScheme.warningColor;
        break;
      default:
        iconData = Icons.payment_outlined;
    }
    
    return Icon(iconData, size: 24.w, color: color);
  }
}

class SavedPaymentMethodCard extends StatelessWidget {
  final String id;
  final String type;
  final String lastFourDigits;
  final String expiryDate;
  final bool isDefault;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const SavedPaymentMethodCard({
    super.key,
    required this.id,
    required this.type,
    required this.lastFourDigits,
    required this.expiryDate,
    this.isDefault = false,
    this.onTap,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = _getCardIcon(type);
    final cardColor = _getCardColor(type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDefault ? theme.colorScheme.primary : theme.dividerColor,
            width: isDefault ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, size: 24.w, color: cardColor),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getCardTypeName(type),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isDefault) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '**** **** **** $lastFourDigits',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'ينتهي: $expiryDate',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'default': onSetDefault?.call(); break;
                    case 'delete': onDelete?.call(); break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'default',
                    enabled: !isDefault,
                    child: Row(
                      children: [
                        Icon(Icons.star_outline, size: 18.w),
                        SizedBox(width: 8.w),
                        Text('تعيين كافتراضي'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18.w, color: theme.colorScheme.error),
                        SizedBox(width: 8.w),
                        Text('حذف', style: TextStyle(color: theme.colorScheme.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }

  IconData _getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'mada': return Icons.credit_card;
      case 'visa': return Icons.credit_card;
      case 'mastercard': return Icons.credit_card;
      case 'apple_pay': return Icons.apple;
      case 'google_pay': return Icons.android;
      default: return Icons.credit_card;
    }
  }

  Color _getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'mada': return Colors.green;
      case 'visa': return Colors.blue;
      case 'mastercard': return Colors.red;
      case 'apple_pay': return Colors.black;
      case 'google_pay': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _getCardTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'mada': return 'مدى';
      case 'visa': return 'Visa';
      case 'mastercard': return 'Mastercard';
      case 'apple_pay': return 'Apple Pay';
      case 'google_pay': return 'Google Pay';
      default: return type;
    }
  }
}