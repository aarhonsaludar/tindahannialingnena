import '../models/user_model.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Demo users for testing - only admin and customer
  final List<Map<String, dynamic>> _demoUsers = [
    // Admin user
    {
      'id': 'admin-1',
      'email': 'admin@tindahan.com',
      'password': 'admin123',
      'name': 'Aling Nena',
      'userType': 'admin',
      'phoneNumber': '+63 917 123 4567',
      'permissions': {
        'manageStaff': true,
        'manageMenu': true,
        'viewReports': true,
        'manageSettings': true,
        'processPayments': true,
        'viewOrders': true,
        'editOrders': true,
      },
    },

    // Customer user
    {
      'id': 'customer-1',
      'email': 'customer@example.com',
      'password': 'customer123',
      'name': 'Elena Reyes',
      'userType': 'customer',
      'phoneNumber': '+63 917 567 8901',
      'address': '123 Mabini St., Manila',
      'permissions': {
        'placeOrders': true,
        'viewOrderHistory': true,
        'editProfile': true,
      },
    },
  ];

  // Login method that returns different types of users
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user with matching credentials
    final userMap = _demoUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (userMap.isEmpty) {
      return null; // Authentication failed
    }

    // Create user object
    _currentUser = User.fromJson(userMap);
    return _currentUser;
  }

  // Register a new customer account
  Future<Map<String, dynamic>> registerCustomer({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? address,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
    final existingUser = _demoUsers.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      return {
        'success': false,
        'message': 'An account with this email already exists',
      };
    }

    // Create a new user ID
    final userId = 'customer-${DateTime.now().millisecondsSinceEpoch}';

    // Create new user map
    final newUserMap = {
      'id': userId,
      'email': email,
      'password': password, // In a real app, this would be hashed
      'name': name,
      'userType': 'customer',
      'phoneNumber': phone,
      'address': address,
      'permissions': {
        'placeOrders': true,
        'viewOrderHistory': true,
        'editProfile': true,
      },
    };

    // Add user to demo users list (in a real app, this would be saved to a database)
    _demoUsers.add(newUserMap);

    // Create user object
    final newUser = User.fromJson(newUserMap);

    return {
      'success': true,
      'message': 'Registration successful',
      'user': newUser,
    };
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required String name,
    String? phoneNumber,
    String? address,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user with matching ID
    final userIndex = _demoUsers.indexWhere((user) => user['id'] == userId);

    if (userIndex == -1) {
      return {'success': false, 'message': 'User not found'};
    }

    // Update user data
    _demoUsers[userIndex]['name'] = name;
    _demoUsers[userIndex]['phoneNumber'] = phoneNumber;
    _demoUsers[userIndex]['address'] = address;

    // Get updated user
    final updatedUserMap = _demoUsers[userIndex];
    final updatedUser = User.fromJson(updatedUserMap);

    // Update current user if this is the logged in user
    if (_currentUser?.id == userId) {
      _currentUser = updatedUser;
    }

    return {
      'success': true,
      'message': 'Profile updated successfully',
      'user': updatedUser,
    };
  }

  // Get default starting page index based on user type
  int getDefaultPageIndex() {
    if (_currentUser == null) return 0;

    switch (_currentUser!.userType) {
      case UserType.admin:
        return 3; // Admin dashboard index
      default:
        return 0; // Home page for customers and guests
    }
  }

  // Continue as guest
  Future<User> continueAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: 'guest-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest User',
      email: 'guest@example.com',
      userType: UserType.guest,
      permissions: {'placeOrders': true, 'viewMenu': true},
    );

    return _currentUser!;
  }

  // Logout method
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }

  // Get user type name - remove staff
  String getUserTypeName(UserType type) {
    switch (type) {
      case UserType.admin:
        return 'Administrator';
      case UserType.customer:
        return 'Customer';
      case UserType.guest:
        return 'Guest';
    }
  }
}
