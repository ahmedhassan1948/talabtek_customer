import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/shared/providers/auth_provider.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';
import 'package:talabtek_customer/shared/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('إنشاء حساب', style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                
                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        'انضم إلى طلبك',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'أنشئ حسابك لتتمتع بأفضل تجربة توصيل',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Name Field
                CustomTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  hint: 'أحمد محمد',
                  prefixIcon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.requiredField;
                    }
                    if (value.trim().length < 2) {
                      return 'الاسم يجب أن يكون حرفين على الأقل';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

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

                // Phone Field
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
                    if (value.length < 8) {
                      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                    }
                    if (!AppConstants.passwordRegex.hasMatch(value)) {
                      return AppConstants.weakPassword;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  hint: '••••••••',
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.requiredField;
                    }
                    if (value != _passwordController.text) {
                      return AppConstants.passwordsNotMatch;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'أوافق على '),
                              TextSpan(
                                text: 'شروط الخدمة',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' و '),
                              TextSpan(
                                text: 'سياسة الخصوصية',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

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

                // Register Button
                CustomButton(
                  text: 'إنشاء حساب',
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),

                SizedBox(height: 24.h),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'أو سجل بـ',
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
                      child: OutlinedButton.icon(
                        onPressed: () => _handleGoogleRegister(authProvider),
                        icon: Icon(Icons.g_mobiledata, size: 20.w),
                        label: Text('Google'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleAppleRegister(authProvider),
                        icon: Icon(Icons.apple, size: 20.w),
                        label: Text('Apple'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟ ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'تسجيل الدخول',
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على الشروط والأحكام')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.registerWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
      _phoneController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }

  Future<void> _handleGoogleRegister(AuthProvider authProvider) async {
    final success = await authProvider.signInWithGoogle();
    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }

  Future<void> _handleAppleRegister(AuthProvider authProvider) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تسجيل الدخول بـ Apple قريباً')),
    );
  }
}