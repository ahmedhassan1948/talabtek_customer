import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel>? banners;
  final double height;
  final double viewportFraction;
  final Duration autoPlayInterval;
  final bool autoPlay;
  final VoidCallback? onBannerTap;

  const BannerCarousel({
    super.key,
    this.banners,
    this.height = 180,
    this.viewportFraction = 0.9,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlay = true,
    this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  late List<BannerModel> _banners;

  @override
  void initState() {
    super.initState();
    _banners = widget.banners ?? _getDefaultBanners();
  }

  List<BannerModel> _getDefaultBanners() {
    return [
      BannerModel(
        id: '1',
        title: 'خصم 50% على الطلب الأول',
        subtitle: 'استخدم كود: WELCOME50',
        imageUrl: 'assets/images/banner1.jpg',
        actionUrl: '/promo/welcome',
        backgroundColor: const Color(0xFFFF6B35),
      ),
      BannerModel(
        id: '2',
        title: 'توصيل مجاني للطلبات فوق 50 ر.س',
        subtitle: 'للطلبات من المطاعم المختارة',
        imageUrl: 'assets/images/banner2.jpg',
        actionUrl: '/promo/free-delivery',
        backgroundColor: const Color(0xFF4CAF50),
      ),
      BannerModel(
        id: '3',
        title: 'مطاعم جديدة في منطقتك',
        subtitle: 'اكتشف أشهى الأطباق',
        imageUrl: 'assets/images/banner3.jpg',
        actionUrl: '/restaurants/new',
        backgroundColor: const Color(0xFF2196F3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          options: CarouselOptions(
            height: widget.height.h,
            viewportFraction: widget.viewportFraction,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = _banners[index];
            return _buildBannerCard(context, banner, index == _currentIndex);
          },
        ),
        SizedBox(height: 12.h),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 24.w : 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BuildContext context, BannerModel banner, bool isActive) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: widget.onBannerTap ?? () => _handleBannerAction(banner),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: (banner.backgroundColor ?? theme.colorScheme.primary).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              CachedImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: banner.backgroundColor ?? theme.colorScheme.primaryContainer,
                ),
                errorWidget: Container(
                  color: banner.backgroundColor ?? theme.colorScheme.primaryContainer,
                ),
              ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      (banner.backgroundColor ?? theme.colorScheme.primary).withOpacity(0.9),
                      (banner.backgroundColor ?? theme.colorScheme.primary).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (banner.subtitle != null) ...[
                      Text(
                        banner.subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                    Text(
                      banner.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Text(
                          'اكتشف المزيد',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBannerAction(BannerModel banner) {
    // Handle banner navigation
    if (banner.actionUrl != null) {
      // Navigate based on action URL
    }
  }
}

class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? actionUrl;
  final Color? backgroundColor;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.actionUrl,
    this.backgroundColor,
    this.startDate,
    this.endDate,
    this.isActive = true,
  });
}

class SmallBannerCarousel extends StatelessWidget {
  final List<SmallBannerModel> banners;
  final double height;
  final VoidCallback? onTap;

  const SmallBannerCarousel({
    super.key,
    required this.banners,
    this.height = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: banners.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final banner = banners[index];
          return _buildSmallBannerCard(context, banner);
        },
      ),
    );
  }

  Widget _buildSmallBannerCard(BuildContext context, SmallBannerModel banner) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap ?? () => _handleBannerAction(banner),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: banner.backgroundColor ?? theme.colorScheme.primaryContainer,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (banner.subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        banner.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBannerAction(SmallBannerModel banner) {
    // Handle banner navigation
  }
}

class SmallBannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? actionUrl;
  final Color? backgroundColor;

  SmallBannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.actionUrl,
    this.backgroundColor,
  });
}