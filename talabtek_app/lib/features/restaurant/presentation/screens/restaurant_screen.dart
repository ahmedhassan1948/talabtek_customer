import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/restaurant/presentation/widgets/restaurant_header.dart';
import 'package:talabtek_customer/features/restaurant/presentation/widgets/menu_category_list.dart';
import 'package:talabtek_customer/features/restaurant/presentation/widgets/cart_bottom_sheet.dart';
import 'package:talabtek_customer/shared/providers/cart_provider.dart';
import 'package:talabtek_customer/shared/providers/auth_provider.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart';
import 'package:talabtek_customer/shared/widgets/loading_widgets.dart';
import 'package:talabtek_customer/shared/widgets/empty_error_states.dart';

class RestaurantScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  RestaurantModel? _restaurant;
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _restaurant = _getMockRestaurant(widget.restaurantId);
      _isLoading = false;
    });
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 200;
    if (showTitle != _showAppBarTitle) {
      setState(() => _showAppBarTitle = showTitle);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = context.watch<CartProvider>();

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null || _restaurant == null) {
      return _buildErrorState();
    }

    final restaurant = _restaurant!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 20.w),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite_outline, size: 20.w),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.share_outlined, size: 20.w),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: _showAppBarTitle
                  ? Text(
                      restaurant.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    )
                  : null,
              titlePadding: EdgeInsets.only(left: 56.w, bottom: 12.h),
              background: RestaurantHeader(restaurant: restaurant),
            ),
          ),
          
          // Menu Categories
          SliverToBoxAdapter(
            child: MenuCategoryList(
              restaurant: restaurant,
              onItemAdded: _handleItemAdded,
            ),
          ),
          
          // Bottom padding for cart
          SliverToBoxAdapter(
            child: SizedBox(height: cartProvider.isEmpty ? 20.h : 100.h),
          ),
        ],
      ),
      
      // Cart Bottom Sheet
      bottomSheet: cartProvider.isEmpty
          ? null
          : CartBottomSheet(
              onCheckout: () => _navigateToCheckout(),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: List.generate(3, (index) => _buildSkeletonCategory()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCategory() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      appBar: CustomAppBar(title: 'المطعم'),
      body: EmptyState.error(
        onActionPressed: _loadRestaurant,
      ),
    );
  }

  void _handleItemAdded(CartItemModel item) {
    final cartProvider = context.read<CartProvider>();
    cartProvider.addItem(item);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${item.productName} إلى السلة'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _navigateToCheckout() {
    Navigator.pushNamed(context, AppRoutes.checkout);
  }

  RestaurantModel _getMockRestaurant(String id) {
    return RestaurantModel(
      id: id,
      name: 'الخيمة النجدية',
      nameEn: 'Alkhaima Alnajdiya',
      description: 'أشهى المأكولات الشعبية النجدية الأصيلة منذ 1985',
      descriptionEn: 'Authentic Najdi cuisine since 1985',
      imageUrl: 'assets/images/restaurant1.jpg',
      coverImageUrl: 'assets/images/restaurant1_cover.jpg',
      images: [],
      categoryId: 'restaurants',
      subCategoryIds: ['saudi'],
      tags: ['شعبية', 'نجدية', 'غداء', 'عشاء', 'مندي', 'كبسة'],
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
    );
  }
}