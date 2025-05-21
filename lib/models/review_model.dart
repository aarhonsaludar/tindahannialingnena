import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Add this import for IconData

enum SortCriterion { mostRecent, highestRated, lowestRated, mostHelpful }

class ReviewTag {
  final String name;
  final IconData? icon;

  const ReviewTag({required this.name, this.icon});
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final String dishId;
  final String dishName;
  final double rating;
  final String review;
  final DateTime date;
  final List<String> tags;
  final List<String> images;
  int helpfulCount;
  final List<String> userIdsWhoMarkedHelpful;
  final List<ReviewReply> replies;
  final bool verified;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.dishId,
    required this.dishName,
    required this.rating,
    required this.review,
    required this.date,
    this.tags = const [],
    this.images = const [],
    this.helpfulCount = 0,
    this.userIdsWhoMarkedHelpful = const [],
    this.replies = const [],
    this.verified = false,
  });

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImage,
    String? dishId,
    String? dishName,
    double? rating,
    String? review,
    DateTime? date,
    List<String>? tags,
    List<String>? images,
    int? helpfulCount,
    List<String>? userIdsWhoMarkedHelpful,
    List<ReviewReply>? replies,
    bool? verified,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      dishId: dishId ?? this.dishId,
      dishName: dishName ?? this.dishName,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      userIdsWhoMarkedHelpful:
          userIdsWhoMarkedHelpful ?? this.userIdsWhoMarkedHelpful,
      replies: replies ?? this.replies,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'dishId': dishId,
      'dishName': dishName,
      'rating': rating,
      'review': review,
      'date': date.toIso8601String(),
      'tags': tags,
      'images': images,
      'helpfulCount': helpfulCount,
      'userIdsWhoMarkedHelpful': userIdsWhoMarkedHelpful,
      'replies': replies.map((r) => r.toJson()).toList(),
      'verified': verified,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      dishId: json['dishId'],
      dishName: json['dishName'],
      rating: json['rating'].toDouble(),
      review: json['review'],
      date: DateTime.parse(json['date']),
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      helpfulCount: json['helpfulCount'] ?? 0,
      userIdsWhoMarkedHelpful: List<String>.from(
        json['userIdsWhoMarkedHelpful'] ?? [],
      ),
      replies:
          (json['replies'] as List?)
              ?.map((r) => ReviewReply.fromJson(r))
              .toList() ??
          [],
      verified: json['verified'] ?? false,
    );
  }
}

class ReviewReply {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final String content;
  final DateTime date;
  final bool isOwner;

  ReviewReply({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.content,
    required this.date,
    this.isOwner = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'content': content,
      'date': date.toIso8601String(),
      'isOwner': isOwner,
    };
  }

  factory ReviewReply.fromJson(Map<String, dynamic> json) {
    return ReviewReply(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      isOwner: json['isOwner'] ?? false,
    );
  }
}

class ReviewSummary {
  final String dishId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  ReviewSummary({
    required this.dishId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewSummary.fromReviews(String dishId, List<Review> reviews) {
    if (reviews.isEmpty) {
      return ReviewSummary(
        dishId: dishId,
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      );
    }

    double sum = 0;
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews) {
      sum += review.rating;
      int rating = review.rating.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }

    return ReviewSummary(
      dishId: dishId,
      averageRating: sum / reviews.length,
      totalReviews: reviews.length,
      ratingDistribution: distribution,
    );
  }
}
