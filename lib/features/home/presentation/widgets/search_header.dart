import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/shared/widgets/custom_text_field.dart';

class SearchHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;

  const SearchHeader({
    super.key,
    this.onTap,
    this.onFilterTap,
    this.controller,
    this.hintText,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 22.w,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    hintText ?? 'ابحث عن مطاعم، أطباق، أو منتجات...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (onFilterTap != null) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20.w,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final bool showVoiceSearch;
  final VoidCallback? onVoiceTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.autofocus = false,
    this.showFilter = true,
    this.onFilterTap,
    this.showVoiceSearch = false,
    this.onVoiceTap,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final radius = borderRadius ?? BorderRadius.circular(16);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText ?? 'ابحث عن مطاعم، أطباق، أو منتجات...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              Icons.search,
              color: theme.colorScheme.onSurfaceVariant,
              size: 22.w,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showVoiceSearch)
                IconButton(
                  icon: Icon(
                    Icons.mic_outlined,
                    color: theme.colorScheme.primary,
                    size: 22.w,
                  ),
                  onPressed: onVoiceTap,
                ),
              if (showFilter)
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 22.w,
                  ),
                  onPressed: onFilterTap,
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final List<String> recentSearches;
  final Function(String) onSuggestionTap;
  final VoidCallback? onClearRecent;

  const SearchSuggestions({
    super.key,
    this.suggestions = const [],
    this.recentSearches = const [],
    required this.onSuggestionTap,
    this.onClearRecent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (suggestions.isEmpty && recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentSearches.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عمليات البحث الأخيرة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onClearRecent != null)
                  TextButton(
                    onPressed: onClearRecent,
                    child: Text(
                      'مسح الكل',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: recentSearches.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.dividerColor,
              indent: 16.w,
              endIndent: 16.w,
            ),
            itemBuilder: (context, index) {
              final search = recentSearches[index];
              return ListTile(
                leading: Icon(
                  Icons.history,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
                title: Text(
                  search,
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18.w,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => onSuggestionTap(search),
                ),
                onTap: () => onSuggestionTap(search),
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
        if (suggestions.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
            child: Text(
              'مقترحات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.dividerColor,
              indent: 16.w,
              endIndent: 16.w,
            ),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                leading: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
                title: Text(
                  suggestion,
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () => onSuggestionTap(suggestion),
              );
            },
          ),
        ],
      ],
    );
  }
}

class SearchResultsHeader extends StatelessWidget {
  final String query;
  final int resultCount;
  final VoidCallback? onSortTap;
  final VoidCallback? onFilterTap;
  final String? sortBy;

  const SearchResultsHeader({
    super.key,
    required this.query,
    required this.resultCount,
    this.onSortTap,
    this.onFilterTap,
    this.sortBy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium,
              children: [
                TextSpan(
                  text: 'نتائج البحث عن ',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '"$query"',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' ($resultCount)',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              if (onSortTap != null)
                OutlinedButton.icon(
                  onPressed: onSortTap,
                  icon: Icon(Icons.sort, size: 18.w),
                  label: Text(sortBy ?? 'ترتيب'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              SizedBox(width: 8.w),
              if (onFilterTap != null)
                OutlinedButton.icon(
                  onPressed: onFilterTap,
                  icon: Icon(Icons.tune, size: 18.w),
                  label: Text('فلترة'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}