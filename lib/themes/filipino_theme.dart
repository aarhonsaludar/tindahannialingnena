import 'package:flutter/material.dart';

/// Class that provides Filipino-themed design elements
class FilipinoTheme {
  /// Primary colors inspired by Filipino cultural elements
  static const Color barongTagalog = Color(0xFFF7F7F7); // Off-white
  static const Color filipiniana = Color(0xFFBF4342); // Red
  static const Color sampaguita = Color(0xFFFFFFFF); // White
  static const Color mangga = Color(0xFFFFB30F); // Yellow/Gold
  static const Color baybayin = Color(0xFF6A3805); // Brown
  static const Color banig = Color(0xFF4CAF50); // Green
  static const Color bandila = Color(0xFF0C37BA); // Blue

  /// Background patterns inspired by Filipino textiles
  static const String inabelPattern = 'assets/patterns/inabel.png';
  static const String binakolPattern = 'assets/patterns/binakol.png';
  static const String t_nalakPattern = 'assets/patterns/t_nalak.png';

  /// Get a theme based on Filipino cultural elements
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: filipiniana,
      fontFamily: 'OpenSans', // Default body font
      colorScheme: ColorScheme.fromSeed(
        seedColor: filipiniana,
        secondary: mangga,
        tertiary: banig,
        background: barongTagalog,
      ),
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(fontFamily: 'Montserrat', color: baybayin),
        displayMedium: TextStyle(fontFamily: 'Montserrat', color: baybayin),
        displaySmall: TextStyle(fontFamily: 'Montserrat', color: baybayin),

        // Headline styles
        headlineLarge: TextStyle(fontFamily: 'Montserrat'),
        headlineMedium: TextStyle(fontFamily: 'Montserrat'),
        headlineSmall: TextStyle(fontFamily: 'Montserrat'),

        // Title styles
        titleLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),

        // Body styles use Open Sans (they'll inherit from fontFamily)
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
        bodySmall: TextStyle(),

        // Label styles
        labelLarge: TextStyle(fontFamily: 'Montserrat'),
        labelMedium: TextStyle(fontFamily: 'Montserrat'),
        labelSmall: TextStyle(fontFamily: 'Montserrat'),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: filipiniana,
        foregroundColor: sampaguita,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: sampaguita,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mangga,
          foregroundColor: baybayin,
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Get Filipino food categories
  static List<Map<String, dynamic>> getFilipinoFoodCategories() {
    return [
      {
        'name': 'Ulam (Main Dishes)',
        'icon': Icons.restaurant,
        'description': 'Main protein dishes paired with rice',
      },
      {
        'name': 'Kanin at Pancit (Rice & Noodles)',
        'icon': Icons.ramen_dining,
        'description': 'Rice dishes and Filipino noodle specialties',
      },
      {
        'name': 'Sabaw (Soups)',
        'icon': Icons.soup_kitchen,
        'description': 'Traditional Filipino soups and stews',
      },
      {
        'name': 'Pulutan (Appetizers)',
        'icon': Icons.tapas,
        'description': 'Finger foods typically served with drinks',
      },
      {
        'name': 'Meryenda (Snacks)',
        'icon': Icons.lunch_dining,
        'description': 'Mid-day snacks and light meals',
      },
      {
        'name': 'Panghimagas (Desserts)',
        'icon': Icons.icecream,
        'description': 'Sweet treats and Filipino desserts',
      },
      {
        'name': 'Inumin (Beverages)',
        'icon': Icons.local_drink,
        'description': 'Traditional and modern Filipino drinks',
      },
    ];
  }

  /// Get Filipino regional cuisine categories
  static List<Map<String, dynamic>> getFilipinoRegionalCuisines() {
    return [
      {
        'region': 'Ilocos',
        'specialties': ['Bagnet', 'Pinakbet', 'Empanada'],
        'image': 'assets/regions/ilocos.jpg',
      },
      {
        'region': 'Pampanga',
        'specialties': ['Sisig', 'Tocino', 'Morcon'],
        'image': 'assets/regions/pampanga.jpg',
      },
      {
        'region': 'Bicol',
        'specialties': ['Bicol Express', 'Laing', 'Pinangat'],
        'image': 'assets/regions/bicol.jpg',
      },
      {
        'region': 'Visayas',
        'specialties': [
          'Lechon',
          'Chicken Inasal',
          'KBL (Kadios, Baboy, Langka)',
        ],
        'image': 'assets/regions/visayas.jpg',
      },
      {
        'region': 'Mindanao',
        'specialties': ['Beef Rendang', 'Tiyula Itum', 'Pyanggang'],
        'image': 'assets/regions/mindanao.jpg',
      },
    ];
  }
}
