class UserSession {
  int userId;
  String userName;
  String token;

  UserSession({this.userId, this.userName, this.token});

  UserSession.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['token'] = this.token;
    return data;
  }
}













