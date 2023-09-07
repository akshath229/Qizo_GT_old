import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/GT_Masters/Masters_UI/Brand_Create.dart';
import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';


class Brand_Master extends StatefulWidget {
  @override
  _Brand_MasterState createState() => _Brand_MasterState();
}

class _Brand_MasterState extends State<Brand_Master> {


  CUWidgets cw=CUWidgets();


  SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  int branchId;
  int userId;
  UserData userData;
  String branchName = "";
  dynamic userName;
  String token;
  String DeviceId;

// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });
    });
  }

  // //------------------for appbar------------
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }

// //---------------end---for appbar------------





  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar:
      PreferredSize(child: Appbarcustomwidget(
        uname:userName,
        branch:branchName,
        pref:pref,
        title:"Brand Master", ), preferredSize: Size.fromHeight(80)),

      body: Create_Brand(height: h,width: w,token: token,device_id: DeviceId,TblShow: true,branchId: branchId,userId: userId,),



    ));
  }
}
