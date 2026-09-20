import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/shared/providers/auth_provider.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';
import 'package:talabtek_customer/shared/widgets/custom_text_field.dart';
import 'package:talabtek_customer/shared/widgets/social_login_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPhoneLogin = true;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                
                // Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          size: 48.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'تسجيل الدخول إلى حسابك',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Login Method Toggle
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMethodTab(
                          'الهاتف',
                          true,
                          _isPhoneLogin,
                          () => setState(() => _isPhoneLogin = true),
                        ),
                      ),
                      Expanded(
                        child: _buildMethodTab(
                          'البريد الإلكتروني',
                          false,
                          !_isPhoneLogin,
                          () => setState(() => _isPhoneLogin = false),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Phone Number Field
                if (_isPhoneLogin) ...[
                  CustomTextField(
                    controller: _phoneController,
                    label: 'رقم الجوال',
                    hint: '05XXXXXXXX',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    prefixText: '+966 ',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.requiredField;
                      }
                      if (!AppConstants.phoneRegex.hasMatch(value)) {
                        return AppConstants.invalidPhone;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.requiredField;
                      }
                      if (!AppConstants.emailRegex.hasMatch(value)) {
                        return AppConstants.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.requiredField;
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 16.h),

                // Remember Me & Forgot Password
                if (!_isPhoneLogin) ...[
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        activeColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      Text(
                        'تذكرني',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],

                // Error Message
                if (authProvider.error != null) ...[
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Login Button
                CustomButton(
                  text: _isPhoneLogin ? 'إرسال رمز التحقق' : 'تسجيل الدخول',
                  isLoading: authProvider.isLoading,
                  onPressed: _handleLogin,
                ),

                SizedBox(height: 24.h),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'أو سجل دخول بـ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                  ],
                ),

                SizedBox(height: 24.h),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: () => _handleGoogleSignIn(authProvider),
                        isLoading: authProvider.isLoading,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SocialLoginButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        onPressed: () => _handleAppleSignIn(authProvider),
                        isLoading: authProvider.isLoading,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Guest Mode
                if (AppConstants.enableGuestMode) ...[
                  OutlinedButton.icon(
                    onPressed: () => _handleGuestLogin(authProvider),
                    icon: Icon(Icons.person_outline, size: 20.w),
                    label: Text('الدخول كزائر'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟ ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: Text(
                        'إنشاء حساب جديد',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTab(String label, bool isPhone, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    bool success = false;

    if (_isPhoneLogin) {
      success = await authProvider.sendOTP(_phoneController.text.trim());
      if (success && mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.otp,
          arguments: {'phone': _phoneController.text.trim()},
        );
      }
    } else {
      success = await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      }
    }
  }

  Future<void> _handleGoogleSignIn(AuthProvider authProvider) async {
    final success = await authProvider.signInWithGoogle();
    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }

  Future<void> _handleAppleSignIn(AuthProvider authProvider) async {
    // Implement Apple Sign In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تسجيل الدخول بـ Apple قريباً')),
    );
  }

  Future<void> _handleGuestLogin(AuthProvider authProvider) async {
    await authProvider.continueAsGuest();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }
}