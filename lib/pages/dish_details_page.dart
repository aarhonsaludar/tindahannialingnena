import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../services/review_service.dart';
import '../themes/filipino_theme.dart';
import '../widgets/hero_image.dart';
import '../widgets/animated_button.dart';
import '../widgets/dish_review_widget.dart';

class DishDetailsPage extends StatefulWidget {
  final Map<String, dynamic> dish;

  const DishDetailsPage({super.key, required this.dish});

  @override
  _DishDetailsPageState createState() => _DishDetailsPageState();
}

class _DishDetailsPageState extends State<DishDetailsPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final reviewService = Provider.of<ReviewService>(context);
    final avgRating = reviewService.getAverageRatingForDish(
      dish['id'] as String,
    );
    final isAvailable = dish['available'] as bool? ?? true;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero image
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: FilipinoTheme.filipiniana,
            flexibleSpace: FlexibleSpaceBar(
              background: HeroImage(
                imageUrl: dish['image'] as String,
                heroTag: 'dish_image_${dish['id']}',
                height: 250,
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {
                  // Add to favorites
                },
              ),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {
                  // Share dish
                },
              ),
            ],
          ),

          // Dish content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            dish['name'] as String,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '₱${dish['price']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                    // Rating
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < avgRating.floor()
                                ? Icons.star
                                : (index < avgRating)
                                ? Icons.star_half
                                : Icons.star_border,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '(${avgRating.toStringAsFixed(1)})',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    // Tags
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(dish['category'] as String),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                        ),
                        if (isAvailable)
                          const Chip(
                            label: Text('Available'),
                            backgroundColor: Colors.green,
                            labelStyle: TextStyle(color: Colors.white),
                          )
                        else
                          const Chip(
                            label: Text('Out of Stock'),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                      ],
                    ),

                    // Description
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dish['description'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),

                    // Divider
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Special instructions
                    const Text(
                      'Special Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _specialInstructionsController,
                      decoration: InputDecoration(
                        hintText: 'E.g., No onions, less spicy, etc.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),

                    // Quantity and add to cart section
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity selector
                            Row(
                              children: [
                                IconButton(
                                  onPressed:
                                      _quantity > 1
                                          ? () => setState(() => _quantity--)
                                          : null,
                                  icon: const Icon(Icons.remove),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _quantity++),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),

                            // Add to cart button
                            Expanded(
                              child: AnimatedButton(
                                onPressed: () => _addToCart(context, dish),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                color:
                                    isAvailable
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart),
                                    SizedBox(width: 8),
                                    Text('Add to Cart'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Reviews section
                    const SizedBox(height: 24),
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DishReviewWidget(
                      dishId: dish['id'] as String,
                      dishName: dish['name'] as String,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> dish) {
    if (!(dish['available'] as bool? ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item is not available')),
      );
      return;
    }

    final cart = Provider.of<CartModel>(context, listen: false);

    for (var i = 0; i < _quantity; i++) {
      cart.addItem(
        id: dish['id'] as String,
        name: dish['name'] as String,
        imageUrl: dish['image'] as String,
        price: dish['price'] as double,
        specialInstructions:
            _specialInstructionsController.text.isEmpty
                ? null
                : _specialInstructionsController.text,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dish['name']} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            // Show cart
          },
        ),
      ),
    );

    // Close with animation
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }
}
