import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height = 52,
    this.borderRadius = 12,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  factory SocialLoginButton.google({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      icon: Image.asset(
        'assets/icons/google.png',
        width: 20.w,
        height: 20.w,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.g_mobiledata,
          size: 20.w,
          color: Colors.red,
        ),
      ),
      label: 'Google',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory SocialLoginButton.apple({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      icon: Icon(Icons.apple, size: 20.w, color: Colors.black),
      label: 'Apple',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
  }

  factory SocialLoginButton.facebook({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      icon: Icon(Icons.facebook, size: 20.w, color: Color(0xFF1877F2)),
      label: 'Facebook',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory SocialLoginButton.twitter({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      icon: Icon(Icons.alternate_email, size: 20.w, color: Color(0xFF1DA1F2)),
      label: 'Twitter',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final fgColor = foregroundColor ?? theme.colorScheme.onSurface;
    final bdColor = borderColor ?? theme.colorScheme.outline;

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          side: BorderSide(color: bdColor, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          textStyle: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            fontFamily: 'Tajawal',
          ),
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
                  icon,
                  SizedBox(width: 10.w),
                  Text(label),
                ],
              ),
      ),
    );
  }
}

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SocialLoginButton.google(
                onPressed: onGooglePressed,
                isLoading: isLoading,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SocialLoginButton.apple(
                onPressed: onApplePressed,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
        if (onFacebookPressed != null) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: SocialLoginButton.facebook(
              onPressed: onFacebookPressed,
              isLoading: isLoading,
            ),
          ),
        ],
      ],
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  const AuthDivider({
    super.key,
    this.text = 'أو',
    this.color,
    this.thickness = 1,
    this.indent = 16,
    this.endIndent = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.dividerColor;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
            indent: indent,
            endIndent: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
            indent: 0,
            endIndent: endIndent,
          ),
        ),
      ],
    );
  }
}