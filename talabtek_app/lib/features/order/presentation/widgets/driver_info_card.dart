import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart'
import 'package:talabtek_customer/shared/widgets/cached_image.dart'

class DriverInfoCard extends StatelessWidget {
  final String driverName;
  final String driverPhone;
  final String vehicleType;
  final String vehiclePlate;
  final double rating;
  final String? driverPhoto;
  final VoidCallback onCall;
  final VoidCallback onChat;

  const DriverInfoCard({
    super.key,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.rating,
    this.driverPhoto,
    required this.onCall,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'معلومات السائق',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Driver Profile
          Row(
            children: [
              UserAvatar(
                imageUrl: driverPhoto,
                name: driverName,
                radius: 30,
                showBorder: true,
                borderColor: theme.colorScheme.primary,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.w, color: Colors.amber),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'متصل',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildActionButton(context, Icons.call, 'اتصال', theme.colorScheme.successColor, onCall),
                  SizedBox(height: 8.h),
                  _buildActionButton(context, Icons.chat_outlined, 'شات', theme.colorScheme.primary, onChat),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          Divider(color: theme.dividerColor),
          SizedBox(height: 12.h),
          
          // Vehicle Info
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.directions_car_outlined,
                  'المركبة',
                  vehicleType,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.confirmation_number_outlined,
                  'اللوحة',
                  vehiclePlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.w, color: color),
            SizedBox(width: 6.w),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.w, color: theme.colorScheme.onSurfaceVariant),
            SizedBox(width: 4.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}