import 'package:flutter/material.dart';
import '../widgets/dish_review_widget.dart';

class DishReviewsPage extends StatelessWidget {
  final String dishId;
  final String dishName;

  const DishReviewsPage({
    super.key,
    required this.dishId,
    required this.dishName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text('Reviews for $dishName'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: DishReviewWidget(dishId: dishId, dishName: dishName),
      ),
    );
  }
}
