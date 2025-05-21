import 'package:flutter/material.dart';

class RestaurantAppController {
  static final RestaurantAppController _instance =
      RestaurantAppController._internal();

  factory RestaurantAppController() {
    return _instance;
  }

  RestaurantAppController._internal();

  // This is a simple method to navigate to the main home with the bottom navigation bar
  void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  // Helper method to handle guest login
  void loginAsGuest(BuildContext context) {
    // In a real app, you might set some user state here
    goToHome(context);
  }
}
