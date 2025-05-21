import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../themes/filipino_theme.dart';
import '../utils/user_session.dart';
import 'customer_registration_page.dart';
import '../widgets/animated_button.dart'; // Import animated button
import '../utils/transitions.dart'; // Import transitions

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// Change from SingleTickerProviderStateMixin to TickerProviderStateMixin
class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isLoginForm = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  late TabController _tabController;
  int _selectedUserType = 0; // 0: Customer, 1: Admin

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedUserType = _tabController.index;
        _clearForm();
      });
    });

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
      _clearForm();
    });
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _errorMessage = null;
  }

  void _fillDemoCredentials() {
    setState(() {
      switch (_selectedUserType) {
        case 0: // Customer
          _emailController.text = 'customer@example.com';
          _passwordController.text = 'customer123';
          break;
        case 1: // Admin
          _emailController.text = 'admin@tindahan.com';
          _passwordController.text = 'admin123';
          break;
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the UserSession from context
      final userSession = Provider.of<UserSession>(context, listen: false);

      // Login with entered credentials
      final user = await userSession.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (user != null) {
        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => const MyHomePage(title: 'Tindahan Ni Aling Nena'),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the UserSession from context
      final userSession = Provider.of<UserSession>(context, listen: false);

      // Login as guest
      await userSession.continueAsGuest();

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => const MyHomePage(title: 'Tindahan Ni Aling Nena'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToRegistration() {
    Navigator.of(context).push(
      Transitions.slideTransition(
        const CustomerRegistrationPage(),
        beginOffset: const Offset(0.0, 1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: FilipinoTheme.barongTagalog,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo and title section
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: FilipinoTheme.filipiniana,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tindahan Ni Aling Nena',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FilipinoTheme.filipiniana,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to your account',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),

                      // Error message display
                      if (_errorMessage != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Login form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email field with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator:
                                    (val) =>
                                        val!.isEmpty
                                            ? 'Email cannot be empty'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password field with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 800),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator:
                                    (val) =>
                                        val!.isEmpty
                                            ? 'Password cannot be empty'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Login button using animated button widget
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1000),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: AnimatedButton(
                                  onPressed: _submitForm,
                                  isLoading: _isLoading,
                                  color: FilipinoTheme.filipiniana,
                                  borderRadius: 12,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // "Continue as guest" button with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1200),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(opacity: value, child: child);
                              },
                              child: TextButton(
                                onPressed: _continueAsGuest,
                                child: const Text('Continue as Guest'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Divider with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1400),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(opacity: value, child: child);
                              },
                              child: Row(
                                children: const [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text('OR'),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Register button with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1600),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Opacity(opacity: value, child: child);
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: _navigateToRegistration,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Create Account'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to check if asset exists
  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(assetPath);
      return true;
    } catch (e) {
      print('Asset not found: $e');
      return false;
    }
  }
}
