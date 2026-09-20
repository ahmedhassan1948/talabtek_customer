import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/notifications/presentation/widgets/notification_tile.dart'
import 'package:talabtek_customer/shared/providers/notification_provider.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart'
import 'package:talabtek_customer/shared/widgets/empty_error_states.dart'
import 'package:talabtek_customer/shared/widgets/loading_widgets.dart'

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'الإشعارات (${notificationProvider.unreadCount})',
        actions: [
          if (notificationProvider.unreadCount > 0)
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: Text(
                'تحديد الكل كمقروء',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: notificationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationProvider.notifications.isEmpty
              ? EmptyState.noNotifications()
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: notificationProvider.notifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final notification = notificationProvider.notifications[index];
                    return NotificationTile(
                      notification: notification,
                      onTap: () => _handleNotificationTap(notification),
                      onDismiss: () => notificationProvider.deleteNotification(notification.id),
                    );
                  },
                ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read
    if (!notification.isRead) {
      context.read<NotificationProvider>().markAsRead(notification.id);
    }
    
    // Navigate based on notification type
    final data = notification.data;
    switch (notification.type) {
      case 'order_update':
        if (data['orderId'] != null) {
          Navigator.pushNamed(context, '/order/tracking/${data['orderId']}');
        }
        break;
      case 'promotion':
      case 'flash_sale':
        Navigator.pushNamed(context, '/promotions');
        break;
      case 'new_restaurant':
        if (data['restaurantId'] != null) {
          Navigator.pushNamed(context, '/restaurant/${data['restaurantId']}');
        }
        break;
      default:
        break;
    }
  }
}