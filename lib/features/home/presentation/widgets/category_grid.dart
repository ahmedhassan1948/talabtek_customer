import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/shared/widgets/cached_image.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryModel>? categories;
  final int crossAxisCount;
  final double aspectRatio;
  final VoidCallback? onSeeAll;
  final Function(String categoryId)? onCategoryTap;

  const CategoryGrid({
    super.key,
    this.categories,
    this.crossAxisCount = 4,
    this.aspectRatio = 1,
    this.onSeeAll,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayCategories = categories ?? _getDefaultCategories();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التصنيفات',
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: aspectRatio,
          ),
          itemCount: displayCategories.length > crossAxisCount * 2
              ? crossAxisCount * 2
              : displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ],
    );
  }

  List<CategoryModel> _getDefaultCategories() {
    return AppConstants.mainCategories.map((cat) => CategoryModel(
      id: cat['id'] as String,
      name: cat['name'] as String,
      nameEn: cat['name'] as String,
      icon: cat['icon'] as String,
      imageUrl: '',
      color: (cat['color'] as int).toString(),
      order: 0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )).toList();
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    final theme = Theme.of(context);
    final color = _parseColor(category.color);

    return GestureDetector(
      onTap: () => onCategoryTap?.call(category.id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: category.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedImage(
                      imageUrl: category.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : _buildIcon(category.icon, color),
          ),
          SizedBox(height: 8.h),
          Text(
            category.name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String iconName, Color color) {
    IconData iconData;
    switch (iconName) {
      case 'restaurant':
        iconData = Icons.restaurant_outlined;
        break;
      case 'shopping_cart':
        iconData = Icons.shopping_cart_outlined;
        break;
      case 'local_pharmacy':
        iconData = Icons.local_pharmacy_outlined;
        break;
      case 'healing':
        iconData = Icons.healing_outlined;
        break;
      case 'local_shipping':
        iconData = Icons.local_shipping_outlined;
        break;
      default:
        iconData = Icons.category_outlined;
    }
    return Center(
      child: Icon(iconData, size: 32.w, color: color),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString));
    } catch (e) {
      return AppTheme.primaryColor;
    }
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String nameEn;
  final String icon;
  final String imageUrl;
  final String color;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final Function(String categoryId)? onCategoryTap;
  final bool showAllOption;

  const CategoryList({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategoryTap,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length + (showAllOption ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0 && showAllOption) {
            return _buildAllCategory(context);
          }
          final categoryIndex = showAllOption ? index - 1 : index;
          if (categoryIndex >= categories.length) return const SizedBox.shrink();
          
          final category = categories[categoryIndex];
          return _buildCategoryChip(context, category);
        },
      ),
    );
  }

  Widget _buildAllCategory(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedCategoryId == null || selectedCategoryId == 'all';

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text('الكل'),
        selected: isSelected,
        onSelected: (selected) => onCategoryTap?.call('all'),
        selectedColor: theme.colorScheme.primaryContainer,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, CategoryModel category) {
    final theme = Theme.of(context);
    final isSelected = selectedCategoryId == category.id;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        avatar: category.imageUrl.isNotEmpty
            ? CircleAvatar(
                radius: 12.r,
                backgroundColor: _parseColor(category.color).withOpacity(0.1),
                child: CachedImage(
                  imageUrl: category.imageUrl,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.cover,
                ),
              )
            : CircleAvatar(
                radius: 12.r,
                backgroundColor: _parseColor(category.color).withOpacity(0.1),
                child: Icon(
                  _getIconData(category.icon),
                  size: 16.w,
                  color: _parseColor(category.color),
                ),
              ),
        label: Text(category.name),
        selected: isSelected,
        onSelected: (selected) => onCategoryTap?.call(category.id),
        selectedColor: theme.colorScheme.primaryContainer,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant_outlined;
      case 'shopping_cart': return Icons.shopping_cart_outlined;
      case 'local_pharmacy': return Icons.local_pharmacy_outlined;
      case 'healing': return Icons.healing_outlined;
      case 'local_shipping': return Icons.local_shipping_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString));
    } catch (e) {
      return AppTheme.primaryColor;
    }
  }
}