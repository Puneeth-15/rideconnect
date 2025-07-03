import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onUserTap;

  const PostCardWidget({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerDark,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          _buildPostContent(),
          if (post['images'] != null && (post['images'] as List).isNotEmpty)
            _buildPostImages(),
          _buildPostActions(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: onUserTap,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentBlue,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: post['user']['avatar'],
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onUserTap,
                      child: Text(
                        post['user']['name'],
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (post['user']['isVerified'] == true) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.accentBlue,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      post['user']['vehicle'],
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 1.w,
                      height: 1.w,
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      post['timestamp'],
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showPostOptions(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHashtagText(post['content']),
          if (post['tripData'] != null) ...[
            SizedBox(height: 2.h),
            _buildTripData(),
          ],
        ],
      ),
    );
  }

  Widget _buildHashtagText(String text) {
    final words = text.split(' ');
    final spans = <TextSpan>[];

    for (final word in words) {
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.accentBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildTripData() {
    final tripData = post['tripData'] as Map<String, dynamic>;
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'route',
            color: AppTheme.accentBlue,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Route: ${tripData['route']}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '${tripData['distance']} • ${tripData['duration']}',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages() {
    final images = post['images'] as List;
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      height: 50.h,
      child: images.length == 1
          ? _buildSingleImage(images[0])
          : _buildMultipleImages(images),
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: imageUrl,
          width: double.infinity,
          height: 50.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMultipleImages(List images) {
    return Container(
      height: 50.h,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: images[index],
                width: double.infinity,
                height: 50.h,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              _buildActionButton(
                icon: post['isLiked'] ? 'favorite' : 'favorite_border',
                color: post['isLiked']
                    ? AppTheme.accentRed
                    : AppTheme.textSecondary,
                count: post['likes'],
                onTap: onLike,
              ),
              SizedBox(width: 6.w),
              _buildActionButton(
                icon: 'chat_bubble_outline',
                color: AppTheme.textSecondary,
                count: post['comments'],
                onTap: onComment,
              ),
              SizedBox(width: 6.w),
              _buildActionButton(
                icon: 'share',
                color: AppTheme.textSecondary,
                count: post['shares'],
                onTap: onShare,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle save post
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'bookmark_border',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
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
      ),
    );
  }

  void _showPostOptions() {
    // Handle post options menu
  }
}
