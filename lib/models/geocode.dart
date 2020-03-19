part of models;

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