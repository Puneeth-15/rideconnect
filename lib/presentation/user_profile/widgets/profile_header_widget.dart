import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isCurrentUser;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onEditProfileTap;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.isCurrentUser,
    required this.isFollowing,
    this.onFollowTap,
    this.onMessageTap,
    this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.w),
          bottomRight: Radius.circular(4.w),
        ),
      ),
      child: Column(
        children: [
          _buildProfileImageSection(),
          SizedBox(height: 2.h),
          _buildUserInfoSection(),
          SizedBox(height: 2.h),
          _buildBioSection(),
          SizedBox(height: 3.h),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Stack(
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.accentBlue,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: userData["profileImage"] as String,
              width: 25.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (userData["isVerified"] == true)
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
                  color: AppTheme.secondaryDark,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.textPrimary,
                size: 3.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      children: [
        Text(
          userData["name"] as String,
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          userData["username"] as String,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.textSecondary,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              userData["location"] as String,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Member since ${userData["memberSince"]}',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    if (userData["bio"] == null || (userData["bio"] as String).isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        userData["bio"] as String,
        style: AppTheme.darkTheme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons() {
    if (isCurrentUser) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onEditProfileTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentRed,
            foregroundColor: AppTheme.textPrimary,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.textPrimary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Edit Profile',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onFollowTap,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFollowing ? AppTheme.surfaceColor : AppTheme.accentBlue,
              foregroundColor: AppTheme.textPrimary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onMessageTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentBlue,
              side: const BorderSide(color: AppTheme.accentBlue),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.accentBlue,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Message',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.accentBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
