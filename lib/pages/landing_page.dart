import 'package:flutter/material.dart';
import 'dart:async';
import '../themes/filipino_theme.dart';
import '../widgets/shared_app_bar.dart';
import '../services/menu_service.dart';
import '../widgets/animated_list_item.dart'; // Add this import

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Add animation controller for the banner
  late PageController _bannerController;
  int _currentBannerPage = 0;

  // Demo data for food items - we'll use this for search
  final List<Map<String, dynamic>> _foodItems = [
    {
      'id': '1',
      'name': 'Adobo',
      'description':
          'Classic Filipino dish with meat marinated in vinegar, soy sauce, and garlic',
      'price': '₱180',
      'image': 'assets/img/adobo.png',
      'category': 'Main Dishes',
    },
    {
      'id': '2',
      'name': 'Sinigang',
      'description': 'Sour soup with pork, vegetables, and tamarind',
      'price': '₱200',
      'image': 'assets/img/sinigang_baboy.jpg',
      'category': 'Soups',
    },
    {
      'id': '3',
      'name': 'Lechon Kawali',
      'description': 'Crispy deep-fried pork belly',
      'price': '₱350',
      'image': 'assets/img/lechon_kawali.jpg',
      'category': 'Main Dishes',
    },
    {
      'id': '4',
      'name': 'Kare-Kare',
      'description':
          'Philippine stew with oxtail and vegetables in peanut sauce',
      'price': '₱320',
      'image': 'assets/img/kare_kare.jpg',
      'category': 'Main Dishes',
    },
    {
      'id': '5',
      'name': 'Pancit Canton',
      'description': 'Stir-fried noodles with meat and vegetables',
      'price': '₱150',
      'image': 'assets/img/pancit_canton.jpg',
      'category': 'Noodles',
    },
    {
      'id': '6',
      'name': 'Bistek Tagalog',
      'description': 'Filipino beef steak with soy sauce and calamansi',
      'price': '₱220',
      'image': 'assets/img/bistek_tagalog.jpg',
      'category': 'Main Dishes',
    },
    {
      'id': '7',
      'name': 'Lumpiang Shanghai',
      'description': 'Fried pork spring rolls',
      'price': '₱120',
      'image': 'assets/img/lumpiang_shanghai.jpg',
      'category': 'Appetizers',
    },
    {
      'id': '8',
      'name': 'Tokwa\'t Baboy',
      'description': 'Fried tofu and pork with vinegar sauce',
      'price': '₱150',
      'image': 'assets/img/tokwat_baboy.jpg',
      'category': 'Appetizers',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Initialize banner controller
    _bannerController = PageController();

    // Setup banner auto-scroll
    _setupBannerAutoScroll();
  }

  void _setupBannerAutoScroll() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_bannerController.hasClients) {
        if (_currentBannerPage == 2) {
          _currentBannerPage = 0;
        } else {
          _currentBannerPage++;
        }

        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults =
          _foodItems.where((item) {
            return item['name'].toLowerCase().contains(query) ||
                item['description'].toLowerCase().contains(query) ||
                item['category'].toLowerCase().contains(query);
          }).toList();
    });
  }

  void _showFoodDetailModal(BuildContext context, Map<String, dynamic> food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          food['image'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Text(
                            food['category'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Food details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                food['name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                food['price'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          food['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Traditional ingredients for ${food['name']} include various fresh and locally sourced items prepared with authentic Filipino cooking techniques.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement add to cart functionality
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${food['name']} added to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FilipinoTheme.filipiniana,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search Filipino dishes...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
                : const Text(
                  'Tindahan Ni Aling Nena',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Baybayin',
                  ),
                ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading:
            _isSearching
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _isSearching = false;
                    });
                  },
                )
                : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // Show cart
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add your sidebar content here
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:
          _isSearching && _searchController.text.isNotEmpty
              ? _buildSearchResults()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroBanner(context),
                    _buildQuickActionButtons(context),
                    _buildWelcomeSection(context),
                    _buildFeaturedDishesSection(context),
                    _buildRegionalCuisineSection(context),
                    _buildSpecialOffersSection(context),
                    _buildStorySection(context),
                    _buildFooter(context),
                  ],
                ),
              ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No dishes found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final food = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: InkWell(
            onTap: () => _showFoodDetailModal(context, food),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.asset(
                    food['image'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          food['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          food['price'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    final List<Map<String, String>> bannerItems = [
      {
        'image': 'assets/img/lechon_kawali.jpg',
        'title': 'Traditional Lechon',
        'subtitle': 'Crispy skin, juicy meat - the Filipino celebration staple',
      },
      {
        'image': 'assets/img/adobo.png',
        'title': 'Signature Adobo',
        'subtitle': 'Our family recipe passed down through generations',
      },
      {
        'image': 'assets/img/sinigang_baboy.jpg',
        'title': 'Comforting Sinigang',
        'subtitle': 'The perfect sour soup for rainy days',
      },
    ];

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              itemCount: bannerItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = bannerItems[index];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _currentBannerPage == index ? 1.0 : 0.7,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image with error handling
                          Image.asset(
                            item['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: ${item['image']}');
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Gradient overlay for text readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: [0.6, 1.0],
                              ),
                            ),
                          ),

                          // Text content
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated indicator dots
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerItems.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentBannerPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _currentBannerPage == index
                          ? FilipinoTheme.filipiniana
                          : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAnimatedQuickActionButton(
            context,
            Icons.restaurant,
            'Dine In',
            () {
              // Handle dine in
            },
            0,
          ),
          _buildAnimatedQuickActionButton(
            context,
            Icons.delivery_dining,
            'Delivery',
            () {
              // Handle delivery
            },
            1,
          ),
          _buildAnimatedQuickActionButton(
            context,
            Icons.shopping_bag,
            'Takeout',
            () {
              // Handle takeout
            },
            2,
          ),
          _buildAnimatedQuickActionButton(
            context,
            Icons.event,
            'Reservations',
            () {
              // Handle reservations
            },
            3,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildQuickActionButton(context, icon, label, onPressed),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xFFFFF8E1), // Warm cream background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Tindahan Ni Aling Nena!',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'Experience authentic Filipino home cooking in the heart of the city. Our recipes have been passed down through generations.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDishesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            margin: const EdgeInsets.only(bottom: 16.0, left: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.secondary, width: 2.0),
              ),
            ),
            child: Text(
              'Featured Dishes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 4, // Number of featured items
              itemBuilder: (context, index) {
                return AnimatedListItem(
                  index: index,
                  duration: const Duration(milliseconds: 500),
                  child: _buildFeaturedItem(
                    context,
                    'Adobo',
                    'assets/img/adobo.png',
                    '₱180',
                    'Classic Filipino dish with meat marinated in vinegar, soy sauce, and garlic',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Add this method for animating featured items
  Widget _buildFeaturedItem(
    BuildContext context,
    String name,
    String imageUrl,
    String price,
    String description,
  ) {
    final colorScheme =
        Theme.of(context).colorScheme; // Add this line to fix the error

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        child: GestureDetector(
          onTap: () {
            // Show food detail
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
              children: [
                // Image section
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    imageUrl,
                    height: 100, // Reduce image height slightly
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $imageUrl');
                      return Container(
                        height: 100,
                        width: 180,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(Icons.image_not_supported, size: 30),
                        ),
                      );
                    },
                  ),
                ),

                // Text content section
                Padding(
                  padding: const EdgeInsets.all(8.0), // Reduce padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14, // Smaller font
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2), // Smaller spacing
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ), // Smaller font
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4), // Smaller spacing
                      Text(
                        price,
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Smaller font
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegionalCuisineSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xFFFFF8E1), // Warm cream background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Regional Cuisine',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildHighlightItem(
            context,
            Icons.restaurant,
            'Ilocano Empanada',
            'Savory stuffed pastry from the Ilocos region',
          ),
          _buildHighlightItem(
            context,
            Icons.family_restroom,
            'Bicol Express',
            'Spicy pork stew with coconut milk from Bicol',
          ),
          _buildHighlightItem(
            context,
            Icons.eco,
            'Cebu Lechon',
            'Famous roasted pig from Cebu',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffersSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.secondary, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.05),
                colorScheme.secondary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Special",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/img/kare_kare.jpg', // Fixed to use Image.asset
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kare-Kare',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Philippine stew with oxtail and vegetables in peanut sauce',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '₱320',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₱256',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/deals');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'View All Deals',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorySection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xFFFFF8E1), // Warm cream background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Why Choose Us',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildHighlightItem(
            context,
            Icons.restaurant,
            'Authentic Filipino Recipes',
            'Traditional cooking methods and ingredients',
          ),
          _buildHighlightItem(
            context,
            Icons.family_restroom,
            'Family-Friendly',
            'Perfect for family gatherings and celebrations',
          ),
          _buildHighlightItem(
            context,
            Icons.eco,
            'Fresh Ingredients',
            'Locally sourced produce and meats',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      color: colorScheme.primary,
      child: Column(
        children: [
          Text(
            'Tindahan Ni Aling Nena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Katapatan Homes, Cabuyao Laguna, Philippines',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Open daily: 10:00 AM - 10:00 PM',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.tiktok, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Tindahan Ni Aling Nena. All rights reserved.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Search delegate for food items
class FoodSearchDelegate extends SearchDelegate<String> {
  final List<String> foodItems = [
    'Adobo',
    'Sinigang',
    'Kare-Kare',
    'Lechon',
    'Pancit Canton',
    'Halo-Halo',
    'Bibingka',
    'Lumpia',
    'Sisig',
    'Tapsilog',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        foodItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Search Filipino dishes...',
          style: TextStyle(color: Colors.grey[400], fontSize: 18),
        ),
      );
    }

    final results =
        foodItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.restaurant_menu),
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
