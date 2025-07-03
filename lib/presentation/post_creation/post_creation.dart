import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/hashtag_input_widget.dart';
import './widgets/location_picker_widget.dart';
import './widgets/photo_selection_widget.dart';
import './widgets/vehicle_tag_widget.dart';

class PostCreation extends StatefulWidget {
  const PostCreation({super.key});

  @override
  State<PostCreation> createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _isPublic = true;
  String _postText = '';
  List<String> _selectedPhotos = [];
  String? _selectedLocation;
  String? _selectedVehicle;
  List<String> _selectedHashtags = [];
  bool _isLoading = false;

  final int _maxCharacters = 500;

  // Mock user data
  final Map<String, dynamic> _currentUser = {
    "id": 1,
    "name": "Alex Rodriguez",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "vehicleType": "Motorcycle",
    "vehicles": [
      {"id": 1, "name": "Yamaha R1", "type": "Sport Bike"},
      {"id": 2, "name": "Honda CBR600", "type": "Sport Bike"},
    ]
  };

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _postText = _textController.text;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  bool get _canShare =>
      _postText.trim().isNotEmpty || _selectedPhotos.isNotEmpty;

  Future<void> _handleShare() async {
    if (!_canShare || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/home-feed');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Post shared successfully!',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_postText.trim().isNotEmpty || _selectedPhotos.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Discard Post?',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard this post?',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.primaryDark,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserSection(),
                      SizedBox(height: 3.h),
                      _buildTextInput(),
                      SizedBox(height: 3.h),
                      _buildActionOptions(),
                      if (_selectedPhotos.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        PhotoSelectionWidget(
                          selectedPhotos: _selectedPhotos,
                          onPhotosChanged: (photos) {
                            setState(() {
                              _selectedPhotos = photos;
                            });
                          },
                        ),
                      ],
                      if (_selectedLocation != null) ...[
                        SizedBox(height: 2.h),
                        LocationPickerWidget(
                          selectedLocation: _selectedLocation,
                          onLocationChanged: (location) {
                            setState(() {
                              _selectedLocation = location;
                            });
                          },
                        ),
                      ],
                      if (_selectedVehicle != null) ...[
                        SizedBox(height: 2.h),
                        VehicleTagWidget(
                          selectedVehicle: _selectedVehicle,
                          vehicles: (_currentUser["vehicles"] as List)
                              .cast<Map<String, dynamic>>(),
                          onVehicleChanged: (vehicle) {
                            setState(() {
                              _selectedVehicle = vehicle;
                            });
                          },
                        ),
                      ],
                      if (_selectedHashtags.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        HashtagInputWidget(
                          selectedHashtags: _selectedHashtags,
                          onHashtagsChanged: (hashtags) {
                            setState(() {
                              _selectedHashtags = hashtags;
                            });
                          },
                        ),
                      ],
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: TextButton(
        onPressed: () async {
          final canPop = await _onWillPop();
          if (canPop && mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Text(
          'Cancel',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ),
      title: Text(
        'New Post',
        style: AppTheme.darkTheme.textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: ElevatedButton(
            onPressed: _canShare && !_isLoading ? _handleShare : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canShare ? AppTheme.accentRed : AppTheme.surfaceColor,
              foregroundColor: AppTheme.textPrimary,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                    ),
                  )
                : Text(
                    'Share',
                    style: AppTheme.darkTheme.textTheme.labelLarge,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
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
                  imageUrl: _currentUser["avatar"] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(0.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryDark,
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: _currentUser["vehicleType"] == "Motorcycle"
                      ? 'motorcycle'
                      : 'directions_car',
                  color: AppTheme.textPrimary,
                  size: 3.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentUser["name"] as String,
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 0.5.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPublic = !_isPublic;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _isPublic ? 'public' : 'group',
                        color: AppTheme.accentBlue,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _isPublic ? 'Public' : 'Followers',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentBlue,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.accentBlue,
                        size: 4.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: 20.h,
            maxHeight: 40.h,
          ),
          child: TextField(
            controller: _textController,
            focusNode: _textFocusNode,
            maxLines: null,
            maxLength: _maxCharacters,
            style: AppTheme.darkTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Share your ride...',
              hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              '${_postText.length}/$_maxCharacters',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: _postText.length > _maxCharacters * 0.9
                    ? AppTheme.warningColor
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            icon: 'photo_camera',
            label: 'Add Photos',
            onTap: () => _showPhotoOptions(),
          ),
          SizedBox(width: 3.w),
          _buildActionButton(
            icon: 'location_on',
            label: 'Add Location',
            onTap: () => _showLocationPicker(),
          ),
          SizedBox(width: 3.w),
          _buildActionButton(
            icon: 'directions_car',
            label: 'Tag Vehicle',
            onTap: () => _showVehiclePicker(),
          ),
          SizedBox(width: 3.w),
          _buildActionButton(
            icon: 'tag',
            label: 'Add Hashtags',
            onTap: () => _showHashtagInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.accentBlue,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
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
              'Add Photos',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoOption(
                    icon: 'photo_camera',
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _addMockPhoto('camera');
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildPhotoOption(
                    icon: 'photo_library',
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _addMockPhoto('gallery');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.accentBlue,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _addMockPhoto(String source) {
    final mockPhotos = [
      "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=300&fit=crop",
    ];

    setState(() {
      if (_selectedPhotos.length < 5) {
        _selectedPhotos
            .add(mockPhotos[_selectedPhotos.length % mockPhotos.length]);
      }
    });
  }

  void _showLocationPicker() {
    setState(() {
      _selectedLocation = "Downtown Garage District, Los Angeles, CA";
    });
  }

  void _showVehiclePicker() {
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
            ...(_currentUser["vehicles"] as List).map((vehicle) {
              final vehicleMap = vehicle as Map<String, dynamic>;
              return ListTile(
                leading: CustomIconWidget(
                  iconName: 'motorcycle',
                  color: AppTheme.accentBlue,
                  size: 6.w,
                ),
                title: Text(
                  vehicleMap["name"] as String,
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  vehicleMap["type"] as String,
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                onTap: () {
                  setState(() {
                    _selectedVehicle = vehicleMap["name"] as String;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showHashtagInput() {
    setState(() {
      _selectedHashtags.addAll(['#motorcycle', '#roadtrip']);
    });
  }
}
