import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserSession extends ChangeNotifier {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  final AuthService _authService = AuthService();
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _authService.isAuthenticated();
  bool get isAdmin => _currentUser?.userType == UserType.admin;
  bool get isCustomer => _currentUser?.userType == UserType.customer;
  bool get isGuest => _currentUser?.userType == UserType.guest;

  int get defaultPageIndex => _authService.getDefaultPageIndex();

  Future<User?> login(String email, String password) async {
    final user = await _authService.login(email, password);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<User> continueAsGuest() async {
    final user = await _authService.continueAsGuest();
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    notifyListeners();
  }

  bool hasPermission(String permission) {
    return _currentUser?.hasPermission(permission) ?? false;
  }
}
