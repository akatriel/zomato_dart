import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:zomato_dart/models/models.dart';

/// An API wrapper in Dart for the Zomato API.
/// See https://developers.zomato.com/documentation
/// for details about the API.
class ZomatoDart {
  /// The Zomato provided user-key
  final String _userKey;

  /// base uri for each endpoint to be added to
  static const String _baseUri = 'https://developers.zomato.com/api/v2.1';
  var _client = http.Client();

  /// Map for headers and other params to be added to
  Map<String, String> _headersMap;

  // TODO: complete logging
  ZomatoDart(this._userKey, {json = true, logging = true}) {
    if (_userKey == null || _userKey == '') {
      throw (InvalidArgumentsException('user-key not provided'));
    }

    _headersMap = {
      'user-key': _userKey,
      'Accept': 'application/' + (json ? 'json' : 'xml')
    };
  }
  /// Get a list of categories
  Future<List<Category>> categories() async {
    String endpoint = '/categories';
    String uri = _baseUri + endpoint;

    List<Category> categories;
    try {
      http.Response response = await _sendRequest(uri, endpoint);

      if (response.statusCode == 200) {
        categories = _extractCategories(response.body);
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

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

  /// Find the Zomato ID and other details for a city.
  /// Return a list of cities based on the provided paramaters
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
      'lon': longitude,
      'lat': latitude,
      'city_ids': cityIds?.join(', '),
      'count': count?.toString()
    };

    // remove params not provided
    paramsMap.removeWhere((k, v) => v == null);

    try {
      var response = await _sendRequest(uri, endpoint, paramsMap: paramsMap);
      print('Zomato Response Status Code: ${response?.statusCode}');

      cities = List<City>();

      if (response.statusCode == 200) {
        var jsonDecoded = convert.jsonDecode(response.body);
        // _InternalLinkedHashMap<String, dynamic>
        // print(jsonDecoded.runtimeType);
        if (jsonDecoded['location_suggestions'] != null) {
          for (var c in jsonDecoded['location_suggestions']) {
            cities.add(City.fromJson(c));
          }
        }
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

    return cities;
  }

  void _printExceptionMessage(e, String endpoint) {
    print("There an error extracting objects from $endpoint");
    print(e);
  }

  /// Returns Zomato Restaurant Collections in a City.
  /// Requires either city_id or lat/lon.
  Future<List<Collection>> collections({int cityId, String latitude, String longitude, int count}) async {
    _validateCollectionsParameters(cityId, latitude, longitude);

    Map<String, String> paramsMap = {
      'city_id': cityId?.toString(),
      'lat': latitude,
      'lon': longitude,
      'count': count?.toString()
    };

    String endpoint = '/collections';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);

    List<Collection> collections;
    if (response.statusCode == 200) {
      collections = List<Collection>();
      var decodedJson = convert.jsonDecode(response.body);

      for (var c in decodedJson['collections']) {
        collections.add(Collection.fromJson(c['collection']));
      }
    } else {
      _printBadResponse(response);
    }

    return collections;
  }

  void _validateCollectionsParameters(int cityId, String latitude, String longitude) {
    if (cityId == null) {
      if (latitude == null && longitude == null)
      {
        throw InvalidArgumentsException("cityId or lat/lon is null and must be provided.");
      } 
      else if (latitude == null || longitude == null)
      {
        throw InvalidArgumentsException("latitude and longitude must be provided together, or provide a cityId.");
      }
    }
  }

  void _printBadResponse(http.Response response) {
    print('Status Code: ${response.statusCode}');
    print(response.body);
    print("The Zomato response was unsuccessful");
  }

  Future<http.Response> _sendRequest(String uri, String endpoint,
      {Map<String, String> paramsMap, Map<String, String> headersMap}) async {
    print("Fetching response from Zomato API for endpoint: $endpoint");

    List<String> params = _buildParamsList(paramsMap);

    // build url from params string
    String url = uri + '?' + (params.isEmpty ? '' : params.join('&'));
    print(url);

    http.Response response = await _client.get(url, headers: _headersMap);
    _client?.close();

    return response;
  }

  List<String> _buildParamsList(Map<String, String> paramsMap) {
    List<String> params;
    if (paramsMap != null) {
      paramsMap.removeWhere((k, v) => v == null);
      params = List<String>();

      if (!paramsMap.isEmpty) {
        paramsMap.forEach((k, v) {
          params.add('$k=$v');
        });
      }
    }
    return params;
  }
}

class InvalidArgumentsException implements Exception {
  String message;
  InvalidArgumentsException(String this.message) {}

  @override
  String toString() {
    return message;
  }
}
