class Order {
  int? id;
  String? name;
  double? amount;
  double? price;
  double? cost;
  String? category;

  Order({this.id, this.name, this.amount, this.price, this.cost, this.category});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    price = json['price'];
    cost = json['cost'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['price'] = price;
    data['cost'] = cost;
    data['category'] = category;
    return data;
  }
}

class Account {
  int? id;
  double? totalPrice;
  bool? isActive;
  List<Order?>? orders;

  Account({this.id, this.totalPrice, this.isActive, this.orders});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalPrice = json['totalPrice'];
    isActive = json['isActive'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['totalPrice'] = totalPrice;
    data['isActive'] = isActive;
    data['orders'] =orders != null ? orders!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}