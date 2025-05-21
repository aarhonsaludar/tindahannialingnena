import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../themes/filipino_theme.dart';
import '../services/menu_service.dart';
import '../services/review_service.dart';
import '../widgets/review_summary_widget.dart';
import '../widgets/animated_list_item.dart'; // Add this import
import '../widgets/animated_button.dart'; // Add this import
import '../utils/transitions.dart'; // Add this import
import 'dish_details_page.dart'; // Add this import

class DealsMenuPage extends StatefulWidget {
  const DealsMenuPage({Key? key}) : super(key: key);

  @override
  _DealsMenuPageState createState() => _DealsMenuPageState();
}

class _DealsMenuPageState extends State<DealsMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final List<Map<String, dynamic>> _filipinoCategories =
      FilipinoTheme.getFilipinoFoodCategories();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  // Map for custom categories to existing categories
  final Map<String, String> _customCategoryMapping = {
    'Ulam': 'Main Dishes',
    'Kanin': 'Rice & Noodles',
    'Sabaw': 'Soups',
    'Pulutan': 'Appetizers',
    'Meryenda': 'Rice & Noodles', // Assuming snacks are under Rice & Noodles
    'Panghimagas': 'Desserts',
    'Inumin': 'Beverages',
  };

  final List<String> _customCategories = [
    'All',
    'Ulam',
    'Kanin',
    'Sabaw',
    'Pulutan',
    'Meryenda',
    'Panghimagas',
    'Inumin',
  ];

  // Adding the missing _categories list
  final List<String> _categories = [
    'All',
    'Main Dishes',
    'Rice & Noodles',
    'Appetizers',
    'Soups',
    'Desserts',
    'Beverages',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _checkout(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    final result = cart.checkout(context); // Pass context here

    if (result['success']) {
      final receipt = result['receipt'];
      _showReceiptDialog(context, receipt);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> receipt) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Column(
            children: [
              // Add logo at the top of the receipt
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Image.asset(
                    'assets/img/logo.png', // Path to your logo
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Receipt',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${receipt['timestamp']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Method:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      receipt['paymentMethod'] ?? 'Cash on Delivery',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Items Section
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...receipt['items'].map<Widget>((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item['quantity']} x ${item['name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (item['specialInstructions'] != null)
                                  Text(
                                    'Note: ${item['specialInstructions']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '₱${item['total']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const Divider(height: 32),

                // Summary Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₱${receipt['subtotal']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fee:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '₱50.0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₱${receipt['total']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuService = Provider.of<MenuService>(context);
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FilipinoTheme.filipiniana,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search menu items...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
                : const Text(
                  'Filipino Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.arrow_back : Icons.menu),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _searchQuery = '';
              });
            } else {
              Scaffold.of(context).openDrawer();
            }
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
                  _searchQuery = '';
                }
              });
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCartModal(context);
                },
              ),
              if (cart.totalQuantity > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.totalQuantity}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: FilipinoTheme.mangga,
          indicatorWeight: 3,
          tabs: const [Tab(text: 'Menu'), Tab(text: 'Promos')],
        ),
      ),
      drawer: Drawer(
        // Add your sidebar content here
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: FilipinoTheme.filipiniana),
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
      body: Column(
        children: [
          // Search results count if searching
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Text(
                    'Search results for "${_searchController.text}": ${_getFilteredMenuItems(menuService.allMenus).length} items',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),

          // Custom category selection
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _customCategories.length,
              itemBuilder: (context, index) {
                final category = _customCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Menu items
          Expanded(
            child: Consumer<MenuService>(
              builder: (context, menuService, child) {
                final filteredItems = _getFilteredMenuItems(
                  menuService.allMenus,
                );

                return filteredItems.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No items found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try a different search term or category',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildMenuItem(context, item);
                      },
                    );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          cart.totalQuantity > 0
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _checkout(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              : null,
    );
  }

  List<Map<String, dynamic>> _getFilteredMenuItems(
    List<Map<String, dynamic>> menuItems,
  ) {
    List<Map<String, dynamic>> filteredItems = [];

    // First filter by category
    if (_selectedCategory == 'All') {
      filteredItems = List.from(menuItems);
    } else if (_customCategoryMapping.containsKey(_selectedCategory)) {
      final mappedCategory = _customCategoryMapping[_selectedCategory];
      filteredItems =
          menuItems
              .where((item) => item['category'] == mappedCategory)
              .toList();
    } else {
      filteredItems = [];
    }

    // Then filter by search query if present
    if (_searchQuery.isNotEmpty) {
      filteredItems =
          filteredItems.where((item) {
            return item['name'].toString().toLowerCase().contains(
                  _searchQuery,
                ) ||
                item['description'].toString().toLowerCase().contains(
                  _searchQuery,
                ) ||
                item['category'].toString().toLowerCase().contains(
                  _searchQuery,
                );
          }).toList();
    }

    return filteredItems;
  }

  Widget _buildCategoryItem(String name, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = name;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? FilipinoTheme.filipiniana
                        : FilipinoTheme.filipiniana.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : FilipinoTheme.filipiniana,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              name.split(' ')[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? FilipinoTheme.filipiniana : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        // Category selection
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategory == _categories[index],
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),

        // Menu items
        Expanded(
          child: Consumer<MenuService>(
            builder: (context, menuService, child) {
              final filteredItems = _getFilteredMenuItems(menuService.allMenus);
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _buildMenuItem(context, item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final cart = Provider.of<CartModel>(context, listen: false);
    final reviewService = Provider.of<ReviewService>(context, listen: false);
    final isAvailable = item['available'] as bool;
    final avgRating = reviewService.getAverageRatingForDish(
      item['id'] as String,
    );

    return AnimatedListItem(
      index: int.parse(item['id'] as String) % 10, // Use a number from the ID for delay
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              Transitions.fadeTransition(
                DishDetailsPage(dish: item),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item image and details section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item image with Hero animation
                  Hero(
                    tag: 'dish_image_${item['id']}',
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item['image'] as String),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Item details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['description'] as String,
                            style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₱${item['price']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                              if (isAvailable)
                                AnimatedButton(
                                  onPressed: () {
                                    _addToCart(context, item);
                                  },
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: 8,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: const Text('Add to Cart'),
                                )
                              else
                                Text(
                                  'Not Available',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Ratings and reviews section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ReviewSummaryWidget(
                  dishId: item['id'] as String,
                  dishName: item['name'] as String,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> item) {
    final cart = Provider.of<CartModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildAddToCartModal(context, item),
    );
  }

  Widget _buildAddToCartModal(BuildContext context, Map<String, dynamic> item) {
    int quantity = 1;
    final TextEditingController instructionsController =
        TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item details row
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image'] as String,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '₱${item['price']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quantity selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        quantity > 1
                            ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                            : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Special instructions
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Special Instructions',
                  hintText: 'E.g., No onions, less spicy, etc.',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              // Add to cart button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final cart = Provider.of<CartModel>(context, listen: false);
                    // Add item to cart
                    for (var i = 0; i < quantity; i++) {
                      cart.addItem(
                        id: item['id'] as String,
                        name: item['name'] as String,
                        imageUrl: item['image'] as String,
                        price: item['price'] as double,
                        specialInstructions:
                            instructionsController.text.isEmpty
                                ? null
                                : instructionsController.text,
                      );
                    }

                    Navigator.pop(context);

                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item['name']} added to cart'),
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          onPressed: () {
                            _showCartModal(context);
                          },
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Add ${quantity > 1 ? '($quantity)' : ''} to Cart',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildCartModal(context),
    );
  }

  Widget _buildCartModal(BuildContext context) {
    // Payment method state for the modal
    String selectedPaymentMethod = 'Cash on Delivery';

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Consumer<CartModel>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add some items from the menu',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Cart',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          cart.clear();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear All'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Cart items list
                  Expanded(
                    child: ListView(
                      children:
                          cart.items.entries.map((entry) {
                            final item = entry.value;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Item image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.asset(
                                        item.imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Item details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item.specialInstructions != null)
                                            Text(
                                              'Note: ${item.specialInstructions}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          Text(
                                            '₱${item.price}',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Quantity controls
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () {
                                            cart.decrementItem(item.id);
                                          },
                                          iconSize: 20,
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () {
                                            cart.updateQuantity(
                                              item.id,
                                              item.quantity + 1,
                                            );
                                          },
                                          iconSize: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment Method Selection
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Payment method radio buttons
                        RadioListTile<String>(
                          title: const Row(
                            children: [
                              Icon(Icons.delivery_dining),
                              SizedBox(width: 8),
                              Text('Cash on Delivery'),
                            ],
                          ),
                          value: 'Cash on Delivery',
                          groupValue: selectedPaymentMethod,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),

                        RadioListTile<String>(
                          title: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('GCash'),
                            ],
                          ),
                          value: 'GCash',
                          groupValue: selectedPaymentMethod,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cart summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text(
                              '₱${cart.totalAmount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            const Text(
                              '₱50',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '₱${cart.totalAmount + 50}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final result = cart.checkout(
                          context,
                        ); // Pass context here
                        Navigator.pop(context);

                        if (result['success']) {
                          // Pass the selected payment method to the receipt
                          result['receipt']['paymentMethod'] =
                              selectedPaymentMethod;
                          _showReceiptDialog(context, result['receipt']);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order placed successfully!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPromosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildDealCard(
          context,
          'Special Deal #${index + 1}',
          'Get a special discount on this amazing deal package.',
          '₱${(index + 1) * 200}',
          '₱${(index + 1) * 250}',
          'assets/img/deal${index + 1}.png', // Updated to local asset
        );
      },
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    String title,
    String description,
    String discountedPrice,
    String originalPrice,
    String imageUrl,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Deal image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl, // Updated to use local asset
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Deal details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      discountedPrice,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      originalPrice,
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Order this deal
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Order Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Menu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for dishes...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
            ),
            onSubmitted: (value) {
              Navigator.pop(context);
              setState(() {
                _isSearching = value.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 16),
          // Popular search terms
          Wrap(
            spacing: 8,
            children: [
              _buildSearchChip('Adobo'),
              _buildSearchChip('Sinigang'),
              _buildSearchChip('Desserts'),
              _buildSearchChip('Spicy'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              _isSearching = _searchController.text.isNotEmpty;
            });
          },
          child: const Text('Search'),
        ),
      ],
    );
  }

  Widget _buildSearchChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _searchController.text = label;
        Navigator.pop(context);
        setState(() {
          _isSearching = true;
          _searchQuery = label.toLowerCase();
        });
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Price Range'),
              const SizedBox(height: 8),
              RangeSlider(
                values: const RangeValues(0, 500),
                min: 0,
                max: 1000,
                divisions: 20,
                labels: const RangeLabels('₱0', '₱500'),
                onChanged: (values) {
                  // Update price range
                },
              ),
              const Divider(),
              CheckboxListTile(
                title: const Text('Vegetarian Options'),
                value: false,
                onChanged: (value) {
                  // Toggle vegetarian options
                },
              ),
              CheckboxListTile(
                title: const Text('Spicy Dishes'),
                value: false,
                onChanged: (value) {
                  // Toggle spicy dishes
                },
              ),
              CheckboxListTile(
                title: const Text('Special Offers Only'),
                value: false,
                onChanged: (value) {
                  // Toggle special offers
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Reset filters
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
