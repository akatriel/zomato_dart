import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/// An API wrapper in Dart for the Zomato API
class ZomatoDart {
  /// The Zomato provided user-key
  final String _userKey;

  /// base uri for each endpoint to be added to
  static const String _baseUri = 'https://developers.zomato.com/api/v2.1';
  var client = http.Client();

  /// Map for headers and other params to be added to
  Map<String, String> _headersMap;

  ZomatoDart(this._userKey) {
    if (_userKey == null || _userKey == '') {
      throw (Exception('user-key not provided'));
    }
    _headersMap = new Map<String, String>.from(
        {'user-key': _userKey, 'Accept': 'application/json'});
  }

  Future<List<Category>> categories() async {
    String endpoint =  '/categories';
    String uri = _baseUri + endpoint;

    http.Response response = await sendRequest(uri, endpoint);

    List<Category> categories;

    if (response.statusCode == 200) {
      categories = _extractCategories(response.body);
    } else {
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

  Future<List<City>> cities(){
    String endpoint = '/cities';
    String uri = _baseUri + endpoint;

  }

  Future<http.Response> sendRequest(String uri, String endpoint) async {
    print("Fetching response from Zomato API for endpoint: $endpoint");
    http.Response response = await client.get(uri, headers: _headersMap);
    return response;
  }
}

class Category {
  int id;
  String name;
  Category(this.id, this.name);
}


class City {
  int id;
  String name;
  int countryId;
  String countryName;
  bool isState;
  int stateId;
  String stateName;
  String stateCode;
  City(this.id, this.name, this.countryId, this.countryName, this.isState,
      this.stateId, this.stateName, this.stateCode);
}
