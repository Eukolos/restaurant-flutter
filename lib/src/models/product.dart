class Product {
  int? id;
  String? name;
  int? price;
  int? cost;
  String? category;
  int? stock;
  int quantity = 0;

  Product({this.id, this.name, this.price, this.cost, this.category, this.stock});
// if not more then stock
  void increaseQuantity() {
    if (quantity != null && stock != null && quantity! < stock!) {
      quantity = quantity! + 1;
    }
  }

  void decreaseQuantity() {
    if (quantity != null && quantity! > 0) {
      quantity = quantity! - 1;
    }
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    cost = json['cost'];
    category = json['category'];
    stock = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['cost'] = cost;
    data['category'] = category;
    data['quantity'] = stock;
    return data;
  }
}

