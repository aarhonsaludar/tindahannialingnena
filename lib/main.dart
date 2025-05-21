import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/landing_page.dart';
import 'pages/deals_menu_page.dart';
import 'pages/profile_page.dart';
import 'pages/location_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/orders_page.dart';
import 'pages/menu_management_page.dart';
import 'pages/settings_page.dart';
import 'themes/filipino_theme.dart';
import 'utils/user_session.dart';
import 'models/cart_model.dart';
import 'pages/splash_screen.dart';
import 'services/menu_service.dart';
import 'services/order_history_service.dart';
import 'services/review_service.dart';
import 'services/auth_service.dart';
import 'services/dashboard_service.dart'; // Add this import
import 'pages/order_history_page.dart';
import 'pages/delivery_times_page.dart';
import 'pages/customer_registration_page.dart';
import 'pages/edit_profile_page.dart';
import 'utils/transitions.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserSession()),
        ChangeNotifierProvider(create: (context) => CartModel()),
        Provider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MenuService()),
        ChangeNotifierProvider(create: (context) => OrderHistoryService()),
        ChangeNotifierProvider(create: (context) => ReviewService()),
        ChangeNotifierProvider(
          create: (context) => DashboardService(),
        ), // Add this provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: false);

    return MaterialApp(
      title: 'Tindahan Ni Aling Nena',
      debugShowCheckedModeBanner: false,
      theme: FilipinoTheme.getTheme(),
      home: userSession.isAdmin ? const DashboardPage() : const SplashScreen(),
      onGenerateRoute: (settings) {
        // Custom route transitions based on route name
        switch (settings.name) {
          case '/home':
            return Transitions.fadeTransition(
              const MyHomePage(title: 'Tindahan Ni Aling Nena'),
            );
          case '/landing':
            return Transitions.fadeTransition(const LandingPage());
          case '/deals':
            return Transitions.slideTransition(const DealsMenuPage());
          case '/profile':
            return Transitions.slideTransition(const ProfilePage());
          case '/location':
            return Transitions.slideTransition(const LocationPage());
          case '/dashboard':
            return Transitions.scaleTransition(const DashboardPage());
          case '/orders':
            return Transitions.slideTransition(const OrdersPage());
          case '/menu-management':
            return Transitions.slideTransition(const MenuManagementPage());
          case '/settings':
            return Transitions.slideTransition(const SettingsPage());
          case '/order-history':
            return Transitions.slideTransition(const OrderHistoryPage());
          case '/delivery-times':
            return Transitions.scaleTransition(const DeliveryTimesPage());
          case '/register':
            return Transitions.slideTransition(
              const CustomerRegistrationPage(),
              beginOffset: const Offset(0.0, 1.0),
            );
          case '/edit-profile':
            return Transitions.fadeTransition(const EditProfilePage());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = 'Tindahan Ni Aling Nena'});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Set initial index to 0, will be updated in didChangeDependencies
    _currentIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the user session
    final userSession = Provider.of<UserSession>(context);

    // Set appropriate starting page based on user type
    _currentIndex = userSession.defaultPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final isAdmin = userSession.isAdmin;

    // Show different pages based on user type
    final List<Widget> pages = [
      if (!isAdmin) const LandingPage(), // Home (Landing Page) for non-admins
      if (!isAdmin) const DealsMenuPage(), // Menu for non-admins
      const ProfilePage(), // Profile
      if (isAdmin) const DashboardPage(), // Admin Dashboard
      if (isAdmin) const MenuManagementPage(), // Menu Management for admin
    ];

    // Create bottom navigation items based on user role
    List<BottomNavigationBarItem> navigationItems = [
      if (!isAdmin)
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      if (!isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Menu Management',
        ),
    ];

    // Ensure current index is valid
    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      drawer: _buildDrawer(userSession),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index, pages.length),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: navigationItems,
      ),
    );
  }

  void _onItemTapped(int index, int pageCount) {
    // Make sure the selected index is valid
    if (index < pageCount) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildDrawer(UserSession userSession) {
    final currentUser = userSession.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    currentUser?.initials ?? 'AN',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  currentUser?.name ?? 'Tindahan Ni Aling Nena',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userSession.isAuthenticated
                      ? userSession.isAdmin
                          ? 'Administrator'
                          : 'Customer'
                      : 'Guest User',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Common navigation for all users
          if (!userSession.isAdmin)
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
          if (!userSession.isAdmin)
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Menu'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              setState(() {
                _currentIndex = userSession.isAdmin ? 1 : 2;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            onTap: () {
              Navigator.pushNamed(context, '/location');
            },
          ),

          // Only show order history for customers and guests
          if (!userSession.isAdmin) ...[
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Order History'),
              onTap: () {
                // Navigate to order history page
                Navigator.pushNamed(context, '/order-history');
                Navigator.pop(context);
              },
            ),
          ],

          Divider(),

          // Admin Navigation - ONLY for admin
          if (userSession.isAdmin) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'MANAGEMENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Orders'),
              onTap: () {
                Navigator.pushNamed(context, '/orders');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('Menu Management'),
              onTap: () {
                Navigator.pushNamed(context, '/menu-management');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
                Navigator.pop(context);
              },
            ),
            Divider(),
          ],

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
