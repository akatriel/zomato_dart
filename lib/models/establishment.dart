part of models;
class Establishment {
  int id;
  String name;

  Establishment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}