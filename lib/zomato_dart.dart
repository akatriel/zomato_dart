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
    http.Response response = await _sendRequest(uri, endpoint);

    if (response.statusCode == 200) {
      categories = _extractCategories(response.body);
    } else {
      _printBadResponse(response);
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

    var response = await _sendRequest(uri, endpoint, paramsMap: paramsMap);
    cities = List<City>();

    try {
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

  /// Returns Zomato Restaurant Collections in a City.
  /// Requires either city_id or lat/lon.
  Future<List<Collection>> collections(
      {int cityId, String latitude, String longitude, int count}) async {
    _validateLocationParameters(cityId, latitude, longitude);

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
    try {
      if (response.statusCode == 200) {
        collections = List<Collection>();
        var decodedJson = convert.jsonDecode(response.body);

        for (var c in decodedJson['collections']) {
          collections.add(Collection.fromJson(c['collection']));
        }
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

    return collections;
  }

  /// Get a list of all cuisines of restaurants listed in a city.
  /// Either cityId or lat/lon must be provided.
  Future<List<Cuisine>> cuisines(
      {int cityId, String latitude, String longitude}) async {
    _validateLocationParameters(cityId, latitude, longitude);

    Map<String, String> paramsMap = {
      'city_id': cityId?.toString(),
      'lat': latitude,
      'lon': longitude,
    };

    String endpoint = '/cuisines';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);

    List<Cuisine> cuisines;
    if (response.statusCode == 200) {
      cuisines = List<Cuisine>();
      var decodedJson = convert.jsonDecode(response.body);

      for (var c in decodedJson['cuisines']) {
        cuisines.add(Cuisine.fromJson(c['cuisine']));
      }
    } else {
      _printBadResponse(response);
    }

    return cuisines;
  }

  // TODO: extremely similar to Cuisines and Collections. Consider refactoring.
  /// Get a list of restaurant types in a city.
  /// Either cityId or lat/lon must be provided.
  Future<List<Establishment>> establishments(
      {int cityId, String latitude, String longitude}) async {
    _validateLocationParameters(cityId, latitude, longitude);

    Map<String, String> paramsMap = {
      'city_id': cityId?.toString(),
      'lat': latitude,
      'lon': longitude,
    };

    String endpoint = '/establishments';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);

    List<Establishment> establishments;

    try {
      if (response.statusCode == 200) {
        establishments = List<Establishment>();
        var decodedJson = convert.jsonDecode(response.body);

        for (var c in decodedJson['establishments']) {
          establishments.add(Establishment.fromJson(c['establishment']));
        }
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

    return establishments;
  }

  /// Search for Zomato locations by keyword. Provide coordinates to get better search results
  Future<List<Location>> locations(String query,
      {String latitude, String longitude, int count}) async {
    Map<String, String> paramsMap = {
      'query': query,
      'lat': latitude,
      'lon': longitude,
      'count': count?.toString(),
    };

    String endpoint = '/locations';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);

    List<Location> locations;

    try {
      if (response.statusCode == 200) {
        locations = List<Location>();
        var decodedJson = convert.jsonDecode(response.body);

        for (var c in decodedJson['location_suggestions']) {
          locations.add(Location.fromJson(c));
        }
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }
    return locations;
  }

  /// Get Foodie Index, Nightlife Index, Top Cuisines and Best rated restaurants in a given location
  /// Arguments for this method are produced from a call to the locations api
  Future<LocationDetail> locationDetails(
      int entityId, String entityType) async {
    Map<String, String> paramsMap = {
      'entity_id': entityId?.toString(),
      'entity_type': entityType
    };

    String endpoint = '/location_details';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);
    LocationDetail locationDetail;
    try {
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        locationDetail = LocationDetail.fromJson(json);
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

    return locationDetail;
  }

  /// Returns similar information to [LocationDetail] based on coordinates
  Future<Geocode> geocode(String latitude, String longitude) async {
    Map<String, String> paramsMap = {
      'lat': latitude,
      'lon': longitude,
    };
    
    if (latitude == null ||
        latitude.isEmpty ||
        longitude == null ||
        longitude.isEmpty) {
      throw (InvalidArgumentsException(
          "Latitude and longitude must be provided"));
    }

    String endpoint = '/geocode';
    String uri = _baseUri + endpoint;
    http.Response response =
        await _sendRequest(uri, endpoint, paramsMap: paramsMap);
    Geocode geocode;
    try {
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        geocode = Geocode.fromJson(json);
      } else {
        _printBadResponse(response);
      }
    } catch (e) {
      _printExceptionMessage(e, endpoint);
    }

    return geocode;
  }

  void _validateLocationParameters(
      int cityId, String latitude, String longitude) {
    if (cityId == null) {
      if (latitude == null && longitude == null) {
        throw InvalidArgumentsException(
            "cityId or lat/lon is null and must be provided.");
      } else if (latitude == null || longitude == null) {
        throw InvalidArgumentsException(
            "latitude and longitude must be provided together, or provide a cityId.");
      }
    }
  }

  void _printExceptionMessage(e, String endpoint) {
    print("There an error extracting objects from $endpoint");
    print(e);
  }

  void _printBadResponse(http.Response response) {
    print('Status Code: ${response.statusCode}');
    print(response.body);
    print("The Zomato response was unsuccessful");
  }

  Future<http.Response> _sendRequest(String uri, String endpoint,
      {Map<String, String> paramsMap, Map<String, String> headersMap}) async {
    print("Fetching response from Zomato API for endpoint: $endpoint");
    http.Response response;

    try {
      List<String> params = _buildParamsList(paramsMap);

      // build url from params string
      String url = uri + '?' + (params.isEmpty ? '' : params.join('&'));
      print(url);

      // TODO: encode uri before sending.
      response = await _client.get(url, headers: _headersMap);
      _client?.close();
    } catch (e) {
      print("There was an exception while sending a requst");
      print(e);
    }

    return response;
  }

  List<String> _buildParamsList(Map<String, String> paramsMap) {
    List<String> params = List<String>();
    if (paramsMap != null) {
      paramsMap.removeWhere((k, v) => v == null);

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
