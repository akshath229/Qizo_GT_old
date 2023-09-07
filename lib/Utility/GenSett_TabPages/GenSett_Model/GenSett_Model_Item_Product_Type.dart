class ProductType {
  ProductType({
    this.id,
    this.productType,
    this.gtitemMaster,
    this.mItemMaster,
  });

  int id;
  String productType;
  List<dynamic> gtitemMaster;
  List<dynamic> mItemMaster;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json["id"],
    productType: json["productType"],
    gtitemMaster: List<dynamic>.from(json["gtitemMaster"].map((x) => x)),
    mItemMaster: List<dynamic>.from(json["mItemMaster"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productType": productType,
    "gtitemMaster": List<dynamic>.from(gtitemMaster.map((x) => x)),
    "mItemMaster": List<dynamic>.from(mItemMaster.map((x) => x)),
  };
}
