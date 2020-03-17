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