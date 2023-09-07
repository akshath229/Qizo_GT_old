
class Del_AddonItems {
  Del_AddonItems({
    this.id,
    this.mainItemId,
    this.itemName,
    this.maintItemUomId,
    this.mainItemUom,
    this.addOnitemId,
    this.addonItemName,
    this.addonItemUomId,
    this.addonItemUom,
    this.addonRate,
    this.isActive,
    this.qty,
  });

  int id;
  int mainItemId;
  String itemName;
  int maintItemUomId;
  String mainItemUom;
  int addOnitemId;
  String addonItemName;
  int addonItemUomId;
  String addonItemUom;
  double addonRate;
  bool isActive;
  var qty;

  factory Del_AddonItems.fromJson(Map<String, dynamic> json) => Del_AddonItems(
    id: json["id"],
    mainItemId: json["mainItemId"],
    itemName: json["itemName"],
    maintItemUomId: json["maintItemUomId"],
    mainItemUom: json["mainItemUom"],
    addOnitemId: json["addOnitemId"],
    addonItemName: json["addonItemName"],
    addonItemUomId: json["addonItemUomId"],
    addonItemUom: json["addonItemUom"],
    addonRate: json["addonRate"],
    isActive: json["isActive"],
    //qty:1 ,
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mainItemId": mainItemId,
    "itemName": itemName,
    "maintItemUomId": maintItemUomId,
    "mainItemUOM": mainItemUom,
    "addOnitemId": addOnitemId,
    "addonItemName": addonItemName,
    "addonItemUomId": addonItemUomId,
    "addonItemUOM": addonItemUom,
    "addonRate": addonRate,
    "isActive": isActive,
    "qty": qty,
  };
}
