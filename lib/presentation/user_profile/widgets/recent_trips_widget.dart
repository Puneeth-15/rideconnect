import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTripsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  final Function(Map<String, dynamic>)? onTripTap;

  const RecentTripsWidget({
    super.key,
    required this.trips,
    this.onTripTap,
  });

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return _buildTripCard(trip);
        },
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.surfaceColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => onTripTap?.call(trip),
        borderRadius: BorderRadius.circular(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(3.w),
                    ),
                    child: CustomImageWidget(
                      imageUrl: trip["mapPreview"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.warningColor,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            trip["rating"].toString(),
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip["title"] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTripStat(
                            icon: 'straighten',
                            value: trip["distance"] as String,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildTripStat(
                            icon: 'schedule',
                            value: trip["duration"] as String,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _formatDate(trip["date"] as String),
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripStat({required String icon, required String value}) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.accentBlue,
          size: 3.w,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            value,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 25.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.surfaceColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'route',
              color: AppTheme.textSecondary,
              size: 8.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No trips recorded yet',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start your first ride!',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.accentBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
