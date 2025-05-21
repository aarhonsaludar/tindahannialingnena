import 'package:flutter/foundation.dart';

class OrderHistoryService extends ChangeNotifier {
  final List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get orderHistory =>
      List.unmodifiable(_orderHistory);

  void addOrder(Map<String, dynamic> order) {
    _orderHistory.insert(0, order); // Add new orders at the beginning
    notifyListeners();
  }

  void clearHistory() {
    _orderHistory.clear();
    notifyListeners();
  }
}
