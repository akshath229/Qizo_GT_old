import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/AQizo_RMS/RMS_HomePage.dart';
import 'package:flutter_app/GT_Masters/AccountGroup.dart';
import 'package:flutter_app/GT_Masters/Company_Profile.dart';
import 'package:flutter_app/GT_Masters/Company_Profile_Index.dart';
import 'package:flutter_app/GT_Masters/LedgerBalance_Index.dart';
import 'package:flutter_app/GT_Masters/Manufacturer_Master.dart';
import 'package:flutter_app/GT_Masters/OtherMasters/Mstr_Area.dart';
import 'package:flutter_app/GT_Masters/OtherMasters/Mstr_District.dart';
import 'package:flutter_app/GT_Masters/OtherMasters/Mstr_Location.dart';
import 'package:flutter_app/GT_Masters/Printing/PDF_Printer.dart';
import 'package:flutter_app/GT_Masters/brandMaster.dart';
import 'package:flutter_app/GT_Masters/item_Master_List.dart';
import 'package:flutter_app/GT_Masters/item_group.dart';
import 'package:flutter_app/GT_Masters/taxMaster.dart';
import 'package:flutter_app/GT_Masters/unitMaster.dart';
import 'package:flutter_app/Testing/Test3.dart';
import 'package:flutter_app/Testing/Test4.dart';
import 'package:flutter_app/Testing/Testpage.dart';
import 'package:flutter_app/Testing/test2.dart';
import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/ledgerBalanceCreate.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import '../salesmanhome.dart';
class Masters_Home_Pgae extends StatefulWidget {
  @override
  _Masters_Home_PgaeState createState() => _Masters_Home_PgaeState();
}

class _Masters_Home_PgaeState extends State<Masters_Home_Pgae> {


  SharedPreferences pref;
  dynamic data;
  dynamic branch;
  // var res;
  dynamic user;
  int branchId;
  int userId;
  UserData userData;
  String branchName = "";
  dynamic userName;
  String token;
  String DeviceId;

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

// //----------------------------------

  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        internet_check();
        GetAppType();
      });
    });
  }

  Widget PageNavigate(page){
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              page));
    });

  }

var AppType;
  GetAppType()async{

    print("GetProjType");
    var res = await http.get("${Env.baseUrl}generalSettings",
        headers: {'Authorization':token});
    print(res.statusCode);
    if (res.statusCode < 210) {
      print("GetProjType sucess");
      print(res.body);
      var result =[];
      result= json.decode(res.body);

      print(result[0]["applicationType"]);

      if(result[0]["applicationType"]=="RMS"||
          result[0]["applicationType"].toString().toLowerCase().contains("rms")) {

         AppType="RMS";

      }else{
        AppType="GT";
      }
      }



      }

// --------------------Net Connection Checking-------------------------------------------------------

var NetWrkSts=false;

  SelectedPage(a){

    switch(a.toString()) {
      case "0": {
        PageNavigate(Item_Group());
      }
      break;

      case "1": {
        PageNavigate(Item_Mstr_List());
      }
      break;

      case "2": {
        PageNavigate(UnitMaster());
      }
      break;
      case "3": {
        PageNavigate(Tax_Master());
      }
      break;

      case "4": {
        PageNavigate(Manufacturer_Master());
      }
      break;

      case "5": {
        PageNavigate(Brand_Master());
      }
      break;
      case "6": {
       // PageNavigate(CreateLedgeBlnc());
        PageNavigate(LedgerBalance_Index());
      }
      break;
      case "7": {
        PageNavigate(Account_Grp());
      }
      break;
      case "8": {
        PageNavigate(Company_Profile_Index());

      }
      break;
      case "9": {
        PageNavigate(Master_Location());

      }
      break;
      case "10": {
        PageNavigate(Master_Area());

      }
      break;
      case "11": {
        PageNavigate(Master_District());

      }
      break;

      default: {
        print("Not Selected");
      }
      break;
    }

}


  internet_check() async{
    var result = await (Connectivity().checkConnectivity()); {
      if(result==ConnectivityResult.mobile ||result== ConnectivityResult.wifi) {
       //print("NetWrkSts");
        setState(() {
          NetWrkSts=true;
        });

        return true;

      }
      else if (result==ConnectivityResult.none){
        // print("Net not Connected");
        // i=false;
        // showDialog(
        //   context: context,
        //   builder: (context) => new AlertDialog(
        //     title: new Text('No Internet Connection'),
        //     content: new Text('Check Internet Connection'),
        //   ),
        // );
        setState(() {
          NetWrkSts=false;
        });

        return false;
      }


    }


  }




  List<String> Mstr_Name_lst=[
   "Item Group",
    " Item ",
    " Unit ",
    " Tax ",
    " Manufacturer ",
    " Brand ",
    "Ledger",
    "Account Grp",
    "Company Prof",
    "Location",
    "Area",
    "District"
  ];

  List<String> Mstr_Name_Img_lst=[
    'https://us.123rf.com/450wm/bsd555/bsd5551602/bsd555160200092/52069484'
        '-food-flat-design-icons-set-dairy-milk-products-and-vegetables-long-shadow'
        '-symbols-salmon-fish-fillet.jpg?ver=6',

    'https://cdn1.iconfinder.com/data/icons/grocery-store-filled/64/Grocery_Shop-36-512.png',

    'https://lh3.googleusercontent.com/wPlpF4OvRnG9eKWV6eNwX2fRwMokrgOb17'
        'lpf_r3iU4HgLOGmr49Z1ZRguJD3Db86g',

    'https://economictimes.indiatimes.com/thumb/msid-77525190,width-120'
        '0,height-900,resizemode-4,imgsize-112483/tax.jpg?from=mdr',

    'https://cdn-icons-png.flaticon.com/512/2051/2051493.png',

    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStzTg6'
        'Q45-lZC2fSD9ESkfNwac4dghpYenSQ&usqp=CAU',
'https://cdn.iconscout.com/icon/premium/png-256-thumb/ledger-10-854095.png',


    'https://www.pinclipart.com/picdir/middle/459-4591076_png-file-svg-general-ledger-icon-clipart.png',
    'https://www.pngitem.com/pimgs/m/78-788231_icon-blue-company-icon-png-transparent-png.png',

  'https://www.iconpacks.net/icons/2/free-location-icon-2955-thumb.png',
  'https://images.squarespace-cdn.com/content/v1/5ed68b9488f424305418c015/1591391327150-CF4AW85WGL7W3Y83FGIG/district-icon.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOMS0Brm67V34sCgDXGdf1cGuNGSojy6hX1w&usqp=CAU',

  ];




 //  Future<bool> _onBackPressed() {
 //    print("futyu");
 // Navigator.pushNamed(context,'/Home');
 //
 //  }
  BackFun(){
    Navigator.pushReplacement
      (context, MaterialPageRoute(builder: (context) =>
    AppType=="GT" ?SalesManHome():
    Rms_Homes()
    ));


    //Masters_Home_Pgae()


  }

  ///--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var ScreeWidth=MediaQuery.of(context).size.width;
    var ScreeHeight=MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(child: Appbarcustomwidget(uname: userName,
          branch: branchName,
          pref: pref,
          title: "Masters"), preferredSize: Size.fromHeight(80)),


      body: WillPopScope(
        onWillPop:() {
          return BackFun();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(physics: ScrollPhysics(),
            itemCount:NetWrkSts==false? Mstr_Name_lst.length:
                           Mstr_Name_Img_lst.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:ScreeWidth>500? 3:2,
              crossAxisSpacing: 5,
              mainAxisSpacing:7 ,
              childAspectRatio:ScreeWidth>500? 1:1.4,
            ),
            itemBuilder: (c, i) {
              return Container(color: Colors.teal,
                child:
              Padding(
                padding: const EdgeInsets.all(3),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        print("index :  $i");
                        setState(() {
                          SelectedPage(i);
                        });
                      },
                      child:NetWrkSts==false? Text(Mstr_Name_lst[i],style: TextStyle(
                          fontSize: 25.0, color: Colors.black) ):
                      // Image.network(Mstr_Name_Img_lst[i],
                      //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return Center(
                      //       child: Icon(Ico ns.image_sharp)
                      //     );
                      //   },),
                      SizedBox(height: ScreeWidth/4,width: ScreeHeight/2.1,
                        child: FadeInImage(image:NetworkImage(Mstr_Name_Img_lst[i]),
                          placeholder: AssetImage("assets/icon1.jpg"),
                          fadeInCurve: Curves.bounceOut,
                          fadeOutCurve:Curves.decelerate,
                          // fadeInDuration: Duration(seconds: 2,),
                          fadeOutDuration:Duration(seconds: 1,) ,),
                      )

                  ),

                    Expanded(
                      child: Center(
                        child: Text(Mstr_Name_lst[i],style: TextStyle(
                            fontSize: 25.0, color: Colors.black)),
                      ),
                    )


                ],),
              ),);
            },
          ),
        ),
      ),


    ));
  }
}
