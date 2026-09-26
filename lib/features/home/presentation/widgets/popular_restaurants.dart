import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/restaurant_list.dart';

class PopularRestaurants extends StatelessWidget {
  final List<RestaurantModel>? restaurants;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final Function(RestaurantModel)? onRestaurantTap;

  const PopularRestaurants({
    super.key,
    this.restaurants,
    this.isLoading = false,
    this.onSeeAll,
    this.onRestaurantTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayRestaurants = restaurants ?? _getDefaultRestaurants();

    if (displayRestaurants.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأكثر طلباً',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Row(
                    children: [
                      Text(
                        'عرض الكل',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.w,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 260.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: displayRestaurants.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final restaurant = displayRestaurants[index];
              return _buildPopularRestaurantCard(context, restaurant);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularRestaurantCard(BuildContext context, RestaurantModel restaurant) {
    final theme = Theme.of(context);
    final isOpen = restaurant.isOpen;

    return GestureDetector(
      onTap: () => onRestaurantTap?.call(restaurant),
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedImage(
                    imageUrl: restaurant.imageUrl,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 8.w,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: isOpen ? theme.colorScheme.successColor : theme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isOpen ? 'مفتوح' : 'مغلق',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Featured Badge
                if (restaurant.isFeatured)
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.warningColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        size: 12.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Rating Badge
                Positioned(
                  bottom: 8.w,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12.w, color: Colors.amber),
                        SizedBox(width: 3.w),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.cuisines.isNotEmpty ? restaurant.cuisines.take(2).join(' • ') : 'مطعم',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.timer_outlined,
                        '${restaurant.deliveryTimeMin} د',
                      ),
                      SizedBox(width: 12.w),
                      _buildInfoItem(
                        context,
                        Icons.local_shipping_outlined,
                        restaurant.deliveryFee == 0
                            ? 'مجاني'
                            : '${restaurant.deliveryFee.toStringAsFixed(0)} ر.س',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.w, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(width: 3.w),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<RestaurantModel> _getDefaultRestaurants() {
    return [
      RestaurantModel(
        id: '1',
        name: 'الخيمة النجدية',
        nameEn: 'Alkhaima Alnajdiya',
        description: 'أشهى المأكولات الشعبية النجدية الأصيلة',
        descriptionEn: 'Authentic Najdi cuisine',
        imageUrl: 'assets/images/restaurant1.jpg',
        coverImageUrl: '',
        images: [],
        categoryId: 'restaurants',
        subCategoryIds: ['saudi'],
        tags: ['شعبية', 'نجدية', 'غداء', 'عشاء'],
        rating: 4.8,
        reviewCount: 1250,
        deliveryTimeMin: 25,
        deliveryTimeMax: 35,
        deliveryFee: 5.0,
        minOrderAmount: 30.0,
        freeDeliveryThreshold: 100.0,
        location: const LatLng(24.7136, 46.6753),
        address: 'طريق الملك فهد، الرياض',
        phone: '0114567890',
        email: 'info@alkhaima.com',
        isOpen: true,
        isActive: true,
        isFeatured: true,
        hasOffer: true,
        offerText: 'خصم 20% على الطلب الأول',
        openingHours: OpeningHoursModel.defaultHours(),
        acceptedPayments: [],
        cuisines: ['سعودي', 'نجدية'],
        metadata: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      RestaurantModel(
        id: '2',
        name: 'برجر كينج',
        nameEn: 'Burger King',
        description: 'برجر مشوي على اللهب بطعم لا يقاوم',
        descriptionEn: 'Flame-grilled burgers',
        imageUrl: 'assets/images/restaurant2.jpg',
        coverImageUrl: '',
        images: [],
        categoryId: 'restaurants',
        subCategoryIds: ['burgers'],
        tags: ['برجر', 'سريع', 'غداء', 'عشاء'],
        rating: 4.5,
        reviewCount: 3200,
        deliveryTimeMin: 20,
        deliveryTimeMax: 30,
        deliveryFee: 0.0,
        minOrderAmount: 25.0,
        freeDeliveryThreshold: 50.0,
        location: const LatLng(24.7200, 46.6800),
        address: 'طريق الأمير سلطان، الرياض',
        phone: '0112345678',
        email: 'info@burgerking.com',
        isOpen: true,
        isActive: true,
        isFeatured: false,
        hasOffer: false,
        openingHours: OpeningHoursModel.defaultHours(),
        acceptedPayments: [],
        cuisines: ['برجر', 'أمريكي'],
        metadata: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      RestaurantModel(
        id: '3',
        name: 'بيتزا هت',
        nameEn: 'Pizza Hut',
        description: 'بيتزا طازجة بعجينة مخبوزة في الفرن',
        descriptionEn: 'Fresh oven-baked pizza',
        imageUrl: 'assets/images/restaurant3.jpg',
        coverImageUrl: '',
        images: [],
        categoryId: 'restaurants',
        subCategoryIds: ['pizza'],
        tags: ['بيتزا', 'إيطالي', 'غداء', 'عشاء'],
        rating: 4.3,
        reviewCount: 2100,
        deliveryTimeMin: 30,
        deliveryTimeMax: 40,
        deliveryFee: 7.0,
        minOrderAmount: 40.0,
        freeDeliveryThreshold: 80.0,
        location: const LatLng(24.7100, 46.6700),
        address: 'طريق الملك عبدالله، الرياض',
        phone: '0113456789',
        email: 'info@pizzahut.com',
        isOpen: true,
        isActive: true,
        isFeatured: true,
        hasOffer: true,
        offerText: 'اشتر واحدة واحصل على الثانية مجاناً',
        openingHours: OpeningHoursModel.defaultHours(),
        acceptedPayments: [],
        cuisines: ['إيطالي', 'بيتزا'],
        metadata: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      RestaurantModel(
        id: '4',
        name: 'شاورما إميل',
        nameEn: 'Shawarma Emil',
        description: 'أشهر شاورما في الرياض منذ 1990',
        descriptionEn: 'Famous shawarma since 1990',
        imageUrl: 'assets/images/restaurant4.jpg',
        coverImageUrl: '',
        images: [],
        categoryId: 'restaurants',
        subCategoryIds: ['shawarma'],
        tags: ['شاورما', 'ساندويش', 'سريع'],
        rating: 4.7,
        reviewCount: 4500,
        deliveryTimeMin: 15,
        deliveryTimeMax: 25,
        deliveryFee: 3.0,
        minOrderAmount: 15.0,
        freeDeliveryThreshold: 40.0,
        location: const LatLng(24.7300, 46.6900),
        address: 'طريق عثمان بن عفان، الرياض',
        phone: '0115678901',
        email: 'info@shawarmaemil.com',
        isOpen: true,
        isActive: true,
        isFeatured: false,
        hasOffer: false,
        openingHours: OpeningHoursModel.defaultHours(),
        acceptedPayments: [],
        cuisines: ['شاورما', 'شرقي'],
        metadata: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

class RecommendedForYou extends StatelessWidget {
  final List<RestaurantModel>? restaurants;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final Function(RestaurantModel)? onRestaurantTap;

  const RecommendedForYou({
    super.key,
    this.restaurants,
    this.isLoading = false,
    this.onSeeAll,
    this.onRestaurantTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayRestaurants = restaurants ?? [];

    if (displayRestaurants.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.recommend_outlined,
                    size: 20.w,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'موصى بها لك',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'عرض الكل',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: displayRestaurants.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final restaurant = displayRestaurants[index];
            return RestaurantCardHorizontal(
              restaurant: restaurant,
              onTap: () => onRestaurantTap?.call(restaurant),
            );
          },
        ),
      ],
    );
  }
}

class NearbyRestaurants extends StatelessWidget {
  final List<RestaurantModel>? restaurants;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final Function(RestaurantModel)? onRestaurantTap;

  const NearbyRestaurants({
    super.key,
    this.restaurants,
    this.isLoading = false,
    this.onSeeAll,
    this.onRestaurantTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayRestaurants = restaurants ?? [];

    if (displayRestaurants.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20.w,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'قريب منك',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'عرض الكل',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: displayRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = displayRestaurants[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: RestaurantCardHorizontal(
                restaurant: restaurant,
                onTap: () => onRestaurantTap?.call(restaurant),
                width: double.infinity,
              ),
            );
          },
        ),
      ],
    );
  }
}