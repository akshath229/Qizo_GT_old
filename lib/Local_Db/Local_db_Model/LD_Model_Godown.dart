class  LD_Model_Godown{

  int gdnId;
  int Local_id;
  dynamic gdnDescription;



  LD_Model_Godown(
      {
        this.gdnId,
        this.Local_id,
        this.gdnDescription,
      });

  LD_Model_Godown.fromJson(Map<String, dynamic> json) {
    gdnId = json['gdnId'];
    Local_id = json['Local_id'];
    gdnDescription = json['gdnDescription'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gdnId'] = this.gdnId;
    data['Local_id'] = this.Local_id;
    data['gdnDescription'] = this.gdnDescription;
    return data;
  }




  Map<String, dynamic> toMap() {
    return {
      'gdnId' : gdnId,
      'Local_id' : Local_id,
      'gdnDescription' : gdnDescription,
    };
  }


}