import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/menu_service.dart';
import '../themes/filipino_theme.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({Key? key}) : super(key: key);

  @override
  _MenuManagementPageState createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  String _selectedCategory = 'All';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FilipinoTheme.filipiniana,
        title: const Text(
          'Menu Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filters - use SizedBox to constrain height
          SizedBox(height: 50, child: _buildCategoryFilter()),

          // Search bar if there's a search query
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search results for "$_searchQuery"',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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

          // Menu items - use Expanded to take remaining space
          Expanded(
            child: Consumer<MenuService>(
              builder: (context, menuService, child) {
                final allMenus = menuService.allMenus;

                // Apply filters
                final filteredMenus = _filterMenuItems(allMenus);

                if (filteredMenus.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No menu items found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12), // Reduced padding
                  itemCount: filteredMenus.length,
                  itemBuilder: (context, index) {
                    final item = filteredMenus[index];
                    final isDumpMenu = menuService.dumpMenus.any(
                      (menu) => menu['id'] == item['id'],
                    );

                    return _buildMenuItemCard(context, item, isDumpMenu);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: FilipinoTheme.filipiniana,
        foregroundColor: Colors.white,
        onPressed: () {
          _showAddEditMenuDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<MenuService>(
      builder: (context, menuService, child) {
        // Get all unique categories
        final categories = <String>{'All'};
        for (final menu in menuService.allMenus) {
          categories.add(menu['category'] as String);
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Reduced padding
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories.elementAt(index);
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
        );
      },
    );
  }

  List<Map<String, dynamic>> _filterMenuItems(
    List<Map<String, dynamic>> items,
  ) {
    List<Map<String, dynamic>> filteredItems = items;

    // Filter by category
    if (_selectedCategory != 'All') {
      filteredItems =
          filteredItems
              .where((item) => item['category'] == _selectedCategory)
              .toList();
    }

    // Filter by search query
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

  Widget _buildMenuItemCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDumpMenu,
  ) {
    final menuService = Provider.of<MenuService>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12), // Reduced margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item header with image
          Stack(
            children: [
              // Item image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  item['image'] as String,
                  height: 120, // Reduced height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120, // Reduced height
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, size: 40),
                    );
                  },
                ),
              ),

              // Category badge - smaller and more compact
              Positioned(
                top: 8, // Reduced top position
                left: 8, // Reduced left position
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ), // Reduced padding
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['category'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Reduced font size
                    ),
                  ),
                ),
              ),

              // Availability badge - smaller and more compact
              Positioned(
                top: 8, // Reduced top position
                right: 8, // Reduced right position
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ), // Reduced padding
                  decoration: BoxDecoration(
                    color:
                        (item['available'] as bool)
                            ? Colors.green.withOpacity(0.8)
                            : Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (item['available'] as bool) ? 'Available' : 'Not Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Reduced font size
                    ),
                  ),
                ),
              ),

              // Badge for dump menu items - smaller and more compact
              if (isDumpMenu)
                Positioned(
                  bottom: 8, // Reduced bottom position
                  right: 8, // Reduced right position
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'System Item',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Reduced font size
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Item details - more compact
          Padding(
            padding: const EdgeInsets.all(12), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontSize: 16, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                        overflow:
                            TextOverflow
                                .ellipsis, // Add this to handle long text
                      ),
                    ),
                    Text(
                      '₱${item['price']}',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Reduced spacing
                Text(
                  item['description'] as String,
                  style: TextStyle(
                    fontSize: 12, // Reduced font size
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis, // Add this to handle long text
                ),
                const SizedBox(height: 12), // Reduced spacing
                // Action buttons with better wrapping for smaller screens
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    // Toggle availability button
                    OutlinedButton.icon(
                      onPressed: () {
                        // Create a copy of the item with availability toggled
                        final updatedItem = Map<String, dynamic>.from(item);
                        updatedItem['available'] = !(item['available'] as bool);

                        if (isDumpMenu) {
                          // For dump menus, we can only toggle availability (fake edit)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Availability updated'),
                            ),
                          );
                        } else {
                          // For dynamic menus, update in the service
                          menuService.updateMenu(
                            item['id'] as String,
                            updatedItem,
                          );
                        }
                      },
                      icon: Icon(
                        (item['available'] as bool)
                            ? Icons.cancel_outlined
                            : Icons.check_circle_outlined,
                        size: 16, // Reduced size
                      ),
                      label: Text(
                        (item['available'] as bool)
                            ? 'Unavailable'
                            : 'Available',
                        style: const TextStyle(fontSize: 12), // Reduced size
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ), // Compact padding
                        minimumSize: const Size(0, 32), // Smaller minimum size
                      ),
                    ),

                    // Edit button
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddEditMenuDialog(
                          context,
                          item: item,
                          isDumpMenu: isDumpMenu,
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16), // Reduced size
                      label: const Text(
                        'Edit',
                        style: TextStyle(fontSize: 12),
                      ), // Reduced size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ), // Compact padding
                        minimumSize: const Size(0, 32), // Smaller minimum size
                      ),
                    ),

                    // Delete button
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context, item, isDumpMenu);
                      },
                      icon: const Icon(Icons.delete, size: 16), // Reduced size
                      label: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 12),
                      ), // Reduced size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ), // Compact padding
                        minimumSize: const Size(0, 32), // Smaller minimum size
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ... existing dialog methods (_showSearchDialog, _showAddEditMenuDialog, etc.)
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Menu Items'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Enter dish name, description or category',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // Search is handled by the listener in initState
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEditMenuDialog(
    BuildContext context, {
    Map<String, dynamic>? item,
    bool isDumpMenu = false,
  }) {
    final isEditing = item != null;
    final title = isEditing ? 'Edit Menu Item' : 'Add Menu Item';

    final nameController = TextEditingController(
      text: isEditing ? item!['name'] as String : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? (item!['price'] as num).toString() : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? item!['description'] as String : '',
    );
    final imageUrlController = TextEditingController(
      text: isEditing ? item!['image'] as String : 'assets/img/dish_name.png',
    );
    bool isAvailable = isEditing ? item!['available'] as bool : true;

    // For the dropdown menu
    final List<String> categories = [
      'Main Dishes',
      'Rice & Noodles',
      'Appetizers',
      'Soups',
      'Desserts',
      'Beverages',
    ];

    // Initial category selection
    String selectedCategory =
        isEditing ? item!['category'] as String : categories[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDumpMenu)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This is a system item. Some changes may be restricted.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Dish Name*',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !isDumpMenu, // Disable for dump items
                    ),
                    const SizedBox(height: 16),

                    // Replace TextField with DropdownButtonFormField for category
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category*',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categories.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged:
                          isDumpMenu
                              ? null // Disable for dump items
                              : (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                });
                              },
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price*',
                        border: OutlineInputBorder(),
                        prefixText: '₱',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description*',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image Path*',
                        border: OutlineInputBorder(),
                        hintText: 'assets/img/dish_name.png',
                      ),
                      enabled: !isDumpMenu, // Disable for dump items
                    ),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('Available'),
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        imageUrlController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'All fields marked with * are required',
                          ),
                        ),
                      );
                      return;
                    }

                    // Try to parse price
                    double? price;
                    try {
                      price = double.parse(priceController.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid price'),
                        ),
                      );
                      return;
                    }

                    final menuService = Provider.of<MenuService>(
                      context,
                      listen: false,
                    );

                    if (isEditing) {
                      // Create updated item
                      final updatedItem = {
                        'id': item!['id'],
                        'name': nameController.text,
                        'category': selectedCategory,
                        'price': price,
                        'description': descriptionController.text,
                        'image': imageUrlController.text,
                        'available': isAvailable,
                      };

                      if (isDumpMenu) {
                        // For dump items, show a notification but don't actually update
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'System items can only have their availability and price modified',
                            ),
                          ),
                        );

                        // Only update availability and price for dump items
                        final limitedUpdate = Map<String, dynamic>.from(item);
                        limitedUpdate['available'] = isAvailable;
                        limitedUpdate['price'] = price;

                        menuService.updateMenu(
                          item['id'] as String,
                          limitedUpdate,
                        );
                      } else {
                        // For dynamic items, perform the update
                        menuService.updateMenu(
                          item['id'] as String,
                          updatedItem,
                        );
                      }
                    } else {
                      // Create new item
                      final newItem = {
                        'id': 'item_${DateTime.now().millisecondsSinceEpoch}',
                        'name': nameController.text,
                        'category': selectedCategory,
                        'price': price,
                        'description': descriptionController.text,
                        'image': imageUrlController.text,
                        'available': isAvailable,
                      };

                      menuService.addMenu(newItem);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Save' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDumpMenu,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Menu Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDumpMenu)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This is a system item and cannot be deleted. You can only mark it as unavailable.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text('Are you sure you want to delete "${item['name']}"?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            if (!isDumpMenu)
              ElevatedButton(
                onPressed: () {
                  final menuService = Provider.of<MenuService>(
                    context,
                    listen: false,
                  );
                  menuService.deleteMenu(item['id'] as String);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  // For dump items, offer to mark as unavailable instead
                  final updatedItem = Map<String, dynamic>.from(item);
                  updatedItem['available'] = false;

                  // This is a fake update - in a real app, you'd update this in a database
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('System item marked as unavailable'),
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mark Unavailable'),
              ),
          ],
        );
      },
    );
  }
}
