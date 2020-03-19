part of models;

class DailyMenu {
  String dailyMenuId;
  String startDate;
  String name;
  List<Dish> dishes;

  DailyMenu({this.dailyMenuId, this.startDate, this.name, this.dishes});

  DailyMenu.fromJson(Map<String, dynamic> json) {
    dailyMenuId = json['daily_menu_id'];
    startDate = json['start_date'];
    name = json['name'];
    if (json['dishes'] != null) {
      dishes = List<Dish>();
      for (var dishWrapper in json['dishes']) {
        if (dishWrapper['dish'] != null) {
          dishes.add(Dish.fromJson(dishWrapper['dish']));
        }
      }
    }
  }
}

class Dish {
  String dishId;
  String name;
  String price;

  Dish({this.dishId, this.name, this.price});

  Dish.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
