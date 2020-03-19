part of models;

class User {
  String name;

  /// User's @handle; uniquely identifies a user on Zomato
  String zomatoHandle;
  String foodieLevel;

  /// 0 to 10
  int foodieLevelNum;
  String foodieColor;
  String profileUrl;
  String profileDeeplink;
  String profileImage;

  User.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      name = json['name'];
      zomatoHandle = json['zomato_handle'];
      foodieLevel = json['foodie_level'];
      foodieLevelNum = json['foodie_level_num'];
      foodieColor = json['foodie_color'];
      profileUrl = json['profile_url'];
      profileDeeplink = json['profile_deeplink'];
      profileImage = json['profile_image'];
    }
  }
}