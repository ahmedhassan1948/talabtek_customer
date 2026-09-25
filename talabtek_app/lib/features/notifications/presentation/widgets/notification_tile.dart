import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/notification_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart'

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconData = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(theme, notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 24.w),
      ),
      onDismissed: (_) => onDismiss?.call(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: notification.isRead
                ? theme.colorScheme.surface
                : theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead ? theme.dividerColor : theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData, size: 20.w, color: iconColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(notification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(top: 6.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order_update': return Icons.local_shipping_outlined;
      case 'promotion': return Icons.local_offer_outlined;
      case 'flash_sale': return Icons.flash_on;
      case 'new_restaurant': return Icons.restaurant_outlined;
      case 'review_reminder': return Icons.star_outline;
      case 'delivery_assigned': return Icons.person_outline;
      case 'driver_arrived': return Icons.near_me_outlined;
      case 'order_delivered': return Icons.check_circle_outline;
      case 'order_cancelled': return Icons.cancel_outlined;
      case 'payment_failed': return Icons.payment_outlined;
      case 'refund_processed': return Icons.money_off_outlined;
      default: return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(ThemeData theme, String type) {
    switch (type) {
      case 'order_update': return theme.colorScheme.primary;
      case 'promotion': return theme.colorScheme.warningColor;
      case 'flash_sale': return theme.colorScheme.error;
      case 'new_restaurant': return theme.colorScheme.secondary;
      case 'review_reminder': return theme.colorScheme.infoColor;
      case 'delivery_assigned': return theme.colorScheme.primary;
      case 'driver_arrived': return theme.colorScheme.successColor;
      case 'order_delivered': return theme.colorScheme.successColor;
      case 'order_cancelled': return theme.colorScheme.error;
      case 'payment_failed': return theme.colorScheme.error;
      case 'refund_processed': return theme.colorScheme.successColor;
      default: return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return '${time.day}/${time.month}/${time.year}';
  }
}