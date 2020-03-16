import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/// An API wrapper in Dart for the Zomato API
class ZomatoDart {
  /// The Zomato provided user-key
  final String _userKey;
  Map<String, String> _headersMap;
  static const String _baseUri = 'https://developers.zomato.com/api/v2.1';

  ZomatoDart(this._userKey) {
    if (_userKey == null || _userKey == '') {
      throw (Exception('user-key not provided'));
    }
    _headersMap = new Map<String, String>.from(
        {'user-key': _userKey, 'Accept': 'application/json'});
  }

  Future<List<Category>> categories() async {
    String uri = _baseUri + '/categories';
    var client = http.Client();
    
    print("Fetching response from Zomato API");
    var response = await client.get(uri, headers: _headersMap);

    List<Category> categories;

    if (response.statusCode == 200) {
      categories = _extractCategories(response.body);
    }
    else {
      print(response);
      print("The Zomato response was unsuccessful");
    }

    client?.close();
    return categories;
  }

  List<Category> _extractCategories(String body) {
    List<Category> categories = List<Category>();
    try {
      var json = convert.jsonDecode(body);
      if (json != null && json.containsKey('categories')) {
        for (var cat in json['categories']) {
          var innerCat = cat['categories'];
          if (innerCat != null) {
            categories.add(Category(innerCat['id'], innerCat['name']));
          }
        }

        print("Finished extracting categories from response");
      }
    } catch (e) {
      print("There was an error extracting categories from the response");
      print(e);
    } 

    return categories;
  }
}

class Category {
  int id;
  String name;
  Category(this.id, this.name);
}
