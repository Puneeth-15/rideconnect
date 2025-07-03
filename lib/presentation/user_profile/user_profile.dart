import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_section_widget.dart';
import './widgets/posted_content_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/recent_trips_widget.dart';
import './widgets/saved_products_widget.dart';
import './widgets/stats_row_widget.dart';
import './widgets/vehicle_garage_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isCurrentUser = true;
  bool _isFollowing = false;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Alex Rodriguez",
    "username": "@alexrider",
    "location": "Los Angeles, CA",
    "memberSince": "March 2022",
    "profileImage":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
    "bio": "Motorcycle enthusiast | Weekend warrior | Custom bike builder",
    "followers": 1247,
    "following": 892,
    "totalRides": 156,
    "isVerified": true,
    "vehicles": [
      {
        "id": 1,
        "make": "Harley Davidson",
        "model": "Street Glide",
        "year": 2023,
        "image":
            "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=400",
        "type": "motorcycle"
      },
      {
        "id": 2,
        "make": "BMW",
        "model": "R1250GS",
        "year": 2022,
        "image":
            "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=400",
        "type": "motorcycle"
      }
    ],
    "recentTrips": [
      {
        "id": 1,
        "title": "Pacific Coast Highway",
        "distance": "245 miles",
        "duration": "6h 30m",
        "date": "2024-01-15",
        "mapPreview":
            "https://images.pixabay.com/photos/2016/12/30/10/03/map-1940220_1280.jpg",
        "rating": 4.8
      },
      {
        "id": 2,
        "title": "Mountain Loop Adventure",
        "distance": "180 miles",
        "duration": "4h 45m",
        "date": "2024-01-08",
        "mapPreview":
            "https://images.pixabay.com/photos/2016/12/30/10/03/map-1940220_1280.jpg",
        "rating": 4.9
      }
    ],
    "savedProducts": [
      {
        "id": 1,
        "name": "Custom Exhaust System",
        "price": "\$899",
        "image":
            "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&auto=format&fit=crop&q=60",
        "seller": "Performance Parts Co."
      },
      {
        "id": 2,
        "name": "LED Headlight Kit",
        "price": "\$299",
        "image":
            "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&auto=format&fit=crop&q=60",
        "seller": "Bright Lights Inc."
      }
    ],
    "postedContent": [
      {
        "id": 1,
        "type": "trip",
        "content":
            "Just completed an amazing ride through the mountains! The weather was perfect and the views were incredible.",
        "image":
            "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=400",
        "likes": 89,
        "comments": 12,
        "timestamp": "2024-01-15T10:30:00Z"
      },
      {
        "id": 2,
        "type": "photo",
        "content": "New modifications on my Street Glide. What do you think?",
        "image":
            "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=400",
        "likes": 156,
        "comments": 23,
        "timestamp": "2024-01-12T14:20:00Z"
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.accentBlue,
        backgroundColor: AppTheme.secondaryDark,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(
                userData: userData,
                isCurrentUser: _isCurrentUser,
                isFollowing: _isFollowing,
                onFollowTap: _handleFollowTap,
                onMessageTap: _handleMessageTap,
                onEditProfileTap: _handleEditProfileTap,
              ),
              SizedBox(height: 2.h),
              StatsRowWidget(
                followers: userData["followers"] as int,
                following: userData["following"] as int,
                totalRides: userData["totalRides"] as int,
                onFollowersTap: _handleFollowersTap,
                onFollowingTap: _handleFollowingTap,
                onRidesTap: _handleRidesTap,
              ),
              SizedBox(height: 3.h),
              VehicleGarageWidget(
                vehicles:
                    (userData["vehicles"] as List).cast<Map<String, dynamic>>(),
                onVehicleTap: _handleVehicleTap,
                onViewAllTap: _handleViewAllVehicles,
              ),
              SizedBox(height: 3.h),
              ActivitySectionWidget(
                title: "Recent Trips",
                onViewAllTap: _handleViewAllTrips,
                child: RecentTripsWidget(
                  trips: (userData["recentTrips"] as List)
                      .cast<Map<String, dynamic>>(),
                  onTripTap: _handleTripTap,
                ),
              ),
              SizedBox(height: 3.h),
              ActivitySectionWidget(
                title: "Saved Products",
                onViewAllTap: _handleViewAllSavedProducts,
                child: SavedProductsWidget(
                  products: (userData["savedProducts"] as List)
                      .cast<Map<String, dynamic>>(),
                  onProductTap: _handleProductTap,
                ),
              ),
              SizedBox(height: 3.h),
              ActivitySectionWidget(
                title: "Posted Content",
                onViewAllTap: _handleViewAllPosts,
                child: PostedContentWidget(
                  posts: (userData["postedContent"] as List)
                      .cast<Map<String, dynamic>>(),
                  onPostTap: _handlePostTap,
                ),
              ),
              SizedBox(height: 4.h),
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
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Text(
        _isCurrentUser ? 'My Profile' : userData["name"] as String,
        style: AppTheme.darkTheme.textTheme.titleLarge,
      ),
      actions: [
        if (_isCurrentUser)
          IconButton(
            onPressed: _handleSettingsTap,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        if (!_isCurrentUser)
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.textPrimary,
              size: 24,
            ),
            color: AppTheme.secondaryDark,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'report',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Report User',
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'block',
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Block User',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _handleFollowTap() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        userData["followers"] = (userData["followers"] as int) + 1;
      } else {
        userData["followers"] = (userData["followers"] as int) - 1;
      }
    });
  }

  void _handleMessageTap() {
    // Navigate to messaging screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${userData["name"]}'),
        backgroundColor: AppTheme.secondaryDark,
      ),
    );
  }

  void _handleEditProfileTap() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening profile editor'),
        backgroundColor: AppTheme.secondaryDark,
      ),
    );
  }

  void _handleSettingsTap() {
    // Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening settings'),
        backgroundColor: AppTheme.secondaryDark,
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'report':
        _showReportDialog();
        break;
      case 'block':
        _showBlockDialog();
        break;
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Text(
          'Report User',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to report this user?',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User reported')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Text(
          'Block User',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to block this user? You will no longer see their content.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _handleFollowersTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening followers list')),
    );
  }

  void _handleFollowingTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening following list')),
    );
  }

  void _handleRidesTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening rides history')),
    );
  }

  void _handleVehicleTap(Map<String, dynamic> vehicle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${vehicle["make"]} ${vehicle["model"]}')),
    );
  }

  void _handleViewAllVehicles() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening vehicle garage')),
    );
  }

  void _handleViewAllTrips() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening trip history')),
    );
  }

  void _handleTripTap(Map<String, dynamic> trip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening trip: ${trip["title"]}')),
    );
  }

  void _handleViewAllSavedProducts() {
    Navigator.pushNamed(context, '/marketplace');
  }

  void _handleProductTap(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening product: ${product["name"]}')),
    );
  }

  void _handleViewAllPosts() {
    Navigator.pushNamed(context, '/home-feed');
  }

  void _handlePostTap(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening post: ${post["content"]}')),
    );
  }
}
