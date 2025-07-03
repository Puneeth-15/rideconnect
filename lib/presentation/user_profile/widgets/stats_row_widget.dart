import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatsRowWidget extends StatelessWidget {
  final int followers;
  final int following;
  final int totalRides;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onRidesTap;

  const StatsRowWidget({
    super.key,
    required this.followers,
    required this.following,
    required this.totalRides,
    this.onFollowersTap,
    this.onFollowingTap,
    this.onRidesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.surfaceColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              title: 'Followers',
              value: _formatNumber(followers),
              onTap: onFollowersTap,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStatItem(
              title: 'Following',
              value: _formatNumber(following),
              onTap: onFollowingTap,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStatItem(
              title: 'Rides',
              value: _formatNumber(totalRides),
              onTap: onRidesTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.accentBlue,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 6.h,
      width: 1,
      color: AppTheme.surfaceColor.withValues(alpha: 0.5),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
