import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/core/utils/app_router.dart'

class ProfileMenu extends StatelessWidget {
  final UserModel user;

  const ProfileMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGuest = user.isGuest;

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor, width: 1),
          ),
          child: Column(
            children: [
              if (!isGuest) ...[
                _buildMenuItem(
                  context,
                  Icons.person_outline,
                  'ملفي الشخصي',
                  'تعديل الاسم، الصورة، وكلمة المرور',
                  onTap: () => Navigator.pushNamed(context, '/profile/edit'),
                ),
                _buildDivider(theme),
                _buildMenuItem(
                  context,
                  Icons.location_on_outlined,
                  'عناويني المحفوظة',
                  'إدارة عناوين المنزل والعمل',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.addresses),
                  badge: '3',
                ),
                _buildDivider(theme),
                _buildMenuItem(
                  context,
                  Icons.payment_outlined,
                  'طرق الدفع',
                  'بطاقات محفوظة، محفظة إلكترونية',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethods),
                  badge: '2',
                ),
                _buildDivider(theme),
                _buildMenuItem(
                  context,
                  Icons.account_balance_wallet_outlined,
                  'المحفظة الإلكترونية',
                  'الرصيد: 0.00 ر.س',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
                ),
              ],
              _buildDivider(theme),
              _buildMenuItem(
                context,
                Icons.receipt_long_outlined,
                'طلباتي',
                'تاريخ الطلبات والتتبع',
                onTap: () => Navigator.pushNamed(context, AppRoutes.orderHistory),
              ),
              _buildDivider(theme),
              _buildMenuItem(
                context,
                Icons.favorite_outline,
                'المفضلة',
                'مطاعم ومنتجات محفوظة',
                onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
              ),
              _buildDivider(theme),
              _buildMenuItem(
                context,
                Icons.notifications_outlined,
                'الإشعارات',
                'إدارة تفضيلات الإشعارات',
                onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              _buildDivider(theme),
              _buildMenuItem(
                context,
                Icons.support_agent_outlined,
                'مركز المساعدة',
                'الشات، الأسئلة الشائعة، اتصل بنا',
                onTap: () => Navigator.pushNamed(context, AppRoutes.support),
              ),
              _buildDivider(theme),
              _buildMenuItem(
                context,
                Icons.settings_outlined,
                'الإعدادات',
                'اللغة، الوضع الداكن، الخصوصية',
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
              if (!isGuest) ...[
                _buildDivider(theme),
                _buildMenuItem(
                  context,
                  Icons.logout_outlined,
                  'تسجيل الخروج',
                  'الخروج من الحساب',
                  textColor: theme.colorScheme.error,
                  iconColor: theme.colorScheme.error,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22.w,
                color: iconColor ?? theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      color: theme.dividerColor,
      indent: 56.w,
      endIndent: 16.w,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text('تسجيل الخروج', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}