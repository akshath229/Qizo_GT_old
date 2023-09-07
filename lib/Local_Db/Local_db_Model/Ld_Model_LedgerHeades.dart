class LD_Model_LedgerHeads {
  int id;
  int Local_id;
  String lhName;
  String lhGroupId;


  LD_Model_LedgerHeads({
    this.id,
    this.lhName,
    this.lhGroupId,
    this.Local_id
  });

  factory LD_Model_LedgerHeads.fromJson(Map<String, dynamic> parsedJson){
    return LD_Model_LedgerHeads(
      id: parsedJson["id"].toInt(),
      Local_id: parsedJson["Local_id"].toInt(),
      lhName:parsedJson["lhName"].toString(),
      lhGroupId: parsedJson["lhGroupId"].toString(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'Local_id' : Local_id,
      'lhName' : lhName,
      'lhGroupId' : lhGroupId,
    };
  }



}