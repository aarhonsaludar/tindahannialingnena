import 'package:flutter/foundation.dart';
import '../models/customer_model.dart';
import 'dart:math';

class DashboardService extends ChangeNotifier {
  final List<Customer> _customers = [];
  final List<Map<String, dynamic>> _allOrders = []; // To store all orders

  // Generate demo data when service is initialized
  DashboardService() {
    _generateDemoData();
  }

  // Get all customers
  List<Customer> get customers => List.unmodifiable(_customers);

  // Get total number of customers
  int get customerCount => _customers.length;

  // Get customers who placed orders today
  int get todayCustomersCount {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    // Get unique customer IDs who ordered today
    final uniqueCustomerIds = <String>{};

    for (var order in _allOrders) {
      if ((order['date'] as DateTime).isAfter(startOfDay)) {
        uniqueCustomerIds.add(order['customerId'] as String);
      }
    }

    return uniqueCustomerIds.length;
  }

  // Get total sales (number of items sold)
  int get totalSales {
    int total = 0;
    for (var order in _allOrders) {
      total += order['items'] as int;
    }
    return total;
  }

  // Get number of new orders today
  int get newOrdersToday {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _allOrders
        .where((order) => (order['date'] as DateTime).isAfter(startOfDay))
        .length;
  }

  // Get number of orders in the past week
  int get newOrdersThisWeek {
    final now = DateTime.now();
    final aWeekAgo = now.subtract(const Duration(days: 7));

    return _allOrders
        .where((order) => (order['date'] as DateTime).isAfter(aWeekAgo))
        .length;
  }

  // Get total revenue from all orders
  double get totalRevenue {
    double total = 0.0;
    for (var order in _allOrders) {
      total += order['amount'] as double;
    }
    return total;
  }

  // Get today's revenue
  double get todayRevenue {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    double total = 0.0;
    for (var order in _allOrders) {
      if ((order['date'] as DateTime).isAfter(startOfDay)) {
        total += order['amount'] as double;
      }
    }
    return total;
  }

  // Get daily revenue for the past 7 days
  Map<DateTime, double> getDailyRevenueLastWeek() {
    final Map<DateTime, double> dailyRevenue = {};
    final now = DateTime.now();

    // Initialize the map with the past 7 days
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      dailyRevenue[date] = 0.0;
    }

    // Sum up the revenue for each day
    for (var order in _allOrders) {
      final orderDate = DateTime(
        (order['date'] as DateTime).year,
        (order['date'] as DateTime).month,
        (order['date'] as DateTime).day,
      );

      if (dailyRevenue.containsKey(orderDate)) {
        dailyRevenue[orderDate] =
            (dailyRevenue[orderDate] ?? 0) + (order['amount'] as double);
      }
    }

    return dailyRevenue;
  }

  // Get popular items based on quantity sold
  List<Map<String, dynamic>> getPopularItems() {
    final Map<String, Map<String, dynamic>> itemMap = {};

    // Process all orders to count items
    for (var order in _allOrders) {
      final orderDetails = order['orderDetails'] as List<dynamic>;

      for (var item in orderDetails) {
        final itemName = item['name'] as String;
        final itemQuantity = item['quantity'] as int;
        final itemPrice = item['price'] as double;
        final itemImage = item['imageUrl'] as String;

        if (!itemMap.containsKey(itemName)) {
          itemMap[itemName] = {
            'name': itemName,
            'quantity': 0,
            'revenue': 0.0,
            'image': itemImage,
          };
        }

        itemMap[itemName]?['quantity'] =
            (itemMap[itemName]?['quantity'] ?? 0) + itemQuantity;
        itemMap[itemName]?['revenue'] =
            (itemMap[itemName]?['revenue'] ?? 0.0) + (itemPrice * itemQuantity);
      }
    }

    // Convert to list and sort by quantity
    final popularItems = itemMap.values.toList();
    popularItems.sort(
      (a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int),
    );

    return popularItems;
  }

  // Get recent orders
  List<Map<String, dynamic>> getRecentOrders({
    int limit = 10,
    String? status,
    DateTime? since,
  }) {
    // Filter orders if needed
    var filteredOrders = List<Map<String, dynamic>>.from(_allOrders);

    if (status != null) {
      filteredOrders =
          filteredOrders.where((order) => order['status'] == status).toList();
    }

    if (since != null) {
      filteredOrders =
          filteredOrders
              .where((order) => (order['date'] as DateTime).isAfter(since))
              .toList();
    }

    // Sort by date (newest first)
    filteredOrders.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    // Return limited number of orders
    return filteredOrders.take(limit).toList();
  }

  // Add a new order directly (from checkout)
  void addNewOrder(Map<String, dynamic> orderData) {
    // Add to all orders list
    _allOrders.add(orderData);

    // Notify listeners that dashboard data has changed
    notifyListeners();
  }

  // Add a random new order (for demo purposes)
  void addRandomOrder() {
    if (_customers.isEmpty) return;

    final random = Random();
    final customerIndex = random.nextInt(_customers.length);
    final customer = _customers[customerIndex];

    // Create a new order with random items
    final order = _createRandomOrder();

    // Create order data for dashboard
    final orderData = {
      'id': order.id,
      'customerId': customer.id,
      'customerName': customer.name,
      'customerEmail': customer.email,
      'customerPhone': customer.phoneNumber,
      'amount': order.totalAmount,
      'date': order.orderDate,
      'status': order.status,
      'items': order.totalItems,
      'paymentMethod': order.paymentMethod,
      'deliveryFee': order.deliveryFee,
      'orderDetails':
          order.items
              .map(
                (item) => {
                  'name': item.name,
                  'price': item.price,
                  'quantity': item.quantity,
                  'imageUrl': item.imageUrl,
                  'total': item.price * item.quantity,
                },
              )
              .toList(),
    };

    // Add order to the customer
    _customers[customerIndex].orders.add(order);

    // Add to all orders list
    _allOrders.add(orderData);

    // Notify listeners that dashboard data has changed
    notifyListeners();
  }

  // Function to update order status
  void updateOrderStatus(String orderId, String newStatus) {
    // Update in _allOrders list
    final orderIndex = _allOrders.indexWhere((order) => order['id'] == orderId);
    if (orderIndex != -1) {
      _allOrders[orderIndex]['status'] = newStatus;
      notifyListeners();
    }

    // Update in customer's orders (if needed for consistency)
    for (var customer in _customers) {
      final customerOrderIndex = customer.orders.indexWhere(
        (order) => order.id == orderId,
      );
      if (customerOrderIndex != -1) {
        // Since Order is immutable, we would need to replace it with a new one
        // This part would depend on your Order class implementation
        break;
      }
    }
  }

  // Generate initial demo data
  void _generateDemoData() {
    // Create some demo customers
    final customers = [
      Customer(
        name: 'Maria Santos',
        email: 'maria.santos@example.com',
        phoneNumber: '+63 917 123 4567',
        address: '123 Rizal Street, Manila',
      ),
      Customer(
        name: 'Juan Dela Cruz',
        email: 'juan.delacruz@example.com',
        phoneNumber: '+63 918 765 4321',
        address: '456 Bonifacio Avenue, Makati',
      ),
      Customer(
        name: 'Elena Reyes',
        email: 'elena.reyes@example.com',
        phoneNumber: '+63 919 222 3333',
        address: '789 Mabini Boulevard, Quezon City',
      ),
      Customer(
        name: 'Pedro Gonzales',
        email: 'pedro.gonzales@example.com',
        phoneNumber: '+63 920 444 5555',
        address: '101 Aguinaldo Highway, Cavite',
      ),
      Customer(
        name: 'Sofia Luna',
        email: 'sofia.luna@example.com',
        phoneNumber: '+63 921 666 7777',
        address: '202 Luna Street, Pasig',
      ),
    ];

    // Add the customers to our list
    _customers.addAll(customers);

    // Generate random orders for each customer
    final random = Random();
    for (var customer in _customers) {
      // Generate between 1 and 5 orders per customer
      final orderCount = random.nextInt(5) + 1;

      for (var i = 0; i < orderCount; i++) {
        // Create an order with a random date in the last 10 days
        final daysAgo = random.nextInt(10);
        final orderDate = DateTime.now().subtract(
          Duration(days: daysAgo, hours: random.nextInt(24)),
        );

        // Create a new order
        final order = _createRandomOrder(orderDate: orderDate);

        // Create order data for dashboard
        final orderData = {
          'id': order.id,
          'customerId': customer.id,
          'customerName': customer.name,
          'customerEmail': customer.email,
          'customerPhone': customer.phoneNumber,
          'amount': order.totalAmount,
          'date': order.orderDate,
          'status': order.status,
          'items': order.totalItems,
          'paymentMethod': order.paymentMethod,
          'deliveryFee': order.deliveryFee,
          'orderDetails':
              order.items
                  .map(
                    (item) => {
                      'name': item.name,
                      'price': item.price,
                      'quantity': item.quantity,
                      'imageUrl': item.imageUrl,
                      'total': item.price * item.quantity,
                    },
                  )
                  .toList(),
        };

        // Add the order to the customer
        customer.orders.add(order);

        // Add to all orders list
        _allOrders.add(orderData);
      }
    }
  }

  // Helper method to create a random order
  Order _createRandomOrder({DateTime? orderDate}) {
    final random = Random();

    // List of sample menu items
    final menuItems = [
      {'name': 'Adobo', 'price': 180.0, 'image': 'assets/img/adobo.png'},
      {
        'name': 'Sinigang',
        'price': 200.0,
        'image': 'assets/img/sinigang_baboy.jpg',
      },
      {
        'name': 'Lechon Kawali',
        'price': 250.0,
        'image': 'assets/img/lechon_kawali.jpg',
      },
      {
        'name': 'Kare-Kare',
        'price': 320.0,
        'image': 'assets/img/kare_kare.jpg',
      },
      {
        'name': 'Pancit Canton',
        'price': 150.0,
        'image': 'assets/img/pancit_canton.jpg',
      },
      {
        'name': 'Halo-Halo',
        'price': 100.0,
        'image': 'assets/img/halo_halo.jpg',
      },
      {'name': 'Bibingka', 'price': 80.0, 'image': 'assets/img/bibingka.jpg'},
      {
        'name': 'Lumpia',
        'price': 120.0,
        'image': 'assets/img/lumpiang_shanghai.jpg',
      },
    ];

    // Generate between 1 and 5 random items for this order
    final itemCount = random.nextInt(5) + 1;
    final orderItems = <OrderItem>[];

    for (var i = 0; i < itemCount; i++) {
      final menuItem = menuItems[random.nextInt(menuItems.length)];
      final quantity = random.nextInt(3) + 1;

      orderItems.add(
        OrderItem(
          name: menuItem['name'] as String,
          price: menuItem['price'] as double,
          quantity: quantity,
          imageUrl: menuItem['image'] as String,
        ),
      );
    }

    // List of possible order statuses
    final statuses = [
      'Pending',
      'Processing',
      'Delivered',
      'Completed',
      'Cancelled',
    ];
    final status = statuses[random.nextInt(statuses.length)];

    // Create the order
    return Order(
      items: orderItems,
      status: status,
      orderDate: orderDate,
      deliveryFee: 50.0,
    );
  }
}
