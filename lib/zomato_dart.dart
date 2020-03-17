import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:zomato_dart/models/models.dart';

/// An API wrapper in Dart for the Zomato API
class ZomatoDart {
  /// The Zomato provided user-key
  final String _userKey;

  /// base uri for each endpoint to be added to
  static const String _baseUri = 'https://developers.zomato.com/api/v2.1';
  var client = http.Client();

  /// Map for headers and other params to be added to
  Map<String, String> _headersMap;

  ZomatoDart(this._userKey, {json = true}) {
    if (_userKey == null || _userKey == '') {
      throw (Exception('user-key not provided'));
    }

    _headersMap = {
      'user-key': _userKey,
      'Accept': 'application/' + (json ? 'json' : 'xml')
    };
  }

  Future<List<Category>> categories() async {
    String endpoint = '/categories';
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
            categories.add(Category.fromJson(innerCat));
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


  /// return a list of cities based on the provided paramaters
  /// The cities returned are found under the "location_suggestions" key
  Future<List<City>> cities(
      {String cityName,
      String latitude,
      String longitude,
      List<int> cityIds,
      int count}) async {
    String endpoint = '/cities';
    String uri = _baseUri + endpoint;
    List<City> cities;
    
    Map<String, String> paramsMap = {
      'q': cityName,
      'lon' : longitude,
      'lat' : latitude,
      'city_ids' : cityIds?.join(', '),
      'count' : count?.toString()
    };
    
    // remove params not provided
    paramsMap.removeWhere((k,v) => v == null);
    
    try {
      var response = await sendRequest(uri, endpoint, paramsMap: paramsMap);
      print('Zomato Response Status Code: ${response?.statusCode}');

      cities = List<City>();

      if (response.statusCode == 200) {
        var jsonDecoded = convert.jsonDecode(response.body);
        // _InternalLinkedHashMap<String, dynamic>
        // print(jsonDecoded.runtimeType);
        if (jsonDecoded['location_suggestions'] != null ){
          for(var c in jsonDecoded['location_suggestions']) {
            cities.add(City.fromJson(c));
          }
        }
      }
    } catch (e) {
      print("There was an error extracting cities from the response.");
      print(e);
    }

    return cities;
  }

  Future<http.Response> sendRequest(String uri, String endpoint,
      {Map<String, String> paramsMap, Map<String, String> headersMap}) async {
    print("Fetching response from Zomato API for endpoint: $endpoint");

    List<String> params;
    // Build params string if params are present
    if (paramsMap != null) {
      paramsMap.removeWhere((k,v) => v == null);
      params = List<String>();

      if(!paramsMap.isEmpty) {     
        paramsMap.forEach((k, v) {
          params.add('$k=$v');
        });
      }
    }
    print(uri + '?' + (params.isEmpty ? '' : params.join('&')));
    http.Response response =
        await client.get(uri + '?' + (params.isEmpty ? '' : params.join('&')), headers: _headersMap);

    return response;
  }
}