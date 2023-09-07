import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Customer_Details.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_Collection_Report.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_CustLocation.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_DeliveryMan_Login.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_ItemHome.dart';
import 'package:flutter_app/AQizo_RMS/New_Delivery_App/Del_Qr_Reader.dart';
import 'package:flutter_app/AQizo_RMS/RMS_Test/RMS_Test_PrintPdfView.dart';
import 'package:flutter_app/AQizo_RMS/RMS_Test/Rms_Test1.dart';

import 'package:flutter_app/AQizo_RMS/RMS_Test/Rms_Test_PrintSimp.dart';
import 'package:flutter_app/AQizo_RMS/Rms_ItemBill_Index.dart';
import 'package:flutter_app/AQizo_RMS/Rms_MakeOrder.dart';
import 'package:flutter_app/AQizo_RMS/itemBill.dart';
import 'package:flutter_app/GT_Masters/Masters_HomePage.dart';
import 'package:flutter_app/PaymentVoucherIndex_Direct.dart';
import 'package:flutter_app/PaymentVoucher_Direct.dart';
import 'package:flutter_app/Purchase.dart';
import 'package:flutter_app/Purchase_Index.dart';
import 'package:flutter_app/Purchase_Return.dart';
import 'package:flutter_app/Purchase_Rtn_Index.dart';
import 'package:flutter_app/Reports/Report_Home.dart';
import 'package:flutter_app/Testing/Test3.dart';
import 'package:flutter_app/Testing/Test4.dart';
import 'package:flutter_app/Testing/TestArabicThermalPrint.dart';
import 'package:flutter_app/Testing/Testpage.dart';
import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/indexpage.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:flutter_app/receiptcollection_Direct.dart';
import 'package:flutter_app/receiptcollectionindex_Direct.dart';
import 'package:flutter_app/sales.dart';
import 'package:flutter_app/salesindex.dart';
import 'package:flutter_app/set_CustomerLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../itemBill.dart';
import '../itemBill_Index.dart';

class Rms_Homes extends StatefulWidget {
  @override
  _Rms_HomesState createState() => _Rms_HomesState();
}

class _Rms_HomesState extends State<Rms_Homes> {
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
      });
    });
  }

//------------------For App Bar------------------------
  SharedPreferences pref;
  dynamic branch;
  var res;
  dynamic user;
  int branchId;
  int userId;
  UserData userData;
  String branchName = "";
  dynamic userName;
  String token;

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
    });
  }

//--------------END----For App Bar--end--------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(190.0),
                child: Appbarcustomwidget(
                  branch: branchName,
                  pref: pref,
                  title: "RMS Home",
                  uname: userName,
                )),


            body: ListView(children: <Widget>[





              NewHomePage(ScreenSize.width, ScreenSize.height),


              CircleButtonNavigate(context),


            ])));
  }


  Widget NewHomePage(width, height) {
    var Mstr_Name_lst = ["Masters", "Transaction", "Reports", "Utility ",];

    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: GridView.builder(physics: ScrollPhysics(),
          itemCount: 4,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: width > 500 ? 3 : 1.5,
          ),
          itemBuilder: (c, i) {
            return Container(color: Colors.teal.shade900,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: RaisedButton(
                    color: Colors.teal,
                    onPressed: () {
                      print("index :  $i");
                      setState(() {
                        SelectedPage(i);
                      });
                    },
                    child: Text(Mstr_Name_lst[i], style: TextStyle(
                        fontSize: 25.0, color: Colors.white))
                ),
              ),
            );
          },
        ));
  }


  ///----------------------------------------------------------


  SelectedPage(a) {
    switch (a.toString()) {
      case "0":
        {
          PageNavigate(Masters_Home_Pgae());
        }
        break;

      case "1":
        {
          PageNavigate(CustomerVisited());
        }
        break;

      case "2":
        {
          PageNavigate(Report_Home_Pgae());
        }
        break;
      case "3":
        {
          // PageNavigate(CustomerVisited());
        }
        break;

    // break;
    // case "6": {
    //   PageNavigate(Test());
    // }
      default:
        {
          print("Not Selected");
        }
        break;
    }
  }


  Widget PageNavigate(page) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              page));
    });
  }


  Widget CircleButtonNavigate(context) {
    return Column(
      children: [


        Button_List(
          context: context,
          name: "Item Bill",
          mainIcon: Icons.apps,
          // routAddPage: Rms_ItemBill(),
          routAddPage: Del_ItemHome(),
          routListPage: Rms_ItemBill_Index(),
        ),



        Button_List(
          context: context,
          name: "Make Order",
          mainIcon: Icons.apps,
          routAddPage: Rms_MakeOrder(),
          routListPage: Rms_MakeOrder(),
        ),





        Button_List(
          context: context,
          name: "Purchase",
          mainIcon: Icons.add_business,
          routAddPage: Purchase(passvalue: null, passname: null.toString()),
          routListPage: Purchase_Index(),
        ),


        Button_List(
        context: context,
          name: "Sales",
          mainIcon: Icons.shopping_cart,
          routAddPage:Newsalespage(
            passvalue: null,
            passname: null.toString(),
          ),
          routListPage: salesindex(),
        ),


        Button_List(
          context: context,
          name: "Purchase Return",
          mainIcon: Icons.assignment_return_outlined,
          routAddPage: PurchaseReturn(
            passvalue: null,
            passname: null.toString(),
          ),
          routListPage: Purchase_Rtn_Index(),
        ),


        //
        // Button_List(
        //   name: "Sales Return",
        //   mainIcon: Icons.remove_shopping_cart_rounded,
        //   routAddPage:SalesReturn(
        //     passvalue: null,
        //     passname: null.toString(),
        //   ),
        //   routListPage:Sales_Rtn_Index(),
        // ),


        Button_List(
            context: context,
            name: "Receipt Collection",
            mainIcon: Icons.fact_check,
            routAddPage: ReceiptCollections_Direct(
              passvalue: null,
              passname: null.toString(),
            ),
            routListPage: ReceiptCollectionIndex_Direct(passvalue: null)),


        Button_List(
            context: context,
            name: "Payment Collection",
            mainIcon: Icons.description_outlined,
            routAddPage: Payment_Voucher_Direct(
              passvalue: null,
              passname: null.toString(),
            ),
            routListPage: Payment_VoucherIndex_Direct(passvalue: null)),



        Button_List(
            context: context,
            name: "Set Location",
            mainIcon: Icons.location_on_outlined,
            routAddPage:Set_Cust_Location(),
            routListPage:Set_Cust_Location()
        ),

        // IconButton(icon: Icon(Icons.qr_code, size: 35,), onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //          // Del_Qr_Rreader()
        //       Del_Login_DeliveyMan()
        //            // RMS_SimPrint(Page_Type:false,Parm_Id: 51,)
        //        // TestArabicTermalPrint()
        //      // Rms_TestSimpPrint(Parm_Id: 51,)
        //          // Dynamic_Pdf_Print(Parm_Id: 5,)
        //         //  New_Model_PdfPrint(Parm_Id: 5,)
        //        //  Rms_Homes()
        //       //  TestRec_Pay_Print(Parm_Id: 11,printType: "Recpt",)
        //              //Testpage()
        //      ),
        //   );
        // })


      ],);
  }


  Padding Button_List({
    context,
    IconData mainIcon,
    String name,
    routAddPage,
    routListPage

  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 4),
      child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                mainIcon,
                color: Colors.teal,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 23,
                ),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.list_alt,
                    color: Colors.teal,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => routListPage),
                    );
                  }),
              SizedBox(
                width: 10,
              ),

              // IconButton(
              //     icon: Icon(
              //       Icons.add_circle_outline_sharp,
              //       color: Colors.teal,
              //       size: 30,
              //     ),
              //     onPressed: (){
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>routAddPage
              //         ),
              //       );
              //     }),

              InkWell(

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => routAddPage
                    ),
                  );
                },
                child: Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 5,
              ),

            ],)),
    );
  }
}