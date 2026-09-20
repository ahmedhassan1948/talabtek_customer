import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talabtek_customer/features/support/presentation/widgets/support_option.dart'
import 'package:talabtek_customer/features/support/presentation/widgets/faq_section.dart'
import 'package:talabtek_customer/core/constants/app_constants.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart'

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'مركز المساعدة'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Options
            Text(
              'كيف يمكننا مساعدتك؟',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            
            SupportOption(
              icon: Icons.chat_outlined,
              title: 'شات مباشر',
              subtitle: 'تواصل مع فريق الدعم فوراً',
              color: theme.colorScheme.primary,
              onTap: () => Navigator.pushNamed(context, '/support/chat/new'),
            ),
            
            SupportOption(
              icon: Icons.phone_outlined,
              title: 'اتصل بنا',
              subtitle: AppConstants.supportPhone,
              color: theme.colorScheme.successColor,
              onTap: _callSupport,
            ),
            
            SupportOption(
              icon: Icons.email_outlined,
              title: 'بريد إلكتروني',
              subtitle: AppConstants.supportEmail,
              color: theme.colorScheme.warningColor,
              onTap: _emailSupport,
            ),
            
            SupportOption(
              icon: Icons.whatsapp_outlined,
              title: 'واتساب',
              subtitle: AppConstants.supportWhatsApp,
              color: const Color(0xFF25D366),
              onTap: _whatsappSupport,
            ),
            
            SizedBox(height: 24.h),
            Divider(color: theme.dividerColor),
            SizedBox(height: 16.h),
            
            // Quick Actions
            Text(
              'إجراءات سريعة',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.5,
              children: [
                _buildQuickAction(
                  context,
                  Icons.receipt_long_outlined,
                  'تتبع طلب',
                  theme.colorScheme.primary,
                  () => Navigator.pushNamed(context, '/orders'),
                ),
                _buildQuickAction(
                  context,
                  Icons.cancel_outlined,
                  'إلغاء طلب',
                  theme.colorScheme.error,
                  () => _showCancelOrderDialog(context),
                ),
                _buildQuickAction(
                  context,
                  Icons.money_off_outlined,
                  'استرداد مبلغ',
                  theme.colorScheme.successColor,
                  () => _showRefundDialog(context),
                ),
                _buildQuickAction(
                  context,
                  Icons.report_outlined,
                  'إبلاغ عن مشكلة',
                  theme.colorScheme.warningColor,
                  () => _showReportDialog(context),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            Divider(color: theme.dividerColor),
            SizedBox(height: 16.h),
            
            // FAQ
            FAQSection(),
            
            SizedBox(height: 24.h),
            Divider(color: theme.dividerColor),
            SizedBox(height: 16.h),
            
            // Legal Links
            Text(
              'معلومات قانونية',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            
            _buildLegalLink(context, 'سياسة الخصوصية', AppConstants.privacyPolicyUrl),
            _buildLegalLink(context, 'شروط الخدمة', AppConstants.termsOfServiceUrl),
            _buildLegalLink(context, 'الأسئلة الشائعة', AppConstants.faqUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24.w, color: color),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalLink(BuildContext context, String title, String url) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.article_outlined,
        color: theme.colorScheme.onSurfaceVariant,
        size: 24.w,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.open_in_new,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20.w,
      ),
      onTap: () => _launchUrl(url),
    );
  }

  Future<void> _callSupport() async {
    final url = 'tel:${AppConstants.supportPhone}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _emailSupport() async {
    final url = 'mailto:${AppConstants.supportEmail}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _whatsappSupport() async {
    final url = 'https://wa.me/${AppConstants.supportWhatsApp.replaceAll('+', '')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إلغاء طلب'),
        content: Text('اختر الطلب الذي تريد إلغاءه من صفحة طلباتك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('فهمت'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/orders');
            },
            child: Text('عرض طلباتي'),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('طلب استرداد'),
        content: Text('للطلبات الملغية أو التي بها مشكلة، يرجى التواصل مع الدعم عبر الشات.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/support/chat/new');
            },
            child: Text('التواصل مع الدعم'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إبلاغ عن مشكلة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.restaurant_outlined, color: Theme.of(context).colorScheme.primary),
              title: Text('مشكلة في المطعم/الطعام'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.successColor),
              title: Text('مشكلة في التوصيل/السائق'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.payment_outlined, color: Theme.of(context).colorScheme.warningColor),
              title: Text('مشكلة في الدفع'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.bug_report_outlined, color: Theme.of(context).colorScheme.error),
              title: Text('مشكلة تقنية في التطبيق'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}