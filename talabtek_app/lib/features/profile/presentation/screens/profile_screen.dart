import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:talabtek_customer/features/profile/presentation/widgets/profile_header.dart'
import 'package:talabtek_customer/features/profile/presentation/widgets/profile_menu.dart'
import 'package:talabtek_customer/features/profile/presentation/widgets/loyalty_card.dart'
import 'package:talabtek_customer/shared/providers/auth_provider.dart'
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/core/utils/app_router.dart'
import 'package:talabtek_customer/shared/widgets/custom_app_bar.dart'

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'الملف الشخصي',
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 24.w),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: user == null
          ? _buildGuestView()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ProfileHeader(user: user!),
                      LoyaltyCard(user: user!),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: ProfileMenu(user: user!),
                ),
              ],
            ),
    );
  }

  Widget _buildGuestView() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 48.w,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'أنت في وضع الزائر',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'سجل دخولك للاستمتاع بجميع الميزات\nحفظ العناوين، تتبع الطلبات، والمزيد',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: Text('تسجيل الدخول'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                    child: Text('إنشاء حساب'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}