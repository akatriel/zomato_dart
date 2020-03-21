part of models;

class UserRating {
  /// Restaurant rating on a scale of 0.0 to 5.0 in increments of 0.1
  String aggregateRating;
  String ratingText;

  /// hex code
  String ratingColor;

  /// # of ratings received
  String votes;

  UserRating(
      {this.aggregateRating, this.ratingText, this.ratingColor, this.votes});
  UserRating.fromJson(Map<String, dynamic> json) {
    aggregateRating = json['aggregate_rating'] is String
        ? json['aggregate_rating']
        : json['aggregate_rating']?.toString();
    ratingText = json['rating_text'];
    ratingColor = json['rating_color'];
    votes = json['votes'] is String ? json['votes'] : json['votes']?.toString();
  }
}
