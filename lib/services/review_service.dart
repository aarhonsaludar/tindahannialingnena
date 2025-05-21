import 'package:flutter/foundation.dart';
import '../models/review_model.dart';
import '../utils/user_session.dart';

class ReviewService extends ChangeNotifier {
  // Mock review data
  final List<Review> _reviews = [
    Review(
      id: '1',
      userId: 'customer-1',
      userName: 'Elena Reyes',
      userImage: null,
      dishId: '1',
      dishName: 'Adobo (Chicken or Pork)',
      rating: 5.0,
      review:
          'Absolutely delicious! The perfect balance of salty, sour, and savory. Just like my lola used to make.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      tags: ['Authentic', 'Flavorful', 'Must-try'],
      helpfulCount: 8,
      verified: true,
    ),
    Review(
      id: '2',
      userId: 'guest-123456',
      userName: 'Juan Dela Cruz',
      dishId: '1',
      dishName: 'Adobo (Chicken or Pork)',
      rating: 4.0,
      review:
          'Very good adobo. The meat was tender and the sauce was flavorful. Would order again.',
      date: DateTime.now().subtract(const Duration(days: 7)),
      tags: ['Family-favorite', 'Tender'],
      helpfulCount: 3,
    ),
    Review(
      id: '3',
      userId: 'customer-2',
      userName: 'Maria Santos',
      dishId: '2',
      dishName: 'Kare-Kare',
      rating: 5.0,
      review:
          'The best kare-kare in town! The sauce is creamy and the bagoong is perfect with it.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['Creamy', 'Authentic'],
      helpfulCount: 12,
      verified: true,
    ),
    Review(
      id: '4',
      userId: 'guest-789012',
      userName: 'Pedro Reyes',
      dishId: '6',
      dishName: 'Pancit Canton',
      rating: 3.0,
      review:
          'Decent pancit. Could use more vegetables and the noodles were a bit overcooked.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['Filling'],
      helpfulCount: 1,
    ),
    Review(
      id: '5',
      userId: 'customer-3',
      userName: 'Ana Dizon',
      userImage: null,
      dishId: '8',
      dishName: 'Halo-Halo',
      rating: 5.0,
      review:
          'Perfect dessert for hot days! So many ingredients and the ube ice cream on top was amazing.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['Sweet', 'Refreshing'],
      helpfulCount: 7,
      verified: true,
      replies: [
        ReviewReply(
          id: 'r1',
          userId: 'admin-1',
          userName: 'Aling Nena',
          content:
              'Thank you for your kind words, Ana! We\'re glad you enjoyed our special halo-halo recipe.',
          date: DateTime.now().subtract(const Duration(hours: 12)),
          isOwner: true,
        ),
      ],
    ),
  ];

  List<Review> get reviews => List.unmodifiable(_reviews);

  ReviewSummary getReviewSummaryForDish(String dishId) {
    final dishReviews =
        _reviews.where((review) => review.dishId == dishId).toList();
    return ReviewSummary.fromReviews(dishId, dishReviews);
  }

  List<Review> getReviewsForDish(
    String dishId, {
    SortCriterion sortBy = SortCriterion.mostRecent,
  }) {
    final dishReviews =
        _reviews.where((review) => review.dishId == dishId).toList();

    switch (sortBy) {
      case SortCriterion.highestRated:
        dishReviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortCriterion.lowestRated:
        dishReviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortCriterion.mostHelpful:
        dishReviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
      case SortCriterion.mostRecent:
      default:
        dishReviews.sort((a, b) => b.date.compareTo(a.date));
    }

    return dishReviews;
  }

  List<Review> filterReviewsByRating(List<Review> reviews, int rating) {
    return reviews.where((review) => review.rating.round() == rating).toList();
  }

  List<Review> getReviewsByUser(String userId) {
    return _reviews.where((review) => review.userId == userId).toList();
  }

  Future<void> addReview({
    required String userId,
    required String userName,
    String? userImage,
    required String dishId,
    required String dishName,
    required double rating,
    required String review,
    required List<String> tags,
    List<String> images = const [],
  }) async {
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      userImage: userImage,
      dishId: dishId,
      dishName: dishName,
      rating: rating,
      review: review,
      date: DateTime.now(),
      tags: tags,
      images: images,
      verified: true, // Assuming the review is from a verified purchase
    );

    _reviews.add(newReview);
    notifyListeners();
  }

  Future<void> markReviewHelpful(String reviewId, String userId) async {
    final index = _reviews.indexWhere((review) => review.id == reviewId);
    if (index != -1) {
      final review = _reviews[index];
      if (!review.userIdsWhoMarkedHelpful.contains(userId)) {
        final updatedReview = review.copyWith(
          helpfulCount: review.helpfulCount + 1,
          userIdsWhoMarkedHelpful: [...review.userIdsWhoMarkedHelpful, userId],
        );
        _reviews[index] = updatedReview;
        notifyListeners();
      }
    }
  }

  Future<void> addReplyToReview(String reviewId, ReviewReply reply) async {
    final index = _reviews.indexWhere((review) => review.id == reviewId);
    if (index != -1) {
      final review = _reviews[index];
      final updatedReview = review.copyWith(
        replies: [...review.replies, reply],
      );
      _reviews[index] = updatedReview;
      notifyListeners();
    }
  }

  Future<void> deleteReview(String reviewId) async {
    _reviews.removeWhere((review) => review.id == reviewId);
    notifyListeners();
  }

  double getAverageRatingForDish(String dishId) {
    final dishReviews =
        _reviews.where((review) => review.dishId == dishId).toList();
    if (dishReviews.isEmpty) return 0;

    final sum = dishReviews.fold(0.0, (sum, review) => sum + review.rating);
    return sum / dishReviews.length;
  }

  List<String> getCommonTagsForDish(String dishId) {
    final dishReviews =
        _reviews.where((review) => review.dishId == dishId).toList();
    if (dishReviews.isEmpty) return [];

    // Count tag occurrences
    Map<String, int> tagCounts = {};
    for (var review in dishReviews) {
      for (var tag in review.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    // Sort by frequency
    final sortedTags =
        tagCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Return top tags (max 5)
    return sortedTags.take(5).map((e) => e.key).toList();
  }
}
