import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/shared/providers/cart_provider.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';
import 'package:talabtek_customer/shared/widgets/bottom_sheet_handle.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final String restaurantId;
  final String restaurantName;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Map<String, String> _selectedOptions = {};
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: Container(color: theme.colorScheme.surfaceContainerHighest),
                  ),
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
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.hasDiscount)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'خصم ${product.discountPercentage.round()}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        SizedBox(height: 8.h),
                        Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16.w, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              '4.8 (250 تقييم)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            if (product.calories > 0) ...[
                              Icon(Icons.local_fire_department, size: 16.w, color: Colors.orange),
                              SizedBox(width: 4.w),
                              Text(
                                '${product.calories} سعرة',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (product.description.isNotEmpty) ...[
                    Text(
                      'الوصف',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      product.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Option Groups
                  if (product.hasOptions) ...[
                    Text(
                      'تخصيص طلبك',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...product.optionGroups.map((group) => _buildOptionGroup(context, group)),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Dietary Info
                  if (_hasDietaryInfo(product)) ...[
                    Text(
                      'معلومات غذائية',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildDietaryInfo(context, product),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Nutrition Info
                  if (product.nutritionInfo.isNotEmpty) ...[
                    Text(
                      'القيمة الغذائية',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildNutritionInfo(context, product),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Allergens
                  if (product.allergens.isNotEmpty) ...[
                    Text(
                      'مسببات الحساسية',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: product.allergens.map((allergen) => Chip(
                        label: Text(allergen),
                        backgroundColor: theme.colorScheme.errorContainer,
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.3)),
                      )).toList(),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Special Instructions
                  Text(
                    'ملاحظات خاصة (اختياري)',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'مثال: بدون بصل، صلصة على الجانب، ناضج جيداً...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h), // Space for bottom bar
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Price Bar
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildOptionGroup(BuildContext context, ProductOptionGroupModel group) {
    final theme = Theme.of(context);
    final isRequired = group.isRequired;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
              Text(
                group.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'إلزامي',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (group.type == 'multiple')
                Text(
                  'اختر حتى ${group.maxSelections}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: group.options.map((option) {
              final isSelected = _selectedOptions[group.id] == option.id;
              return _buildOptionChip(context, option, isSelected, () {
                if (group.type == 'single') {
                  setState(() => _selectedOptions[group.id] = option.id);
                } else {
                  // Multiple selection would need different handling
                  setState(() => _selectedOptions[group.id] = option.id);
                }
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChip(BuildContext context, ProductOptionModel option, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 18.w,
                color: theme.colorScheme.primary,
              ),
            if (isSelected) SizedBox(width: 6.w),
            Text(
              option.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (option.price > 0) ...[
              SizedBox(width: 8.w),
              Text(
                '+${option.price.toStringAsFixed(2)} ر.س',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasDietaryInfo(ProductModel product) {
    return product.isVegetarian || product.isVegan || product.isGlutenFree || product.isHalal;
  }

  Widget _buildDietaryInfo(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    final items = <Widget>[];
    
    if (product.isVegetarian) {
      items.add(_buildDietaryItem(context, 'نباتي', Icons.eco_outlined, theme.colorScheme.successColor));
    }
    if (product.isVegan) {
      items.add(_buildDietaryItem(context, 'فيجان', Icons.spa_outlined, theme.colorScheme.primary));
    }
    if (product.isGlutenFree) {
      items.add(_buildDietaryItem(context, 'خالي من الجلوتين', Icons.grain_outlined, theme.colorScheme.infoColor));
    }
    if (product.isHalal) {
      items.add(_buildDietaryItem(context, 'حلال', Icons.verified_outlined, theme.colorScheme.warningColor));
    }
    if (product.spicyLevel > 0) {
      items.add(_buildDietaryItem(context, 'مستوى الحدة: ${product.spicyLevel}/3', Icons.local_fire_department_outlined, theme.colorScheme.error));
    }
    
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: items,
    );
  }

  Widget _buildDietaryItem(BuildContext context, String text, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.w, color: color),
          SizedBox(width: 8.w),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        children: product.nutritionInfo.entries.map((entry) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                entry.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final optionsPrice = product.optionGroups
        .expand((g) => g.options.where((o) => _selectedOptions[g.id] == o.id))
        .fold(0.0, (sum, o) => sum + o.price);
    final unitPrice = product.finalPrice + optionsPrice;
    final totalPrice = unitPrice * _quantity;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السعر للوحدة',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${unitPrice.toStringAsFixed(2)} ر.س',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 20.w),
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.w),
                  ),
                  Text(
                    '$_quantity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 20.w),
                    onPressed: () => setState(() => _quantity++),
                    constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.w),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Add to Cart Button
            Expanded(
              child: CustomButton(
                text: 'إضافة إلى السلة - ${totalPrice.toStringAsFixed(2)} ر.س',
                isLoading: _isAddingToCart,
                onPressed: _addToCart,
                height: 50,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    final product = widget.product;
    final cartProvider = context.read<CartProvider>();
    
    // Check required options
    for (final group in product.optionGroups) {
      if (group.isRequired && !_selectedOptions.containsKey(group.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى اختيار ${group.name}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }
    
    setState(() => _isAddingToCart = true);
    
    // Build selected options
    final selectedOptions = <CartOptionModel>[];
    for (final group in product.optionGroups) {
      final selectedId = _selectedOptions[group.id];
      if (selectedId != null) {
        final option = group.options.firstWhere((o) => o.id == selectedId);
        selectedOptions.add(CartOptionModel(
          optionId: group.id,
          optionName: group.name,
          valueId: option.id,
          valueName: option.name,
          price: option.price,
          isRequired: group.isRequired,
        ));
      }
    }
    
    final cartItem = CartItemModel(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      productName: product.name,
      productImage: product.imageUrl,
      restaurantId: widget.restaurantId,
      restaurantName: widget.restaurantName,
      unitPrice: product.finalPrice + optionsPrice,
      quantity: _quantity,
      selectedOptions: selectedOptions,
      addedAt: DateTime.now(),
    );
    
    final success = await cartProvider.addItem(cartItem);
    
    setState(() => _isAddingToCart = false);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة ${product.name} × $_quantity إلى السلة'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }
}