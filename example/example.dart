import 'package:zomato_dart/zomato_dart.dart';

/// Command Line Sample
/// Run with: $ dart example.dart {user-key}
void main(List<String> args) async {
  String userKey = args.first;
  print('Your Zomato user-key: $userKey');

  // var cats = await ZomatoDart(userKey).categories();
  // print(cats.first.name);

  // var cities = await ZomatoDart(userKey).cities(cityName: "Los Angeles", count: 5);
  // print(cities.length);

  var collections = await ZomatoDart(userKey).collections();
  print(collections.first.title);
}