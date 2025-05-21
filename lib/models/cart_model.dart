import 'package:flutter/material.dart'; // Add this import
import 'package:provider/provider.dart';
import '../services/order_history_service.dart';
import '../services/dashboard_service.dart';
import '../utils/user_session.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.specialInstructions,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    String? specialInstructions,
  }) {
    if (_items.containsKey(id)) {
      // Increase quantity if item already exists
      _items.update(
        id,
        (existingItem) => existingItem.copyWith(
          quantity: existingItem.quantity + 1,
          specialInstructions:
              specialInstructions ?? existingItem.specialInstructions,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          imageUrl: imageUrl,
          price: price,
          specialInstructions: specialInstructions,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id) && quantity > 0) {
      _items.update(
        id,
        (existingItem) => existingItem.copyWith(quantity: quantity),
      );
      notifyListeners();
    }
  }

  void updateSpecialInstructions(String id, String? specialInstructions) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) =>
            existingItem.copyWith(specialInstructions: specialInstructions),
      );
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void decrementItem(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingItem) =>
            existingItem.copyWith(quantity: existingItem.quantity - 1),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Checkout the cart and generate a receipt
  Map<String, dynamic> checkout(BuildContext context) {
    if (_items.isEmpty) {
      return {'success': false, 'message': 'Your cart is empty!'};
    }

    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final receipt = {
      'id': orderId,
      'items':
          _items.values.map((item) {
            return {
              'name': item.name,
              'quantity': item.quantity,
              'price': item.price,
              'total': item.totalPrice,
              'specialInstructions': item.specialInstructions,
              'imageUrl': item.imageUrl,
            };
          }).toList(),
      'subtotal': totalAmount,
      'deliveryFee': 50.0,
      'total': totalAmount + 50.0,
      'timestamp': DateTime.now().toString(),
      'date': DateTime.now(),
      'status': 'Pending',
    };

    // Save to order history
    final orderHistoryService = Provider.of<OrderHistoryService>(
      context,
      listen: false,
    );
    orderHistoryService.addOrder(receipt);

    // Get current user info
    final userSession = Provider.of<UserSession>(context, listen: false);
    final currentUser = userSession.currentUser;

    // Create order data for dashboard with customer info
    final dashboardOrderData = {
      'id': orderId,
      'customerId':
          currentUser?.id ?? 'guest-${DateTime.now().millisecondsSinceEpoch}',
      'customerName': currentUser?.name ?? 'Guest User',
      'customerEmail': currentUser?.email ?? 'guest@example.com',
      'customerPhone': currentUser?.phoneNumber ?? 'N/A',
      'amount': totalAmount + 50.0, // Include delivery fee
      'date': DateTime.now(),
      'status': 'Pending',
      'items': _items.values.fold(0, (sum, item) => sum + item.quantity),
      'paymentMethod': 'Cash on Delivery',
      'deliveryFee': 50.0,
      'orderDetails':
          _items.values.map((item) {
            return {
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'imageUrl': item.imageUrl,
              'total': item.totalPrice,
            };
          }).toList(),
    };

    // Update dashboard with new order
    final dashboardService = Provider.of<DashboardService>(
      context,
      listen: false,
    );
    dashboardService.addNewOrder(dashboardOrderData);

    // Clear the cart after checkout
    clear();

    // Show delivery times page after successful checkout
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, '/delivery-times');
    });

    return {'success': true, 'receipt': receipt};
  }
}
