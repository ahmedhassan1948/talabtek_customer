import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isTextButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget? loadingWidget;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextButton = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.width,
    this.height = 52,
    this.borderRadius = 12,
    this.padding,
    this.icon,
    this.loadingWidget,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;
    final bdColor = borderColor ?? theme.colorScheme.primary;

    if (isTextButton) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: fgColor,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          minimumSize: Size(width ?? double.infinity, height),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          textStyle: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight, fontFamily: 'Tajawal'),
        ),
        child: _buildContent(theme),
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: bdColor,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          side: BorderSide(color: bdColor, width: 1.5),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          minimumSize: Size(width ?? double.infinity, height),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          textStyle: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight, fontFamily: 'Tajawal'),
        ),
        child: _buildContent(theme),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        disabledBackgroundColor: theme.colorScheme.outline,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        minimumSize: Size(width ?? double.infinity, height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        elevation: 0,
        shadowColor: theme.shadowColor,
        textStyle: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight, fontFamily: 'Tajawal'),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return bgColor.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
      ),
      child: _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return loadingWidget ?? SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(width: 8.w),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color> gradientColors;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradientColors = const [AppTheme.gradientStart, AppTheme.gradientEnd],
    this.height = 52,
    this.borderRadius = 12,
    this.icon,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
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
                          color: theme.colorScheme.onPrimary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool isLoading;
  final String? tooltip;

  const IconButtonWidget({
    super.key,
    this.onPressed,
    required this.icon,
    this.size = 44,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius = 12,
    this.isLoading = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fgColor = foregroundColor ?? theme.colorScheme.onSurface;
    final bdColor = borderColor ?? theme.colorScheme.outline;

    Widget button = Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: bdColor != null ? Border.all(color: bdColor, width: 1) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                    ),
                  )
                : IconTheme(
                    data: IconThemeData(color: fgColor, size: 22.w),
                    child: icon,
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}