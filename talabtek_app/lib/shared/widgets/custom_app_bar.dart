import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.surfaceTintColor,
    this.elevation = 0,
    this.bottom,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      leading: leading ??
          (automaticallyImplyLeading && showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.w,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: 1,
      bottom: bottom,
      shape: Border(
        bottom: BorderSide(
          color: theme.dividerColor,
          width: elevation > 0 ? 0 : 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class SliverCustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;

  const SliverCustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.surfaceTintColor,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.w,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      snap: snap,
      shape: Border(
        bottom: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final List<Widget>? actions;
  final Widget? leading;
  final bool autofocus;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final Color? backgroundColor;
  final bool readOnly;

  const SearchAppBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.actions,
    this.leading,
    this.autofocus = false,
    this.showFilter = false,
    this.onFilterTap,
    this.backgroundColor,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          autofocus: autofocus,
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
          readOnly: readOnly,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText ?? 'ابحث...',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.w),
              child: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 22.w,
              ),
            ),
            suffixIcon: showFilter
                ? IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 22.w,
                    ),
                    onPressed: onFilterTap,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          ),
        ),
      ),
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shape: Border(
        bottom: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController tabController;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsetsGeometry? padding;

  const TabAppBar({
    super.key,
    required this.tabs,
    required this.tabController,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 3,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: TabBar(
        controller: tabController,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: indicatorWeight,
        indicatorSize: indicatorSize,
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ?? theme.colorScheme.onSurfaceVariant,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
        padding: padding,
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          color: theme.dividerColor,
          thickness: 1,
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}