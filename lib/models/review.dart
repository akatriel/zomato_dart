part of models;

/// Partner Access Only
class Review {
  /// 0 to 5; increments of .5
  double rating;
  String reviewText;
  int id;

  /// hexcode
  String ratingColor;
  String reviewTimeFriendly;
  String ratingText;

  /// Unix timestamp
  int timestamp;
  int likes;
  User user;
  int commentsCount;

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating']?.toDouble();
    reviewText = json['review_text'];
    id = json['id'];
    ratingColor = json['rating_color'];
    reviewTimeFriendly = json['review_time_friendly'];
    ratingText = json['rating_text'];
    timestamp = json['timestamp'];
    likes = json['likes'];
    user = User.fromJson(json['user']);
    commentsCount = json['comments_count'];
  }
}
