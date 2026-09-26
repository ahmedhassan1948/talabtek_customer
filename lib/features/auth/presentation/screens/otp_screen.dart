import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/shared/providers/auth_provider.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart';
import 'package:talabtek_customer/core/constants/app_constants.dart';
import 'package:talabtek_customer/core/utils/app_router.dart';
import 'package:talabtek_customer/shared/widgets/custom_button.dart';
import 'package:talabtek_customer/shared/widgets/otp_input_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;
  int _remainingSeconds = 120;
  bool _canResend = false;
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    );
    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_timerController);
    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.forward(from: 0);
    _timerController.addListener(() {
      if (mounted) {
        setState(() {
          _remainingSeconds = (120 * (1 - _timerController.value)).ceil();
          if (_remainingSeconds <= 0) {
            _canResend = true;
          }
        });
      }
    });
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;
    
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOTP(widget.phoneNumber);
    
    if (success && mounted) {
      setState(() {
        _canResend = false;
        _remainingSeconds = 120;
      });
      _timerController.reset();
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رمز جديد')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final formattedPhone = widget.phoneNumber.replaceAllMapped(
      RegExp(r'(\d{2})(\d{3})(\d{3})(\d{2})'),
      (match) => '+${match[1]} ${match[2]} ${match[3]} ${match[4]}',
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('التحقق من رقم الجوال', style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                
                // Icon
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.sms_outlined,
                    size: 48.w,
                    color: theme.colorScheme.primary,
                  ),
                ),

                SizedBox(height: 24.h),

                // Title
                Text(
                  'تم إرسال رمز التحقق',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8.h),

                // Phone number
                Text(
                  'إلى الرقم $formattedPhone',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 32.h),

                // OTP Input
                OTPInputField(
                  controller: _otpController,
                  length: AppConstants.otpLength,
                  onCompleted: (code) => _verifyOTP(code),
                ),

                SizedBox(height: 24.h),

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

                // Verify Button
                CustomButton(
                  text: 'تأكيد',
                  isLoading: authProvider.isLoading,
                  onPressed: () => _verifyOTP(_otpController.text),
                ),

                SizedBox(height: 24.h),

                // Resend Timer
                Column(
                  children: [
                    if (!_canResend) ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60.w,
                            height: 60.w,
                            child: CircularProgressIndicator(
                              value: _timerAnimation.value,
                              strokeWidth: 4,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                            ),
                          ),
                          Text(
            '$_remainingSeconds ث',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'يمكنك إعادة الإرسال بعد',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: _resendOTP,
                        icon: Icon(Icons.refresh, size: 18.w),
                        label: Text('إعادة إرسال الرمز'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 32.h),

                // Change Number
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'لم تستلم الرمز؟ ',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        TextSpan(
                          text: 'تغيير رقم الجوال',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOTP(String code) async {
    if (code.length != AppConstants.otpLength) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOTP(code);

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }
}