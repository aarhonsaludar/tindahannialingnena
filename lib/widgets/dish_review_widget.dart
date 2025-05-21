import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import '../utils/user_session.dart';
import '../utils/format_utils.dart';

class DishReviewWidget extends StatefulWidget {
  final String dishId;
  final String dishName;

  const DishReviewWidget({
    Key? key,
    required this.dishId,
    required this.dishName,
  }) : super(key: key);

  @override
  _DishReviewWidgetState createState() => _DishReviewWidgetState();
}

class _DishReviewWidgetState extends State<DishReviewWidget> {
  SortCriterion _sortBy = SortCriterion.mostRecent;
  int? _filterRating;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewService>(
      builder: (context, reviewService, child) {
        final summary = reviewService.getReviewSummaryForDish(widget.dishId);
        final reviews = reviewService.getReviewsForDish(
          widget.dishId,
          sortBy: _sortBy,
        );
        final filteredReviews =
            _filterRating != null
                ? reviewService.filterReviewsByRating(reviews, _filterRating!)
                : reviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewSummary(context, summary),
            const SizedBox(height: 16),
            _buildFilterAndSortOptions(context),
            const SizedBox(height: 16),
            _buildReviewList(context, filteredReviews),
            if (filteredReviews.isEmpty) _buildNoReviewsMessage(context),
            const SizedBox(height: 16),
            _buildWriteReviewButton(context),
          ],
        );
      },
    );
  }

  Widget _buildReviewSummary(BuildContext context, ReviewSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ratings & Reviews',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          summary.averageRating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${summary.totalReviews} ${summary.totalReviews == 1 ? 'review' : 'reviews'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final ratingValue = 5 - index;
                      final count =
                          summary.ratingDistribution[ratingValue] ?? 0;
                      final percentage =
                          summary.totalReviews > 0
                              ? count / summary.totalReviews
                              : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Text(
                              '$ratingValue',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.grey[200],
                                color: Theme.of(context).colorScheme.secondary,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$count',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSortOptions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text('Filter & Sort'),
            ),
            Row(
              children: [
                // Rating filter chips
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _filterRating == null,
                          onSelected: (selected) {
                            setState(() {
                              _filterRating = null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ...List.generate(5, (index) {
                          final rating = 5 - index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('$rating'),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color:
                                        _filterRating == rating
                                            ? Colors.white
                                            : Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                  ),
                                ],
                              ),
                              selected: _filterRating == rating,
                              onSelected: (selected) {
                                setState(() {
                                  _filterRating = selected ? rating : null;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // Sort dropdown
                PopupMenuButton<SortCriterion>(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort by',
                  onSelected: (SortCriterion value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: SortCriterion.mostRecent,
                          child: Text('Most Recent'),
                        ),
                        const PopupMenuItem(
                          value: SortCriterion.highestRated,
                          child: Text('Highest Rated'),
                        ),
                        const PopupMenuItem(
                          value: SortCriterion.lowestRated,
                          child: Text('Lowest Rated'),
                        ),
                        const PopupMenuItem(
                          value: SortCriterion.mostHelpful,
                          child: Text('Most Helpful'),
                        ),
                      ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList(BuildContext context, List<Review> reviews) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return _buildReviewItem(context, reviews[index]);
      },
    );
  }

  Widget _buildReviewItem(BuildContext context, Review review) {
    final userSession = Provider.of<UserSession>(context, listen: false);
    final currentUserId = userSession.currentUser?.id;
    final hasMarkedHelpful =
        currentUserId != null &&
        review.userIdsWhoMarkedHelpful.contains(currentUserId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage:
                      review.userImage != null
                          ? NetworkImage(review.userImage!)
                          : null,
                  child:
                      review.userImage == null
                          ? Text(
                            review.userName.isNotEmpty
                                ? review.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          )
                          : null,
                ),
                const SizedBox(width: 12),

                // User info and rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatDate(review.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          if (review.verified)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.verified_user,
                                size: 14,
                                color: Colors.green[700],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Review content
            const SizedBox(height: 12),
            Text(review.review),

            // Review tags
            if (review.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      review.tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              labelStyle: const TextStyle(fontSize: 12),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                ),
              ),

            // Review images
            if (review.images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            review.images[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Mark helpful and replies
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Helpful button
                  TextButton.icon(
                    onPressed:
                        hasMarkedHelpful
                            ? null
                            : () {
                              if (currentUserId != null) {
                                final reviewService =
                                    Provider.of<ReviewService>(
                                      context,
                                      listen: false,
                                    );
                                reviewService.markReviewHelpful(
                                  review.id,
                                  currentUserId,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You need to be logged in to mark reviews as helpful',
                                    ),
                                  ),
                                );
                              }
                            },
                    icon: Icon(
                      hasMarkedHelpful
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      size: 16,
                    ),
                    label: Text(
                      'Helpful (${review.helpfulCount})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),

                  // Reply button
                  TextButton.icon(
                    onPressed: () {
                      _showReplyDialog(context, review.id);
                    },
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Reply', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            // Replies section
            if (review.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      review.replies
                          .map((reply) => _buildReply(context, reply))
                          .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReply(BuildContext context, ReviewReply reply) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    reply.isOwner
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[400],
                backgroundImage:
                    reply.userImage != null
                        ? NetworkImage(reply.userImage!)
                        : null,
                child:
                    reply.userImage == null
                        ? Text(
                          reply.userName.isNotEmpty
                              ? reply.userName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 8),
              Text(
                reply.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              if (reply.isOwner)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Owner',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              const Spacer(),
              Text(
                formatDate(reply.date),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 4.0),
            child: Text(reply.content),
          ),
        ],
      ),
    );
  }

  Widget _buildNoReviewsMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to review this dish',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWriteReviewButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          _showReviewDialog(context);
        },
        icon: const Icon(Icons.rate_review),
        label: const Text('Write a Review'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: false);
    if (!userSession.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to write a review'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => WriteReviewPage(
              dishId: widget.dishId,
              dishName: widget.dishName,
            ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String reviewId) {
    final userSession = Provider.of<UserSession>(context, listen: false);
    if (!userSession.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to reply to a review'),
        ),
      );
      return;
    }

    final currentUser = userSession.currentUser!;
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to Review'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Write your reply...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  final reviewService = Provider.of<ReviewService>(
                    context,
                    listen: false,
                  );

                  reviewService.addReplyToReview(
                    reviewId,
                    ReviewReply(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: currentUser.id,
                      userName: currentUser.name,
                      userImage: currentUser.profileImage,
                      content: textController.text.trim(),
                      date: DateTime.now(),
                      isOwner: userSession.isAdmin,
                    ),
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your reply has been posted')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class WriteReviewPage extends StatefulWidget {
  final String dishId;
  final String dishName;

  const WriteReviewPage({
    Key? key,
    required this.dishId,
    required this.dishName,
  }) : super(key: key);

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5;
  List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Authentic',
    'Flavorful',
    'Spicy',
    'Sweet',
    'Savory',
    'Fresh',
    'Filling',
    'Value for Money',
    'Must-try',
    'Healthy',
    'Comfort Food',
    'Creative',
    'Traditional',
    'Family-friendly',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Write a Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish info
            Card(
              child: ListTile(
                title: Text(
                  widget.dishName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Share your experience with this dish'),
              ),
            ),
            const SizedBox(height: 16),

            // Rating
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How would you rate this dish?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              size: 36,
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: Text(
                        _getRatingText(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Review text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Write your review',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Share your thoughts about this dish...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add tags',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select tags that best describe this dish',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (_selectedTags.length < 5) {
                                      _selectedTags.add(tag);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You can select up to 5 tags',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating.toInt()) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _submitReview() {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your review before submitting'),
        ),
      );
      return;
    }

    final userSession = Provider.of<UserSession>(context, listen: false);
    final currentUser = userSession.currentUser!;
    final reviewService = Provider.of<ReviewService>(context, listen: false);

    reviewService.addReview(
      userId: currentUser.id,
      userName: currentUser.name,
      userImage: currentUser.profileImage,
      dishId: widget.dishId,
      dishName: widget.dishName,
      rating: _rating,
      review: _reviewController.text.trim(),
      tags: _selectedTags,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your review has been submitted')),
    );
  }
}
