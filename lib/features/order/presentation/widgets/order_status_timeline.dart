import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'

class OrderStatusTimeline extends StatelessWidget {
  final String currentStatus;
  final DateTime? estimatedDelivery;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
    this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = AppConstants.orderStatuses;
    final currentIndex = statuses.indexOf(currentStatus);
    
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
                  Icons.timeline_outlined,
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'حالة الطلب',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (estimatedDelivery != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 14.w, color: theme.colorScheme.warningColor),
                      SizedBox(width: 4.w),
                      Text(
                        _formatTime(estimatedDelivery!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.warningColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final label = AppConstants.orderStatusLabels[status] ?? status;
            final isCompleted = index < currentIndex;
            final isCurrent = index == currentIndex;
            final isLast = index == statuses.length - 1;
            
            return _buildStatusItem(context, label, index, isCompleted, isCurrent, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, String label, int index, bool isCompleted, bool isCurrent, bool isLast) {
    final theme = Theme.of(context);
    final statusColor = isCurrent ? theme.colorScheme.primary : (isCompleted ? theme.colorScheme.successColor : theme.colorScheme.outline);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and circle
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent ? statusColor : theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor,
                  width: isCurrent ? 3 : 2,
                ),
                boxShadow: isCurrent
                    ? [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)]
                    : [],
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 14.w, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Expanded(
                child: Container(
                  width: 2,
                  color: index < currentIndex ? theme.colorScheme.successColor : theme.dividerColor,
                ),
              ),
          ],
        ),
        SizedBox(width: 16.w),
        
        // Status label and time
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: isLast ? 0 : 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCompleted || isCurrent ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                  ),
                  child: Text(label),
                ),
                if (isCurrent) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 6.w, color: theme.colorScheme.primary),
                      SizedBox(width: 6.w),
                      Text(
                        'الحالة الحالية',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class SimpleOrderStatus extends StatelessWidget {
  final String status;
  final bool showLabel;

  const SimpleOrderStatus({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = AppConstants.orderStatusLabels[status] ?? status;
    final color = _getStatusColor(theme, status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: color),
          if (showLabel) ...[
            SizedBox(width: 6.w),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status) {
      case 'pending': return theme.colorScheme.warningColor;
      case 'confirmed': return theme.colorScheme.infoColor;
      case 'preparing': return theme.colorScheme.primary;
      case 'ready': return theme.colorScheme.secondary;
      case 'picked_up': return theme.colorScheme.primary;
      case 'delivering': return theme.colorScheme.primary;
      case 'delivered': return theme.colorScheme.successColor;
      case 'cancelled': return theme.colorScheme.error;
      default: return theme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.hourglass_empty;
      case 'confirmed': return Icons.check_circle_outline;
      case 'preparing': return Icons.restaurant_outlined;
      case 'ready': return Icons.inventory_2_outlined;
      case 'picked_up': return Icons.local_shipping_outlined;
      case 'delivering': return Icons.delivery_dining_outlined;
      case 'delivered': return Icons.check_circle;
      case 'cancelled': return Icons.cancel_outlined;
      default: return Icons.help_outline;
    }
  }
}