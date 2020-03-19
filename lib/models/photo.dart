part of models;

/// Partner Access Only
/// But sometimes returned anyway...
class Photo {
  String id;
  String url;

  /// URL for 200 X 200 thumb image file
  String thumbUrl;
  User user;
  int resId;
  String caption;

  /// Unix timestamp when the photo was uploaded
  int timestamp;
  String friendlyTime;

  /// usually 640px
  int width;

  /// usually 640px
  int height;
  int commentsCount;
  int likesCount;

  Photo.fromJson(Map<String, dynamic> json) {
    if (json != null && json['photo'] != null) {
      id = json['photo']['id'];
      url = json['photo']['url'];
      thumbUrl = json['photo']['thumb_url'];
      user = User.fromJson(json['photo']['user']);
      resId = json['photo']['res_id'];
      caption = json['photo']['caption'];
      timestamp = json['photo']['timestamp'];
      friendlyTime = json['photo']['friendly_time'];
      width = json['photo']['width'];
      height = json['photo']['height'];
      commentsCount = json['photo']['comments_count'];
      likesCount = json['photo']['likes_count'];
    }
  }
}

