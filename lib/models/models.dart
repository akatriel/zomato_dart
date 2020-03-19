// TODO: Move into their own files?
// TODO: Should fail loudly?

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
      for (var restaurantWrapper in json['best_rated_restaurant']) {
        if (restaurantWrapper['restaurant'] != null) {
          bestRatedRestaurants
              .add(Restaurant.fromJson(restaurantWrapper['restaurant']));
        }
      }
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
    r = json['R'] != null ? R.fromJson(json['R']) : null;
    id = json['id'];
    name = json['name'];
    url = json['url'];
    location = json['location'] != null
        ? ResLocation.fromJson(json['location'])
        : null;
    switchToOrderMenu = json['switch_to_order_menu'];
    cuisines = json['cuisines'];
    timings = json['timings'];
    averageCostForTwo = json['average_cost_for_two'];
    priceRange = json['price_range'];
    currency = json['currency'];
    highlights = json['highlights']?.cast<String>();
    opentableSupport = json['opentable_support'];
    isZomatoBookRes = json['is_zomato_book_res'];
    mezzoProvider = json['mezzo_provider'];
    isBookFormWebView = json['is_book_form_web_view'];
    bookFormWebViewUrl = json['book_form_web_view_url'];
    bookAgainUrl = json['book_again_url'];
    thumb = json['thumb'];
    userRating = json['user_rating'] != null
        ? new UserRating.fromJson(json['user_rating'])
        : null;
    allReviewsCount = json['all_reviews_count'];
    photosUrl = json['photos_url'];
    photoCount = json['photo_count'];
    if (json['photos'] != null) {
      photos = new List<Photo>();
      json['photos'].forEach((p) {
        photos.add(new Photo.fromJson(p));
      });
    }
    menuUrl = json['menu_url'];
    featuredImage = json['featured_image'];
    hasOnlineDelivery = json['has_online_delivery'];
    isDeliveringNow = json['is_delivering_now'];
    includeBogoOffers = json['include_bogo_offers'];
    deeplink = json['deeplink'];
    isTableReservationSupported = json['is_table_reservation_supported'];
    hasTableBooking = json['has_table_booking'];
    eventsUrl = json['events_url'];
    phoneNumbers = json['phone_numbers'];
    if (json['all_reviews'] != null && json['all_reviews']['reviews'] != null) {
      reviews = List<Review>();
      for (var r in json['all_reviews']['reviews']) {
        reviews.add(Review.fromJson(r));
      }
    }
    establishment = json['establishment']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['switch_to_order_menu'] = this.switchToOrderMenu;
    data['cuisines'] = this.cuisines;
    data['timings'] = this.timings;
    data['average_cost_for_two'] = this.averageCostForTwo;
    data['price_range'] = this.priceRange;
    data['currency'] = this.currency;
    data['highlights'] = this.highlights;
    data['opentable_support'] = this.opentableSupport;
    data['is_zomato_book_res'] = this.isZomatoBookRes;
    data['mezzo_provider'] = this.mezzoProvider;
    data['is_book_form_web_view'] = this.isBookFormWebView;
    data['book_form_web_view_url'] = this.bookFormWebViewUrl;
    data['book_again_url'] = this.bookAgainUrl;
    data['thumb'] = this.thumb;
    data['all_reviews_count'] = this.allReviewsCount;
    data['photos_url'] = this.photosUrl;
    data['photo_count'] = this.photoCount;
    data['menu_url'] = this.menuUrl;
    data['featured_image'] = this.featuredImage;
    data['has_online_delivery'] = this.hasOnlineDelivery;
    data['is_delivering_now'] = this.isDeliveringNow;
    data['include_bogo_offers'] = this.includeBogoOffers;
    data['deeplink'] = this.deeplink;
    data['is_table_reservation_supported'] = this.isTableReservationSupported;
    data['has_table_booking'] = this.hasTableBooking;
    data['events_url'] = this.eventsUrl;
    data['phone_numbers'] = this.phoneNumbers;
    data['establishment'] = this.establishment;
    return data;
  }
}

class RestaurantSearch {
  List<Restaurant> restaurants;
  int resultsFound;
  int resultsShown;
  int resultsStart;

  RestaurantSearch.fromJson(Map<String, dynamic> json) {
    resultsFound = json['results_found'];
    resultsShown = json['results_shown'];
    resultsStart = json['results_start'];
    if (json['restaurants'] != null) {
      restaurants = List<Restaurant>();
      for (var restaurantWrapper in json['restaurants']) {
        if (restaurantWrapper['restaurant'] != null) {
          restaurants.add(Restaurant.fromJson(restaurantWrapper['restaurant']));
        }
      }
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

class Geocode {
  Location location;
  Popularity popularity;
  String link;
  List<Restaurant> nearbyRestaurants;

  Geocode({this.location, this.popularity, this.link, this.nearbyRestaurants});

  Geocode.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    popularity = json['popularity'] != null
        ? new Popularity.fromJson(json['popularity'])
        : null;
    link = json['link'];
    if (json['nearby_restaurants'] != null) {
      nearbyRestaurants = new List<Restaurant>();
      for (var restaurantWrapper in json['nearby_restaurants']) {
        if (restaurantWrapper['restaurant'] != null) {
          nearbyRestaurants
              .add(new Restaurant.fromJson(restaurantWrapper['restaurant']));
        }
      }
    }
  }
}

class Popularity {
  String popularity;
  String nightlifeIndex;
  List<String> nearbyRes;
  List<String> topCuisines;
  String popularityRes;
  String nightlifeRes;
  String subzone;
  int subzoneId;
  String city;

  Popularity(
      {this.popularity,
      this.nightlifeIndex,
      this.nearbyRes,
      this.topCuisines,
      this.popularityRes,
      this.nightlifeRes,
      this.subzone,
      this.subzoneId,
      this.city});

  Popularity.fromJson(Map<String, dynamic> json) {
    popularity = json['popularity'];
    nightlifeIndex = json['nightlife_index'];
    nearbyRes = json['nearby_res'].cast<String>();
    topCuisines = json['top_cuisines'].cast<String>();
    popularityRes = json['popularity_res'];
    nightlifeRes = json['nightlife_res'];
    subzone = json['subzone'];
    subzoneId = json['subzone_id'];
    city = json['city'];
  }
}
