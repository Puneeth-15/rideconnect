import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivitySectionWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onViewAllTap;
  final String? subtitle;
  final IconData? icon;

  const ActivitySectionWidget({
    super.key,
    required this.title,
    required this.child,
    this.onViewAllTap,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      CustomIconWidget(
                        iconName: _getIconName(),
                        color: AppTheme.accentBlue,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle!,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (onViewAllTap != null)
            TextButton(
              onPressed: onViewAllTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.accentBlue,
                    size: 3.w,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getIconName() {
    switch (title.toLowerCase()) {
      case 'recent trips':
        return 'route';
      case 'saved products':
        return 'bookmark';
      case 'posted content':
        return 'post_add';
      default:
        return 'folder';
    }
  }
}
