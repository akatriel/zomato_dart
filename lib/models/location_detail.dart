part of models;

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
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    numRestaurant = json['num_restaurant'];
    if (json['best_rated_restaurant'] != null) {
      bestRatedRestaurants = List<Restaurant>();
      for (var restaurantWrapper in json['best_rated_restaurant']) {
        if (restaurantWrapper['restaurant'] != null) {
          bestRatedRestaurants
              .add(Restaurant.fromJson(restaurantWrapper['restaurant']));
        }
      }
    }
  }
}
