import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/shared/models/user_model.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/shared/widgets/cached_image.dart'

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(
                imageUrl: user.photoUrl,
                name: user.name,
                radius: 40,
                showBorder: true,
                borderColor: Colors.white,
                borderWidth: 3,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (user.email.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.verified_user, size: 14.w, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text(
                          user.isVerified ? 'حساب موثق' : 'غير موثق',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Stats
          Row(
            children: [
              _buildStat(theme, '12', 'طلبات'),
              _buildDivider(theme),
              _buildStat(theme, '4.8', 'تقييم'),
              _buildDivider(theme),
              _buildStat(theme, '150', 'نقاط'),
              _buildDivider(theme),
              _buildStat(theme, '8', 'مفضلة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(ThemeData theme, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 40.h,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }
}