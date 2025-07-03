import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/post_card_widget.dart';
import './widgets/story_section_widget.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicator = RefreshIndicator(
    onRefresh: () async {
      await Future.delayed(const Duration(seconds: 2));
    },
    child: Container(),
  );
  bool _isLoading = false;
  int _currentIndex = 0;

  // Mock data for posts
  final List<Map<String, dynamic>> _posts = [
    {
      "id": 1,
      "user": {
        "name": "Alex Rodriguez",
        "avatar":
            "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=150",
        "vehicle": "Yamaha R1",
        "isVerified": true
      },
      "timestamp": "2 hours ago",
      "content":
          "Just completed an epic 500km ride through the mountains! The weather was perfect and the roads were amazing. #bikelife #mountainride #yamaha",
      "images": [
        "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=600",
        "https://images.pexels.com/photos/1119796/pexels-photo-1119796.jpeg?auto=compress&cs=tinysrgb&w=600"
      ],
      "likes": 124,
      "comments": 23,
      "shares": 8,
      "isLiked": false,
      "type": "photo"
    },
    {
      "id": 2,
      "user": {
        "name": "Sarah Chen",
        "avatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=150",
        "vehicle": "BMW M3",
        "isVerified": false
      },
      "timestamp": "4 hours ago",
      "content":
          "Track day at Silverstone! My M3 performed flawlessly. New personal best lap time! 🏁 #trackday #bmw #silverstone #racing",
      "images": [
        "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=600"
      ],
      "likes": 89,
      "comments": 15,
      "shares": 5,
      "isLiked": true,
      "type": "photo"
    },
    {
      "id": 3,
      "user": {
        "name": "Mike Johnson",
        "avatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=150",
        "vehicle": "Harley Davidson",
        "isVerified": true
      },
      "timestamp": "6 hours ago",
      "content":
          "Planning a group ride this weekend. Route: City → Coast → Mountains. Who's in? Drop a comment if interested! #groupride #harley #weekend",
      "images": [],
      "likes": 67,
      "comments": 34,
      "shares": 12,
      "isLiked": false,
      "type": "text",
      "tripData": {
        "distance": "250 km",
        "duration": "4 hours",
        "route": "Coastal Highway"
      }
    },
    {
      "id": 4,
      "user": {
        "name": "Emma Wilson",
        "avatar":
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=150",
        "vehicle": "Tesla Model S",
        "isVerified": false
      },
      "timestamp": "8 hours ago",
      "content":
          "Just installed new performance mods on my Tesla. The acceleration is insane now! 0-60 in 2.1 seconds ⚡ #tesla #electric #performance #mod",
      "images": [
        "https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=600"
      ],
      "likes": 156,
      "comments": 28,
      "shares": 19,
      "isLiked": true,
      "type": "photo"
    },
    {
      "id": 5,
      "user": {
        "name": "David Park",
        "avatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=150",
        "vehicle": "Ducati Panigale",
        "isVerified": true
      },
      "timestamp": "12 hours ago",
      "content":
          "Maintenance day! Changed oil, cleaned chain, and checked tire pressure. Taking care of your bike is essential for safe riding. #maintenance #ducati #safety",
      "images": [
        "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=600"
      ],
      "likes": 78,
      "comments": 12,
      "shares": 6,
      "isLiked": false,
      "type": "photo"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/rides');
        break;
      case 2:
        Navigator.pushNamed(context, '/post-creation');
        break;
      case 3:
        Navigator.pushNamed(context, '/marketplace');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFeed,
                color: AppTheme.accentBlue,
                backgroundColor: AppTheme.secondaryDark,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: StorySectionWidget(),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _posts.length) {
                            return PostCardWidget(
                              post: _posts[index],
                              onLike: () => _handleLike(_posts[index]['id']),
                              onComment: () =>
                                  _handleComment(_posts[index]['id']),
                              onShare: () => _handleShare(_posts[index]['id']),
                              onUserTap: () =>
                                  _handleUserTap(_posts[index]['user']['name']),
                            );
                          } else if (_isLoading) {
                            return Container(
                              height: 8.h,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: AppTheme.accentBlue,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return null;
                        },
                        childCount: _posts.length + (_isLoading ? 1 : 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post-creation'),
        backgroundColor: AppTheme.accentRed,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.textPrimary,
          size: 28,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerDark,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RideConnect',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.accentBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle search
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  // Handle notifications
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerDark,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.primaryDark,
        selectedItemColor: AppTheme.accentBlue,
        unselectedItemColor: AppTheme.textSecondary,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'directions_bike',
              color: _currentIndex == 1
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle_outline',
              color: _currentIndex == 2
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: _currentIndex == 3
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _handleLike(int postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        _posts[postIndex]['isLiked'] = !_posts[postIndex]['isLiked'];
        _posts[postIndex]['likes'] += _posts[postIndex]['isLiked'] ? 1 : -1;
      }
    });
  }

  void _handleComment(int postId) {
    // Handle comment action
    print('Comment on post $postId');
  }

  void _handleShare(int postId) {
    // Handle share action
    print('Share post $postId');
  }

  void _handleUserTap(String userName) {
    Navigator.pushNamed(context, '/user-profile');
  }
}
