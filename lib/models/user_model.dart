import 'package:flutter/material.dart';

enum UserType { admin, customer, guest }

class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final UserType userType;
  final String? profileImage;
  final Map<String, dynamic> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    required this.userType,
    this.profileImage,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      profileImage: json['profileImage'],
      permissions: json['permissions'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'userType': userType.toString().split('.').last,
      'profileImage': profileImage,
      'permissions': permissions,
    };
  }

  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}';
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  Color get userColor {
    switch (userType) {
      case UserType.admin:
        return Colors.purple;
      case UserType.customer:
        return Colors.teal;
      case UserType.guest:
        return Colors.grey;
    }
  }

  IconData get userIcon {
    switch (userType) {
      case UserType.admin:
        return Icons.admin_panel_settings;
      case UserType.customer:
        return Icons.person;
      case UserType.guest:
        return Icons.person_outline;
    }
  }

  bool hasPermission(String permission) {
    return permissions[permission] == true;
  }
}
