import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? address;
  final DateTime createdAt;
  final List<Order> orders;

  Customer({
    String? id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.address,
    DateTime? createdAt,
    List<Order>? orders,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       orders = orders ?? [];

  // Add a new order to this customer
  void addOrder(Order order) {
    orders.add(order);
  }

  // Calculate total spent by this customer
  double get totalSpent =>
      orders.fold(0.0, (total, order) => total + order.totalAmount);

  // Get count of orders within a specific time period
  int getOrderCountSince(DateTime date) {
    return orders.where((order) => order.orderDate.isAfter(date)).length;
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double deliveryFee;
  final String status;
  final DateTime orderDate;
  final String? specialInstructions;
  final String paymentMethod;

  Order({
    String? id,
    required this.items,
    this.deliveryFee = 50.0,
    this.status = 'Pending',
    DateTime? orderDate,
    this.specialInstructions,
    this.paymentMethod = 'Cash on Delivery',
  }) : id = id ?? const Uuid().v4(),
       orderDate = orderDate ?? DateTime.now();

  // Calculate total order amount including delivery fee
  double get totalAmount =>
      items.fold(0.0, (total, item) => total + item.price * item.quantity) +
      deliveryFee;

  // Calculate total number of items in the order
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String? specialInstructions;

  OrderItem({
    String? id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
    this.specialInstructions,
  }) : id = id ?? const Uuid().v4();
}
