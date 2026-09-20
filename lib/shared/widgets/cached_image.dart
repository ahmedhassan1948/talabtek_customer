import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showErrorIcon;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final String? cacheKey;

  const CachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.showErrorIcon = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 100),
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget(theme);
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: (context, url) => _buildPlaceholder(theme),
      errorWidget: (context, url, error) => _buildErrorWidget(theme),
      memCacheWidth: width != null ? (width! * 2).round() : null,
      memCacheHeight: height != null ? (height! * 2).round() : null,
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildPlaceholder(ThemeData theme) {
    if (placeholder != null) return placeholder!;
    
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surfaceVariant,
      child: Container(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    if (errorWidget != null) return errorWidget!;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
      child: showErrorIcon
          ? Icon(
              Icons.image_not_supported_outlined,
              size: (width != null && width! < 50) ? 20.w : 32.w,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : null,
    );
  }
}

class RestaurantImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool showShimmer;

  const RestaurantImage({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: borderRadius,
      placeholder: showShimmer
          ? Shimmer.fromColors(
              baseColor: theme.colorScheme.surfaceContainerHighest,
              highlightColor: theme.colorScheme.surfaceVariant,
              child: Container(
                width: width,
                height: height,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
            )
          : null,
      errorWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
        child: Icon(
          Icons.restaurant_outlined,
          size: (width < 100) ? 24.w : 40.w,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final BorderRadius? borderRadius;
  final bool showShimmer;

  const ProductImage({
    super.key,
    this.imageUrl,
    required this.size,
    this.borderRadius,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return RestaurantImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      showShimmer: showShimmer,
    );
  }
}

class CategoryImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final IconData fallbackIcon;

  const CategoryImage({
    super.key,
    this.imageUrl,
    required this.size,
    this.backgroundColor,
    this.fallbackIcon = Icons.category_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surfaceVariant,
          child: Container(
            width: size,
            height: size,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        errorWidget: Container(
          width: size,
          height: size,
          color: backgroundColor ?? theme.colorScheme.primaryContainer,
          child: Icon(
            fallbackIcon,
            size: size * 0.4,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final txtColor = textColor ?? theme.colorScheme.onPrimaryContainer;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        decoration: showBorder
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor ?? theme.colorScheme.primary,
                  width: borderWidth,
                ),
              )
            : null,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: ClipOval(
            child: CachedImage(
              imageUrl: imageUrl,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorWidget: _buildInitials(theme, bgColor, txtColor),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? theme.colorScheme.primary,
                width: borderWidth,
              ),
            )
          : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: _buildInitials(theme, bgColor, txtColor),
      ),
    );
  }

  Widget _buildInitials(ThemeData theme, Color bgColor, Color txtColor) {
    String initials = '';
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }
    
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: txtColor,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  final List<String?> imageUrls;
  final int maxVisible;
  final double radius;
  final double overlap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const AvatarStack({
    super.key,
    required this.imageUrls,
    this.maxVisible = 3,
    this.radius = 20,
    this.overlap = 8,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleUrls = imageUrls.take(maxVisible).toList();
    final remaining = imageUrls.length - maxVisible;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          for (int i = 0; i < visibleUrls.length; i++)
            Positioned(
              left: (radius * 2 - overlap) * i,
              child: UserAvatar(
                imageUrl: visibleUrls[i],
                radius: radius,
                backgroundColor: backgroundColor,
                showBorder: true,
                borderColor: borderColor ?? theme.colorScheme.surface,
                borderWidth: borderWidth,
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: (radius * 2 - overlap) * visibleUrls.length,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                  border: Border.all(
                    color: borderColor ?? theme.colorScheme.surface,
                    width: borderWidth,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      fontSize: radius * 0.5,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}