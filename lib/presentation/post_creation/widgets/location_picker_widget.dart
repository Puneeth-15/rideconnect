import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationPickerWidget extends StatelessWidget {
  final String? selectedLocation;
  final Function(String?) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
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
                iconName: 'location_on',
                color: AppTheme.accentBlue,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Location',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
              ),
              GestureDetector(
                onTap: () => onLocationChanged(null),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 15.h,
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Stack(
              children: [
                // Mock map background
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentBlue.withValues(alpha: 0.1),
                        AppTheme.accentBlue.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'map',
                        color: AppTheme.accentBlue,
                        size: 8.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Map Preview',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1.h,
                  left: 2.w,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      selectedLocation ?? 'No location selected',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showLocationSearch(context),
                  icon: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.accentBlue,
                    size: 4.w,
                  ),
                  label: const Text('Search Location'),
                ),
              ),
              SizedBox(width: 2.w),
              OutlinedButton.icon(
                onPressed: () => _useCurrentLocation(),
                icon: CustomIconWidget(
                  iconName: 'my_location',
                  color: AppTheme.accentBlue,
                  size: 4.w,
                ),
                label: const Text('Current'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
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
                'Search Location',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a place...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: _buildLocationSuggestions(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLocationSuggestions(BuildContext context) {
    final suggestions = [
      "Downtown Garage District, Los Angeles, CA",
      "Pacific Coast Highway, Malibu, CA",
      "Mulholland Drive, Hollywood Hills, CA",
      "Route 66, Barstow, CA",
      "Angeles Crest Highway, La Cañada Flintridge, CA",
    ];

    return suggestions.map((location) {
      return ListTile(
        leading: CustomIconWidget(
          iconName: 'location_on',
          color: AppTheme.accentBlue,
          size: 5.w,
        ),
        title: Text(
          location,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        onTap: () {
          onLocationChanged(location);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  void _useCurrentLocation() {
    onLocationChanged("Current Location - Los Angeles, CA");
  }
}
