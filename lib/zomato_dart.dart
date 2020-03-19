import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:zomato_dart/models/models.dart';

enum EntityType { city, subzone, zone, landmark, metro, group }

enum Sort { cost, rating, real_distance }

enum Order { asc, desc }

/// An API wrapper in Dart for the Zomato API.
/// See https://developers.zomato.com/documentation
/// for details about the API.
class ZomatoDart {
  /// The Zomato provided user-key
  final String _userKey;

  /// base uri for each endpoint to be added to
  static const String _baseUri = 'https://developers.zomato.com/api/v2.1';
  var _client = http.Client();

  /// Map for headers
  Map<String, String> _headersMap;

  // TODO: complete logging
  ZomatoDart(this._userKey, {bool json = true, bool logging = true}) {
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
    List<Category> categories;

    http.Response response = await _fetchResponse('/categories');

    if (response?.statusCode == 200) {
      categories = _extractCategories(response.body);
    } else {
      _printBadResponse(response);
    }

    return categories;
  }

  List<Category> _extractCategories(String body) {
    List<Category> categories = List<Category>();
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

    Map<String, String> paramsMap = {
      'q': cityName,
      'lon': longitude,
      'lat': latitude,
      'city_ids': cityIds?.join(', '),
      'count': count?.toString()
    };

    var response = await _fetchResponse('/cities', paramsMap: paramsMap);
    
    List<City> cities;
    if (response?.statusCode == 200) {
      cities = List<City>();
      var jsonDecoded = convert.jsonDecode(response.body);
      if (jsonDecoded['location_suggestions'] != null) {
        for (var c in jsonDecoded['location_suggestions']) {
          cities.add(City.fromJson(c));
        }
      }
    } else {
      _printBadResponse(response);
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

    http.Response response =
        await _fetchResponse('/collections', paramsMap: paramsMap);

    List<Collection> collections;
    if (response?.statusCode == 200) {
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

    http.Response response =
        await _fetchResponse('cuisines', paramsMap: paramsMap);

    List<Cuisine> cuisines;
    if (response?.statusCode == 200) {
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

    http.Response response =
        await _fetchResponse('/establishments', paramsMap: paramsMap);

    List<Establishment> establishments;
    if (response?.statusCode == 200) {
      establishments = List<Establishment>();
      var decodedJson = convert.jsonDecode(response.body);

      for (var c in decodedJson['establishments']) {
        establishments.add(Establishment.fromJson(c['establishment']));
      }
    } else {
      _printBadResponse(response);
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

    http.Response response =
        await _fetchResponse('/locations', paramsMap: paramsMap);

    List<Location> locations;
    if (response?.statusCode == 200) {
      locations = List<Location>();
      var decodedJson = convert.jsonDecode(response.body);

      for (var c in decodedJson['location_suggestions']) {
        locations.add(Location.fromJson(c));
      }
    } else {
      _printBadResponse(response);
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

    http.Response response =
        await _fetchResponse('/location_details', paramsMap: paramsMap);

    LocationDetail locationDetail;
    if (response?.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      locationDetail = LocationDetail.fromJson(json);
    } else {
      _printBadResponse(response);
    }

    return locationDetail;
  }

  /// Returns similar information to [LocationDetail] based on coordinates
  Future<Geocode> geocode(String latitude, String longitude) async {
    Map<String, String> paramsMap = {
      'lat': latitude,
      'lon': longitude,
    };

    _validateLatLon(latitude, longitude);

    http.Response response =
        await _fetchResponse('/geocode', paramsMap: paramsMap);

    Geocode geocode;
    if (response?.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      geocode = Geocode.fromJson(json);
    } else {
      _printBadResponse(response);
    }

    return geocode;
  }

  void _validateLatLon(String latitude, String longitude) {
    if (latitude == null ||
        latitude.isEmpty ||
        longitude == null ||
        longitude.isEmpty) {
      throw (InvalidArgumentsException(
          "Latitude and longitude must be provided"));
    }
  }

  /// returns a single restaurant based on a provided id
  Future<Restaurant> restaurant(String id) async {
    Map<String, String> paramsMap = {'res_id': id};

    if (id == null || id.isEmpty) {
      throw (InvalidArgumentsException("id must be provided"));
    }

    http.Response response =
        await _fetchResponse('/restaurant', paramsMap: paramsMap);

    Restaurant restaurant;
    if (response?.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      restaurant = Restaurant.fromJson(json);
    } else {
      _printBadResponse(response);
    }

    return restaurant;
  }

  // TODO: add method helper to retrieve next batch
  /// Get restaurant reviews using the Zomato restaurant ID.
  /// Only 5 latest reviews are available under the Basic API plan.
  /// [ReviewQuery] object returned which contains a list of reviews.
  Future<ReviewQuery> reviews(String resId, {int start, int count}) async {
    Map<String, String> paramsMap = {
      'res_id': resId,
      'start': start?.toString(),
      'count': count?.toString()
    };

    if (resId == null || resId.isEmpty) {
      throw (InvalidArgumentsException("id must be provided"));
    }

    http.Response response =
        await _fetchResponse('/reviews', paramsMap: paramsMap);

    ReviewQuery reviewQuery;
    if (response?.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      reviewQuery = ReviewQuery.fromJson(json);
    } else {
      _printBadResponse(response);
    }

    return reviewQuery;
  }

  /// The location input can be specified using Zomato location ID or coordinates.
  /// Cuisine / Establishment / Collection IDs can be obtained from respective api
  /// calls.
  ///
  /// Get up to 100 restaurants by changing the 'start' and 'count'
  /// parameters with the maximum value of count being 20.
  ///
  /// Partner Access is required to access photos and reviews.
  ///
  /// [count] is 20 by default
  ///
  /// [latitude] and [longitude] must be provided together
  ///
  /// All parameters are optional.
  Future<RestaurantSearch> restaurantSearch(
      {int entity_id,
      EntityType entityType,
      String query,
      int start,
      int count,
      String latitude,
      String longitude,
      // meters
      int radius,
      // csv form
      String cuisines,
      // estblishment id obtained from establishments call
      int establishmentType,
      int collectionId,
      int categoryId,
      Sort sort,
      Order order}) async {
    Map<String, String> paramsMap = {
      'entity_id': entity_id?.toString(),
      'entity_type': entityType?.toString(),
      'q': query,
      'start': start?.toString(),
      'lat': latitude,
      'lon': longitude,
      'radius': radius?.toString(),
      'cuisines': cuisines,
      'establishment_type': establishmentType?.toString(),
      'collection_id': collectionId?.toString(),
      'category_id': categoryId?.toString(),
      'sort': sort?.toString(),
      'order': order?.toString()
    };

    http.Response response =
        await _fetchResponse('/search', paramsMap: paramsMap);

    RestaurantSearch rs;
    if (response?.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      rs = RestaurantSearch.fromJson(json);
    } else {
      _printBadResponse(response);
    }

    return rs;
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

  void _printBadResponse(http.Response response) {
    print('Status Code: ${response?.statusCode}');
    print(response?.body);
  }

  Future<http.Response> _fetchResponse(String endpoint,
      {Map<String, String> paramsMap, Map<String, String> headersMap}) async {

    print("Fetching response from Zomato API for endpoint: $endpoint");
    http.Response response;

    try {
      String url = _buildUrl(endpoint, paramsMap: paramsMap);
      print(url);

      // TODO: encode url before sending?
      response = await _client.get(url, headers: _headersMap);
      _client?.close();
    } catch (e) {
      print(e);
    }

    return response;
  }

  /// build url from params string and endpoint
  String _buildUrl(String endpoint, {Map<String, String> paramsMap}) {
    String uri = _baseUri + endpoint;
    String params = _buildParamsString(paramsMap);
    return uri + params;
  }

  String _buildParamsString(Map<String, String> paramsMap) {
    if (paramsMap == null || paramsMap.isEmpty) return '';
    // cleanup Map
    paramsMap.removeWhere((k, v) => v == null);

    List<String> params = List<String>();
    paramsMap.forEach((k, v) {
      params.add('$k=$v');
    });

    return params.isNotEmpty ? '?' + params.join('&') : '';
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
