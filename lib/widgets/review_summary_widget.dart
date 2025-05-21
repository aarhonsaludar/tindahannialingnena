import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import '../pages/dish_reviews_page.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final String dishId;
  final String dishName;

  const ReviewSummaryWidget({
    Key? key,
    required this.dishId,
    required this.dishName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewService>(
      builder: (context, reviewService, child) {
        final summary = reviewService.getReviewSummaryForDish(dishId);
        final commonTags = reviewService.getCommonTagsForDish(dishId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Average rating with stars
            Row(
              children: [
                Text(
                  summary.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < summary.averageRating.floor()
                          ? Icons.star
                          : (index < summary.averageRating)
                          ? Icons.star_half
                          : Icons.star_border,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${summary.totalReviews})',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),

            // Common tags if available
            if (commonTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    commonTags
                        .take(3)
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(fontSize: 12),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
              ),
            ],

            // View all reviews button
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            DishReviewsPage(dishId: dishId, dishName: dishName),
                  ),
                );
              },
              child: Text(
                summary.totalReviews > 0
                    ? 'View all ${summary.totalReviews} reviews'
                    : 'Be the first to review',
              ),
            ),
          ],
        );
      },
    );
  }
}
