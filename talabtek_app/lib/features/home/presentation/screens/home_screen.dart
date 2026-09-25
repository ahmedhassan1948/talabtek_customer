import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/banner_carousel.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/category_grid.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/restaurant_list.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/flash_sale_section.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/search_header.dart';
import 'package:talabtek_customer/features/home/presentation/widgets/popular_restaurants.dart';
import 'package:talabtek_customer/shared/providers/app_provider.dart';
import 'package:talabtek_customer/shared/providers/auth_provider.dart'
import 'package:talabtek_customer/shared/providers/location_provider.dart';
import 'package:talabtek_customer/shared/providers/cart_provider.dart';
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart';
import 'package:talabtek_customer/shared/widgets/loading_widgets.dart';
import 'package:talabtek_customer/shared/widgets/empty_error_states.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    
    _initializeData();
  }

  Future<void> _initializeData() async {
    final appProvider = context.read<AppProvider>();
    final locationProvider = context.read<LocationProvider>();
    final authProvider = context.read<AuthProvider>();
    
    await Future.wait([
      appProvider.initialize(),
      locationProvider.initialize(),
      if (authProvider.isAuthenticated) authProvider.loadUserData(),
    ]);
  }

  void _onScroll() {
    final shouldShowFab = _scrollController.offset > 300;
    if (shouldShowFab != _showFab) {
      setState(() => _showFab = shouldShowFab);
      if (_showFab) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationProvider = context.watch<LocationProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Location
          SliverAppBar(
            title: const _LocationHeader(),
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 1,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, size: 24.w),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              IconButton(
                icon: Icon(Icons.favorite_outline, size: 24.w),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
              ),
              SizedBox(width: 8.w),
            ],
          ),

          // Search Header
          SliverToBoxAdapter(
            child: SearchHeader(
              onTap: () => Navigator.pushNamed(context, AppRoutes.search),
              onFilterTap: () => _showFilterBottomSheet(context),
            ),
          ),

          // Promotional Banners
          SliverToBoxAdapter(
            child: BannerCarousel(),
          ),

          // Categories
          SliverToBoxAdapter(
            child: CategoryGrid(),
          ),

          // Flash Sale Section
          SliverToBoxAdapter(
            child: FlashSaleSection(),
          ),

          // Popular Restaurants
          SliverToBoxAdapter(
            child: PopularRestaurants(),
          ),

          // All Restaurants Section Header
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              'جميع المطاعم',
              onTap: () => Navigator.pushNamed(context, AppRoutes.category, arguments: {'id': 'restaurants'}),
            ),
          ),

          // Restaurant List
          RestaurantList(),

          // Bottom Padding for FAB
          SliverToBoxAdapter(
            child: SizedBox(height: 100.h),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
          icon: Icon(Icons.keyboard_arrow_up, size: 24.w),
          label: Text('أعلى', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationProvider = context.watch<LocationProvider>();
    
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.addresses),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18.w,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عنوان التوصيل',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    locationProvider.currentAddress.isNotEmpty
                        ? locationProvider.currentAddress
                        : 'جاري تحديد الموقع...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String _sortBy = 'recommended';
  double _maxDeliveryTime = 60;
  double _maxDeliveryFee = 20;
  double _minRating = 0;
  bool _freeDeliveryOnly = false;
  bool _openNowOnly = false;
  List<String> _selectedCuisines = [];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'recommended', 'label': 'الموصى بها'},
    {'value': 'rating', 'label': 'الأعلى تقييماً'},
    {'value': 'delivery_time', 'label': 'الأسرع توصيلاً'},
    {'value': 'price_low', 'label': 'السعر: من الأقل للأعلى'},
    {'value': 'price_high', 'label': 'السعر: من الأعلى للأقل'},
    {'value': 'newest', 'label': 'الأحدث'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الفلترة والترتيب',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'إعادة تعيين',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: theme.dividerColor),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort By
                  Text(
                    'ترتيب حسب',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _sortOptions.map((option) {
                      final isSelected = _sortBy == option['value'];
                      return FilterChip(
                        label: Text(option['label']!),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _sortBy = option['value']!);
                        },
                        selectedColor: theme.colorScheme.primaryContainer,
                        checkmarkColor: theme.colorScheme.primary,
                        labelStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Delivery Time
                  Text(
                    'وقت التوصيل: ${_maxDeliveryTime.round()} دقيقة كحد أقصى',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _maxDeliveryTime,
                    min: 15,
                    max: 90,
                    divisions: 15,
                    label: '${_maxDeliveryTime.round()} دقيقة',
                    onChanged: (value) => setState(() => _maxDeliveryTime = value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Delivery Fee
                  Text(
                    'رسوم التوصيل: ${_maxDeliveryFee.round()} ر.س كحد أقصى',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _maxDeliveryFee,
                    min: 0,
                    max: 30,
                    divisions: 15,
                    label: _maxDeliveryFee == 0 ? 'مجاني' : '${_maxDeliveryFee.round()} ر.س',
                    onChanged: (value) => setState(() => _maxDeliveryFee = value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Rating
                  Text(
                    'الحد الأدنى للتقييم: ${_minRating == 0 ? 'أي' : _minRating.toStringAsFixed(1)} نجوم',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _minRating == 0 ? 'أي' : _minRating.toStringAsFixed(1),
                    onChanged: (value) => setState(() => _minRating = value),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Toggle Options
                  _buildToggleOption(
                    theme,
                    'التوصيل المجاني فقط',
                    _freeDeliveryOnly,
                    (value) => setState(() => _freeDeliveryOnly = value),
                  ),
                  _buildToggleOption(
                    theme,
                    'المفتوح الآن فقط',
                    _openNowOnly,
                    (value) => setState(() => _openNowOnly = value),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Cuisines
                  Text(
                    'المطابخ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ['سعودي', 'شرقي', 'آسيوي', 'إيطالي', 'برجر', 'بحري', 'صحي', 'حلويات']
                        .map((cuisine) => FilterChip(
                              label: Text(cuisine),
                              selected: _selectedCuisines.contains(cuisine),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedCuisines.add(cuisine);
                                  } else {
                                    _selectedCuisines.remove(cuisine);
                                  }
                                });
                              },
                              selectedColor: theme.colorScheme.primaryContainer,
                              checkmarkColor: theme.colorScheme.primary,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Apply Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text('إلغاء'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text('تطبيق الفلترة'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(ThemeData theme, String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _sortBy = 'recommended';
      _maxDeliveryTime = 60;
      _maxDeliveryFee = 20;
      _minRating = 0;
      _freeDeliveryOnly = false;
      _openNowOnly = false;
      _selectedCuisines.clear();
    });
  }

  void _applyFilters() {
    // Apply filters and close bottom sheet
    Navigator.pop(context, {
      'sortBy': _sortBy,
      'maxDeliveryTime': _maxDeliveryTime,
      'maxDeliveryFee': _maxDeliveryFee,
      'minRating': _minRating,
      'freeDeliveryOnly': _freeDeliveryOnly,
      'openNowOnly': _openNowOnly,
      'cuisines': _selectedCuisines,
    });
  }
}