import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';
import 'package:talabtek_customer/features/restaurant/presentation/widgets/product_card.dart';
import 'package:talabtek_customer/features/restaurant/presentation/screens/product_detail_screen.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';

class MenuCategoryList extends StatefulWidget {
  final RestaurantModel restaurant;
  final Function(CartItemModel)? onItemAdded;

  const MenuCategoryList({
    super.key,
    required this.restaurant,
    this.onItemAdded,
  });

  @override
  State<MenuCategoryList> createState() => _MenuCategoryListState();
}

class _MenuCategoryListState extends State<MenuCategoryList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // In a real app, you'd fetch categories from the restaurant
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _getMockCategories();

    return Column(
      children: [
        // Category Tabs
        Container(
          color: theme.colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            tabs: categories.map((cat) => Tab(text: cat['name'])).toList(),
            onTap: (index) {
              setState(() => _selectedCategoryIndex = index);
            },
          ),
        ),

        // Category Content
        TabBarView(
          controller: _tabController,
          children: categories.map((category) => _buildCategoryContent(category)).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryContent(Map<String, dynamic> category) {
    final products = _getMockProducts(category['id']);
    
    if (products.isEmpty) {
      return _buildEmptyCategory();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: products.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          restaurantId: widget.restaurant.id,
          restaurantName: widget.restaurant.name,
          onTap: () => _navigateToProductDetail(product),
          onAddToCart: widget.onItemAdded,
        );
      },
    );
  }

  Widget _buildEmptyCategory() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 64.w,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد أصناف في هذا القسم',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(ProductModel product) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: {
        'product': product,
        'restaurantId': widget.restaurant.id,
        'restaurantName': widget.restaurant.name,
      },
    );
  }

  List<Map<String, String>> _getMockCategories() {
    return [
      {'id': 'main', 'name': 'الأطباق الرئيسية'},
      {'id': 'appetizers', 'name': 'المقبلات'},
      {'id': 'drinks', 'name': 'المشروبات'},
    ];
  }

  List<ProductModel> _getMockProducts(String categoryId) {
    final allProducts = [
      ProductModel(
        id: '1',
        restaurantId: widget.restaurant.id,
        categoryId: 'main',
        subCategoryId: 'mandi',
        name: 'مندي لحم',
        nameEn: 'Lamb Mandi',
        description: 'مندي لحم طري مع أرز بصري أصلي وسلطة',
        descriptionEn: 'Tender lamb mandi with authentic basmati rice and salad',
        imageUrl: 'assets/images/mandi.jpg',
        images: [],
        price: 45.0,
        originalPrice: 55.0,
        discountPercentage: 18,
        calories: 650,
        preparationTime: '30-40 دقيقة',
        isAvailable: true,
        isPopular: true,
        isVegetarian: false,
        isVegan: false,
        isGlutenFree: false,
        isHalal: true,
        spicyLevel: 1,
        optionGroups: [
          ProductOptionGroupModel(
            id: 'rice',
            name: 'نوع الأرز',
            nameEn: 'Rice Type',
            type: 'single',
            isRequired: true,
            options: [
              ProductOptionModel(id: 'basmati', name: 'بصري', nameEn: 'Basmati', price: 0, isDefault: true),
              ProductOptionModel(id: 'egyptian', name: 'مصري', nameEn: 'Egyptian', price: 0),
            ],
          ),
          ProductOptionGroupModel(
            id: 'meat',
            name: 'إضافات اللحم',
            nameEn: 'Meat Add-ons',
            type: 'multiple',
            maxSelections: 3,
            options: [
              ProductOptionModel(id: 'extra_meat', name: 'لحم إضافي', nameEn: 'Extra Meat', price: 15.0),
              ProductOptionModel(id: 'chicken', name: 'دجاج', nameEn: 'Chicken', price: 12.0),
            ],
          ),
        ],
        tags: ['مندي', 'غداء', 'شهير'],
        allergens: [],
        nutritionInfo: {'protein': '45g', 'carbs': '78g', 'fat': '22g'},
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '2',
        restaurantId: widget.restaurant.id,
        categoryId: 'main',
        subCategoryId: 'kabsa',
        name: 'كبسة دجاج',
        nameEn: 'Chicken Kabsa',
        description: 'كبسة دجاج مشوي مع أرز متبل ومكسرات',
        descriptionEn: 'Grilled chicken kabsa with spiced rice and nuts',
        imageUrl: 'assets/images/kabsa.jpg',
        images: [],
        price: 38.0,
        calories: 580,
        preparationTime: '25-35 دقيقة',
        isAvailable: true,
        isPopular: true,
        isVegetarian: false,
        isVegan: false,
        isGlutenFree: false,
        isHalal: true,
        spicyLevel: 1,
        optionGroups: [
          ProductOptionGroupModel(
            id: 'spice',
            name: 'مستوى البهارات',
            nameEn: 'Spice Level',
            type: 'single',
            isRequired: true,
            options: [
              ProductOptionModel(id: 'mild', name: 'عادي', nameEn: 'Mild', price: 0, isDefault: true),
              ProductOptionModel(id: 'medium', name: 'متوسط', nameEn: 'Medium', price: 0),
              ProductOptionModel(id: 'hot', name: 'حار', nameEn: 'Hot', price: 0),
            ],
          ),
        ],
        tags: ['كبسة', 'دجاج', 'غداء'],
        allergens: ['مكسرات'],
        nutritionInfo: {'protein': '42g', 'carbs': '72g', 'fat': '18g'},
        order: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '3',
        restaurantId: widget.restaurant.id,
        categoryId: 'appetizers',
        subCategoryId: 'salads',
        name: 'سلطة فتوش',
        nameEn: 'Fattoush Salad',
        description: 'سلطة خضار طازجة مع خبز مقلي وسماق',
        descriptionEn: 'Fresh vegetable salad with fried bread and sumac',
        imageUrl: 'assets/images/fattoush.jpg',
        images: [],
        price: 18.0,
        calories: 120,
        preparationTime: '10-15 دقيقة',
        isAvailable: true,
        isPopular: false,
        isVegetarian: true,
        isVegan: true,
        isGlutenFree: false,
        isHalal: true,
        spicyLevel: 0,
        optionGroups: [],
        tags: ['سلطة', 'مقبلات', 'نباتي'],
        allergens: ['غلوتين'],
        nutritionInfo: {'protein': '3g', 'carbs': '15g', 'fat': '5g'},
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '4',
        restaurantId: widget.restaurant.id,
        categoryId: 'appetizers',
        subCategoryId: 'soups',
        name: 'شوربة حريرة',
        nameEn: 'Harira Soup',
        description: 'شوربة مغربية تقليدية بالحمص والعدس',
        descriptionEn: 'Traditional Moroccan soup with chickpeas and lentils',
        imageUrl: 'assets/images/harira.jpg',
        images: [],
        price: 15.0,
        calories: 180,
        preparationTime: '10-15 دقيقة',
        isAvailable: true,
        isPopular: false,
        isVegetarian: true,
        isVegan: false,
        isGlutenFree: true,
        isHalal: true,
        spicyLevel: 1,
        optionGroups: [],
        tags: ['شوربة', 'مقبلات', 'نباتي'],
        allergens: [],
        nutritionInfo: {'protein': '8g', 'carbs': '22g', 'fat': '4g'},
        order: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '5',
        restaurantId: widget.restaurant.id,
        categoryId: 'drinks',
        subCategoryId: 'soft_drinks',
        name: 'بيبسي',
        nameEn: 'Pepsi',
        description: 'مشروب غازي منعش',
        descriptionEn: 'Refreshing soft drink',
        imageUrl: 'assets/images/pepsi.jpg',
        images: [],
        price: 5.0,
        calories: 150,
        preparationTime: 'فوري',
        isAvailable: true,
        isPopular: false,
        isVegetarian: true,
        isVegan: true,
        isGlutenFree: true,
        isHalal: true,
        spicyLevel: 0,
        optionGroups: [
          ProductOptionGroupModel(
            id: 'size',
            name: 'الحجم',
            nameEn: 'Size',
            type: 'single',
            isRequired: true,
            options: [
              ProductOptionModel(id: 'small', name: 'صغير', nameEn: 'Small', price: 0, isDefault: true),
              ProductOptionModel(id: 'medium', name: 'وسط', nameEn: 'Medium', price: 2.0),
              ProductOptionModel(id: 'large', name: 'كبير', nameEn: 'Large', price: 4.0),
            ],
          ),
        ],
        tags: ['مشروبات', 'غازية'],
        allergens: [],
        nutritionInfo: {'sugar': '40g'},
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '6',
        restaurantId: widget.restaurant.id,
        categoryId: 'drinks',
        subCategoryId: 'juices',
        name: 'عصير برتقال طازج',
        nameEn: 'Fresh Orange Juice',
        description: 'عصير برتقال طبيعي 100%',
        descriptionEn: '100% natural orange juice',
        imageUrl: 'assets/images/orange_juice.jpg',
        images: [],
        price: 12.0,
        calories: 110,
        preparationTime: '5-10 دقيقة',
        isAvailable: true,
        isPopular: true,
        isVegetarian: true,
        isVegan: true,
        isGlutenFree: true,
        isHalal: true,
        spicyLevel: 0,
        optionGroups: [],
        tags: ['عصائر', 'طازج', 'صحي'],
        allergens: [],
        nutritionInfo: {'vitamin_c': '120mg', 'sugar': '22g'},
        order: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return allProducts.where((p) => p.categoryId == categoryId).toList();
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final String restaurantId;
  final String restaurantName;
  final Function(CartItemModel)? onItemAdded;
  final Function(ProductModel)? onProductTap;

  const CategorySection({
    super.key,
    required this.title,
    required this.products,
    required this.restaurantId,
    required this.restaurantName,
    this.onItemAdded,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: products.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              restaurantId: restaurantId,
              restaurantName: restaurantName,
              onTap: () => onProductTap?.call(product),
              onAddToCart: onItemAdded,
            );
          },
        ),
      ],
    );
  }
}