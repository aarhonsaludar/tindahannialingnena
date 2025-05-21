import 'package:flutter/material.dart';

/// User profile types supported by the application
enum UserRole { owner, manager, chef, server, cashier, customer, guest }

/// Class that contains information about different user profiles
class UserProfiles {
  /// Get color associated with different user roles
  static Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return Colors.purple;
      case UserRole.manager:
        return Colors.blue;
      case UserRole.chef:
        return Colors.orange;
      case UserRole.server:
        return Colors.green;
      case UserRole.cashier:
        return Colors.amber;
      case UserRole.customer:
        return Colors.teal;
      case UserRole.guest:
        return Colors.blueGrey;
    }
  }

  /// Get icon associated with different user roles
  static IconData getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return Icons.storefront;
      case UserRole.manager:
        return Icons.manage_accounts;
      case UserRole.chef:
        return Icons.restaurant;
      case UserRole.server:
        return Icons.room_service;
      case UserRole.cashier:
        return Icons.point_of_sale;
      case UserRole.customer:
        return Icons.person;
      case UserRole.guest:
        return Icons.person_outline;
    }
  }

  /// Get permissions for different user roles
  static Map<String, bool> getRolePermissions(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return {
          'manageStaff': true,
          'viewReports': true,
          'editMenu': true,
          'manageInventory': true,
          'accessSettings': true,
          'processPayments': true,
          'viewOrders': true,
        };
      case UserRole.manager:
        return {
          'manageStaff': true,
          'viewReports': true,
          'editMenu': true,
          'manageInventory': true,
          'accessSettings': false,
          'processPayments': true,
          'viewOrders': true,
        };
      case UserRole.chef:
        return {
          'manageStaff': false,
          'viewReports': false,
          'editMenu': false,
          'manageInventory': true,
          'accessSettings': false,
          'processPayments': false,
          'viewOrders': true,
        };
      case UserRole.server:
        return {
          'manageStaff': false,
          'viewReports': false,
          'editMenu': false,
          'manageInventory': false,
          'accessSettings': false,
          'processPayments': false,
          'viewOrders': true,
        };
      case UserRole.cashier:
        return {
          'manageStaff': false,
          'viewReports': false,
          'editMenu': false,
          'manageInventory': false,
          'accessSettings': false,
          'processPayments': true,
          'viewOrders': true,
        };
      case UserRole.customer:
        return {
          'placeOrder': true,
          'viewMenu': true,
          'viewOrderHistory': true,
          'editProfile': true,
        };
      case UserRole.guest:
        return {
          'placeOrder': true,
          'viewMenu': true,
          'viewOrderHistory': false,
          'editProfile': false,
        };
    }
  }
}
