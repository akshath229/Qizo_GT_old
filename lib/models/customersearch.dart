class Customer {
  int id;
  String lhName;
  String lhGroupId;


  Customer({this.id,this.lhName,this.lhGroupId});

  factory Customer.fromJson(Map<String, dynamic> parsedJson){
    return Customer(
      id: parsedJson["id"].toInt(),
      lhName:parsedJson["lhName"].toString(),
      lhGroupId: parsedJson["lhGroupId"].toString(),
     );
  }
}

