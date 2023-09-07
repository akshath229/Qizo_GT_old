import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Reports/Report_Button.dart';
import 'package:flutter_app/Reports/Sales_Reports/Sales_Item_ProfitReport.dart';
import 'package:flutter_app/Reports/Sales_Reports/Sales_Item_Report.dart';
import 'package:flutter_app/Reports/Sales_Reports/Sales_Report.dart';
import 'package:flutter_app/Reports/Sales_Reports/Sales_Rtn_Report.dart';
import 'package:flutter_app/Reports/Sales_Reports/Sales_Vat_Report.dart';
import 'package:flutter_app/Reports/Sales_Reports/Salesmanwise%20_Report.dart';
import 'package:flutter_app/Reports/Sales_Reports/Salesmanwise_Sales_Report.dart';
import 'package:flutter_app/Reports/Stock_Reports/Stock_Aging_Report.dart';
import 'package:flutter_app/Reports/Stock_Reports/Stock_Report.dart';

import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sales_Rpt_Index extends StatefulWidget {


  @override
  _Sales_Rpt_IndexState createState() => _Sales_Rpt_IndexState();
}

class _Sales_Rpt_IndexState extends State<Sales_Rpt_Index> {
  SharedPreferences pref;

  dynamic data;

  dynamic branch;

  dynamic user;

  int branchId;

  int userId;

  UserData userData;

  String branchName = "";

  dynamic userName;

  String token;

  String DeviceId;

  Report_Button _report_button= Report_Button();


  read() async {
    setState(() {

      var v = pref.getString("userData");
      var c = json.decode(v);
      user = UserData.fromJson(c); // token gets this code user.user["token"]
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }


  void initState() {
    setState(() {


      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(child: Appbarcustomwidget(uname: userName,
          branch: branchName,
          pref: pref,
          title: "Sales"), preferredSize: Size.fromHeight(80)),


      body:Column(children: [

        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Summary Report",linkepage:Sales_Report() ),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Vat Report",linkepage:Sales_Vat_Report()),
          SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Return Report",linkepage:Sales_Rtn_Report()),
         SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Salesmanwise Summary Report",linkepage:Salesmanwise_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Salesmanwise Sales Report",linkepage:Salesmanwise_Sales_Report()),
        SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Sales Item Report",linkepage:Sales_Item_Report()),
         SizedBox(height: 10,),
        _report_button.ReportCustomButton(context:context,name:"Item Profit Report",linkepage:Sales_Item_Profit_Report()),

      ]),
    ));
  }





}











