class Category {
  int id;
  String name;
  Category(this.id, this.name);
  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class City {
  int id;
  String name;
  int countryId;
  String countryName;
  int isState;
  int stateId;
  String stateName;
  String stateCode;
  City(this.id, this.name, this.countryId, this.countryName, this.isState,
      this.stateId, this.stateName, this.stateCode);

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    isState = json['is_state'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateCode = json['state_code'];
  }
}

class Collection {
  int id;
  int resCount;
  String imageUrl;
  String url;
  String title;
  String description;
  String shareUrl;

  Collection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resCount = json['res_count'];
    imageUrl = json['image_url'];
    url = json['url'];
    title = json['title'];
    description = json['description'];
    shareUrl = json['shareUrl'];
  }
}

class Cuisine {
  int cuisineId;
  String cuisineName;

  Cuisine.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisine_id'];
    cuisineName = json['cuisine_name'];
  }
}

class Establishment {
  int id;
  String name;

  Establishment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

// TODO: return to geocode

class Location {
  /// city, zone, subzone, landmark, group, metro, street
  String entityType;
  int entityId;
  String title;
  String latitude;
  String longitude;
  int cityId;
  String cityName;
  int countryId;
  String countryName;

  Location.fromJson(Map<String, dynamic> json) {
    entityType = json['entity_type'];
    entityId = json['entity_id'];
    title = json['title'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    cityId = json['city_id'];
    cityName = json['city_name'];
    countryId = json['country_id'];
    countryName = json['country_name'];
  }
}

/// Zomato details for a location
class LocationDetail {
  String popularity;
  String nightlifeIndex;
  List<String> nearbyRes;
  List<String> topCuisines;
  String popularityRes;
  String nightlifeRes;
  String subzone;
  int subzoneId;
  String city;
  Location location;
  int numRestaurant;
  List<Restaurant> bestRatedRestaurants;

  LocationDetail(
      {this.popularity,
      this.nightlifeIndex,
      this.nearbyRes,
      this.topCuisines,
      this.popularityRes,
      this.nightlifeRes,
      this.subzone,
      this.subzoneId,
      this.city,
      this.location,
      this.numRestaurant,
      this.bestRatedRestaurants});

  LocationDetail.fromJson(Map<String, dynamic> json) {
    popularity = json['popularity'];
    nightlifeIndex = json['nightlife_index'];
    nearbyRes = json['nearby_res'].cast<String>();
    topCuisines = json['top_cuisines'].cast<String>();
    popularityRes = json['popularity_res'];
    nightlifeRes = json['nightlife_res'];
    subzone = json['subzone'];
    subzoneId = json['subzone_id'];
    city = json['city'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    numRestaurant = json['num_restaurant'];
    if (json['best_rated_restaurant'] != null) {
      bestRatedRestaurants = new List<Restaurant>();
      json['best_rated_restaurant'].forEach((v) {
        bestRatedRestaurants.add(new Restaurant.fromJson(v));
      });
    }
  }
}

// Skipped offers
class Restaurant {
  String id;
  String name;
  String url;
  ResLocation location;
  int averageCostForTwo;

  /// 1 - 4
  int priceRange;
  String currency;
  String thumb;
  String featuredImage;
  String photosUrl;
  String menuUrl;
  String eventsUrl;
  UserRating userRating;

  /// boolean
  int hasOnlineDelivery;

  /// boolean
  int isDeliveringNow;

  /// boolean
  int hasTableBooking;
  String deeplink;

  /// List of cuisines served at the restaurant in csv format
  String cuisines;

  // The rest of the properties are only available with partner access.
  /// number of reviews
  int allReviewsCount;

  /// max 10
  int photoCount;

  /// Restaurant's contact numbers in csv format
  String phoneNumbers;
  List<Photo> photos;
  List<Review> reviews;

  // Not in documention:
  R r;
  int switchToOrderMenu;
  String timings;
  List<String> highlights;
  int opentableSupport;
  int isZomatoBookRes;
  String mezzoProvider;
  int isBookFormWebView;
  String bookFormWebViewUrl;
  String bookAgainUrl;
  bool includeBogoOffers;
  int isTableReservationSupported;
  List<String> establishment;
  // ^^^^^Not in documention

  Restaurant.fromJson(Map<String, dynamic> json) {
    if (json['restaurant'] != null) {
      r = json['R'] != null ? R.fromJson(json['restaurant']['R']) : null;
      id = json['restaurant']['id'];
      name = json['restaurant']['name'];
      url = json['restaurant']['url'];
      location = json['restaurant']['location'] != null
          ? ResLocation.fromJson(json['restaurant']['location'])
          : null;
      switchToOrderMenu = json['restaurant']['switch_to_order_menu'];
      cuisines = json['restaurant']['cuisines'];
      timings = json['restaurant']['timings'];
      averageCostForTwo = json['restaurant']['average_cost_for_two'];
      priceRange = json['restaurant']['price_range'];
      currency = json['restaurant']['currency'];
      highlights = json['restaurant']['highlights']?.cast<String>();
      opentableSupport = json['restaurant']['opentable_support'];
      isZomatoBookRes = json['restaurant']['is_zomato_book_res'];
      mezzoProvider = json['restaurant']['mezzo_provider'];
      isBookFormWebView = json['restaurant']['is_book_form_web_view'];
      bookFormWebViewUrl = json['restaurant']['book_form_web_view_url'];
      bookAgainUrl = json['restaurant']['book_again_url'];
      thumb = json['restaurant']['thumb'];
      userRating = json['restaurant']['user_rating'] != null
          ? new UserRating.fromJson(json['restaurant']['user_rating'])
          : null;
      allReviewsCount = json['restaurant']['all_reviews_count'];
      photosUrl = json['restaurant']['photos_url'];
      photoCount = json['restaurant']['photo_count'];
      if (json['restaurant']['photos'] != null) {
        photos = new List<Photo>();
        json['restaurant']['photos'].forEach((p) {
          photos.add(new Photo.fromJson(p));
        });
      }
      menuUrl = json['restaurant']['menu_url'];
      featuredImage = json['restaurant']['featured_image'];
      hasOnlineDelivery = json['restaurant']['has_online_delivery'];
      isDeliveringNow = json['restaurant']['is_delivering_now'];
      includeBogoOffers = json['restaurant']['include_bogo_offers'];
      deeplink = json['restaurant']['deeplink'];
      isTableReservationSupported =
          json['restaurant']['is_table_reservation_supported'];
      hasTableBooking = json['restaurant']['has_table_booking'];
      eventsUrl = json['restaurant']['events_url'];
      phoneNumbers = json['restaurant']['phone_numbers'];
      if (json['restaurant']['all_reviews'] != null &&
          json['restaurant']['all_reviews']['reviews'] != null) {
        reviews = List<Review>();
        for (var r in json['restaurant']['all_reviews']['reviews']) {
          reviews.add(Review.fromJson(r));
        }
      }
      establishment = json['restaurant']['establishment']?.cast<String>();
    }
  }
}

/// Sits within Restaurant object 
/// Not mentioned in documentation.
class R {
  HasMenuStatus hasMenuStatus;
  int resId;

  R({this.hasMenuStatus, this.resId});

  R.fromJson(Map<String, dynamic> json) {
    hasMenuStatus = json['has_menu_status'] != null
        ? new HasMenuStatus.fromJson(json['has_menu_status'])
        : null;
    resId = json['res_id'];
  }
}

/// Not mentioned in documentation
class HasMenuStatus {
  int delivery;
  int takeaway;

  HasMenuStatus({this.delivery, this.takeaway});

  HasMenuStatus.fromJson(Map<String, dynamic> json) {
    delivery = json['delivery'];
    takeaway = json['takeaway'];
  }
}

/// Restaurant Location
class ResLocation {
  String address;
  String locality;
  String city;
  int cityId;
  String latitude;
  String longitude;
  String zipcode;
  int countryId;
  String localityVerbose;

  ResLocation(
      {this.address,
      this.locality,
      this.city,
      this.cityId,
      this.latitude,
      this.longitude,
      this.zipcode,
      this.countryId,
      this.localityVerbose});

  ResLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    locality = json['locality'];
    city = json['city'];
    cityId = json['city_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipcode = json['zipcode'];
    countryId = json['country_id'];
    localityVerbose = json['locality_verbose'];
  }
}

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
    rating = json['rating'];
    reviewText = json['review_text'];
    id = json['id'];
    ratingColor = json['rating_color'];
    reviewTimeFriendly = json['review_time_friendly'];
    ratingText = json['rating_text'];
    timestamp = json['timestamp'];
    likes = json['likes'];
    user = json['user'];
    commentsCount = json['comments_count'];
  }
}

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
