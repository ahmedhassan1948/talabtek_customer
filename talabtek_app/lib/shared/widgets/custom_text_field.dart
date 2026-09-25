import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.fillColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            prefixText: prefixText,
            prefixStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 22.w,
                      ),
                      child: prefixIcon!,
                    ),
                  )
                : null,
            prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.w),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 22.w,
                      ),
                      child: suffixIcon!,
                    ),
                  )
                : null,
            suffixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.w),
            filled: true,
            fillColor: fillColor ?? theme.colorScheme.surfaceContainerHighest,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final Color? backgroundColor;

  const SearchTextField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.autofocus = false,
    this.showFilter = false,
    this.onFilterTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
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
          hintText: hint ?? 'ابحث عن مطاعم، أطباق، أو منتجات...',
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const PasswordTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
    );
  }
}