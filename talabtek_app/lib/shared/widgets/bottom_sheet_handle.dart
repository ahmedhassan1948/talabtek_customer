import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class BottomSheetHandle extends StatelessWidget {
  final Color? color;
  final double width;
  final double height;
  final double marginTop;
  final double marginBottom;

  const BottomSheetHandle({
    super.key,
    this.color,
    this.width = 40,
    this.height = 4,
    this.marginTop = 12,
    this.marginBottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(top: marginTop.h, bottom: marginBottom.h),
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.outline,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class DraggableBottomSheet extends StatelessWidget {
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool expand;
  final bool showHandle;
  final Color? handleColor;
  final Widget? header;
  final VoidCallback? onClose;

  const DraggableBottomSheet({
    super.key,
    required this.child,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.9,
    this.expand = false,
    this.showHandle = true,
    this.handleColor,
    this.header,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: expand,
      builder: (context, scrollController) {
        return Container(
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
          child: Column(
            children: [
              if (showHandle)
                BottomSheetHandle(color: handleColor),
              if (header != null) header!,
              if (header != null)
                Divider(height: 1, color: theme.dividerColor),
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ModalBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? action;
  final bool showHandle;
  final bool isScrollControlled;
  final EdgeInsetsGeometry? padding;

  const ModalBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.showHandle = true,
    this.isScrollControlled = true,
    this.padding,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? action,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => ModalBottomSheet(
        child: child,
        title: title,
        action: action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            BottomSheetHandle(),
          if (title != null || action != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, showHandle ? 8.h : 16.h, 16.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (action != null) action!,
                ],
              ),
            ),
          if (title != null || action != null)
            Divider(height: 1, color: theme.dividerColor),
          Flexible(
            child: Padding(
              padding: padding ?? EdgeInsets.all(16.w),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onClose;

  const BottomSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onClose != null)
            IconButton(
              icon: Icon(Icons.close, size: 24.w),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}