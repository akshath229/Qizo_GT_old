class ServerDate {
  String workingDate;
  String workingTime;

  ServerDate({this.workingDate, this.workingTime});

  ServerDate.fromJson(Map<String, dynamic> json) {
    workingDate = json['workingDate'];
    workingTime = json['workingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workingDate'] = this.workingDate;
    data['workingTime'] = this.workingTime;
    return data;
  }
}
