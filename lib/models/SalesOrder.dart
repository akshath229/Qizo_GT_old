class Sales {

//  "sodItemId": 19,
//  "sodQty": 10,
//  "sodRate": 15000
  int sodItemId;
  double sodQty;
  double sodRate;

  Sales({this.sodItemId, this.sodQty, this.sodRate});

  Sales.fromJson(Map<String, dynamic> json) {
    sodItemId = json['sodItemId'];
    sodQty = json['sodQty'];
    sodRate = json['sodRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sodItemId'] = this.sodItemId;
    data['sodQty'] = this.sodQty;
    data['sodRate'] = this.sodRate;
    return data;
  }
}
























