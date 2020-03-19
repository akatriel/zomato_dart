part of models;

/// Wrapper class for Reviews
class ReviewQuery {
  List<Review> userReviews;

  /// max number of results to retrieve
  int reviewsCount;

  /// fetch results after this offset
  int reviewsStart;
  int reviewsShown;

  ReviewQuery.fromJson(Map<String, dynamic> json) {
    reviewsCount = json['reviews_count'];
    reviewsStart = json["reviews_start"];
    reviewsShown = json["reviews_shown"];
    if (json['user_reviews'] != null) {
      userReviews = List<Review>();
      if (json['user_reviews'] != null) {
        for (var r in json['user_reviews']) {
          userReviews.add(Review.fromJson(r['review']));
        }
      }
    }
  }
}