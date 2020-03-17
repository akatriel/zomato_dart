import 'package:zomato_dart/zomato_dart.dart';

/// Command Line Sample
void main(List<String> args) async {
  String userKey = args.first;
  print('Your Zomato user-key: $userKey');

  // var cats = await ZomatoDart(userKey).categories();
  // print(cats.first.name);

  var cities = await ZomatoDart(userKey).cities();
  print(cities.length);
}