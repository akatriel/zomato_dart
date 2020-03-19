part of models;
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