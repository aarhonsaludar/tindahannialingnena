import 'package:flutter/foundation.dart';

class MenuService extends ChangeNotifier {
  final List<Map<String, dynamic>> _dumpMenus = [
    // Main Dishes
    {
      'id': '1',
      'name': 'Adobo (Chicken or Pork)',
      'category': 'Main Dishes',
      'price': 180.0,
      'image': 'assets/img/adobo.png',
      'description':
          'Chicken or pork marinated in vinegar, soy sauce, and spices',
      'available': true,
    },
    {
      'id': '2',
      'name': 'Kare-Kare',
      'category': 'Main Dishes',
      'price': 250.0,
      'image': 'assets/img/kare_kare.jpg',
      'description': 'Oxtail peanut stew with vegetables',
      'available': true,
    },
    {
      'id': '3',
      'name': 'Bistek Tagalog',
      'category': 'Main Dishes',
      'price': 200.0,
      'image': 'assets/img/bistek_tagalog.jpg',
      'description': 'Filipino beef steak with soy sauce and calamansi',
      'available': true,
    },
    {
      'id': '4',
      'name': 'Sinigang na Baboy',
      'category': 'Main Dishes',
      'price': 220.0,
      'image': 'assets/img/sinigang_baboy.jpg',
      'description': 'Pork sour soup with vegetables',
      'available': true,
    },
    {
      'id': '5',
      'name': 'Lechon Kawali',
      'category': 'Main Dishes',
      'price': 250.0,
      'image': 'assets/img/lechon_kawali.jpg',
      'description': 'Crispy fried pork belly',
      'available': true,
    },
    {
      'id': '6',
      'name': 'Pancit Canton',
      'category': 'Noodles',
      'price': 150.0,
      'image': 'assets/img/pancit_canton.jpg',
      'description': 'Stir-fried noodles with vegetables and meat',
      'available': true,
    },
    {
      'id': '7',
      'name': 'Lumpiang Shanghai',
      'category': 'Appetizers',
      'price': 120.0,
      'image': 'assets/img/lumpiang_shanghai.jpg',
      'description': 'Fried spring rolls with ground pork and vegetables',
      'available': true,
    },
    {
      'id': '8',
      'name': 'Halo-Halo',
      'category': 'Desserts',
      'price': 100.0,
      'image': 'assets/img/halo_halo.jpg',
      'description':
          'Mixed dessert with shaved ice, milk, and various ingredients',
      'available': true,
    },
    {
      'id': '9',
      'name': 'Bibingka',
      'category': 'Desserts',
      'price': 80.0,
      'image': 'assets/img/bibingka.jpg',
      'description': 'Rice cake with coconut and cheese',
      'available': true,
    },
    {
      'id': '10',
      'name': 'Turon',
      'category': 'Desserts',
      'price': 50.0,
      'image': 'assets/img/turon.jpg',
      'description': 'Fried banana rolls with caramelized sugar',
      'available': true,
    },
    {
      'id': '11',
      'name': 'Taho',
      'category': 'Desserts',
      'price': 30.0,
      'image': 'assets/img/taho.jpg',
      'description': 'Silken tofu with syrup and tapioca pearls',
      'available': true,
    },
    {
      'id': '12',
      'name': 'Sago\'t Gulaman',
      'category': 'Beverages',
      'price': 40.0,
      'image': 'assets/img/sagot_gulaman.jpg',
      'description': 'Sweet drink with tapioca pearls and gelatin',
      'available': true,
    },
    {
      'id': '13',
      'name': 'Buko Juice',
      'category': 'Beverages',
      'price': 50.0,
      'image': 'assets/img/buko_juice.jpg',
      'description': 'Fresh coconut juice',
      'available': true,
    },
    {
      'id': '14',
      'name': 'Calamansi Juice',
      'category': 'Beverages',
      'price': 30.0,
      'image': 'assets/img/calamansi_juice.jpg',
      'description': 'Fresh calamansi juice',
      'available': true,
    },
    {
      'id': '15',
      'name': 'Sinigang na Hipon',
      'category': 'Main Dishes',
      'price': 230.0,
      'image': 'assets/img/sinigang_na_hipon.jpg',
      'description': 'Shrimp sour soup with vegetables',
      'available': true,
    },
    {
      'id': '16',
      'name': 'Pinakbet',
      'category': 'Main Dishes',
      'price': 180.0,
      'image': 'assets/img/pinakbet.jpg',
      'description': 'Mixed vegetables with shrimp paste',
      'available': true,
    },
    {
      'id': '17',
      'name': 'Chicken Inasal',
      'category': 'Main Dishes',
      'price': 200.0,
      'image': 'assets/img/chicken_inasal.jpg',
      'description': 'Grilled chicken marinated in vinegar and spices',
      'available': true,
    },
    {
      'id': '18',
      'name': 'Pork Sisig',
      'category': 'Main Dishes',
      'price': 220.0,
      'image': 'assets/img/pork_sisig.jpg',
      'description': 'Sizzling chopped pork with onions and chili',
      'available': true,
    },
    {
      'id': '19',
      'name': 'Laing',
      'category': 'Main Dishes',
      'price': 180.0,
      'image': 'assets/img/laing.jpg',
      'description': 'Taro leaves cooked in coconut milk',
      'available': true,
    },
    {
      'id': '20',
      'name': 'Ginataang Kalabasa',
      'category': 'Main Dishes',
      'price': 200.0,
      'image': 'assets/img/ginataang_kalabasa.jpg',
      'description': 'Squash and string beans cooked in coconut milk',
      'available': true,
    },
    {
      'id': '21',
      'name': 'Pancit Malabon',
      'category': 'Noodles',
      'price': 160.0,
      'image': 'assets/img/pancit_malabon.jpg',
      'description': 'Thick noodles with seafood and sauce',
      'available': true,
    },
    {
      'id': '22',
      'name': 'Pancit Palabok',
      'category': 'Noodles',
      'price': 150.0,
      'image': 'assets/img/pancit_palabok.jpg',
      'description': 'Rice noodles with shrimp sauce and toppings',
      'available': true,
    },
    {
      'id': '23',
      'name': 'Arroz Caldo',
      'category': 'Main Dishes',
      'price': 120.0,
      'image': 'assets/img/arroz_caldo.jpg',
      'description': 'Rice porridge with chicken and ginger',
      'available': true,
    },
    {
      'id': '24',
      'name': 'Goto',
      'category': 'Main Dishes',
      'price': 130.0,
      'image': 'assets/img/goto.jpg',
      'description': 'Rice porridge with tripe and ginger',
      'available': true,
    },
    {
      'id': '25',
      'name': 'Tokwa\'t Baboy',
      'category': 'Appetizers',
      'price': 100.0,
      'image': 'assets/img/tokwat_baboy.jpg',
      'description': 'Fried tofu and pork with vinegar sauce',
      'available': true,
    },
    {
      'id': '26',
      'name': 'Chicharon Bulaklak',
      'category': 'Appetizers',
      'price': 150.0,
      'image': 'assets/img/chicharon_bulaklak.jpg',
      'description': 'Deep-fried pork intestines',
      'available': true,
    },
    {
      'id': '27',
      'name': 'Balut',
      'category': 'Appetizers',
      'price': 20.0,
      'image': 'assets/img/balut.jpg',
      'description': 'Fertilized duck egg',
      'available': true,
    },
    {
      'id': '28',
      'name': 'Isaw',
      'category': 'Appetizers',
      'price': 10.0,
      'image': 'assets/img/isaw.jpg',
      'description': 'Grilled chicken intestines',
      'available': true,
    },
    {
      'id': '29',
      'name': 'Taho',
      'category': 'Beverages',
      'price': 30.0,
      'image': 'assets/img/taho.jpg',
      'description': 'Silken tofu with syrup and tapioca pearls',
      'available': true,
    },
    {
      'id': '30',
      'name': 'Salabat',
      'category': 'Beverages',
      'price': 40.0,
      'image': 'assets/img/salabat.jpg',
      'description': 'Ginger tea',
      'available': true,
    },
  ];

  // Dynamic menus (these can be modified)
  final List<Map<String, dynamic>> _dynamicMenus = [];

  List<Map<String, dynamic>> get allMenus => [..._dumpMenus, ..._dynamicMenus];
  List<Map<String, dynamic>> get dumpMenus => List.unmodifiable(_dumpMenus);
  List<Map<String, dynamic>> get dynamicMenus =>
      List.unmodifiable(_dynamicMenus);

  void addMenu(Map<String, dynamic> newMenu) {
    // Ensure the ID is unique
    String newId =
        newMenu['id'] as String? ??
        'item_${DateTime.now().millisecondsSinceEpoch}';
    newMenu['id'] = newId;

    // Add default "available" flag if not present
    if (!newMenu.containsKey('available')) {
      newMenu['available'] = true;
    }

    _dynamicMenus.add(newMenu);
    notifyListeners(); // Notify listeners to update UI
  }

  void updateMenu(String id, Map<String, dynamic> updatedMenu) {
    final index = _dynamicMenus.indexWhere((menu) => menu['id'] == id);
    if (index != -1) {
      _dynamicMenus[index] = updatedMenu;
      notifyListeners(); // Notify listeners to update UI
    }
  }

  void deleteMenu(String id) {
    _dynamicMenus.removeWhere((menu) => menu['id'] == id);
    notifyListeners(); // Notify listeners to update UI
  }

  // Toggle availability for dump menu items (for testing)
  void toggleAvailability(String id) {
    // Check in dynamic menus first
    final dynamicIndex = _dynamicMenus.indexWhere((menu) => menu['id'] == id);
    if (dynamicIndex != -1) {
      _dynamicMenus[dynamicIndex]['available'] =
          !_dynamicMenus[dynamicIndex]['available'];
      notifyListeners();
      return;
    }

    // Then check in dump menus
    final dumpIndex = _dumpMenus.indexWhere((menu) => menu['id'] == id);
    if (dumpIndex != -1) {
      _dumpMenus[dumpIndex]['available'] = !_dumpMenus[dumpIndex]['available'];
      notifyListeners();
    }
  }
}
