import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/restaurant_list.dart';

class FlashSaleSection extends StatefulWidget {
  final List<FlashSaleModel>? flashSales;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final Function(FlashSaleModel)? onFlashSaleTap;

  const FlashSaleSection({
    super.key,
    this.flashSales,
    this.isLoading = false,
    this.onSeeAll,
    this.onFlashSaleTap,
  });

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> with TickerProviderStateMixin {
  late AnimationController _timerController;
  int _remainingSeconds = 3600; // 1 hour default

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timerController.repeat();
    _timerController.addListener(() {
      if (mounted && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flashSales = widget.flashSales ?? _getDefaultFlashSales();

    if (flashSales.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.flash_on,
                      size: 20.w,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'عروض خاطفة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCountdownTimer(theme),
                  if (widget.onSeeAll != null) ...[
                    SizedBox(width: 8.w),
                    TextButton(
                      onPressed: widget.onSeeAll,
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
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: flashSales.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final flashSale = flashSales[index];
              return _buildFlashSaleCard(context, flashSale);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownTimer(ThemeData theme) {
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 14.w, color: theme.colorScheme.error),
          SizedBox(width: 6.w),
          Text(
            '$hours:$minutes:$seconds',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleCard(BuildContext context, FlashSaleModel flashSale) {
    final theme = Theme.of(context);
    final discountPercentage = flashSale.originalPrice > 0
        ? ((flashSale.originalPrice - flashSale.discountedPrice) / flashSale.originalPrice * 100).round()
        : 0;

    return GestureDetector(
      onTap: () => widget.onFlashSaleTap?.call(flashSale),
      child: Container(
        width: 280.w,
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
                    imageUrl: flashSale.imageUrl,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Discount Badge
                Positioned(
                  top: 12.w,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-$discountPercentage%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Timer
                Positioned(
                  top: 12.w,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, size: 12.w, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text(
                          _formatDuration(flashSale.timeRemaining),
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
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flashSale.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    flashSale.restaurantName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '${flashSale.discountedPrice.toStringAsFixed(2)} ر.س',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (flashSale.originalPrice > flashSale.discountedPrice)
                        Text(
                          '${flashSale.originalPrice.toStringAsFixed(2)} ر.س',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'اطلب الآن',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  List<FlashSaleModel> _getDefaultFlashSales() {
    return [
      FlashSaleModel(
        id: '1',
        title: 'وجبة برجر مزدوجة + بطاطس + مشروب',
        restaurantName: 'برجر كينج',
        imageUrl: 'assets/images/flash1.jpg',
        originalPrice: 45.0,
        discountedPrice: 29.99,
        timeRemaining: const Duration(hours: 2, minutes: 30),
      ),
      FlashSaleModel(
        id: '2',
        title: 'بيتزا متوسطة + صلصة + مشروب',
        restaurantName: 'بيتزا هت',
        imageUrl: 'assets/images/flash2.jpg',
        originalPrice: 55.0,
        discountedPrice: 35.0,
        timeRemaining: const Duration(hours: 1, minutes: 45),
      ),
      FlashSaleModel(
        id: '3',
        title: 'ساندويش شاورما + بطاطس + مشروب',
        restaurantName: 'شاورما إميل',
        imageUrl: 'assets/images/flash3.jpg',
        originalPrice: 28.0,
        discountedPrice: 19.99,
        timeRemaining: const Duration(hours: 3, minutes: 15),
      ),
    ];
  }
}

class FlashSaleModel {
  final String id;
  final String title;
  final String restaurantName;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final Duration timeRemaining;
  final String? description;
  final List<String>? includedItems;
  final int maxQuantity;
  final int soldQuantity;

  FlashSaleModel({
    required this.id,
    required this.title,
    required this.restaurantName,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.timeRemaining,
    this.description,
    this.includedItems,
    this.maxQuantity = 50,
    this.soldQuantity = 0,
  });

  double get discountPercentage => originalPrice > 0
      ? ((originalPrice - discountedPrice) / originalPrice * 100)
      : 0;
  bool get isActive => timeRemaining.inSeconds > 0;
  int get remainingQuantity => maxQuantity - soldQuantity;
}

class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final double height;
  final BorderRadius? borderRadius;

  const PromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.backgroundColor,
    this.onTap,
    this.height = 120,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      backgroundColor.withOpacity(0.9),
                      backgroundColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          'اكتشف العرض',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(Icons.arrow_forward_ios, size: 14.w, color: Colors.white),
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
}