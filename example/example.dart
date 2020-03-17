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

  // var collections = await ZomatoDart(userKey).collections();
  // print(collections.first.title);

  // Be mindful of bad coordinates
  // var cuisines = await ZomatoDart(userKey).cuisines(latitude: "40", longitude: "-37");

  // var cuisines = await ZomatoDart(userKey).cuisines(cityId:280);
  // print(cuisines.first.cuisineName);

  var establishments = await ZomatoDart(userKey).establishments(cityId:280);
  print(establishments.first.name);
}