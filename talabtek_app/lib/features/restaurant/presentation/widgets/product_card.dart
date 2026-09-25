import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/restaurant_model.dart';
import 'package:talabtek_customer/shared/models/cart_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final String restaurantId;
  final String restaurantName;
  final VoidCallback? onTap;
  final Function(CartItemModel)? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.restaurantId,
    required this.restaurantName,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final hasDiscount = product.hasDiscount;
    final hasOptions = product.hasOptions;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
            // Image and Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedImage(
                    imageUrl: product.imageUrl,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      height: 140.h,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                
                // Badges
                Positioned(
                  top: 8.w,
                  left: 8.w,
                  child: _buildBadges(context),
                ),
                
                // Discount Badge
                if (hasDiscount)
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${product.discountPercentage.round()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                
                // Favorite Button
                Positioned(
                  bottom: 8.w,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      size: 18.w,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            
            // Product Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.isPopular)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.warningColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 10.w, color: theme.colorScheme.warningColor),
                              SizedBox(width: 2.w),
                              Text(
                                'شائع',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.warningColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Description
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: _isExpanded ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  // Dietary Tags
                  if (_hasDietaryTags(product)) ...[
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: _buildDietaryTags(context, product),
                    ),
                  ],
                  
                  // Options Indicator
                  if (hasOptions) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune_outlined,
                            size: 12.w,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'خيارات متاحة',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 12.h),
                  
                  // Price and Add Button
                  Row(
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.finalPrice.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (hasDiscount)
                            Text(
                              '${product.originalPrice!.toStringAsFixed(2)} ر.س',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Add to Cart Button
                      _buildAddButton(context),
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

  Widget _buildBadges(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final badges = <Widget>[];
    
    if (product.isVegetarian) {
      badges.add(_buildBadge(context, 'نباتي', theme.colorScheme.successColor, Icons.eco_outlined));
    }
    if (product.isVegan) {
      badges.add(_buildBadge(context, 'فيجان', theme.colorScheme.primary, Icons.spa_outlined));
    }
    if (product.isGlutenFree) {
      badges.add(_buildBadge(context, 'خالي من الجلوتين', theme.colorScheme.infoColor, Icons.grain_outlined));
    }
    if (product.spicyLevel > 0) {
      badges.add(_buildBadge(context, 'حار ${product.spicyLevel}/3', theme.colorScheme.error, Icons.local_fire_department_outlined));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: badges.map((b) => Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: b,
      )).toList(),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.w, color: Colors.white),
          SizedBox(width: 3.w),
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

  bool _hasDietaryTags(ProductModel product) {
    return product.isVegetarian || product.isVegan || product.isGlutenFree || product.isHalal;
  }

  List<Widget> _buildDietaryTags(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    final tags = <Widget>[];
    
    if (product.isVegetarian) {
      tags.add(_buildDietaryTag(context, 'نباتي', Icons.eco_outlined, theme.colorScheme.successColor));
    }
    if (product.isVegan) {
      tags.add(_buildDietaryTag(context, 'فيجان', Icons.spa_outlined, theme.colorScheme.primary));
    }
    if (product.isGlutenFree) {
      tags.add(_buildDietaryTag(context, 'خالي من الجلوتين', Icons.grain_outlined, theme.colorScheme.infoColor));
    }
    if (product.isHalal) {
      tags.add(_buildDietaryTag(context, 'حلال', Icons.verified_outlined, theme.colorScheme.warningColor));
    }
    
    return tags;
  }

  Widget _buildDietaryTag(BuildContext context, String text, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.w, color: color),
          SizedBox(width: 3.w),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final theme = Theme.of(context);
    final hasOptions = widget.product.hasOptions;
    
    if (hasOptions) {
      return OutlinedButton.icon(
        onPressed: widget.onTap,
        icon: Icon(Icons.add, size: 18.w),
        label: Text('إضافة'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    
    return ElevatedButton.icon(
      onPressed: _addToCart,
      icon: Icon(Icons.add_shopping_cart_outlined, size: 18.w),
      label: Text('إضافة'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  void _addToCart() {
    final cartItem = CartItemModel(
      id: '${widget.product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: widget.product.id,
      productName: widget.product.name,
      productImage: widget.product.imageUrl,
      restaurantId: widget.restaurantId,
      restaurantName: widget.restaurantName,
      unitPrice: widget.product.finalPrice,
      quantity: 1,
      selectedOptions: [],
      addedAt: DateTime.now(),
    );
    
    widget.onAddToCart?.call(cartItem);
  }
}

class ProductCardHorizontal extends StatelessWidget {
  final ProductModel product;
  final String restaurantId;
  final String restaurantName;
  final Function(CartItemModel)? onAddToCart;
  final VoidCallback? onTap;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    required this.restaurantId,
    required this.restaurantName,
    this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.hasDiscount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedImage(
                    imageUrl: product.imageUrl,
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercentage.round()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '${product.finalPrice.toStringAsFixed(2)} ر.س',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: 6.w),
                        Text(
                          '${product.originalPrice!.toStringAsFixed(2)} ر.س',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          final cartItem = CartItemModel(
                            id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
                            productId: product.id,
                            productName: product.name,
                            productImage: product.imageUrl,
                            restaurantId: restaurantId,
                            restaurantName: restaurantName,
                            unitPrice: product.finalPrice,
                            quantity: 1,
                            selectedOptions: [],
                            addedAt: DateTime.now(),
                          );
                          onAddToCart?.call(cartItem);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16.w,
                            color: theme.colorScheme.primary,
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
}