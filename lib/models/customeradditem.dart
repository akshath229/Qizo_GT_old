class CustomerAdd {
  int id;
  int slNo;
  String item;
  String unit;
  double rate;
  double quantity;
  double amount;
  dynamic NetAmt;
  double txper;
  double txAmt;
  double cess;
  int StkId;
  dynamic Invnum;
  double Disc_Amt;

  CustomerAdd({this.id,this.slNo,this.item,this.rate,
    this.quantity,this.amount,this.NetAmt,this.txper,
    this.cess,this.StkId,this.Invnum,this.txAmt,this.Disc_Amt, this.unit});

  factory CustomerAdd.fromJson(Map<String, dynamic> parsedJson){
    return CustomerAdd(
      id:parsedJson["id"].toInt(),
      slNo: parsedJson["slNo"].toInt(),
      item:parsedJson["item"].toString(),
      unit:parsedJson["unit"].toString(),
      rate: parsedJson["rate"].toDouble(),
      quantity:parsedJson["quantity"].toDouble(),
      amount: parsedJson["amount"].toDouble(),
      NetAmt: parsedJson["NetAmt"].toDouble(),
        txper: parsedJson["txper"].toDouble(),
        cess: parsedJson["cess"].toDouble(),
      StkId: parsedJson["StkId"].toDouble(),
      Invnum: parsedJson["Invnum"].toDouble(),
      txAmt: parsedJson["txAmt"].toDouble(),
      Disc_Amt: parsedJson["Disc_Amt"].toDouble(),
    );
  }
}

