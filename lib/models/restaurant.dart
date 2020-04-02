part of models;

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

  Restaurant(
    this.id, {
    this.name,
    this.url,
    this.location,
    this.averageCostForTwo,
    this.priceRange,
    this.currency,
    this.thumb,
    this.featuredImage,
    this.photosUrl,
    this.menuUrl,
    this.eventsUrl,
    this.userRating,
    this.hasOnlineDelivery,
    this.isDeliveringNow,
    this.hasTableBooking,
    this.deeplink,
    this.cuisines,
    this.allReviewsCount,
    this.photoCount,
    this.phoneNumbers,
    this.photos,
    this.reviews,
    this.r,
    this.switchToOrderMenu,
    this.timings,
    this.highlights,
    this.opentableSupport,
    this.isZomatoBookRes,
    this.mezzoProvider,
    this.isBookFormWebView,
    this.bookFormWebViewUrl,
    this.bookAgainUrl,
    this.includeBogoOffers,
    this.isTableReservationSupported,
    this.establishment,
  });

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
        ? UserRating.fromJson(json['user_rating'])
        : null;
    allReviewsCount = json['all_reviews_count'];
    photosUrl = json['photos_url'];
    photoCount = json['photo_count'];
    if (json['photos'] != null) {
      photos = List<Photo>();
      json['photos'].forEach((p) {
        photos.add(Photo.fromJson(p));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

  RestaurantSearch({
    this.restaurants,
    this.resultsFound,
    this.resultsShown,
    this.resultsStart,
  });

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
        ? HasMenuStatus.fromJson(json['has_menu_status'])
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
