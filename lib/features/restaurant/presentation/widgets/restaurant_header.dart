import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';

class RestaurantHeader extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOpen = restaurant.isOpen;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover Image
        CachedImage(
          imageUrl: restaurant.coverImageUrl.isNotEmpty ? restaurant.coverImageUrl : restaurant.imageUrl,
          fit: BoxFit.cover,
          placeholder: Container(color: theme.colorScheme.surfaceContainerHighest),
        ),
        
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Content
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 20.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badges Row
              Row(
                children: [
                  if (restaurant.isFeatured)
                    _buildBadge(
                      context,
                      'مميز',
                      theme.colorScheme.warningColor,
                      Icons.star_outlined,
                    ),
                  if (restaurant.hasOffer) ...[
                    if (restaurant.isFeatured) SizedBox(width: 8.w),
                    _buildBadge(
                      context,
                      restaurant.offerText ?? 'عرض خاص',
                      theme.colorScheme.error,
                      Icons.local_offer_outlined,
                    ),
                  ],
                  const Spacer(),
                  // Status Badge
                  _buildStatusBadge(context, isOpen),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Restaurant Name
              Text(
                restaurant.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 4.h),
              
              // Cuisines
              if (restaurant.cuisines.isNotEmpty)
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: restaurant.cuisines.map((cuisine) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      cuisine,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              
              SizedBox(height: 12.h),
              
              // Info Row
              Row(
                children: [
                  _buildInfoItem(context, Icons.star, restaurant.rating.toStringAsFixed(1), '${restaurant.reviewCount} تقييم'),
                  SizedBox(width: 20.w),
                  _buildInfoItem(context, Icons.timer_outlined, '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax}', 'دقيقة'),
                  SizedBox(width: 20.w),
                  _buildInfoItem(
                    context,
                    Icons.local_shipping_outlined,
                    restaurant.deliveryFee == 0 ? 'مجاني' : '${restaurant.deliveryFee.toStringAsFixed(0)} ر.س',
                    'توصيل',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.w, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isOpen) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isOpen ? theme.colorScheme.successColor : theme.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isOpen ? theme.colorScheme.successColor : theme.colorScheme.onSurfaceVariant).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            isOpen ? 'مفتوح الآن' : 'مغلق حالياً',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: Colors.white),
            SizedBox(width: 4.w),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class RestaurantInfoSection extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantInfoSection({super.key, required this.restaurant});

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
              Icon(
                Icons.info_outline,
                size: 20.w,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات المطعم',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          _buildInfoRow(context, Icons.location_on_outlined, 'العنوان', restaurant.address),
          _buildInfoRow(context, Icons.phone_outlined, 'الهاتف', restaurant.phone),
          if (restaurant.email.isNotEmpty)
            _buildInfoRow(context, Icons.email_outlined, 'البريد', restaurant.email),
          _buildInfoRow(
            context,
            Icons.access_time_outlined,
            'ساعات العمل',
            _getOpeningHoursText(restaurant.openingHours),
          ),
          if (restaurant.minOrderAmount > 0)
            _buildInfoRow(
              context,
              Icons.shopping_cart_outlined,
              'الحد الأدنى للطلب',
              '${restaurant.minOrderAmount.toStringAsFixed(0)} ر.س',
            ),
          if (restaurant.freeDeliveryThreshold > 0)
            _buildInfoRow(
              context,
              Icons.local_shipping_outlined,
              'توصيل مجاني للطلبات فوق',
              '${restaurant.freeDeliveryThreshold.toStringAsFixed(0)} ر.س',
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.w, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getOpeningHoursText(OpeningHoursModel hours) {
    if (hours.is24Hours) return 'مفتوح 24 ساعة';
    
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final dayHours = hours.days[dayName];
    
    if (dayHours == null || dayHours.isClosed) return 'مغلق اليوم';
    return '${dayHours.open} - ${dayHours.close}';
  }

  String _getDayName(int weekday) {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return days[weekday - 1];
  }
}

class RestaurantGallery extends StatelessWidget {
  final List<String> images;

  const RestaurantGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Text(
            'معرض الصور',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: images.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedImage(
                  imageUrl: images[index],
                  width: 180.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}