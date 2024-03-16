class TableStatus {
  int? id;
  bool? isAvailable;

  TableStatus({this.id, this.isAvailable});

  TableStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['isAvailable'] = isAvailable;
    return data;
  }
}
