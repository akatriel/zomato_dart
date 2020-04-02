part of models;

class Cuisine {
  int cuisineId;
  String cuisineName;

  Cuisine({this.cuisineId, this.cuisineName});
  
  Cuisine.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisine_id'];
    cuisineName = json['cuisine_name'];
  }
}
