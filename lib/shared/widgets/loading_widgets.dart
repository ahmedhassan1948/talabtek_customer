import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final Widget? customLoader;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.customLoader,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customLoader ?? const CircularProgressIndicator(),
                    if (message != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String? message;
  final Widget? customLoader;
  final Color? backgroundColor;

  const FullScreenLoader({
    super.key,
    this.message,
    this.customLoader,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customLoader ?? const CircularProgressIndicator(),
            if (message != null) ...[
              SizedBox(height: 16.h),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LottieLoader extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final bool repeat;
  final bool animate;
  final Widget? fallback;

  const LottieLoader({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.repeat = true,
    this.animate = true,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: repeat,
      animate: animate,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? const CircularProgressIndicator();
      },
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (!enabled) return child;
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? theme.colorScheme.surfaceContainerHighest,
      highlightColor: highlightColor ?? theme.colorScheme.surfaceVariant,
      period: period,
      child: child,
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  const SkeletonLoader.circular({
    super.key,
    required double diameter,
    this.baseColor,
    this.highlightColor,
  }) : width = diameter,
       height = diameter,
       borderRadius = BorderRadius.circular(diameter / 2);

  const SkeletonLoader.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? theme.colorScheme.surfaceContainerHighest,
      highlightColor: highlightColor ?? theme.colorScheme.surfaceVariant,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final Widget Function(int index)? itemBuilder;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 120,
    this.padding,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (itemBuilder != null) {
          return itemBuilder!(index);
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SkeletonLoader.rectangular(
            width: double.infinity,
            height: itemHeight,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double itemHeight;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final Widget Function(int index)? itemBuilder;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.itemHeight = 200,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1 / (itemHeight / ((MediaQuery.of(context).size.width - 32 - crossAxisSpacing) / crossAxisCount)),
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (itemBuilder != null) {
          return itemBuilder!(index);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader.rectangular(
              width: double.infinity,
              height: itemHeight * 0.6,
              borderRadius: BorderRadius.circular(12),
            ),
            SizedBox(height: 8.h),
            SkeletonLoader.rectangular(
              width: double.infinity,
              height: 16,
              borderRadius: BorderRadius.circular(8),
            ),
            SizedBox(height: 4.h),
            SkeletonLoader.rectangular(
              width: 80.w,
              height: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        );
      },
    );
  }
}

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final String? refreshMessage;
  final String? releasingMessage;
  final String? completeMessage;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.refreshMessage,
    this.releasingMessage,
    this.completeMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      displacement: 40.h,
      strokeWidth: 3,
      child: child,
    );
  }
}

class InfiniteScrollLoader extends StatelessWidget {
  final bool hasMore;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final Widget? loader;
  final String? message;

  const InfiniteScrollLoader({
    super.key,
    this.hasMore = false,
    this.isLoading = false,
    this.onLoadMore,
    this.loader,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: Center(
          child: Text(
            'لا توجد المزيد من العناصر',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              loader ?? const CircularProgressIndicator(),
              if (message != null) ...[
                SizedBox(height: 8.h),
                Text(
                  message!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  const LoadingButton({
    super.key,
    required this.isLoading,
    this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: theme.colorScheme.outline,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize.sp,
                      fontWeight: fontWeight,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}