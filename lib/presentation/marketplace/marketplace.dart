import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selector_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/product_card_widget.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  String _selectedCategory = 'Parts';
  List<String> _activeFilters = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;

  final List<String> _categories = [
    'Parts',
    'Vehicles',
    'Accessories',
    'Custom Mods'
  ];

  // Mock data for marketplace products
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "title": "Performance Cold Air Intake System",
      "price": "\$299.99",
      "image":
          "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "AutoParts Pro",
      "rating": 4.8,
      "isVerified": true,
      "category": "Parts",
      "condition": "New",
      "location": "Los Angeles, CA"
    },
    {
      "id": 2,
      "title": "2018 Honda Civic Type R",
      "price": "\$35,000",
      "image":
          "https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Mike's Motors",
      "rating": 4.9,
      "isVerified": true,
      "category": "Vehicles",
      "condition": "Used",
      "location": "Miami, FL"
    },
    {
      "id": 3,
      "title": "LED Headlight Conversion Kit",
      "price": "\$149.99",
      "image":
          "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Bright Lights Co",
      "rating": 4.6,
      "isVerified": false,
      "category": "Accessories",
      "condition": "New",
      "location": "Phoenix, AZ"
    },
    {
      "id": 4,
      "title": "Custom Carbon Fiber Spoiler",
      "price": "\$899.99",
      "image":
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Carbon Customs",
      "rating": 4.7,
      "isVerified": true,
      "category": "Custom Mods",
      "condition": "New",
      "location": "Detroit, MI"
    },
    {
      "id": 5,
      "title": "Turbo Exhaust System",
      "price": "\$1,299.99",
      "image":
          "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Speed Demons",
      "rating": 4.9,
      "isVerified": true,
      "category": "Parts",
      "condition": "New",
      "location": "Dallas, TX"
    },
    {
      "id": 6,
      "title": "Racing Seat Set (2 Seats)",
      "price": "\$799.99",
      "image":
          "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Race Ready",
      "rating": 4.5,
      "isVerified": true,
      "category": "Accessories",
      "condition": "New",
      "location": "Seattle, WA"
    },
    {
      "id": 7,
      "title": "2020 BMW M3 Competition",
      "price": "\$65,000",
      "image":
          "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Luxury Motors",
      "rating": 4.8,
      "isVerified": true,
      "category": "Vehicles",
      "condition": "Used",
      "location": "New York, NY"
    },
    {
      "id": 8,
      "title": "Custom Body Kit - Universal",
      "price": "\$2,499.99",
      "image":
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=400",
      "seller": "Body Mods Inc",
      "rating": 4.6,
      "isVerified": true,
      "category": "Custom Mods",
      "condition": "New",
      "location": "Las Vegas, NV"
    }
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _filteredProducts = List.from(_allProducts);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      // Simulate loading more products
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        bool matchesCategory = _selectedCategory == 'All' ||
            (product['category'] as String) == _selectedCategory;
        bool matchesSearch = _searchController.text.isEmpty ||
            (product['title'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProducts();
  }

  void _addFilter(String filter) {
    if (!_activeFilters.contains(filter)) {
      setState(() {
        _activeFilters.add(filter);
      });
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterModal(),
    );
  }

  Widget _buildFilterModal() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Done',
                    style: TextStyle(color: AppTheme.accentBlue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: [
                _buildFilterSection('Price Range',
                    ['\$0-\$100', '\$100-\$500', '\$500-\$1000', '\$1000+']),
                _buildFilterSection(
                    'Condition', ['New', 'Used', 'Refurbished']),
                _buildFilterSection('Location',
                    ['Within 25 miles', 'Within 50 miles', 'Within 100 miles']),
                _buildFilterSection(
                    'Brand', ['Honda', 'BMW', 'Toyota', 'Ford', 'Chevrolet']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
        ),
        ...options.map((option) => CheckboxListTile(
              title:
                  Text(option, style: AppTheme.darkTheme.textTheme.bodyMedium),
              value: _activeFilters.contains(option),
              onChanged: (bool? value) {
                if (value == true) {
                  _addFilter(option);
                } else {
                  _removeFilter(option);
                }
              },
              activeColor: AppTheme.accentBlue,
            )),
        SizedBox(height: 2.h),
      ],
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredProducts = List.from(_allProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategorySelector(),
            _buildActiveFilters(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppTheme.accentBlue,
                child: _buildProductGrid(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to sell item screen
        },
        backgroundColor: AppTheme.accentRed,
        foregroundColor: AppTheme.textPrimary,
        label: Text(
          'Sell Item',
          style: AppTheme.darkTheme.textTheme.labelLarge,
        ),
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.textPrimary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _filterProducts(),
                style: AppTheme.darkTheme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search parts, vehicles...',
                  hintStyle: AppTheme.darkTheme.inputDecorationTheme.hintStyle,
                  prefixIcon: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _filterProducts();
                          },
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showFilterModal,
            child: Container(
              height: 6.h,
              width: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.textPrimary,
                    size: 24,
                  ),
                  if (_activeFilters.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.accentRed,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _activeFilters.length.toString(),
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
    );
  }

  Widget _buildCategorySelector() {
    return CategorySelectorWidget(
      categories: _categories,
      selectedCategory: _selectedCategory,
      onCategoryChanged: _onCategoryChanged,
    );
  }

  Widget _buildActiveFilters() {
    if (_activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _activeFilters.length,
        itemBuilder: (context, index) {
          return FilterChipWidget(
            label: _activeFilters[index],
            onRemove: () => _removeFilter(_activeFilters[index]),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return _buildSkeletonGrid();
    }

    if (_filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredProducts.length + (_isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredProducts.length) {
          return _buildSkeletonCard();
        }

        return ProductCardWidget(
          product: _filteredProducts[index],
          onTap: () {
            // Navigate to product detail
          },
          onLongPress: () => _showQuickActions(_filteredProducts[index]),
        );
      },
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 1.5.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.textSecondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No items found',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your filters or search terms',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _activeFilters.clear();
                _selectedCategory = 'Parts';
                _filteredProducts = List.from(_allProducts);
              });
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.textPrimary,
                size: 24,
              ),
              title: Text(
                'Save to Wishlist',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Add to wishlist logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.textPrimary,
                size: 24,
              ),
              title: Text(
                'Share',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Share logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.textPrimary,
                size: 24,
              ),
              title: Text(
                'Message Seller',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Message seller logic
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
