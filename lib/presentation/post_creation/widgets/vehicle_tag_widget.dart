import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleTagWidget extends StatelessWidget {
  final String? selectedVehicle;
  final List<Map<String, dynamic>> vehicles;
  final Function(String?) onVehicleChanged;

  const VehicleTagWidget({
    super.key,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onVehicleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'directions_car',
                color: AppTheme.accentBlue,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Tagged Vehicle',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
              ),
              GestureDetector(
                onTap: () => onVehicleChanged(null),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (selectedVehicle != null) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'motorcycle',
                      color: AppTheme.textPrimary,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedVehicle!,
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.accentBlue,
                          ),
                        ),
                        Text(
                          _getVehicleType(selectedVehicle!),
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentBlue.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          OutlinedButton.icon(
            onPressed: () => _showVehicleSelector(context),
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.accentBlue,
              size: 4.w,
            ),
            label: Text(
                selectedVehicle != null ? 'Change Vehicle' : 'Select Vehicle'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
          ),
        ],
      ),
    );
  }

  String _getVehicleType(String vehicleName) {
    final vehicle = vehicles.firstWhere(
      (v) => v["name"] == vehicleName,
      orElse: () => {"type": "Unknown"},
    );
    return vehicle["type"] as String;
  }

  void _showVehicleSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Vehicle',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ...vehicles.map((vehicle) {
              final isSelected = selectedVehicle == vehicle["name"];
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentBlue
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'motorcycle',
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.accentBlue,
                      size: 6.w,
                    ),
                  ),
                  title: Text(
                    vehicle["name"] as String,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.accentBlue
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    vehicle["type"] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.accentBlue.withValues(alpha: 0.8)
                          : AppTheme.textSecondary,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.accentBlue,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    onVehicleChanged(vehicle["name"] as String);
                    Navigator.pop(context);
                  },
                  tileColor: isSelected
                      ? AppTheme.accentBlue.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.accentBlue.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
