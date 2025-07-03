import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Chip(
        label: Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        deleteIcon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.textPrimary,
          size: 16,
        ),
        onDeleted: onRemove,
        backgroundColor: AppTheme.accentBlue.withValues(alpha: 0.2),
        side: BorderSide(
          color: AppTheme.accentBlue,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
