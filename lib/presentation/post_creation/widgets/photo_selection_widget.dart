import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoSelectionWidget extends StatelessWidget {
  final List<String> selectedPhotos;
  final Function(List<String>) onPhotosChanged;

  const PhotoSelectionWidget({
    super.key,
    required this.selectedPhotos,
    required this.onPhotosChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'photo_library',
              color: AppTheme.accentBlue,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Photos (${selectedPhotos.length}/5)',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedPhotos.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              return _buildPhotoItem(selectedPhotos[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(String photoUrl, int index) {
    return Stack(
      children: [
        Container(
          width: 30.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accentBlue.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: photoUrl,
              width: 30.w,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 1.h,
          right: 1.w,
          child: GestureDetector(
            onTap: () {
              final updatedPhotos = List<String>.from(selectedPhotos);
              updatedPhotos.removeAt(index);
              onPhotosChanged(updatedPhotos);
            },
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textPrimary,
                size: 4.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
