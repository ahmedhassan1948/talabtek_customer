import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final String? imageAsset;
  final IconData? icon;
  final double iconSize;
  final Widget? action;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.imageAsset,
    this.icon,
    this.iconSize = 80,
    this.action,
    this.actionText,
    this.onActionPressed,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  const EmptyState.noOrders({
    super.key,
    this.actionText,
    this.onActionPressed,
    this.padding,
  }) : title = 'لا توجد طلبات',
       message = 'ابدأ رحلتك مع طلبك واطلب وجبتك المفضلة الآن',
       imageAsset = 'assets/animations/empty_orders.json',
       icon = Icons.receipt_long_outlined,
       action = null;

  const EmptyState.noRestaurants({
    super.key,
    this.actionText,
    this.onActionPressed,
    this.padding,
  }) : title = 'لا توجد مطاعم متاحة',
       message = 'لا توجد مطاعم في منطقتك حالياً، يرجى المحاولة لاحقاً',
       imageAsset = 'assets/animations/empty_restaurant.json',
       icon = Icons.restaurant_outlined,
       action = null;

  const EmptyState.noFavorites({
    super.key,
    this.actionText,
    this.onActionPressed,
    this.padding,
  }) : title = 'لا توجد مفضلات',
       message = 'أضف مطاعمك ومنتجاتك المفضلة للوصول السريع إليها',
       imageAsset = 'assets/animations/empty_favorites.json',
       icon = Icons.favorite_border,
       action = null;

  const EmptyState.noNotifications({
    super.key,
    this.actionText,
    this.onActionPressed,
    this.padding,
  }) : title = 'لا توجد إشعارات',
       message = 'ستظهر إشعاراتك هنا عند وصول طلبات جديدة أو عروض خاصة',
       imageAsset = 'assets/animations/empty_notifications.json',
       icon = Icons.notifications_none_outlined,
       action = null;

  const EmptyState.noSearchResults({
    super.key,
    String? query,
    this.actionText,
    this.onActionPressed,
    this.padding,
  }) : title = 'لا توجد نتائج',
       message = query != null ? 'لم نجد نتائج لـ "$query"' : 'جرب البحث بكلمات مختلفة',
       imageAsset = 'assets/animations/empty_search.json',
       icon = Icons.search_off_outlined,
       action = null;

  const EmptyState.noInternet({
    super.key,
    this.actionText = 'إعادة المحاولة',
    this.onActionPressed,
    this.padding,
  }) : title = 'لا يوجد اتصال بالإنترنت',
       message = 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
       imageAsset = 'assets/animations/no_internet.json',
       icon = Icons.wifi_off_outlined,
       action = null;

  const EmptyState.error({
    super.key,
    this.title = 'حدث خطأ',
    this.message = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
    this.actionText = 'إعادة المحاولة',
    this.onActionPressed,
    this.padding,
  }) : imageAsset = 'assets/animations/error.json',
       icon = Icons.error_outline,
       action = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Animation or Icon
          if (imageAsset != null)
            SizedBox(
              width: 200.w,
              height: 200.w,
              child: Lottie.asset(
                imageAsset!,
                fit: BoxFit.contain,
                repeat: true,
                errorBuilder: (context, error, stackTrace) => _buildIcon(theme),
              ),
            )
          else if (icon != null)
            _buildIcon(theme),

          SizedBox(height: 24.h),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          // Message
          if (message != null) ...[
            SizedBox(height: 12.h),
            Text(
              message!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Action
          if (action != null || (actionText != null && onActionPressed != null)) ...[
            SizedBox(height: 24.h),
            action ??
                CustomButton(
                  text: actionText!,
                  onPressed: onActionPressed,
                  icon: const Icon(Icons.refresh, size: 20),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: iconSize.w,
      height: iconSize.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize * 0.5,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onDismiss;
  final IconData? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ErrorState({
    super.key,
    this.title = 'حدث خطأ',
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.onDismiss,
    this.icon,
    this.backgroundColor,
    this.padding,
  });

  const ErrorState.network({
    super.key,
    this.actionText = 'إعادة المحاولة',
    this.onActionPressed,
    this.onDismiss,
  }) : title = 'خطأ في الاتصال',
       message = 'تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
       icon = Icons.wifi_off_outlined;

  const ErrorState.server({
    super.key,
    this.actionText = 'إعادة المحاولة',
    this.onActionPressed,
    this.onDismiss,
  }) : title = 'خطأ في الخادم',
       message = 'حدث خطأ في الخادم، فريقنا يعمل على إصلاحه. يرجى المحاولة لاحقاً',
       icon = Icons.dns_outlined;

  const ErrorState.unauthorized({
    super.key,
    this.actionText = 'تسجيل الدخول',
    this.onActionPressed,
    this.onDismiss,
  }) : title = 'جلسة منتهية',
       message = 'انتهت صلاحية جلستك، يرجى تسجيل الدخول مرة أخرى',
       icon = Icons.lock_outline;

  const ErrorState.notFound({
    super.key,
    this.actionText,
    this.onActionPressed,
    this.onDismiss,
  }) : title = 'غير موجود',
       message = 'الصفحة أو المورد الذي تبحث عنه غير موجود',
       icon = Icons.search_off_outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.errorContainer;
    final textColor = theme.colorScheme.onErrorContainer;
    
    return Container(
      padding: padding ?? EdgeInsets.all(24.w),
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 24.w,
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, color: textColor.withOpacity(0.6), size: 20.w),
                  onPressed: onDismiss,
                ),
            ],
          ),
          if (actionText != null && onActionPressed != null) ...[
            SizedBox(height: 16.h),
            CustomButton(
              text: actionText!,
              onPressed: onActionPressed,
              isOutlined: true,
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.error,
              borderColor: theme.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isVisible;

  const OfflineBanner({
    super.key,
    this.onRetry,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            size: 20.w,
            color: theme.colorScheme.error,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'أنت غير متصل بالإنترنت. بعض الميزات قد لا تعمل.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              ),
              child: Text(
                'إعادة المحاولة',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MaintenanceBanner extends StatelessWidget {
  final String message;
  final DateTime? endTime;

  const MaintenanceBanner({
    super.key,
    this.message = 'الصيانة جارية، نعتذر عن أي إزعاج',
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: theme.colorScheme.warningColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 20.w,
            color: theme.colorScheme.warningColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'صيانة مجدولة',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.warningColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (endTime != null)
            Text(
              'تنتهي في ${_formatTime(endTime!)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.warningColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}