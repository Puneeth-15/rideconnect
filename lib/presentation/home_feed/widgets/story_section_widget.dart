import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StorySectionWidget extends StatelessWidget {
  const StorySectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stories = [
      {
        "id": 1,
        "user": "Your Story",
        "avatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=150",
        "hasStory": false,
        "isOwn": true,
      },
      {
        "id": 2,
        "user": "Alex",
        "avatar":
            "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=150",
        "hasStory": true,
        "isOwn": false,
      },
      {
        "id": 3,
        "user": "Sarah",
        "avatar":
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=150",
        "hasStory": true,
        "isOwn": false,
      },
      {
        "id": 4,
        "user": "Mike",
        "avatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=150",
        "hasStory": true,
        "isOwn": false,
      },
      {
        "id": 5,
        "user": "Emma",
        "avatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=150",
        "hasStory": true,
        "isOwn": false,
      },
    ];

    return Container(
      height: 25.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Stories',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return _buildStoryItem(story);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(Map<String, dynamic> story) {
    return Container(
      margin: EdgeInsets.only(right: 3.w),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: story['hasStory'] && !story['isOwn']
                      ? LinearGradient(
                          colors: [
                            AppTheme.accentRed,
                            AppTheme.accentBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  border: story['isOwn']
                      ? Border.all(
                          color: AppTheme.textSecondary,
                          width: 2,
                        )
                      : null,
                ),
                padding: EdgeInsets.all(
                    story['hasStory'] && !story['isOwn'] ? 2 : 0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.secondaryDark,
                  ),
                  padding: EdgeInsets.all(
                      story['hasStory'] && !story['isOwn'] ? 2 : 0),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: story['avatar'],
                      width: 18.w,
                      height: 18.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (story['isOwn'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryDark,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.textPrimary,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: 18.w,
            child: Text(
              story['user'],
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
