import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostedContentWidget extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final Function(Map<String, dynamic>)? onPostTap;

  const PostedContentWidget({
    super.key,
    required this.posts,
    this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 28.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      width: 75.w,
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
        onTap: () => onPostTap?.call(post),
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
                      imageUrl: post["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2.w,
                    left: 2.w,
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
                            iconName: _getPostTypeIcon(post["type"] as String),
                            color: AppTheme.accentBlue,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _getPostTypeLabel(post["type"] as String),
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
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
                      post["content"] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildEngagementStat(
                          icon: 'favorite',
                          count: post["likes"] as int,
                          color: AppTheme.accentRed,
                        ),
                        SizedBox(width: 4.w),
                        _buildEngagementStat(
                          icon: 'comment',
                          count: post["comments"] as int,
                          color: AppTheme.accentBlue,
                        ),
                        const Spacer(),
                        Text(
                          _formatTimestamp(post["timestamp"] as String),
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
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

  Widget _buildEngagementStat({
    required String icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          count.toString(),
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 28.h,
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
              iconName: 'post_add',
              color: AppTheme.textSecondary,
              size: 8.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No posts yet',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Share your first ride!',
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

  String _getPostTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'trip':
        return 'route';
      case 'photo':
        return 'photo_camera';
      case 'video':
        return 'videocam';
      default:
        return 'post_add';
    }
  }

  String _getPostTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'trip':
        return 'Trip';
      case 'photo':
        return 'Photo';
      case 'video':
        return 'Video';
      default:
        return 'Post';
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
