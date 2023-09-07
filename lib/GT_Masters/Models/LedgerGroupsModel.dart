class LedgerGrpModel {
  LedgerGrpModel({
    this.id,
    this.lgName,
    this.lgAliasName,
    this.lgUnderGruupId,
    this.groupUnder,
    this.lgPrimaryId,
    this.lgPrimaryName,
    this.lgType,
    this.lgGrpBehaveSubLedger,
    this.lgUserId,
    this.lgBranchId,
    this.lgPriceLevelId,
  });

  int id;
  String lgName;
  String lgAliasName;
  int lgUnderGruupId;
  String groupUnder;
  int lgPrimaryId;
  String lgPrimaryName;
  String lgType;
  bool lgGrpBehaveSubLedger;
  int lgUserId;
  int lgBranchId;
  dynamic lgPriceLevelId;

  factory LedgerGrpModel.fromJson(Map<String, dynamic> json) => LedgerGrpModel(
    id: json["id"],
    lgName: json["lgName"],
    lgAliasName: json["lgAliasName"],
    lgUnderGruupId: json["lgUnderGruupId"],
    groupUnder: json["groupUnder"],
    lgPrimaryId: json["lgPrimaryId"],
    lgPrimaryName: json["lgPrimaryName"],
    lgType: json["lgType"],
    lgGrpBehaveSubLedger: json["lgGrpBehaveSubLedger"],
    lgUserId: json["lgUserId"],
    lgBranchId: json["lgBranchId"],
    lgPriceLevelId: json["lgPriceLevelId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lgName": lgName,
    "lgAliasName": lgAliasName,
    "lgUnderGruupId": lgUnderGruupId,
    "groupUnder": groupUnder,
    "lgPrimaryId": lgPrimaryId,
    "lgPrimaryName": lgPrimaryName,
    "lgType": lgType,
    "lgGrpBehaveSubLedger": lgGrpBehaveSubLedger,
    "lgUserId": lgUserId,
    "lgBranchId": lgBranchId,
    "lgPriceLevelId": lgPriceLevelId,
  };
}
