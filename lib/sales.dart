import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:android_intent/android_intent.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/GT_Masters/AppTheam.dart';
import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';
import 'package:flutter_app/GT_Masters/Printing/New_Model_PdfPrint.dart';
import 'package:flutter_app/GT_Masters/Printing/PDF_Printer.dart';
import 'package:flutter_app/Local_Db/Local_db.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Company.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Godown.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_ItemMaster.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Sales.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/LD_model_UnitTyp.dart';
import 'package:flutter_app/Local_Db/Local_db_Model/Ld_Model_LedgerHeades.dart';
import 'package:flutter_app/Local_Db/Offline_Print.dart';
import 'package:flutter_app/Purchase.dart';
import 'package:flutter_app/Purchase_Index.dart';
import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/models/customeradditem.dart';
import 'package:flutter_app/models/customersearch.dart';
import 'package:flutter_app/models/finishedgoods.dart';
import 'package:flutter_app/models/paymentcondition.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:flutter_app/models/usersession.dart';
import 'package:flutter_app/newtestpage.dart';
import 'package:flutter_app/salesindex.dart';
import 'package:flutter_app/salesmanhome.dart';
import 'package:flutter_app/shopvisited.dart';
import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';

import 'GT_Masters/Printing/Gst_Print_Foramt.dart';



class Newsalespage extends StatefulWidget {

  dynamic itemrowdata=[];
  int passvalue;
  dynamic passname;
  Newsalespage({this.passvalue,this.passname,this.itemrowdata});




  @override
  _NewsalespageState createState() => _NewsalespageState();

}

class _NewsalespageState extends State<Newsalespage> {

  static List<LD_Model_UnitTyp> offline_unit = <LD_Model_UnitTyp>[];
  static List<LD_Model_Godown> offline_godown = <LD_Model_Godown>[];
  static List<LD_Model_ItemMaster> offline_itemMaster = <LD_Model_ItemMaster>[];
  static List<LD_Model_LedgerHeads> offline_LdgrMaster = <LD_Model_LedgerHeads>[];
  //static List<LD_Model_Company> offline_CompanyMaster = <LD_Model_Company>[];
  var  offline_CompanyMaster = [];

  ///--------------------------
  double TextBoxHeight=40;
  double TextBoxCurve=10;
  bool ItemsAdd_Widget_Visible=false;
  AutoCompleteTextField searchTextField;
  UserData userData;
  String branchName;
  dynamic userName;
  dynamic password;
  String token;
  dynamic openingAmountBalance = 0.0;
  double grandTotal = 0;
  dynamic delivery = "";
  double itmtxper=0.0;
  dynamic itmqty = "";
  double cessper=0.0;
  double CgstPer=0.0;
  double SgstPer=0.0;
  double Igstper=0.0;
  int TaxId=null;
  bool TaxInOrExc;
  dynamic Hsncode="";
  dynamic btnname="";
  // var formatter = NumberFormat('#,##,000.00');
  var formatter = NumberFormat('#,##,##,##,##0.00');
  int branchId;
  int userId;
  dynamic userArray;
  dynamic serverDate;
  UserSession usr;
  var DateOnlyFormat = new DateFormat('yyy/MM/dd');
  String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  TextEditingController salesdeliveryController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  List<dynamic> batchdata = [];
  List<dynamic> multibatchdata = [];
  dynamic user;
  bool boxvisible=true;
  AppTheam theam =AppTheam();

  static List<FinishedGoods> goods = new List<FinishedGoods>();
  static List<PaymentCondition> payment = new List<PaymentCondition>();
  static List<UnitType> unit = new List<UnitType>();
  static List<Godown> Gdwn = new List<Godown>();
  dynamic SalesEditDatas;
  dynamic Vouchnum;
  int itemGdwnId=null;
  double Srate;
  dynamic Edate;
  dynamic batchnum;
  dynamic nosunt;
  dynamic Brcode;
  dynamic StkId;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  var  _devicesMsg="";
  int customerSelectedId;
  String customerSelectedEmail;
  String customerSelectedName;

  TextEditingController controller = new TextEditingController();
  FocusNode field1FocusNode = FocusNode(); //Create first FocusNode

  String selectedLetter;
  TextEditingController customerController = new TextEditingController();
  TextEditingController godownController = new TextEditingController();
  TextEditingController goodsController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController generalRemarksController = new TextEditingController();
  TextEditingController paymentController = new TextEditingController();
  TextEditingController UnitController = new TextEditingController();
  TextEditingController paymentTypeController = new TextEditingController();
  TextEditingController InvNoController = new TextEditingController();
  TextEditingController DiscountController = new TextEditingController();
  TextEditingController Itemwise_DiscountController = new TextEditingController();



  GlobalKey<AutoCompleteTextFieldState<Customer>> key =
  new GlobalKey(); //only one autocomplte
  String selectedPerson = "";
  CustomerAdd customer;
  Saless sale;
  Salesedit slse;
  int salesItemId = null;
  int salesLedgerId = null;
  int salesPaymentId = null;
  int paymentType_Id = null;
  var Tax_IdNull=null;
  int unitId=null;
  dynamic deliveryDate;
  bool GSTtyp=false;// for check the GST type is IGST or SGST
//   validation variables
  bool customerSelect = false;
  bool GodownSelect = false;
  bool itemSelect = false;
  bool paymentSelect = false;
  bool unitSelect = false;
  bool deliveryDateSelect = false;
  bool rateSelect = false;
  bool quantitySelect = false;
  bool paymentTypeSelect = false;
  int slnum=0;
  CUWidgets cw=CUWidgets();
  static List<Salesedit> salesedt = new List<Salesedit>();
  static List<Saless> sales = new List<Saless>();
  static List<CustomerAdd> customerItemAdd = new List<CustomerAdd>();
  static List<Customer> users = new List<Customer>();
  bool loading = true;
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  bool negativeSalesAllow;
  var dataForTicket;
  var footerCaptions;
  bool checkboxval = false;
  // PrinterNetworkManager _printerManager = PrinterNetworkManager();
  var Companydata;
  var retunid;
  bool TaxTypeGst;
  var  paymentType=[{"id":0,"type":"Cash"},{"id":1,"type":"Credit"}];
  bool Save_Pending=false;
  double DiscountAmount=0.0;
  double ItemWiseDiscountAmount=0.0;

  FocusNode rateFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  FocusNode generalFocus = FocusNode();

  var DefultPrint_typ=null;
  SharedPreferences pref;

  dynamic slsname;
//  get Token
  read() async {
    var v = pref.getString("userData");
    print("USER DATA: $v");
    var c = json.decode(v);

    user = UserData.fromJson(c); // token gets this code user.user["token"]

    setState(() {
      branchId =int.parse(c["BranchId"]) ;
      print("user data......${branchId.toString()}..........");
      print(user.user["token"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      password = user.password;
      userName = user.user["userName"];
      print("123.....");
      print(branchName);
      print(userName);
      userId=user.user["userId"];
      GetCompantPro(branchId);
    });
  }

  bool internet_Connection=true;


  Initial_internet_check() async {

    var result = await (Connectivity().checkConnectivity());
    {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          internet_Connection=true;
        });
        return true;
      } else if (result == ConnectivityResult.none) {

        print("No internet Connection");
        setState(() {
          internet_Connection=false;
        });
      }
    }
  }


  internet_check()async{

    Connectivity().onConnectivityChanged.listen((event) {
      print(event);
      if(event==ConnectivityResult.none) {
        print("Noi nernet");
        setState(() {
          internet_Connection=false;
          GetOffline_data();
        });
        return event;
      }
      else{
        internet_Connection=true;
        print("Have inernet");

      }
    });


  }


  GetOffline_data()async{

    var _unit=  await  Local_Db().GetUnitData();
    var _godown=  await  Local_Db().GetGodownData();
    var _itemMstr=  await  Local_Db().GetItemMasterData();
    var _Ldgrmstr=  await  Local_Db().GetLedgerMasterData();
   // var _Ldcmpny=  await  Local_Db().GetCompanyMasterData();

    setState(() {
      offline_unit=_unit;
      offline_godown=_godown;
      offline_itemMaster=_itemMstr;
      offline_LdgrMaster=_Ldgrmstr;
    //  offline_CompanyMaster=_Ldcmpny;
    });

    print("------GetOffline data----1-------");
  }

  Save_toLocalDb()async{

    var req = [{
      "voucherDate": DateOnlyFormat.format(DateTime.now()),
      //serverDate.toString(),
      "orderHeadId": null,
      "orderDate": null,
      "expDate": null,
      "ledgerId": salesLedgerId,
      "partyName": slsname,
      "address1": null,
      "address2": null,
      "gstNo": null,
      "phone": null,
      "shipToName": null,
      "shipToAddress1": null,
      "shipToAddress2": null,
      "shipToPhone": null,
      "narration": generalRemarksController.text.toString(),
      "amount":Net_Amt_Befor_Tax,// (grandTotal-DiscountAmount),
      "userId": userId,
      "branchId": branchId,
      "otherAmt": 0.00,
      "discountAmt": 0.00,
      "creditPeriod": null,
      "paymentCondition": paymentType_Id.toString() == "0"
          ? "Cash"
          : "Credit",
      "paymentType": paymentType_Id,
      "invoiceType": "BtoB",
      "invoicePrefix": null,
      "invoiceSuffix": null,
      "cancelFlg": null,
      "entryDate": null,
      "slesManId": null,
      "branchUpdated": false,
      "saleTypeInterState": false,
      "salesDetails": sales,
      "salesExpense": [
        //   {
        //   "expenseLedgerId":1,
        //   "amount": null,
        //   "taxHeadId": null,
        //   "taxAmt": null,
        //   "cgstAmt": null,
        //   "sgstAmt": null,
        //   "igstAmt": null
        // }
      ]
    }];
    //  print("req $req");
    var parm=json.encode(req);
    var dd=json.decode(parm);
    print(parm.runtimeType);
    print(dd.runtimeType);

    List <dynamic> tagsJson =dd;
    List<LD_Model_Sales> ut = tagsJson.map((tagsJson) =>
        LD_Model_Sales.fromJson(tagsJson)).toList();

    //log("parm $parm");

    var res_id=await Local_Db().PostToSales(ut);

    print(res_id);
    print("res_id");
    Resetfunction();
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Center(child: Text("Sales Save")),
            ));
    return;

    // var res=await Local_Db().Get_Data_ForPrint(res_id);
    //
    // Offline_Print().Printerticket(:offline_CompanyMaster[0] ,dataForTicket:res[0] );





  }


  //--------------Get Tx Type-----------------------
  GetTax() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "MTaxes", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //   print(" Taxes= $res");

      List<dynamic> data = res["taxList"];
      print(" Taxas are");
      print(data[0]["txId"]);
      Tax_IdNull=data[0]["txId"];
    }
  }
  // get customer selectapi
  getCustomer() async {
    try {
      final response =
      await http.get("${Env.baseUrl}${Env.CustomerURL}", headers: {
        "Authorization": user.user["token"],
      });
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');
        Map<String, dynamic> data = json.decode(response.body);
        print("array is");
        print(data["lst"]); //used  this to autocomplete
        print("........");
        // print(response.statusCode);
        // print(data["lst"]);
        userArray = data["lst"];
        users = (data["lst"] as List)
            .map<Customer>((customer) =>
            Customer.fromJson(Map<String, dynamic>.from(customer)))
            .toList();
//        users=loadUsers(s.toString());
        return users;
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users");
    }
  }

  //get customer ledger balance
  getCustomerLedgerBalance(int accountId) async {
    try {
      final response = await http.get("${Env.baseUrl}getsettings",
          headers: {"accept": "application/json"});
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('...................');

        // print(response.body);

        List<dynamic> list = json.decode(response.body);
        print(list[0]["workingDate"] +
            "....................." +
            list[0]["workingTime"]);
        setState(() {
          serverDate = list[0]["workingDate"];
        });
        var formatter =
        new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want

        String formattedDate = formatter
            .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
        print(formattedDate);

        getLedger(accountId, formattedDate);
      } else {
        print("Error getting users");
      }
    } catch (e) {
      print("Error getting users" +e.toString());
    }
    print("customer Id is");
    print(accountId);
  }

  getLedger(dynamic acId, dynamic date) async {
    print("the acoound ti is " + acId.toString());
    print("the given date is");
    print("the dateis ti isdate" + date.toString());
    var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
    print("url:" + url);
    try {
      final response = await http.get(url, headers: {
        "Authorization": user.user["token"],
      });
//      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        var e = json.decode(response.body);
        print(e["openingAmount"]);
        setState(() {
          if (e["openingAmount"] > 0.0) {
            openingAmountBalance = e["openingAmount"];
          } else {
            print("opening amount is zero");
          }
        });
      }
    } catch (e) {
      print("error" + e);
    }
  }



  //--------------Get Inv no-----------------------
  GetInvNo() async {
    var jsonres = await cw.CUget_With_Parm(
        api: "getsettings/1/gtsales", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      print(res);
      setState(() {
        InvNoController.text=res[0]["vocherNo"].toString();
      });

    }
  }




  GeneralSettings()async{


    final res =
    await http.get("${Env.baseUrl}generalSettings", headers: {
      "Authorization": user.user["token"],
    });

    if(res.statusCode<210) {
      print(res);
      var GenSettingsData = json.decode(res.body);
      print(GenSettingsData[0]["applicationTaxTypeGst"]);
      setState(() {
        TaxTypeGst=GenSettingsData[0]["applicationTaxTypeGst"];

        print("TaxType");
        print(TaxTypeGst);
        DefultPrint_typ=GenSettingsData[0]["salesPrinterType"];
        negativeSalesAllow=GenSettingsData[0]["negativeSalesAllow"];
      });
    }
  }



  // get itemselectapi
  getFinishedGoods() async {
    String url = "${Env.baseUrl}GtItemMasters/1/1";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});

      print("goods Condition");
      if(res.statusCode==200) {
        //print(res.body);
        print("json decoded");

        var tagsJson = json.decode(res.body);
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<FinishedGoods> p = t
            .map((t) => FinishedGoods.fromJson(t))
            .toList();

        //print(p);
        goods = p;
      }
    } catch (e) {print("error on getFinishedGoods : $e");}
  }



  // get payment Condition
  getPaymentCondition() async {
    String url = "${Env.baseUrl}Mconditions";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});

      print("payment Condition");
      if(res.statusCode==200) {
        print(res.body);
        print("json decoded");

        var tagsJson = json.decode(res.body);
        print(tagsJson);
        List<dynamic> t = json.decode(res.body);
        List<PaymentCondition> p =
        t.map((t) => PaymentCondition.fromJson(t)).toList();

        print("ppp $p");
        payment = p;
      }
    } catch (e) {print("error on getPaymentCondition: $e");}
  }



  GetUnit() async {
    String url = "${Env.baseUrl}GtUnits";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("Units");
      print(res.body.toString());
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['gtunit'];
        List<UnitType> ut = tagsJson.map((tagsJson) =>
            UnitType.fromJson(tagsJson)).toList();
        print("uuuu : $ut");
        unit = ut;
      }
    } catch (e) {
      print("error on  unit= $e");
    }
  }



  GetGodown()async{
    String url = "${Env.baseUrl}Mgodowns";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("Units");
      if(res.statusCode==200) {
        List <dynamic> tagsJson = json.decode(res.body)['mGodown'];
        List<Godown> gd = tagsJson.map((tagsJson) =>
            Godown.fromJson(tagsJson)).toList();
        print("Godwon : $gd");
        Gdwn = gd;
        if(Gdwn.length==1){
          godownController.text =tagsJson[0]["gdnDescription"];
          itemGdwnId=tagsJson[0]["gdnId"];
        }
      }
    } catch (e) {
      print("error on  unit= $e");
    }

  }


  ///------------multiple item select-------------------
  var SelectedRowData=[];
  var SelectedRowDataSAmple=[];
  TextEditingController QtyController = new TextEditingController();
  bool ShowAllItem=false;
  var Net_VAt=0.0;
  var Net_Amt_Befor_Tax=0.0;
  ///-------------------------------

//for test ..........
//   salesSave() async {
//
//     print("sales length");
//
//     print(branchId);
//     print(userId);
//
//
//   }
  //.........................



  VlidationBeforeSave() async {
    int TblDatalength=0;
    if(btnname=="Save"){
      TblDatalength=sales.length;
    }else{
      TblDatalength=SalesEditDatas.length;
    }
    if(TblDatalength< 1){

      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Center(
                  child: Text(
                    "Please Add Item...",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
//              content: Text("user data:   " + user.user["token"]),
              ));
      return;
    }

    if(paymentType_Id!=null) {
      setState(() {
        paymentTypeSelect=false;
      });
      if (paymentType_Id.toString() == "1") {
        var Ldg_IdOnCash=await getsalesLedgerId(customerController.text);
        if(Ldg_IdOnCash==null){
          salesLedgerId=null;
        }


        if (salesLedgerId == null || customerController.text == "") {
          setState(() {
            print("salesLedgerId $salesLedgerId");
            customerSelect = true;
            return;
          });
        } else {
          setState(()  {
            customerSelect = false;
            slsname=customerController.text;
          });
          salesSave();
        }
      } else {
        setState(()  {
          customerSelect = false;
          slsname=customerController.text;
        });
        print("juio");
        salesSave();

      }
    }
    else{

      setState(() {
        paymentTypeSelect=true;
      });
    }

  }


//  sales save function ------------------------------------------------------

  salesSave() async {
    if(widget.passvalue==0 ||widget.passvalue==null ||(widget.itemrowdata).containsKey('ledgerName')) {
      //  var exDate=DateTime.now();
      setState(() {
        if (godownController.text == "") {
          print("Godown not selected");
          GodownSelect = true;
        }
        else {
          print("on");
          GodownSelect = false;
        }
      });


//------check off line or online
      if(internet_Connection==false){
        Save_toLocalDb();
        print("sales oflibe");
      }
      else{
        print("sales Online Save");


        final url = "${Env.baseUrl}SalesHeaders";
        // print("sales length");
        // print(sales.length);
        // print(sales);
        // print("list length");
        // print(customerItemAdd.length);
        delivery = "";
        delivery = salesdeliveryController.text.toString();
        var remarks = generalRemarksController.text.toString();
        // print("sales ledger Id");
        // print(salesLedgerId);
        // print("sales Item Id");
        // print(salesItemId);
        // print("sales payment Id");
        // print(salesPaymentId);
        // print("server date");
        // print(serverDate);
        // print("delivery date");
        // print(deliveryDate);
        // print("remarks");
        if (widget.itemrowdata !=
            null) { //add godown id for sals order converted data
          print("Datas from sales order");
          for (int i = 0; i < sales.length; i++) {
            if (sales[i].gdnId == null || sales[i].gdnId == 0) {
              print("gdnId is null");
              sales[i].gdnId = itemGdwnId;
            }
          }
        }


        var param = json.encode(sales);
        print("itms are : $param");

        // print("Saless : $sales");
        if (deliveryDateSelect || paymentSelect
            || customerItemAdd.length <= 0 || sales.length <= 0 ||
            godownController.text == "" || customerController.text == "" ||
            paymentTypeController.text.toString() == "null") {
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text(
                      "Please Check the fields",
                      style: TextStyle(color: Colors.red),
                    ),
//              content: Text("user data:   " + user.user["token"]),
                  ));
          return;
        } else {
          var exDate = DateTime.parse(serverDate);
          var param = json.encode(sales);
          print("Validation Complited itms are : $param");
          var req = {
            "voucherDate": DateOnlyFormat.format(DateTime.now()),
            "singVouchernumber": 0,
            "Mechinecode": user.deviceId,
            //serverDate.toString(),
            "orderHeadId": null,
            "orderDate": null,
            "expDate": DateOnlyFormat.format(exDate),
            "ledgerId": salesLedgerId,
            "partyName": slsname,
            "address1": null,
            "address2": null,
            "gstNo": null,
            "phone": null,
            "shipToName": null,
            "shipToAddress1": null,
            "shipToAddress2": null,
            "shipToPhone": null,
            "narration": remarks == "" ? null : remarks,
            "amount":Net_Amt_Befor_Tax,// grandTotal,
            "userId": userId,
            "branchId": branchId,
            "otherAmt": 0.00,
            "discountAmt": DiscountAmount,
            "balanceAmount":(grandTotal-DiscountAmount),
            "creditPeriod": null,
            "paymentCondition": paymentType_Id.toString() == "0"
                ? "Cash"
                : "Credit",
            "paymentType": paymentType_Id,
            "invoiceType": "BtoB",
            "invoicePrefix": null,
            "invoiceSuffix": null,
            "cancelFlg": null,
            "entryDate": null,
            "slesManId": null,
            "branchUpdated": false,
            "Tax_amt":Net_VAt,
            "saleTypeInterState": false,
            "salesDetails": sales,
            "salesExpense": [
              //   {
              //   "expenseLedgerId":1,
              //   "amount": null,
              //   "taxHeadId": null,
              //   "taxAmt": null,
              //   "cgstAmt": null,
              //   "sgstAmt": null,
              //   "igstAmt": null
              // }
            ]
          };

        print("the request is " + req.toString());
          var params = json.encode(req);
            print("the parameter is " + params.toString());

          print("iouioiououi");
          // debugPrint(params);
          log(params);

          setState(() {
            Save_Pending = true;
          });

          var res = await http.post(url,
              headers: {
                'accept': 'application/json',
                'content-type': 'application/json',
                'Authorization': user.user["token"],
                'deviceId': user.deviceId
              },
              body: params);

          print("salesSave : " + res.statusCode.toString());
          print("salesSave : " + res.body.toString());
          if (res.statusCode == 500) {
            var c = json.decode(res.body);
            var msg = c['erromsg'].toString();
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(msg),
                    ));
          }
          else if (res.statusCode == 200 || res.statusCode == 201) {
            print("401 : " + res.body.toString());
            try {
              String ms = "Out Of Stock";
              var c = json.decode(res.body);
              // var msg = c['outOfStockList']["data"].toString();
              // print("return" + msg);
              log("responce : "+c.toString());
              if (json.decode(res.body).containsKey('outOfStockList'))
                // if (msg.length >0)
                  {
                print("exist");
                // ms = msg;
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text(ms),
                        ));
                setState(() {
                  setState(() {
                    Save_Pending = false;
                  });
                });
              } else {
                retunid = await jsonDecode(res.body);
                // GetdataPrint(retunid['id']);
                setState(() {
                  Resetfunction();
                  customerItemAdd.clear();
                  sales.clear();
                  customerController.text = "";
                  // salesdeliveryController.text = "";
                  generalRemarksController.text = "";
                  paymentController.text = "";
                  salesLedgerId = null;
                  salesItemId = null;
                  salesPaymentId = null;
                  grandTotal = 0;
                });

                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Center(child: Text("Sales Saved...",style: TextStyle(color: Colors.green),)),
                        ));
                rateSelect = false;
                quantitySelect = false;
                Timer(Duration(microseconds: 10,), () {
                  print("Yeah, this line is printed after 2 seconds");
                  salesdeliveryController.text =
                      DateFormat("dd-MM-yyyy").format(DateTime.now());
                  // GetdataPrint(retunid['id']);
                  var _url = 'http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${retunid['id']}&uBr=$branchId&uNm=$userName&uP=$password';
                  // UrlLaunch(_url);
                  PdfPrint(retunid['id'],true,retunid);
                  // Navigator.pop(context);
                });
              }
            }
            catch (e) {
              print("error in update $e");
              cw.FailePopup(context);
              setState(() {
                Save_Pending = false;
              });
            }
          }
        }
      }





      //update part----------------------------------------editsave editpart-----------------------------------------
    }

    else{

      print("on else part");

      int id =widget.passvalue;
      final url = "${Env.baseUrl}SalesHeaders/$id";
      print("id=   $id");
      //print(salesedt.length);
      //print(salesedt);
      //print("list length");
      //print(customerItemAdd.length);
      delivery = "";
      delivery = salesdeliveryController.text.toString();
      var remarks = generalRemarksController.text.toString();

      //print("sales ledger Id");
      //print(salesLedgerId);
      //print("sales Item Id");
      //print(salesItemId);
      //print("sales payment Id");
      //print(salesPaymentId);
      //print("server date");
      //print(serverDate);
      //print("delivery date");
      //print(deliveryDate);
      // print("remarks");
      // print(SalesEditDatas);
      //  var param = json.encode(salesedt);
      // print("aaaasales : $param");

      var Ldg_IdOnCash=await getsalesLedgerId(slsname);
      print("Ldg_IdOnCash on edit ----$Ldg_IdOnCash");
      var req = {
        "id":widget.passvalue,
        "voucherNo": SalesEditDatas["salesHeader"][0]["voucherNo"],                            //on edit
        "voucherDate":DateOnlyFormat.format(DateTime.now()), //serverDate.toString(),
        "orderHeadId": null,
        "orderDate": null,
        "expDate": SalesEditDatas["salesHeader"][0]["expDate"].toString(),
        // "ledgerId":SalesEditDatas["salesHeader"][0]["ledgerId"].toString(),//salesLedgerId
        "ledgerId":Ldg_IdOnCash==null?null:salesLedgerId,
        "partyName": slsname,
        "address1": null,
        "address2": null,
        "gstNo": null,
        "phone": null,
        "shipToName": null,
        "shipToAddress1": null,
        "shipToAddress2": null,
        "shipToPhone": null,
        "narration": remarks,
        "amount":Net_Amt_Befor_Tax,// grandTotal,
        "userId":  userId,
        "branchId": branchId,
        "otherAmt": 0.00,
        "discountAmt": DiscountAmount,
        "creditPeriod": null,
        "paymentCondition": "",
        "paymentType": 0,
        "invoiceType": "BtoB",
        "invoicePrefix": null,
        "invoiceSuffix": null,
        "cancelFlg": null,
        "entryDate":SalesEditDatas["salesHeader"][0]["entryDate"].toString(),//null,// serverDate.toString(),
        "slesManId": null,
        "branchUpdated":false,
        "saleTypeInterState":false,
        "adjustAmount":0.0,
        "adlDiscAmount":0.0,
        "adlDiscPercent":0.0,
        "balanceAmount":(grandTotal-DiscountAmount),
        "cashReceived":0.0,
        "Tax_amt":Net_VAt,
        "otherAmountReceived":0.0,
        "salesDetails": salesedt,
        "salesExpense": []
      };
      // "salesExpense": [
      //   {
      //     "salesHeaderId": widget.passvalue,
      //   "expenseLedgerId":null,
      //   "amount": grandTotal,
      //   "taxHeadId": null,
      //   "taxAmt": 0,
      //   "cgstAmt": 0,
      //   "sgstAmt": 0,
      //   "igstAmt": 0
      // }
      //   ]
      print(req);
      print(jsonEncode(salesedt).toString());


      setState(() {
        if (customerController.text == "") {
          customerSelect = true;
        } else {
          customerSelect = false;
        }

        // if (salesPaymentId == 0 || paymentController.text == "") {
        //   paymentSelect = true;
        // } else {
        //   paymentSelect = false;
        // }
        if (delivery != "") {
          deliveryDateSelect = false;

          return;
        } else {
          deliveryDateSelect = true;
        }
      });
      // print("Saless : $sales");

      setState(() {

      });
      if (customerSelect || deliveryDateSelect || paymentSelect
          || customerItemAdd.length <= 0 ||salesedt.length <=0) {


        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Please Check the fields",
                style: TextStyle(color: Colors.red),
              ),
//              content: Text("user data:   " + user.user["token"]),
            ));
      } else {
        var params = json.encode(req);
        print("final data");
        debugPrint(params);



        setState(() {
          Save_Pending=true;
        });
        var res = await http.put(url,
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Authorization': user.user["token"],
              'deviceId': user.deviceId
            },
            body: params);
        //  print("saveddd");
        print("SalesHeaders of edit : "+res.statusCode.toString());
// testing------
        if (res.statusCode == 204) {

          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Sales Updated"),
                  ));
          rateSelect = false;
          quantitySelect = false;


          setState(() {
            Resetfunction();
            customerItemAdd.clear();
            sales.clear();
            salesedt.clear();
            customerController.text = "";
            salesdeliveryController.text = "";
            generalRemarksController.text = "";
            paymentController.text = "";
            salesLedgerId=null;
            salesItemId =null;
            salesPaymentId =null;
            grandTotal = 0;
            Resetfunction();
            var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${widget.passvalue}&uBr=$branchId&uNm=$userName&uP=$password';
            //UrlLaunch(_url);

          });
          Timer(Duration(seconds:1), () {
            print("this line is printed after 2 seconds");
            // Navigator.pop(context);
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => salesindex()));
            PdfPrint(widget.passvalue,true,params);
          });
        }
        //--------------------






        if (res.statusCode == 200 ||
            res.statusCode == 201 &&
                customerItemAdd.length > 0 &&
                salesedt.length > 0 &&
                salesLedgerId > 0 ) {
          // print("401 : " + res.body.toString());
          try {
            String ms = "Out Of Stock";
            var c = json.decode(res.body);
            // var msg = c['outOfStockList']["data"].toString();
            // print("return" + msg);
            // print(msg.length);
            if (json.decode(res.body).containsKey('outOfStockList'))
              // if (msg.length >0)
                {
              print("exist");
              // ms = msg;
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text(ms),
                      ));
              setState(() {
                Save_Pending=true;
              });
            } else {
              setState(() {
                customerItemAdd.clear();
                sales.clear();
                salesedt.clear();
                customerController.text = "";
                salesdeliveryController.text = "";
                generalRemarksController.text = "";
                paymentController.text = "";
                salesLedgerId =null;
                salesItemId =null;
                salesPaymentId=null;
                grandTotal = 0;
                Resetfunction();
              });

              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Sales Updated"),
                      ));
              rateSelect = false;
              quantitySelect = false;
              setState(() {
                Save_Pending=true;
              });
              Timer(Duration(seconds: 2), () {
                print("Yeah, this line is printed after 2 seconds");

                Navigator.pop(context);
              });
            }
          }
          catch(e){print("error in update $e");}
          cw.FailePopup(context);
          setState(() {
            Save_Pending=true;
          });
        }

      }
    }
  }




  @override
  void initState() {
    GetOffline_data();
    Initial_internet_check();
    if(widget.passname.toString()!= "null") {
      //   print("value rctptclln= " + widget.passvalue.toString());
      customerController.text = widget.passname;
      GetEditLedgerId();
      getCustomerLedgerBalance(salesLedgerId);
      slsname=widget.passname;
      salesdeliveryController.text=widget.itemrowdata['voucherDate'];
    }


    //  print("......");
    goodsController.text = "";
    SharedPreferences.getInstance().then((value) {
      pref = value;
      read();
      getCustomer();
      getFinishedGoods();
      getPaymentCondition();
      GetUnit();
      GetGodown();
      GetTax();
      GetInvNo();
      GeneralSettings();
      salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
      //testing----------------------------------------------
      if(widget.itemrowdata ==null)//for  sales create
          {
        print("itemrowdata...null");
        btnname="Save";
        getCustomerLedgerBalance(0);
        //printer function...
      }
      else if((widget.itemrowdata).containsKey('ledgerName')) //from sales order
          {
        databindingSoh( widget.itemrowdata["id"]);
        btnname="Save";
        print("from  sales Header //sales oreder");
        //printer function...
      }
      else
      {
        print("itemrowdata...have it"+  widget.itemrowdata["id"].toString()); // from sales list
        databinding( widget.itemrowdata["id"]);
        btnname="Update";
      }

      //-------------------------------------------
      footerdata();
      Priter_Initial_Part();
    });
//    getUsers();
    super.initState();
    customerController.addListener(customerLedgerIdListener);
    goodsController.addListener(itemIdListener);
    paymentController.addListener(paymentIdListener);
    UnitController.addListener(unitIdListener);
  }




  GetEditLedgerId()async{

    salesLedgerId=await getsalesLedgerId(widget.passname);
    print("-----GetEditLedgerId--$salesLedgerId--");
  }

  getsalesLedgerId(lhName){
    print("getsalesLedgerId");

    var s;

    if(internet_Connection==true){

      final _results = users.where((product) => product.lhName.toString() == lhName.toString());

      print(_results.toString());
      for (Customer p in _results) {

        s=p.id;

        print(p.lhName.toString());
        print("--------$s---------");
      }
      return s;
    }

    else

    {
      final _results = offline_LdgrMaster.where((product) => product.lhName.toString() == lhName.toString());

      print(_results.toString());
      for (LD_Model_LedgerHeads p in _results) {

        s=p.id;

        print(p.lhName.toString());
        print("--------$s---------");
      }
      return s;
    }
  }






  getItemIndex(dynamic item) {
    var index = customerItemAdd.indexOf(item);
    return index + 1;
  }

  customerLedgerIdListener() {

    setState(() {
      salesLedgerId ==null;
      openingAmountBalance = 0;
      print(customerController.text);
      print("item");
    });
  }

  itemIdListener() {
    setState(() {
      print("Item    .....................");
      //salesItemId = 0;
      print(goodsController.text);
    });
  }

  paymentIdListener() {
    print("payment");
    salesPaymentId == null;

    print(paymentController.text);
  }

  unitIdListener() {
    print("Unit");
    unitId == null;
    print(UnitController.text);
  }

  validationQuantity() {
    if (quantityController.text == "") {
      quantitySelect = true;
      validationRate();
    } else {
      quantitySelect = false;
      validationRate();
    }
  }

  validationRate() {
    if (rateController.text == "" ||rateController.text == "0.0" ) {
      rateSelect = true;
      validationUnit();
    } else {
      rateSelect = false;
      validationUnit();
    }
  }

  validationUnit() {
    if ( unitId ==null) {
      unitSelect = true;

    } else {
      unitSelect = false;
    }
  }


// add customer item----------------------------------------------------

  addCustomerItem() {

    print("add...... ");
    setState(() {
      if (salesItemId == null || goodsController.text == "") {
        itemSelect = true;
        validationQuantity();
//      validationRate();
      } else {
        itemSelect = false;
        validationQuantity();
//      validationRate();
      }
    });

    if (rateController.text == "" || unitId == null || rateController.text == "null"||
        quantityController.text == "" ||
        salesItemId == null ||rateController.text == "0.0") {
      print("check fields");
      print(salesItemId);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("check fields"),
//              content: Text("user data:   " + user.user["token"]),
          ));
      return;
    }
    var amount = double.parse(quantityController.text) *(double.parse(rateController.text)-ItemWiseDiscountAmount);
    // print(amount);
    // print(customerItemAdd.length);
    print(goodsController.text);
    dynamic itmName=goodsController.text;
    // print(quantityController.text);
    // print(rateController.text);
//    _markers.add(Marker(
//        markerId: MarkerId("Marker id"),
//    position: latLng,
//    infoWindow: InfoWindow(
//    title: 'Your Location',
//    snippet: 'More info',
//    ),
    dynamic  aftertax=0;
    dynamic  befortax=0;
    var igst=0.00;



    setState(() {
      var rate= double.parse(rateController.text)-ItemWiseDiscountAmount;
      // grandTotal = grandTotal + amount; // calc with out tax
      //  dynamic  aftertax=rate+((rate/100)*(itmtxper+cessper));

      // double cgst=double.parse(((rate/100)*CgstPer).toStringAsFixed(2));
      // double sgst=double.parse(((rate/100)*SgstPer).toStringAsFixed(2));
      dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2));

      print("amount  $amount");


      /// calc with tax
      //    var totligst=igst*double.parse(quantityController.text);
      //  var totlcgst=cgst*double.parse(quantityController.text);
      // var totlsgst=sgst*double.parse(quantityController.text);
      //    var taxOneItm =((rate/100)*(itmtxper+cessper));
      //  var  ToatalTax=taxOneItm*double.parse(quantityController.text);
      //    print("grandTotal before $grandTotal");
      //   grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
      //      aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
      //    print("grandTotal after $grandTotal");
      ///--------test calc with tax----------------



      var taxOneItm;
      var taxAmtOfCgst;
      var taxAmtOfSgst;
      var  ToatalTax;


      if(TaxInOrExc==true){

//  var WithOutTaxamt=((itmtxper+100)/100);
// print("gjgik");
//  print(WithOutTaxamt.toString());
//  //taxOneItm=rate/WithOutTaxamt;
//  taxOneItm=(rate/100)*itmtxper;
//   taxAmtOfCgst=(WithOutTaxamt/2);
//   taxAmtOfSgst=(WithOutTaxamt/2);
//  // ToatalTax =taxOneItm*double.parse(quantityController.text);
//   grandTotal = grandTotal + amount;
//   aftertax= amount;
//   befortax=taxOneItm*double.parse(quantityController.text);
        var WithOutTaxamt=((itmtxper+100)/100);
        taxOneItm=rate/WithOutTaxamt;
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);
        aftertax= amount;
        befortax=taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + aftertax;
      }
      else{

        taxOneItm =((rate/100)*(itmtxper+cessper));
        taxAmtOfCgst=(taxOneItm/2);
        taxAmtOfSgst=(taxOneItm/2);
        ToatalTax =taxOneItm*double.parse(quantityController.text);
        grandTotal = grandTotal + ToatalTax + amount;
        aftertax=ToatalTax + amount;
        befortax=amount;
      }


      if(GSTtyp==true){
        igst= Igst*double.parse(quantityController.text);
        taxAmtOfCgst=0;
        taxAmtOfSgst=0;
      }

      if(TaxTypeGst==false){

        igst=0.0;
        taxAmtOfCgst=0.0;
        taxAmtOfSgst=0.0;

      }


      Net_VAt=Net_VAt+(aftertax-befortax);
      print("aftertax".toString());
      print(aftertax.toString());
      print(befortax.toString());
      print(Net_VAt.toString());
      print((aftertax-befortax).toString());





      Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;

      // print("Final................");
      // print(taxOneItm.toString());
      // print("CGST = "+taxAmtOfCgst.toString());
      // print(aftertax.toString());
      // print("igst = "+igst.toString());

      print("Final................");
      print((customerItemAdd.length + 1).toString());
      print(itmName.toString());

      ++slnum;
      if(widget.passvalue==null|| widget.passvalue==0  ||(widget.itemrowdata).containsKey('ledgerName'))
      {
        print("on save part item add");

        sale = Saless(
          itmName:itmName,
          ItemSlNo:customerItemAdd.length + 1,//slnum,
          itemId:salesItemId,
          qty:double.parse(quantityController.text),
          rate:double.parse(rateController.text),
          disPercentage:0,
          cgstPercentage:CgstPer,
          sgstPercentage:SgstPer,
          cessPercentage:0,
          discountAmount:0,
          cgstAmount:(taxAmtOfCgst *double.parse(quantityController.text)),
          sgstAmount:(taxAmtOfSgst*double.parse(quantityController.text)),
          cessAmount:0,
          igstPercentage:Igstper,
          igstAmount:igst,
          taxPercentage:itmtxper,
          taxAmount:aftertax-befortax,
          //taxAmount:(((double.parse(rateController.text))/100)*(itmtxper))*double.parse(quantityController.text),
          taxInclusive:TaxInOrExc,
          amountBeforeTax:befortax,
          amountIncludingTax:aftertax,
          netTotal:aftertax,
          hsncode:Hsncode,
          gdnId:itemGdwnId,//1
          taxId:TaxId??Tax_IdNull,
          rackId:null,
          addTaxId:TaxId??Tax_IdNull,
          unitId:unitId,
          nosInUnit:nosunt,
          barcode:Brcode,
          StockId:StkId,
          BatchNo:batchnum,
          ExpiryDate:Edate,
          Notes:null,
          DiscountAmount: ItemWiseDiscountAmount

        );

        sales.add(sale);
        print(".............");
        print(sale.itemId);
        print(sale.qty);
        print(sale.rate);
        print(sales);
        var param = json.encode(sales);
        print("sales : $param");
        print("............");



      }
      else
      {
        print("on edit part8888 ");

        slse = Salesedit(
            shid:widget.passvalue,
            ItemSlNo:slnum,
            itemId:salesItemId,
            qty:double.parse(quantityController.text),
            rate:double.parse(rateController.text),
            disPercentage:0,
            cgstPercentage:CgstPer,
            sgstPercentage:SgstPer,
            cessPercentage:0,
            discountAmount:0,
            cgstAmount:(taxAmtOfCgst*double.parse(quantityController.text)),
            sgstAmount:(taxAmtOfSgst*double.parse(quantityController.text)),
            cessAmount:0,
            igstPercentage:Igstper,
            igstAmount:igst,
            taxPercentage:itmtxper,
            taxAmount:aftertax-befortax,
            //taxAmount:(((double.parse(rateController.text))/100)*(itmtxper))*double.parse(quantityController.text),
            taxInclusive:false,
            amountBeforeTax:befortax,
            amountIncludingTax:aftertax,
            netTotal:aftertax,
            hsncode:Hsncode,
            gdnId:itemGdwnId,
            taxId:TaxId??Tax_IdNull,
            rackId:null,
            addTaxId:TaxId??Tax_IdNull,
            unitId:unitId,
            nosInUnit:nosunt,
            barcode:Brcode,
            StockId:StkId,
            BatchNo:batchnum,
            ExpiryDate:Edate,
            Notes:null,
            adlDiscAmount:null,
            adlDiscPercent:null,
            //DiscountAmount: ItemWiseDiscountAmount
        );

        salesedt.add(slse);
        print(".............");
        print(slse.itemId);
        print(slse.qty);
        print(slse.rate);
        print(slse);
        var param = json.encode(slse);
        print("slse : $param");
        print("............");

      }
    });


    customer = CustomerAdd(
        id: salesItemId,
        slNo: customerItemAdd.length + 1,
        item: goodsController.text,
        quantity: double.parse(quantityController.text),
        rate: double.parse(rateController.text),
        txper:itmtxper,
        cess:cessper,
        NetAmt:aftertax,
        amount: amount,
        StkId:StkId,
        txAmt:aftertax-befortax,
        Disc_Amt: ItemWiseDiscountAmount

    );

    print(customer.item);
    setState(() {
      customerItemAdd.add(customer);
      ItemsAdd_Widget_Visible=false;
    });
    print(customerItemAdd);
    goodsController.text = "";
    quantityController.text = "";
    rateController.text = "";
    UnitController.text="";
    unitId=null;
  }

  // remove customer items
  removeListElement(int id, int sl, double netamount,double taxAmt) {
    print("on delete");
    if(netamount==null){
      netamount=0.00;
    }

    print(netamount.toString());
    print(taxAmt.toString());
    print("-----------remove--------");
    print("sl num = $sl");

    ///----test calc
    setState(() {
      grandTotal=  (grandTotal-netamount);
      Net_VAt=Net_VAt-taxAmt;
      Net_Amt_Befor_Tax=Net_Amt_Befor_Tax-(netamount-taxAmt);
      print(netamount);
    });
    ///----test calc
    customerItemAdd.removeWhere((element) => element.slNo == sl && element.id==id );
    sales.removeWhere((element) => element.ItemSlNo == sl && element.itemId==id );
    salesedt.removeWhere((element) => element.ItemSlNo == sl && element.itemId==id);

    // grandTotal = grandTotal - amount;
    setState(() {
      //
      // double taxamt=0.0;
      // taxamt= amount+((amount/100)*(itmtxper+cessper));
      // grandTotal=  (grandTotal-taxamt);
      //

      // grandTotal=  (grandTotal-amount); //with out tax

      print("end deleted");
      print(grandTotal);
      print("sales.length= "+sales.length.toString());
      print("salesedt.length= "+salesedt.length.toString());
      if(sales.length==0 && salesedt.length==0){
        grandTotal=0;
        Net_Amt_Befor_Tax=0.0;
        Net_VAt=0;
      }
      // slnum=slnum-1;
    });


  }


  Future<bool> _onBackPressed() {
    //  // Navigator.pop(context,salesLedgerId);
    Navigator.pop(context);
    customerItemAdd=[];
    Resetfunction();


    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => CustomerVisited(a:salesLedgerId.toString(),b:slsname.toString(),)),  );
    //


  }


  //testing --------------------



  //getbatch no----------itembatchcheck------------------
  getbatch(id)async
  {
    String url = "${Env.baseUrl}GtStocks/$id/-1/";
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("batch data GtStocks/$id/-1/");
      // print(res);
      if(res.statusCode<205) {
        var tagsJson = await json.decode(res.body);
        print("oi " + tagsJson.toString());
        batchdata = tagsJson['data'] as List;
        //  batchdata.forEach(print);
        print("batchdata length");
        // print(batchdata.length.toString());
        print(batchdata);


        if (batchdata.length > 1) {
          boxvisible = true;

          showDialog(
              context: context,
              builder: (context) =>
                  Visibility(
                    visible: boxvisible,
                    child: AlertDialog(
                      actions: [
                        Container(
                          height: 300,
                          width: 350,
                          child: Row(
//            verticalDirection: VerticalDirection.down,
//            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // SizedBox(
                              //   width: 60,
                              // ),

                              Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        showCheckboxColumn: false,
                                        columnSpacing: 17,
                                        onSelectAll: (b) {},
                                        sortAscending: true,
                                        columns: <DataColumn>[
                                          DataColumn(
                                            label: Text('Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Rate'),
                                          ),
                                          DataColumn(
                                            label: Text('Qty'),
                                          ),
                                          DataColumn(
                                            label: Text('Expiry Date'),
                                          ),
                                          DataColumn(
                                            label: Text('Batch No'),
                                          ),
                                          // DataColumn(
                                          //   label: Text('Amount'),
                                          // ),
                                          // DataColumn(
                                          //   label: Text('Add'),
                                          // ),
                                        ],
                                        rows: batchdata
                                            .map(
                                              (itemRow) =>
                                              DataRow(
                                                onSelectChanged: (a) {
                                                  print(itemRow['id']);
                                                  // id: 21
                                                  multibatchitembinding(
                                                      itemRow);

                                                  Navigator.pop(context);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Container(width: 150,
                                                      child: Text(
                                                          '${itemRow['itmName']
                                                              .toString()}(${itemRow['gdnDescription']
                                                              .toString()})'),
                                                    ),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        '${itemRow['srate']
                                                            .toString() ==
                                                            "null"
                                                            ? "-"
                                                            : itemRow['srate']
                                                            .toString()}'),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        '${itemRow['qty']
                                                            .toString()}'),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child:
                                                      //Text( '${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate']))}'),
                                                      Text(
                                                          (itemRow['expiryDate']) ==
                                                              null
                                                              ? "-:-:-"
                                                              : (DateFormat(
                                                              "dd-MM-yyyy")
                                                              .format(
                                                              DateTime.parse(
                                                                  itemRow['expiryDate'])))),
                                                    ),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  DataCell(
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Text(
                                                          '${itemRow['batchNo'] ??
                                                              "-"}'),

                                                    ),
                                                    showEditIcon: false,
                                                    placeholder: false,
                                                  ),
                                                  // DataCell(
                                                  //   GestureDetector(
                                                  //       onTap: () {
                                                  //
                                                  //       },
                                                  //       child: Icon(Icons.add_circle_outline_sharp)),
                                                  // ),
                                                ],
                                              ),
                                        )
                                            .toList(),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 3,
                              )
                            ],
                          ),
                        )
                      ],
//              content: Text("user data:   " + user.user["token"]),
                    ),
                  ));
        }

        else if (batchdata.length == 0) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  actions: [
                    Container(
                        height: 60,
                        width: 350,
                        child: Center(
                            child: Text("Stock Not Available...!",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 20),)
                        )),

                  ],
                ),
          );
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        }

        else {
          print("with one data");
          print(batchdata[0]["itmName"]);

          dynamic j = [];
          j = {
            "id": batchdata[0]["Id"],
            "itemId": id,
            "expiryDate": batchdata[0]["expiryDate"],
            "srate": batchdata[0]["Rate"],
            "batchNo": batchdata[0]["batchNo"],
            "nos": batchdata[0]["nos"],
            "barcode": batchdata[0]["barcode"],
            "godownId": batchdata[0]["godownId"]
          };
          print(j);
          multibatchitembinding(j);
        }
      }
      else if(res.statusCode==404){


        dynamic j = [];
        if(negativeSalesAllow){

          j = {
            "id": id,
            "itemId": id,
            "expiryDate": null,
            "srate": null,
            "batchNo": null,
            "nos": null,
            "barcode": null,
            "godownId":itemGdwnId
          };
          multibatchitembinding(j);


        }else{
         return showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) =>
                AlertDialog(
                  actions: [
                    Container(
                        height: 60,
                        width: 350,
                        child: Center(
                            child: Text("Stock Not Available...!",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 20),)
                        )),

                  ],
                ),
          );
        }


      }
    } catch (e) {
      print("error on  batch = $e");
    }

  }




//multiple batch item binding-----
  multibatchitembinding(rowdata)async {
    print("888888 data bind multibatchitembinding");
    print(rowdata);
    Edate=rowdata['expiryDate'];
    Srate=rowdata['srate']??0.00;
    batchnum=rowdata['batchNo'];
    nosunt=rowdata['nos'];
    Brcode=rowdata['barcode'];
    StkId=rowdata['id'];
    rateController.text=Srate.toString();
    int id=rowdata['itemId'];
    salesItemId =id;
    itemGdwnId=rowdata['godownId'].toString()=="null"?itemGdwnId:rowdata['godownId'];
   // print(id.toString());
    String url = "${Env.baseUrl}GtItemMasters/$salesItemId";
    var tagsJson;
    try {
      final res =
      await http.get(url, headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(res.body.toString());
      tagsJson = jsonDecode(res.body)["result"][0];
    }
    catch (e) {
      print("error on  batch = $e");
      var res= await Local_Db().Get_Selected_ItemData(salesItemId);
      tagsJson=res[0];
    }


   // print("====555555====");
    // print(tagsJson);
    // print(tagsJson['description'].toString());

    //goodsController.text =name;

   // print("close.... $salesItemId");

   // print( tagsJson["itmTaxInclusive"].toString());

    // salesItemId = tagsJson["id"];
    goodsController.text = tagsJson["itmName"];



    // print("nnnnn $salesItemId");
    // print("nnnnn "+goodsController.text);


    (tagsJson["txPercentage"] == null ||tagsJson["txPercentage"] == "null") ? itmtxper=0.0:itmtxper =tagsJson["txPercentage"];
    (tagsJson["atPercentage"] == null ||tagsJson["atPercentage"] == "null") ? cessper=0.0:cessper =tagsJson["atPercentage"];
    (tagsJson["description"] == null ||tagsJson["description"] == "null") ?  UnitController.text="": UnitController.text =tagsJson["description"];
    (tagsJson["itmUnitId"] == null ||tagsJson["itmUnitId"] == "null") ? unitId=null: unitId =tagsJson["itmUnitId"];
    (tagsJson["itmHsn"] == null ||tagsJson["itmHsn"]  == "null") ?  Hsncode ="": Hsncode =tagsJson["itmHsn"];
    (tagsJson["txCgstPercentage"] == null ||tagsJson["txCgstPercentage"] == "null") ?  CgstPer =0: CgstPer =tagsJson["txCgstPercentage"];
    (tagsJson["txSgstPercentage"] == null ||tagsJson["txSgstPercentage"] == "null") ?  SgstPer =0: SgstPer =tagsJson["txSgstPercentage"];
    (tagsJson["txIgstpercentage"] == null ||tagsJson["txIgstpercentage"] == "null") ?  Igstper =0: Igstper =tagsJson["txIgstpercentage"];
    (tagsJson["itmTaxId"] == null ||tagsJson["itmTaxId"]  == "null") ?  TaxId=null: TaxId =tagsJson["itmTaxId"];


    //------for offlinr data
    if(tagsJson["itmTaxInclusive"].runtimeType==int){
      TaxInOrExc=tagsJson["itmTaxInclusive"]==0?false:true;
    }else
    {
      TaxInOrExc=tagsJson["itmTaxInclusive"];
    }

if(Srate==0.0){
  tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null"? Srate=0.00: Srate =tagsJson["itmSalesRate"];
setState(() {
  rateController.text=Srate.toString();
});

}

    // (tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null") ? rateController.text="": Srate =tagsJson["itmSalesRate"];
    //rateController.text=Srate.toString();
    //Srate=rowdata['itmSalesRate'];
   // print("11111111$SgstPer");
   // print(tagsJson["description"]);
    print  ("888888 data bind multibatchitembinding Completed");

  }

  //----------------------------


  Resetfunction(){

    GodownSelect=false;
    ItemsAdd_Widget_Visible=false;
    customerSelect = false;
    deliveryDateSelect = false;
    rateSelect = false;
    quantitySelect = false;
    itemSelect = false;
    paymentSelect = false;
    customerItemAdd.clear();
    sales.clear();
    customerController.text = "";
    //salesdeliveryController.text = "";
    generalRemarksController.text = "";
    paymentController.text = "";
    grandTotal = 0;
    salesPaymentId = null;
    salesItemId = null;
    salesLedgerId = null;
    UnitController.text="";
    unitId=null;
    unitSelect=false;
    quantityController.text="";
    goodsController.text="";
    slnum=0;
    salesedt.clear();
    rateController.text="";
    paymentTypeController.text="";
    paymentType_Id=null;
    paymentTypeSelect=false;
    godownController.text="";
    itemGdwnId=null;
    Net_Amt_Befor_Tax=0.0;
    Net_VAt=0.0;
    GetInvNo();
    GetGodown();
    salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
    Save_Pending=false;

    btnname="Save";
    Itemwise_DiscountController.text="";
    ItemWiseDiscountAmount=0.0;
    DiscountAmount=0.0;
    DiscountController.text="";

  }

  Resetfuncttion(){

    ItemsAdd_Widget_Visible=false;
    DiscountController.text="";
    UnitController.text="";
    goodsController.text="";
    rateController.text="";
    paymentTypeController.text="";
    Itemwise_DiscountController.text="";
    generalRemarksController.text="";
    quantityController.text="";
    GetInvNo();

  }

//-------------------------------------------------------
  itemReEditing(items)async{

    print(items.StkId);
    var itmStkid=items.StkId;
    try {
      final res =
      await http.get(Env.baseUrl+"GtStocks/$itmStkid", headers: {"Authorization": user.user["token"]});


      var tagsJson = json.decode(res.body);
      print(tagsJson.toString());
      print(tagsJson["expiryDate"].toString());
      dynamic itemdata=[];
      itemdata={
        "id":itmStkid,
        "itemId":items.id,
        "expiryDate":tagsJson["expiryDate"],
        "srate":tagsJson["srate"],
        "batchNo":tagsJson["batchNo"],
        "nos":null,
        "barcode":tagsJson["barcode"],
        "godownId":tagsJson["godownId"]
      };
      print(itemdata);
      multibatchitembinding(itemdata);
      // removeListElement(items.id,
      //     items.slNo, items.NetAmt);

    }catch(e)
    {print("error on itemReEditing $e");}
    // GtStocks/$id/1/"
    // getbatch(items.StkId);
    quantityController.text=items.quantity.toString();
    // rateController.text=items.rate.toString();

    // id: salesItemId,
    // slNo: customerItemAdd.length + 1,
    // item: goodsController.text,
    // quantity: double.parse(quantityController.text),
    // rate: double.parse(rateController.text),
    // txper:itmtxper,
    // cess



  }
//-------------------------------------------------------
//--------------------------Barcode Reader----------------------

  void qr_Barcode_Readfunction() async {
    try {
      print("in qr_Barcode_Readfunction ");
      var result = await BarcodeScanner.scan();
      // print("type");
      // print(result.type);
      // print("rawContent");
      // print(result.rawContent);
      // print("format");
      // print(result.format);
      // print("formatNote");
      // print(result.formatNote);
      final jsonres =
      await http.get(Env.baseUrl+"GtitemMasters/1/${result.rawContent}/barcode", headers: {"Authorization": user.user["token"]});
      print("batch data");
      print(jsonres.statusCode);
      var tagsJson = jsonDecode(jsonres.body);
      print(tagsJson);
      print(tagsJson["result"][0]["id"]);

      print(result.formatNote);
      setState(() {
        getbatch(tagsJson["result"][0]["id"]);
        quantityController.text="1";
        // goodsController.text=result.rawContent.toString();
        FocusScope.of(context).requestFocus(rateFocus);

      });
    }
    catch(e) {  print("Error on qr_Barcode_Readfunction $e");}

  }





  ///-----------------------multiple item Select--------------------------------

  ShowAllItemPopup(Itemdata){
    showDialog(
        context: context,
        builder: (context) =>   AlertDialog(
          shape:RoundedRectangleBorder(
            side: BorderSide(color:  Colors.blueAccent, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),

          //  content: Itm_Slct_All_Popup(data: Itemdata,),
          actions: [
            // listreturn= Itm_Slct_All_Popup(data: Itemdata,)
            Column(
              children: [
                Container(color: Colors.white,
                  height: MediaQuery.of(context).size.width/1.2,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 14,
                        onSelectAll: (b) { },
                        sortAscending: true,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('Name'),
                          ),
                          // DataColumn(
                          //   label: Text('Qty'),
                          // ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                        ],
                        rows:goods
                            .map(
                              (itemRow)=>

                              DataRow(
                                selected:SelectedRowData.contains(itemRow),
                                color:MaterialStateColor.resolveWith(
                                      (states) {
                                    if (SelectedRowData.contains(itemRow)) {
                                      return Colors.teal;

                                    } else {
                                      return Colors.white;
                                    }
                                    setState(() {  });
                                  },

                                ),

                                onSelectChanged: (bool selected) {
                                  // print(itemRow.index);
                                  SelectedRows(selected, itemRow);
                                },

                                cells: [
                                  DataCell(
                                    Container(
                                      width: 150,
                                      child: Text('${itemRow.itmName.toString()}'),
                                    ),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text('${itemRow.itmSalesRate.toString()=="null"?
                                    0.0:itemRow.itmSalesRate.toString()}'),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                ],
                              ),

                        )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Container(height: 50,width: MediaQuery.of(context).size.width,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:2,right: 2),
                          child: ElevatedButton(
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700), ) ,
                              onPressed: (){
                                if(SelectedRowData.length<1){

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) =>   AlertDialog(
                                        shape:RoundedRectangleBorder(
                                          side: BorderSide(color:  Colors.red, width: 2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Center(child: Text("Add Item...!")),));


                                  Timer(Duration(milliseconds:1200),() {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  });

                                }else{
                                  Navigator.pop(context, SelectedRowData) ;
                                  MultipleItemAddtoTable();
                                }
                              },

                              child: Text("Add to Cart")),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:2,right: 2),
                          child: ElevatedButton(
                              style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), ) ,
                              onPressed: (){
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text("Cancel")),
                        ),
                      ),

                      Container(height: 30,width: 30,
                          decoration: BoxDecoration(color: Colors.teal,
                              borderRadius: BorderRadius.circular(20)),
                          child:Center(child: Text(SelectedRowData.length.toString())))
                    ],
                  ),)
              ],
            )
          ],
        ));

  }



  SelectedRows(bool stsus,FinishedGoods data)async{
    print("SelectedRows");
    print(data.itmUnitId);
    if (stsus) {



      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return  AlertDialog(
                shape:RoundedRectangleBorder(
                  side: BorderSide(color:  Colors.blueAccent, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(child: Text(data.itmName)),
                content:   Container(
                  width: 100,
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller:QtyController,
                          onFieldSubmitted: (val)  {
                            print('onSubmited $val');
                          },
                          // focusNode: generalFocus,
                          enabled: true,
                          validator: (v) {
                            if (v.isEmpty) return "Required";
                            return null;
                          },
//
//                  focusNode: field1FocusNode,
                          cursorColor: Colors.black,

                          scrollPadding:
                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            // curve brackets object
                            hintText: "Quantity",
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      ElevatedButton(onPressed: (){
                        setState(() {
                          Navigator.of(context, rootNavigator: true).pop();
                          ItemPushToArray(data,QtyController.text);
                        });
                      }, child: Text("OK"))
                    ],
                  ),
                ),


              );
            },
          );
        },
      );





    }

    else {





      setState(() {
        Navigator.of(context).pop();
        SelectedRowData.remove(data);
        SelectedRowDataSAmple.removeWhere((element) => element["id"] == data.id);

        ShowAllItemPopup(goods);
      });



    }











  }


  ItemPushToArray(FinishedGoods data,qty){
    print("ItemPushToArray");
    print(data.itmUnitId.toString());

    var json={
      "id" :data.id,
      "itmTaxInclusive":data.itmTaxInclusive,
      "itmName" :data.itmName,
      "qty":qty,
      "itmImage" :data.itmImage,
      "itmUserId" :data.itmUserId,
      "itmBranchId":data.itmBranchId,
      "txPercentage" :data.txPercentage,
      "atPercentage" :data.atPercentage,
      "description" :data.description,
      "itmHsn" :data.itmHsn,
      "unitId":data.itmUnitId,
      "itmUnitId":data.itmUnitId,
      "txCgstPercentage":data.txCgstPercentage,
      "txSgstPercentage":data.txSgstPercentage,
      "txIgstpercentage" :data.txIgstpercentage,
      "itmTaxId" :data.itmTaxId,
      "itmSalesRate" :data.itmSalesRate,
      "itmStkTypeId":data.itmStkTypeId
    };


    SelectedRowData.add(data);
    SelectedRowDataSAmple.add(json);
    setState(() {
      QtyController.text="";
    });
  }



  MultipleItemAddtoTable (){

    print(SelectedRowData.length.toString());


    print("SelectedRowDataSAmple");
    print(SelectedRowDataSAmple.length.toString());
    print(json.encode(SelectedRowDataSAmple).toString());


    var amount;
    dynamic itmName=goodsController.text;
    dynamic  aftertax=0;
    dynamic  befortax=0;
    var igst=0.00;
    var rate;
    //  dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2))
    var taxOneItm;
    var taxAmtOfCgst;
    var taxAmtOfSgst;
    var  ToatalTax;





    for(int i=0;i<SelectedRowDataSAmple.length;i++){
      itmtxper=SelectedRowDataSAmple[i]["txPercentage"]??0.0;
      TaxInOrExc=SelectedRowDataSAmple[i]["itmTaxInclusive"]??false;
      rate= SelectedRowDataSAmple[i]["itmSalesRate"]??0.0;
      var Qty= double.parse(SelectedRowDataSAmple[i]["qty"]??0);
      amount=rate*Qty;
      if(TaxInOrExc==true){

        var WithOutTaxamt=((SelectedRowDataSAmple[i]["txPercentage"]+100)/100);
        taxOneItm=rate/WithOutTaxamt;
        taxAmtOfCgst=(WithOutTaxamt/2);
        taxAmtOfSgst=(WithOutTaxamt/2);
        aftertax= amount;
        befortax=taxOneItm*Qty;
        grandTotal = grandTotal + aftertax;

      }
      else{

        taxOneItm =((rate/100)*(SelectedRowDataSAmple[i]["txPercentage"]??0.0));
        taxAmtOfCgst=(taxOneItm/2);
        taxAmtOfSgst=(taxOneItm/2);
        ToatalTax =taxOneItm*Qty;
        grandTotal = grandTotal + ToatalTax + amount;
        aftertax=ToatalTax + amount;
        befortax=amount;
      }

      Net_VAt=Net_VAt+(aftertax-befortax);
      Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;
      // if(GSTtyp==true){
      //   igst= Igst*double.parse(quantityController.text);
      //   taxAmtOfCgst=0;
      //   taxAmtOfSgst=0;
      // }

      if(TaxTypeGst==false){

        igst=0.0;
        taxAmtOfCgst=0.0;
        taxAmtOfSgst=0.0;

      }

      if(btnname=="Save") {
        sale = Saless(
          itmName: SelectedRowDataSAmple[i]["itmName"],
          // Total_amt:grandTotal,
          amountBeforeTax: befortax,
          amountIncludingTax: aftertax,
          barcode: Brcode,
          //batch:null,
          cessAmount: 0,
          cessPercentage: 0,
          cgstAmount: taxAmtOfCgst *Qty,
          cgstPercentage: SgstPer,
          discountAmount: 0,
          ExpiryDate: Edate,
          gdnId: itemGdwnId,
          igstAmount: igst,
          igstPercentage: Igstper,
          itemId: SelectedRowDataSAmple[i]["id"],
          ItemSlNo: i,
          netTotal: aftertax,
          nosInUnit: nosunt,
          Notes: null,
          //purchaseRate:aftertax,
          qty: Qty,
          rate: rate,
          sgstAmount: taxAmtOfSgst *Qty,
          sgstPercentage: SgstPer,
          taxAmount: aftertax - befortax,
          taxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxInclusive: false,
          unitId: SelectedRowDataSAmple[i]["unitId"],
          addTaxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxPercentage: SelectedRowDataSAmple[i]["txPercentage"],
          StockId: SelectedRowDataSAmple[i]["itmStkTypeId"],
            DiscountAmount: ItemWiseDiscountAmount
        );

        sales.add(sale);
        print("......save......");
      }
      else{


        slse = Salesedit(
          shid:widget.passvalue,
          // shid: salesLedgerId,
          //itmName: SelectedRowDataSAmple[i]["itmName"],
          // Total_amt:grandTotal,
          amountBeforeTax: befortax,
          amountIncludingTax: aftertax,
          barcode: Brcode,
          //batch:null,
          cessAmount: 0,
          cessPercentage: 0,
          cgstAmount: (taxAmtOfCgst *Qty),
          cgstPercentage: SgstPer,
          discountAmount: ItemWiseDiscountAmount,
          ExpiryDate: Edate,
          gdnId: itemGdwnId,
          igstAmount: igst,
          igstPercentage: Igstper,
          itemId: SelectedRowDataSAmple[i]["id"],
          ItemSlNo: i,
          netTotal: aftertax,
          nosInUnit: nosunt,
          Notes: null,
          //purchaseRate:aftertax,
          qty: Qty,
          rate: rate,
          sgstAmount: (taxAmtOfSgst*Qty),
          sgstPercentage: SgstPer,
          taxAmount: aftertax - befortax,
          taxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxInclusive: false,
          unitId: SelectedRowDataSAmple[i]["unitId"],
          addTaxId: SelectedRowDataSAmple[i]["itmTaxId"],
          taxPercentage: SelectedRowDataSAmple[i]["txPercentage"],
          StockId: SelectedRowDataSAmple[i]["itmStkTypeId"],
        );

        salesedt.add(slse);
        print("......Edit......");
      }



      customer = CustomerAdd(
          id: SelectedRowDataSAmple[i]["id"],
          slNo: i,
          item: SelectedRowDataSAmple[i]["itmName"],
          quantity:  double.parse(SelectedRowDataSAmple[i]["qty"]),
          rate:  SelectedRowDataSAmple[i]["itmSalesRate"],
          txper: SelectedRowDataSAmple[i]["txPercentage"],
          cess: null,
          NetAmt: aftertax,
          amount:amount ,
          StkId: SelectedRowDataSAmple[i]["itmStkTypeId"],
          txAmt:aftertax-befortax,
          Disc_Amt: ItemWiseDiscountAmount
      );

      customerItemAdd.add(customer);
    }
    print(customer);

    //var bindData=[];
    print(customerItemAdd.length);
    print(sales.length);

    setState(() {
      ItemsAdd_Widget_Visible=false;
    });
  }
  ///-------------------------------------------------------------------------------




  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
//      key: scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(190.0),
            child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Sales")
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),


            SizedBox(height:TextBoxHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TypeAheadField(
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(),
                        controller: customerController,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText: customerSelect
                              ? "Please Select Customer ?"
                              : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                print("cleared");
                                customerController.text = "";
                                salesLedgerId = null;
                                openingAmountBalance = 0;
                              });
                            },
                          ),

                          isDense: true,
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TextBoxCurve)),
                          // i need very low size height
                          labelText:
                          'customer search', // i need to decrease height
                        )),
                    suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 90.0),
                    suggestionsCallback: (pattern) {

                      if(internet_Connection==true){
                        return users.where((user) =>
                            user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                      }

                      else{
                        return offline_LdgrMaster.where((user) =>
                            user.lhName.toUpperCase().contains(pattern.toUpperCase()));
                      }


                    },
                    itemBuilder: (context, suggestion) {
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          tileColor: theam.DropDownClr,
                          title: Text(
                            suggestion.lhName,
                            style: TextStyle(color: Colors.white
                            ),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      print(suggestion.lhName);
                      print("selected");

                      customerController.text = suggestion.lhName;
                      print("close.... $salesLedgerId");
                      slsname = suggestion.lhName;
                      print(suggestion.id);
                      print(".......sales Ledger id");
                      salesLedgerId = suggestion.id;
                      if (suggestion.id != null) {
                        getCustomerLedgerBalance(suggestion.id);
                      }
                      print(salesLedgerId);
                      print("...........");
                    },
                    errorBuilder: (BuildContext context, Object error) =>
                        Text('$error',
                            style: TextStyle(
                                color: Theme.of(context).errorColor)),
                    transitionBuilder:
                        (context, suggestionsBox, animationController) =>
                        FadeTransition(
                          child: suggestionsBox,
                          opacity: CurvedAnimation(
                              parent: animationController,
                              curve: Curves.elasticIn),
                        )),
              ),
            ),


            Visibility(
              visible: openingAmountBalance > 0,
              child: SizedBox(
                height: 15,
              ),
            ),
            Visibility(
              visible: openingAmountBalance > 0,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: Text(
                      "Current Balance:  " + openingAmountBalance.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Visibility(
              visible: openingAmountBalance > 0,
              child: SizedBox(
                height: 9,
              ),
            ),

            SizedBox(height:GodownSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: 15),
                      showCursor: true,
                      controller: salesdeliveryController,
                      enabled: false,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
                      focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,

                      onTap: () async {
                        final DateTime now = DateTime.now();
                        DateTime date = await showDatePicker(
                            context: context,
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: now,
                            firstDate: now.subtract(Duration(days: 1)),
                            lastDate: DateTime(2080),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child,
                              );
                            });
                        deliveryDate = date;
                        var d = DateFormat("d-MM-yyyy").format(date);
                        salesdeliveryController.text = d;
                        // if (date != null) {
                        //   print(date);
                        //   if (date.day < DateTime.now().day) {
                        //     print("invalid date select");
                        //
                        //     salesdeliveryController.text = "";
                        //     return;
                        //   } else {
                        //     deliveryDate = date;
                        //     var d = DateFormat("yyyy-MM-d").format(date);
                        //     salesdeliveryController.text = d;
                        //   }
                        // }
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: deliveryDateSelect ? "invalid date " : null,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 24,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
                        hintText: "Inv: Date:dd/mm/yy",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Inv: Date",
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: godownController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: GodownSelect
                                    ? "Please Select Godown ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      godownController.text = "";
                                      itemGdwnId = null;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Godown search', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            if(internet_Connection==true) {
                              print("Gdwn online");
                              return Gdwn.where((gwn) =>
                                  gwn.gdnDescription.toUpperCase().contains(
                                      pattern.toUpperCase()));

                            }
                            else{
                              print("offline_godown online");
                              return offline_godown.where((gwn) =>
                                  gwn.gdnDescription.toUpperCase().contains(
                                      pattern.toUpperCase()));
                            }
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              // So you upgraded flutter recently?
                              // i upgarded more times
                              // flutter cleaned
                              // get pubed
                              // outdated more times..try
                              // but now result to bad...
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.gdnDescription,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.gdnDescription);
                            print("selected");
                            print(suggestion.gdnId);
                            godownController.text = suggestion.gdnDescription;
                            itemGdwnId=suggestion.gdnId;
                            print(".......${itemGdwnId.toString()}....");
                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
                  SizedBox(width: 10),
                ],
              ),
            ),




            SizedBox(
              width: 10,
            ),

            AddItemWidgets(context,ItemsAdd_Widget_Visible),


            ///-----------------------Payment Condition---------------------------------
            SizedBox(height:5),
            SizedBox(height:paymentTypeSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: paymentTypeController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: paymentTypeSelect
                                    ? "Invalid Payment Typ"
                                    : null,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      paymentTypeController.text = "";
                                      paymentType_Id=null;
                                    });
                                  },
                                ),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Payment Type', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
//                        print(payment);
                            return paymentType
//                            .where((user) => goods.itmName == pattern);
                                .where((us) => us['type'].toString().contains(pattern));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion["type"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion["type"],);
                            print("Item selected");

                            paymentTypeController.text = suggestion["type"];

                            print(suggestion['id']);
                            print("....... paymentType_Id id");
                            paymentType_Id = suggestion["id"];

                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
//              SizedBox(height: 10),
                  SizedBox(
                    width: 1,
                  ),
                  Visibility(visible:!ItemsAdd_Widget_Visible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child:   ElevatedButton(style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),),
                          onPressed: () {
                            if (itemGdwnId == null) {
                              setState(() {
                                GodownSelect = true;
                              });

                              return;
                            }
                            if (ShowAllItem == false) {
                              setState(() {
                                GodownSelect = false;
                                ItemsAdd_Widget_Visible =
                                !ItemsAdd_Widget_Visible;
                                Itemwise_DiscountController.text="";
                              });
                            }

                            else {
                              setState(() {
                                Itemwise_DiscountController.text="";
                                print("uiopupu");
                                SelectedRowDataSAmple = [];
                                SelectedRowData = [];
                                ShowAllItemPopup(goods);
                                ItemsAdd_Widget_Visible =
                                !ItemsAdd_Widget_Visible;
                                GodownSelect = false;

                              });
                            }
                          }, child:Text("ADD ITEMS",style: TextStyle(fontSize: 17),)),
                    ),
                  ),


                  Visibility(visible:!ItemsAdd_Widget_Visible,
                    child: Stack(
                      children: [

                        Positioned(left: 13,
                            child: Text(" All",style: TextStyle(fontSize: 12),)),

                        Checkbox(
                          value:ShowAllItem,
                          onChanged: (bool value) {
                            setState(() {
                              ShowAllItem = !ShowAllItem;

                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox( width: 5,),

                ],
              ),
            ),
//             Row(
//               children: [
//                 SizedBox(width: 10),
//                 Expanded(
//                     child: TypeAheadField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: TextStyle(),
//                             controller: paymentController,
//                             decoration: InputDecoration(
//                               errorStyle: TextStyle(color: Colors.red),
//                               errorText: paymentSelect
//                                   ? "Invalid Payment Selected"
//                                   : null,
//                               suffixIcon: IconButton(
//                                 icon: Icon(Icons.remove_circle),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     print("cleared");
//                                     paymentController.text = "";
//                                     salesPaymentId = 0;
//                                   });
//                                 },
//                               ),
//
//                               isDense: true,
//                               contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(TextBoxCurve)),
//                               // i need very low size height
//                               labelText:
//                               'Payment Condition', // i need to decrease height
//                             )),
//                         suggestionsBoxDecoration:
//                         SuggestionsBoxDecoration(elevation: 90.0),
//                         suggestionsCallback: (pattern) {
// //                        print(payment);
//                           return payment
// //                            .where((user) => goods.itmName == pattern);
//                               .where((us) => us.conDescription.contains(pattern));
//                         },
//                         itemBuilder: (context, suggestion) {
//                           return Card(
//                             color: Colors.blue,
//                             // shadowColor: Colors.blue,
//                             child: ListTile(
//                               tileColor: theam.DropDownClr,
//                               title: Text(
//                                 suggestion.conDescription,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                         onSuggestionSelected: (suggestion) {
//                           print(suggestion.conDescription);
//                           print("Item selected");
//
//                           paymentController.text = suggestion.conDescription;
//                           print("close.... $salesPaymentId");
//                           salesPaymentId = 0;
//
//                           print(suggestion.id);
//                           print(".......sales Item id");
//                           salesPaymentId = suggestion.id;
//                           print(salesPaymentId);
//                           print("...........");
//                         },
//                         errorBuilder: (BuildContext context, Object error) =>
//                             Text('$error',
//                                 style: TextStyle(
//                                     color: Theme.of(context).errorColor)),
//                         transitionBuilder:
//                             (context, suggestionsBox, animationController) =>
//                             FadeTransition(
//                               child: suggestionsBox,
//                               opacity: CurvedAnimation(
//                                   parent: animationController,
//                                   curve: Curves.elasticIn),
//                             ))),
// //              SizedBox(height: 10),
//                 SizedBox(
//                   width: 10,
//                 )
//               ],
//             ),
            SizedBox(
              height: 5,
            ),
            SizedBox(height: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType:TextInputType.number ,
                      controller:DiscountController,
                      cursorColor: Colors.black,
                      onChanged: (a){
                        try{
                          setState(() {

                           var Disamt=double.parse(DiscountController.text);
                               DiscountAmount=Disamt;
                          // Parese. DiscountController.text
                          });
                        }catch(e){
                          print("error on DiscountAmount $e");
                          setState(() {
                            DiscountAmount=0.0;
                          });
                        }
                      },
                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),

                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Discount",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller:InvNoController,
                      cursorColor: Colors.black,
                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      decoration: InputDecoration(
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Inv.No",
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: generalRemarksController,
                      focusNode: generalFocus,
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "General Remarks",
                      ),
                    ),
                  ),
                ],
              ),
            ),



            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment:MainAxisAlignment.end ,
              children: [
                // SizedBox(
                //   width: 10,
                // ),
                Visibility(
                  visible:Save_Pending==false,
                  child: GestureDetector(
                      onTap: () {
                        print("Save");
                        //salesSave();
                        VlidationBeforeSave();
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Save_Pending==true?Colors.grey:
                          theam.saveBtn_Clr,
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            btnname,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      )

                  ),
                ),
                SizedBox(width:10),
                // SizedBox(width:MediaQuery.of(context).size.width  *0.44),
                GestureDetector(
                    onTap: () {
                      print("Reset");
                      setState(() {

                        // internet_check();
                        Resetfunction();
                      });
                    },
                    child:Container(alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    )

                ),
                SizedBox(width:10),
                // Padding(
                //   padding: EdgeInsets.only(left: 164.0, right: 0.0),
                //   child: RaisedButton(
                //     textColor: Colors.white,
                //     color: Colors.lightBlueAccent,
                //     child: Text("Reset"),
                //     onPressed: () {
                //       setState(() {
                //         customerSelect = false;
                //         deliveryDateSelect = false;
                //         rateSelect = false;
                //         quantitySelect = false;
                //         itemSelect = false;
                //         paymentSelect = false;
                //         customerItemAdd.clear();
                //         sales.clear();
                //         customerController.text = "";
                //         salesdeliveryController.text = "";
                //         generalRemarksController.text = "";
                //         paymentController.text = "";
                //         grandTotal = 0;
                //         salesPaymentId = 0;
                //         salesItemId = 0;
                //         salesLedgerId = 0;
                //       });
                //     },
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(TextBoxCurve),
                //     ),
                //   ),
                // ),
              ],
            ),

            //-----test-------
            // GestureDetector(child: Text("rtrtzxrtrtrt",style: TextStyle(color: Colors.red),),
            //   onTap: (){
            //    // GetdataPrint(352);
            //     GetGodown();
            //   },),



            SizedBox(
              height: 0,
              // width: 30,
            ),
            Visibility(
              visible: customerItemAdd.length > 0,
              child: Row(
                //verticalDirection: VerticalDirection.down,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width: 1,
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        dataRowHeight: 38,
                        onSelectAll: (b) {},
                        sortAscending: true,
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('No',textAlign: TextAlign.left,),
                          ),
                          DataColumn(
                            label: Text('Item'),
                          ),
                          DataColumn(
                            label: Text('QTY'),
                          ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                          DataColumn(
                            label: Text('Disc'),
                          ),
                          DataColumn(
                            label: Text('Tax %'),
                          ),
                          DataColumn(
                            label: Text('Tax Amt'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                          DataColumn(
                            label: Text(''),
                          ),
                        ],
                        rows: customerItemAdd
                            .map(
                              (itemRow) => DataRow(
                            onSelectChanged: (a){
                              print(itemRow.item);


                              showDialog(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                      title: Text("Are you sure to delete? ",textAlign: TextAlign.center,),
                                      content:Text("${itemRow.item}",textAlign: TextAlign.center,style:TextStyle(color: Colors.teal,fontSize: 25,fontWeight: FontWeight.bold)),
                                      actions: [
                                        FlatButton(
                                          child: Text("No",style: TextStyle(color: Colors.black),),
                                          onPressed: () {
                                            setState(() {
                                              print("No...");
                                              Navigator.pop(
                                                  context); // this is proper..it will only pop the dialog which is again a screen
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Yes",style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            setState(() {
                                              print("Yes");
                                              removeListElement(itemRow.id,
                                                  itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                              Navigator.pop(
                                                  context);
                                            });
                                          },
                                        )
                                      ]));

                            },
                            cells: [
                              DataCell(
                                Text(getItemIndex(itemRow).toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(itemRow.item.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(itemRow.quantity.toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text((itemRow.rate??0.0).toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(itemRow.Disc_Amt.toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,
                                  child: Text((itemRow.txper)!=null?itemRow.txper.toString():0.0
                                      .toString()),
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,
                                  child: Text((itemRow.txAmt)!=null?itemRow.txAmt.toStringAsFixed(2):0.0
                                  //((itemRow['amount']!=null))?formatter.format((itemRow['amount'])):"0.0"
                                      .toString()),
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Align(alignment: Alignment.centerRight,child: Text(formatter.format(itemRow.NetAmt).toString())),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                IconButton(icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      removeListElement(itemRow.id,
                                          itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 40,
                  // )
                ],
              ),
            ),


            Visibility(
                visible:grandTotal > 0,
                child: Divider(color: Colors.black,)),
            Visibility(
                visible: grandTotal > 0,
                child: Row(mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    Column(children: [
                      Text('Total Amt : ',
                          style: TextStyle(fontSize: 20,color: Colors.black,)),

                      Text('Discount : ',
                          style: TextStyle(fontSize: 20,color: Colors.black,)),

                      Text('Total ${TaxTypeGst==true?"GST":"VAT"}  : ',
                          style: TextStyle(fontSize: 20,color: Colors.black,)),
                      Text('Net Amt   : ',
                          style: TextStyle(fontSize: 20,color: Colors.black,)),

                    ],),

                    Column(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(Net_Amt_Befor_Tax.toStringAsFixed(2),
                            style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
                        Text(DiscountAmount.toStringAsFixed(2),
                            style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
                        Text(Net_VAt.toStringAsFixed(2),
                            style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
                        Text(formatter.format(grandTotal-DiscountAmount),
                            style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),

                      ],),
                    SizedBox(width: MediaQuery.of(context).size.width/4,)
                  ],)
//         Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 90,
//                   ),
//                   Expanded(
//                     child: TextField(
//                       readOnly: true,
//                       controller: controller,
//                       style: TextStyle(
//                           color: Colors.lightBlue,
// //                      fontFamily: Font.AvenirLTProMedium.value,
//                           fontSize: 17),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         // hintText: 'Total Amount : $grandTotal',
//                         hintText: 'Total Amt : '+formatter.format(grandTotal),
//                         hintStyle:  TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                           backgroundColor: Colors.white10,
// //                          fontFamily: Font.AvenirLTProBook.value)
//                         )
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
            ),
            //
            // IconButton(icon: Icon(Icons.ac_unit), onPressed: () async {
            //
            //
            //
            //
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               GST_Print_Format(Parm_Id: 17, title:"title",  Details_Data: "")
            //               ));
            //
            //
            //    }),

            WillPopScope(

              onWillPop: _onBackPressed,
              child: Text(""),
            ),
            // SizedBox(height:500),
            //  SizedBox(height: MediaQuery.of(context).viewInsets.top),
            // SizedBox(height:  MediaQuery.of(context).size.width*1),

          ],
        ),


        // resizeToAvoidBottomInset: false,


        bottomSheet: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Container(color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,bottom: 15),
              child: FloatingActionButton(

                  backgroundColor: Colors.blue,
                  hoverColor: Colors.red,  elevation: 5,

                  child: Icon(Icons.home_filled),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder:(context) =>
                            SalesManHome()), (route) => false);
                    customerItemAdd=[];
                  }),

            ),
          ),
        ),
        floatingActionButton:Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: SpeedDial(
              animatedIcon:AnimatedIcons.menu_arrow,
              overlayColor: Colors.blue,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add_business),
                    backgroundColor: Colors.blue,
                    label: "Purchase",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Purchase(
                                passvalue: null,
                                passname: null.toString(),
                              )));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.description_outlined),
                    backgroundColor: Colors.blue,
                    label: "Sales Index",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>salesindex()));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.description_outlined),
                    backgroundColor: Colors.blue,
                    label: "Purchase Index",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Purchase_Index()));
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.request_quote_outlined),
                    backgroundColor: Colors.blue,
                    label: "Ledger Balance",
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newtestpage(passvalue:slsname.toString(),Shid:salesLedgerId)),  );
                    } ),
                SpeedDialChild(
                    child: Icon(Icons.remove_red_eye_outlined),
                    backgroundColor: Colors.blue,
                    label: "Shop Visited",
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shopvisited(passvalue:salesLedgerId,passname:slsname.toString(),)));
                    } ),
              ]),
        ),

      ),
    );
  }
  ///----------------------------------ItemsAdd part ----------------------------------------

  Visibility AddItemWidgets(BuildContext context,bool visibility) {
    return Visibility( visible: visibility,
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 3),
        child: Container(decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),color: Colors.blueGrey.shade50),
          child: Column(children: [
            SizedBox(
              height: 6,
            ),
            SizedBox(height: itemSelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(width: 10),

                  // Text("IGST",style: TextStyle(fontSize: 12),),
                  //
                  // Checkbox(
                  //   value: this.GSTtyp,
                  //   onChanged: (bool value) {
                  //     setState(() {
                  //       this.GSTtyp = value;
                  //
                  //       print("GSTtyp $value");
                  //     });
                  //   },
                  // ), //Checkbox

                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              style: TextStyle(),
                              controller: goodsController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                errorText: itemSelect
                                    ? "Please Select product Item ?"
                                    : null,
//                            errorText: _validateName ? "please enter name" : null,
//                            errorBorder:InputBorder.none ,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print("cleared");
                                      goodsController.text = "";
                                      salesItemId = null;
                                      openingAmountBalance = 0;
                                      rateController.text="";
                                    });
                                  },
                                ),


                                prefixIcon:  IconButton(icon: Icon(Icons.qr_code,color: Colors.black,), onPressed: (){

                                  qr_Barcode_Readfunction();
                                }),

                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TextBoxCurve)),
                                // i need very low size height
                                labelText:
                                'Item search', // i need to decrease height
                              )),
                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            if(internet_Connection==true) {
                              return goods.where((user) =>
                                  user.itmName.trim().toLowerCase().contains(
                                      pattern.trim().toLowerCase()));
                            }
                            else{
                              return offline_itemMaster.where((user) =>
                                  user.itmName.trim().toLowerCase().contains(
                                      pattern.trim().toLowerCase()));
                            }

                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              // shadowColor: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.itmName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.itmName);
                            print("item selected");
                            setState(() {
                               getbatch(suggestion.id);
                              var j={
                                "id":suggestion.id,
                                "itemId":suggestion.id,
                                "expiryDate":null,
                                "srate":suggestion.itmSalesRate,
                                "batchNo":null,
                                "nos":null,
                                "barcode":suggestion.itmBarCode,
                                "godownId":itemGdwnId
                              };
                             // multibatchitembinding(j);
                            });


                            print(salesItemId);
                            print("...........");

                            //  print(".........$cessper..");
                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
                  SizedBox(
                    width: 10,
                    height: 5,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(height:quantitySelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      onEditingComplete: (){
                        qtyFocus.unfocus();
                        FocusScope.of(context).requestFocus(rateFocus);
                      },
                      focusNode: qtyFocus,
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
                      // will disable paste operation
//                  focusNode: field1FocusNode,
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                      ],
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: quantitySelect ? "Invalid Qty" : null,
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),

                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Quantity",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
//----------------unit-------------------
                  Expanded(
                      child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller:UnitController ,
                            style: TextStyle(),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              errorText: unitSelect
                                  ? "Invalid Unit Selected"
                                  : null,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_circle),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    print("cleared");
                                    UnitController.text = "";
                                    //  salesPaymentId = 0;
                                  });
                                },
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TextBoxCurve)),

                              hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                              labelText: "Unit",
                            ),
                          ),

                          suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(elevation: 90.0),
                          suggestionsCallback: (pattern) {
                            print("internet_Connection");
                            print(internet_Connection);
                            print(unit.length.toString());
                            print(offline_unit.length.toString());

                            if(internet_Connection==true)
                              return unit.where((unt) => unt.description.contains(pattern));
                            return offline_unit.where((unt) => unt.description.contains(pattern));
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              color: Colors.blue,
                              child: ListTile(
                                tileColor: theam.DropDownClr,
                                title: Text(
                                  suggestion.description,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            print(suggestion.description);
                            print("Unit selected");

                            UnitController.text = suggestion.description;
                            print("close.... $unitId");
                            unitId = null;

                            print(suggestion.id);
                            print(".......Unit id");
                            unitId = suggestion.id;
                            print(unitId);
                            print("...........");
                          },
                          errorBuilder: (BuildContext context, Object error) =>
                              Text('$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor)),
                          transitionBuilder:
                              (context, suggestionsBox, animationController) =>
                              FadeTransition(
                                child: suggestionsBox,
                                opacity: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.elasticIn),
                              ))),
                  SizedBox(
                    width: 10,
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(height:quantitySelect==true?60: TextBoxHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: TextFormField(
                      keyboardType:TextInputType.number ,
                      controller:Itemwise_DiscountController,
                      cursorColor: Colors.black,
                      onChanged: (a){
                        try{
                          setState(() {

                            var Disamt=double.parse(Itemwise_DiscountController.text);
                            ItemWiseDiscountAmount=Disamt;

                          });
                        }catch(e){
                          print("error on ItemWiseDiscountAmount $e");
                          setState(() {
                            ItemWiseDiscountAmount=0.0;
                          });
                        }
                      },
                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),

                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                        labelText: "Discount",
                      ),
                    ),
                  ),
                  SizedBox(width: 4),


                  Expanded(
                    child: TextFormField(
                      controller: rateController,
                      focusNode: rateFocus,
                      onEditingComplete: (){
                        rateFocus.unfocus();
                        FocusScope.of(context).requestFocus(generalFocus);
                      },
                      enabled: true,
                      validator: (v) {
                        if (v.isEmpty) return "Required";
                        return null;
                      },
//
                      cursorColor: Colors.black,

                      scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      keyboardType: TextInputType.number,

                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}")),
                      ],
                      decoration: InputDecoration(

//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                        errorStyle: TextStyle(color: Colors.red),
                        errorText: rateSelect ? "Invalid Rate" : null,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TextBoxCurve)),
                        // curve brackets object
//                    hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                        labelText: "Rate",
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),


            Row(

              children: [

                // SizedBox(
                //   width: 400,
                // ),

                Text("IGST",style: TextStyle(fontSize: 12),),

                Checkbox(
                  value: this.GSTtyp,
                  onChanged: (bool value) {
                    setState(() {
                      this.GSTtyp = value;

                      print("GSTtyp $value");
                    });
                  },
                ), //Ch


                Expanded(
                  child: InkWell(
                    onTap:addCustomerItem,
                    child: Container(child: Center(child: Text("Add",style:
                    TextStyle(color: Colors.white,fontSize: 25),)),color: Colors.green,
                      height: 40,
                    ),
                  ),
                ),
                SizedBox(width: 10,),

                Expanded(
                  child: InkWell(
                    onTap: (){
                      Resetfuncttion();
                  },
                    child: Container(child: Center(child: Text("Hide",style:
                    TextStyle(color: Colors.white,fontSize: 25),)),color: Colors.indigo,
                      height: 40,
                    ),
                  ),
                ),
                     SizedBox(width: 15,),

//                 SizedBox.fromSize(
//                   size: Size(45, 45), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Colors.lightBlueAccent, // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: addCustomerItem,
// //                      onPressed: ,
//                         // button pressed
//                         child: Icon(
//                           Icons.add,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
              ],
            ),

          ],),
        ),
      ),
    );
  }

  ///------------------------------------------------------------------------




  Future<Null> refreshList() async {

    await Future.delayed(Duration(seconds: 1));

    setState(() {

    });

    return null;
  }

  databinding(id) async{
    print("databinding sales : $id");
    double amount =0.0;
    try {
      final bindata =
      await http.get("${Env.baseUrl}SalesHeaders/$id", headers: { //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
    //  log("databinding sales edit"+bindata.body.toString());
      print("databinding sales edit ${bindata.statusCode.toString()}");
      print(bindata.statusCode);

      var tagsJson = jsonDecode(bindata.body);




      SalesEditDatas=tagsJson;

      // print("databinding decoded  "+(tagsJson["salesHeader"][0]["voucherDate"]).toString());
      paymentTypeController.text=tagsJson["salesHeader"][0]["paymentType"]=="0"?"Cash":"Credit";
      (tagsJson["salesHeader"][0]["narration"] == null)? generalRemarksController.text="":generalRemarksController.text=tagsJson["salesHeader"][0]["narration"];
      var bindDt="-:-:-";
      print(tagsJson["salesHeader"][0]["voucherDate"]);
      var vchDate =tagsJson["salesHeader"][0]["voucherDate"];
      if(vchDate!=null)
      {

        var prsDt = DateTime.tryParse(
            tagsJson["salesHeader"][0]["voucherDate"]);
        bindDt = DateFormat("d-MM-yyyy").format(prsDt);
      }


      setState(() {
        paymentType_Id=tagsJson["salesHeader"][0]["paymentType"];
        paymentTypeController.text=tagsJson["salesHeader"][0]["paymentType"].toString()=="0"?
        "Cash":"Credit";
      });
      salesdeliveryController.text=bindDt;
      deliveryDate=bindDt;
      Vouchnum=tagsJson["salesHeader"][0]["voucherNo"];
      List <dynamic> binditm =tagsJson["salesDetails"]as List;
      print("binditm");
      print(binditm);
      for(int i=0;i<binditm.length;i++)
      {
        Net_VAt=Net_VAt+(binditm[i]["taxAmount"]);
        Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+binditm[i]["amountBeforeTax"];
        print(binditm[i]["itmName"]);
        customer = CustomerAdd(
          id: binditm[i]["itemId"],
          slNo: customerItemAdd.length + 1,
          item: binditm[i]["itmName"],
          quantity:binditm[i]["qty"],
          rate: binditm[i]["rate"],
          txper: binditm[i]["taxPercentage"],
          amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
          StkId:binditm[i]["stockId"],
          NetAmt: (binditm[i]["amountIncludingTax"]),
          txAmt:binditm[i]["taxAmount"],
          Disc_Amt:binditm[i]["discountAmount"],

          //  txAmt:(binditm[i]["rate"]/100)*(binditm[i]["taxPercentage"]??0.0)
          //txAmt: (binditm[i]["amountIncludingTax"]-(binditm[i]["rate"])*(binditm[i]["qty"]))
        );

        setState(() {
          ++slnum;

          //  grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]); // with out tax
          // grandTotal=grandTotal+(binditm[i]["amountIncludingTax"]); // with  tax
          //  grandTotal=Net_VAt+Net_Amt_Befor_Tax;
          grandTotal=tagsJson["salesHeader"][0]["balanceAmount"];
          slse = Salesedit(
              ItemSlNo :slnum,
              shid:widget.passvalue,
              itemId: binditm[i]["itemId"],
              qty: binditm[i]["qty"],
              rate:binditm[i]["rate"],
              disPercentage: binditm[i]["disPercentage"]== null?0:binditm[i]["disPercentage"],
              cgstPercentage:binditm[i]["cgstPercentage"]== null?0:binditm[i]["cgstPercentage"],
              sgstPercentage: binditm[i]["sgstPercentage"],
              cessPercentage: binditm[i]["cessPercentage"],
              discountAmount: binditm[i]["discountAmount"],
              cgstAmount: binditm[i]["cgstAmount"],
              sgstAmount: binditm[i]["sgstAmount"],
              cessAmount: binditm[i]["cessAmount"],
              igstPercentage: binditm[i]["igstPercentage"],
              igstAmount: binditm[i]["igstAmount"],
              taxPercentage: binditm[i]["taxPercentage"],
              // taxPercentage:itmtxper == null?0:itmtxper,
              taxAmount:binditm[i]["taxAmount"],
              //  taxAmount: ((binditm[i]["rate"]/100)*(binditm[i]["taxPercentage"]))*(binditm[i]["qty"]),
              taxInclusive :false,
              amountBeforeTax: binditm[i]["amountBeforeTax"],
              // amountBeforeTax: ( binditm[i]["rate"])* (binditm[i]["qty"]),
              amountIncludingTax: binditm[i]["amountIncludingTax"],
              //( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["taxPercentage"]),
              netTotal:binditm[i]["amountIncludingTax"],
              gdnId:binditm[i]["gdnId"],
              taxId:binditm[i]["taxId"],
              rackId:binditm[i]["rackId"],
              addTaxId: binditm[i]["taxId"],
              unitId: binditm[i]["unitId"],
              nosInUnit: binditm[i]["nosInUnit"],
              barcode: binditm[i]["barcode"],
              StockId: binditm[i]["stockId"],
              BatchNo: binditm[i]["batchNo"],
              ExpiryDate: binditm[i]["expiryDate"],
              Notes:binditm[i]["Notes"],
              hsncode:binditm[i]["hsncode"],
              adlDiscAmount:binditm[i]["adlDiscAmount"],
              adlDiscPercent:binditm[i]["adlDiscPercent"]
          );
          // print("fff"+slse.rate.toString());
          // print(slse);
          var parampars = json.encode(slse);
          salesedt.add(slse);
        });
        // print("gggggg"+ binditm[i]["rate"].toString());
        setState(() {
          // print("gggggg"+json.encode(slse));
          customerItemAdd.add(customer);
          //  grandTotal= grandTotal+ binditm[i]["rate"];
        });
      }

    }catch(e){ print("databinding1 error $e");}
  }




  //for binde data from Soh -------------------------sohdata--------------------------------------------


//---data binding old for salesorder-----

  databindingSoh(id) async{
    print("databinding : $id");
    double amount =0.0;
    var igst=0.00;
    var aftertax;
    try {
      final bindata =
      await http.get("${Env.baseUrl}Soheader/$id/3", headers: {
        "Authorization": user.user["token"],
      });
      print("databinding  "+bindata.body);
      print(bindata.statusCode);
      var tagsJson = json.decode(bindata.body);


      print("databinding decoded  "+tagsJson["data"]["voucherDate"]);

      generalRemarksController.text=tagsJson["data"]["narration"];

      var prsDt= DateTime.tryParse(tagsJson["data"]["voucherDate"]);
      var bindDt= DateFormat("d-MM-yyyy").format(prsDt);
      salesdeliveryController.text=bindDt;
      deliveryDate=bindDt;
      List <dynamic> binditm =tagsJson["data"]["sodetailed"]as List;
      for(int i=0;i<binditm.length;i++)
      {
        print("Soh detail data");
        print(binditm[i]["itemName"]);
        print(binditm.length);
        print(binditm[i]["rate"]);
        /// tax calc...........
        var rate=(binditm[i]["rate"]);
        amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
        //  double cgst=double.parse(((rate/100)*(binditm[i]["txCgstPercentage"])).toStringAsFixed(2));
        //  double sgst=double.parse(((rate/100)*(binditm[i]["txSgstPercentage"])).toStringAsFixed(2));
        dynamic Igst=double.parse(((rate/100)*(binditm[i]["txIgstpercentage"])).toStringAsFixed(2));
        //  amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
        //  print("amount  $amount");
        //
        //  var totligst=igst*(binditm[i]["qty"]);
        //  var totlcgst=cgst*(binditm[i]["qty"]);
        //  var totlsgst=sgst*(binditm[i]["qty"]);
        //  var taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
        //  var  ToatalTax=taxOneItm*(binditm[i]["qty"]);
        //  print("grandTotal before $grandTotal");
        //  grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
        // var aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
        //  print("grandTotal after $grandTotal");

        var taxOneItm =((rate/100)*(itmtxper));
        var taxAmtOfCgst;
        var taxAmtOfSgst;
        var  ToatalTax;
        dynamic  befortax=0;

        if(binditm[i]["itmTaxInclusive"]==true){

          var WithOutTaxamt=(((binditm[i]["txPercentage"])+100)/100);
          print("WithOutTaxamt in inclusive of edit bind");
          print(WithOutTaxamt.toString());
          taxOneItm=rate/WithOutTaxamt;
          taxAmtOfCgst=(WithOutTaxamt/2);
          taxAmtOfSgst=(WithOutTaxamt/2);
          // ToatalTax =taxOneItm*double.parse(quantityController.text);
          grandTotal = grandTotal + amount;
          aftertax= amount;
          befortax=taxOneItm*(binditm[i]["qty"]);
        }
        else {

          taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
          taxAmtOfCgst=(taxOneItm/2);
          taxAmtOfSgst=(taxOneItm/2);
          ToatalTax =taxOneItm*(binditm[i]["qty"]);
          grandTotal = grandTotal + ToatalTax + amount;
          aftertax=ToatalTax + amount;
          befortax=amount;

        }


        if(GSTtyp==true){
          igst= Igst*double.parse(quantityController.text);
          taxAmtOfCgst=0;
          taxAmtOfSgst=0;
        }


        if(TaxTypeGst==false){

          igst=0.0;
          taxAmtOfCgst=0.0;
          taxAmtOfSgst=0.0;

        }

        /// tax calc...........



        customer = CustomerAdd(
            id: binditm[i]["itemId"],
            slNo: customerItemAdd.length + 1,
            item: binditm[i]["itemName"],
            quantity:binditm[i]["qty"],
            rate: binditm[i]["rate"],
            txper: binditm[i]["txPercentage"],
            // cess:cessper,
            amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
            StkId:binditm[i]["stockId"],
            NetAmt: aftertax,
            txAmt: aftertax-befortax,
            Disc_Amt: binditm[i]["discountAmount"],
        );

        setState(() {
          ++slnum;
          // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);
          // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);

          sale = Saless(
            ItemSlNo :slnum,
            shid:widget.passvalue,
            itmName: binditm[i]["itemName"],
            itemId: binditm[i]["itemId"],
            qty: binditm[i]["qty"],
            rate:binditm[i]["rate"],
            disPercentage: 0,
            cgstPercentage: (binditm[i]["txCgstPercentage"]),
            sgstPercentage: (binditm[i]["txSgstPercentage"]),
            cessPercentage: 0,
            discountAmount:  0,
            cgstAmount:  taxAmtOfCgst,
            sgstAmount: taxAmtOfSgst,
            cessAmount: 0,
            igstPercentage:(binditm[i]["txIgstpercentage"]),
            igstAmount:  igst,
            taxPercentage:binditm[i]["taxPercentage"],
            // taxPercentage:itmtxper == null?0:itmtxper,
            taxAmount: ((binditm[i]["rate"]/100)*(binditm[i]["txPercentage"]))*(binditm[i]["qty"]),
            taxInclusive :false,
            amountBeforeTax:befortax, //( binditm[i]["rate"])* (binditm[i]["qty"]),
            amountIncludingTax:aftertax,//( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]),
            netTotal:aftertax,
            gdnId:binditm[i]["gdnId"],//1
            taxId:binditm[i]["itmTaxId"],
            rackId: null,
            addTaxId: binditm[i]["itmTaxId"],
            unitId: binditm[i]["unitId"],
            nosInUnit: 6,
            barcode:  null,
            StockId: binditm[i]["stockId"],
            BatchNo:null,// binditm[i]["batchNo"],
            ExpiryDate:null,// binditm[i]["expiryDate"],
            Notes:null,
            hsncode:null,
            DiscountAmount:binditm[i]["DiscountAmount"],
            // adlDiscAmount:0,
            // adlDiscPercent:0
          );


          print("1111111");
          // print("Sohdata"+sale.rate.toString());
          print(sale);
          var parampars = json.encode(sale);
          print("databindingSoh sales parampars : $parampars");
          sales.add(sale);
        });
        print("Soh dara rate"+ binditm[i]["rate"].toString());
        setState(() {
          customerItemAdd.add(customer);
//
//        // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);
          // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);


        });
      }
    }catch(e){ print("databinding1 Soh1 error $e");}
  }



//----------------------------------------------------------
//--------------------Print part-------------------------------------------

  GetdataPrint(id) async {
    print("sales for print : $id");
    double amount = 0.0;
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      dataForTicket = await jsonDecode(tagsJson.body);
      // print("sales for print");
      print(dataForTicket);

      Timer(Duration(milliseconds: 1), () async{
        // await wifiprinting();
        blutoothprinting();
        // _ticket(PaperSize.mm58);
      });

    } catch (e) {
      print('error on databinding $e');
    }
  }



  footerdata() async {
    try {
      print("footer data decoded  ");
      final tagsJson =
      await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
        "Authorization": user.user["token"],
      });

      setState(() {
        footerCaptions = jsonDecode(tagsJson.body);
        print( "on footerCaptions :" +footerCaptions.toString());
        // wifiprinting();
      });

    } catch (e) {
      print(e);
    }
  }

  GetCompantPro(id)async{
    print("GetCompantPro");
    print(id.toString());
    try {
      final tagsJson =
      await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
        //Soheader //SalesHeaders
        "Authorization": user.user["token"],
      });
      if(tagsJson.statusCode==200) {
        Companydata = jsonDecode(tagsJson.body);
      }
      // print( "on GetCompantPro :" +Companydata.toString());
    }
    catch(e){
      print("error on GetCompantPro : $e");
    }
  }
//----------printing ticket generate--------------------------

  Future<Ticket> _ticket(PaperSize paper) async {
    // final ticket = Ticket(paper);
    print('in');
    final ticket = Ticket(paper);

    List<dynamic> slsDet = dataForTicket["salesDetails"] as List;
    dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
        ? "00"
        : (dataForTicket["salesHeader"][0]["voucherNo"]).toString();
// dynamic date=(dataForTicket["salesHeader"][0]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["salesHeader"][0]["voucherDate"]));
    dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
    dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
        (dataForTicket["salesHeader"][0]["partyName"])== ""
        ? ""
        : (dataForTicket["salesHeader"][0]["partyName"]).toString();



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:branchName.toString(),
          width: 10,
          styles: PosStyles(bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileAddress1"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,)),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text: (Companydata["companyProfileAddress2"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);

    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileAddress3"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);



    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:(Companydata["companyProfileMobile"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);




    ticket.row([
      PosColumn(text: ' ', width: 1),
      PosColumn(
          text:  (Companydata["companyProfileEmail"]).toString(),
          width: 10,
          styles:PosStyles(bold: false,underline: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(text: ' ', width: 1)
    ]);





    ticket.text('GSTIN: ' +
        ( Companydata["companyProfileGstNo"]).toString()+' ',
        styles: PosStyles(bold: false,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));


    ticket.text('Inv.NO : ' + VchNo.toString(),
        styles: PosStyles(bold: true, width: PosTextSize.size1));
    //ticket.emptyLines(1);
    ticket.text('Date : $date');

    //---------------------------------------------------------
    if(partyName !="")
    {
      //ticket.emptyLines(1);
      ticket.text('Name : $partyName');
    }
    if((dataForTicket["salesHeader"][0]["gstNo"]) !=null)
    {
      // ticket.emptyLines(1);
      ticket.text('GST No :' +((dataForTicket["salesHeader"][0]["gstNo"])));
    }
    //---------------------------------------------------------

    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text:'No',
        styles: PosStyles(align: PosAlign.left),
        width:1,
      ),
      PosColumn(
        text:'Item',
        styles: PosStyles(bold: true,align: PosAlign.center),
        width: 2,
      ),
      PosColumn(text: 'Qt', width: 1,styles: PosStyles(align: PosAlign.right ),),
      PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
      PosColumn(text: ' Amonunt', width: 3,styles: PosStyles(align: PosAlign.center ),),
    ]);
    ticket
        .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
    var snlnum=0;
    dynamic total = 0.000;
    for (var i = 0; i < slsDet.length; i++) {
      total = slsDet[i]["amountIncludingTax"] + total;
      // ticket.emptyLines(1);
      snlnum=snlnum+1;
      ticket.row([
        PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
            align: PosAlign.left
        )),

        PosColumn(text: (slsDet[i]["itmName"]),
            width: 11,styles:
            PosStyles(align: PosAlign.left )),] );

      // for space
      ticket.row([
        PosColumn(
          text: (''),
          width: 1,
        ),
        PosColumn(
            text: (' '+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
            width: 3,
            styles: PosStyles(
                align: PosAlign.right
            )),

        PosColumn(
            text: (' ' + ((slsDet[i]["taxPercentage"])).toStringAsFixed(2))
                .toString(),styles:PosStyles(align: PosAlign.right ),
            width: 2),
        PosColumn(
            text: ((slsDet[i] ["amountIncludingTax"])).toStringAsFixed(2)
            ,styles:PosStyles(align:PosAlign.right ),
            width:4),
      ]);
    }


    ticket.hr(ch:"=",len: 32);
    ticket.row([
      PosColumn(
          text: 'Total',
          width: 4,
          styles: PosStyles(
            bold: true,align:PosAlign.left,
          )),
      PosColumn(
          text:'Rs '+(total.toStringAsFixed(2)).toString(),
          width: 8,
          styles: PosStyles(bold: true,align: PosAlign.right,)),
    ]);
    ticket.hr(
        ch: '_',len: 32 );

    // ticket.row([
    //   PosColumn(text: ' ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerCaption'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: ' ', width: 1)
    // ]);
    //
    // ticket.row([
    //   PosColumn(text: '  ', width: 1),
    //   PosColumn(
    //       text: footerCaptions[0]['footerText'],
    //       width: 10,
    //       styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: '  ', width: 1)
    // ]);

    ticket.feed(1);
    ticket.text('Thank You...Visit again !!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.cut();
    return ticket;
  }
// //..................................................
//
//   wifiprinting() async {
//     try {
//       print(" print in");
//      _printerManager.selectPrinter('192.168.0.100');
//      //_printerManager.selectPrinter(null);
//       final res =
//       await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//       print(" print in");
//     } catch (e) {
//       print("error on print $e");
//     }
//   }



  Priter_Initial_Part(){
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          searchPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
          blutoothEnable();
        }
      });
    } else {
      searchPrinter();
    }


  }

  void searchPrinter() {
    try {
      _printerManager.startScan(Duration(seconds: 2));
      _printerManager.scanResults.listen((val) {
        if (!mounted) return;
        setState(() =>_devices = val);
        if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
      });
    }
    catch(e){print("result for scan print $e");}
  }

  blutoothprinting(){
    print(" on blutoothprinting");
    for(int i=0;i<_devices.length;i++){
      if(_devices[i].address=="00:11:22:33:44:55"){
        print("find _devices");
        print(_devices.length.toString());
        print(_devices[i].address);
        print(_devices[i].name);
        print(i.toString());
        _startPrint(_devices[i]);
        // dispose();
        break;
      }
    }

    print("not find _devices");

  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }


/*Show dialog if blutooth not enabled and open settings blutooth*/
  Future blutoothEnable() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Blutooth is Off ?",
                style: TextStyle(color: Colors.red),
              ),
              content:
              const Text('Please make sure you enabled Blutooth for Printing'),
              actions: <Widget>[

                SizedBox(width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      FlatButton(
                          child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      FlatButton(
                          child: Text('Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          onPressed: () {
                            final AndroidIntent intent = AndroidIntent(
                                action:
                                'android.settings.BLUETOOTH_SETTINGS');
                            intent.launch();
                            Navigator.of(context, rootNavigator: true).pop();
                            // _gpsService();
                          }),
                    ],
                  ),
                )
              ],
            );
          });
    }
  }

  ///-----------------URL Print--------------------------------------
  UrlLaunch(url)async{
    //  var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=1&uBr=$branchId&uNm=$userName&uP=$password';
    print("yuyuiyi");
    print(url);
    if (!await launch(url)) throw 'Could not launch $url';
  }




  ///---------------------------PDF Print--------------------------------------



  //Vat Tax Invoice
  // Vat Simplified
  // Vat A4
  // Vat 3 Inch
  // Vat 2 Inch


  //var s="Vat Tax Invoice";



  PdfPrint(id,isGst,data){

if(isGst==false) {
print("the default print typ is " + DefultPrint_typ.toString() + id.toString());

  if (DefultPrint_typ.toString().contains("Tax Invoice") ||
      DefultPrint_typ.toString().contains("Simplified")) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                New_Model_PdfPrint(Parm_Id: id,
                  Page_Type: DefultPrint_typ.contains("Tax Invoice") == true
                      ? true
                      : false,)));

  }
  else {
    print("the default print else is " + DefultPrint_typ.toString() + id.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Pdf_Print(Parm_Id: id,
                  Page_Type: DefultPrint_typ.contains("4") == true
                      ? "A4"
                      : "3 Inch",)));
  }
}
else{
  print("the default try else is " + id.toString()+ "the id is " +data.toString() );
//in gst typ  indian typ
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GST_Print_Format(Parm_Id: id,
                title:"title",
                Details_Data:data,
               )));


}
  }

//----------------------Print part End-----------------------------------------






}




class Saless {
  String itmName;
  int ItemSlNo;
  int shid;
  int itemId;
  double qty;
  double rate;
  double disPercentage;
  double cgstPercentage;
  double sgstPercentage;
  double cessPercentage;
  double discountAmount;
  double cgstAmount;
  double sgstAmount;
  double cessAmount;
  double igstPercentage;
  double igstAmount;
  double taxPercentage;
  double taxAmount;
  bool taxInclusive;
  double amountBeforeTax;
  double amountIncludingTax;
  double netTotal;
  // dynamic hsncode;
  int gdnId;
  int taxId;
  int rackId;
  int addTaxId;
  int unitId;
  dynamic nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic hsncode;
  dynamic DiscountAmount;

  Saless({
    this.itmName,
    this.ItemSlNo,
    this.shid,
    this.itemId,
    this.qty,
    this.rate,
    this.disPercentage,
    this.cgstPercentage,
    this.sgstPercentage,
    this.cessPercentage,
    this.discountAmount,
    this.cgstAmount,
    this.sgstAmount,
    this.cessAmount,
    this.igstPercentage,
    this.igstAmount,
    this.taxPercentage,
    this.taxAmount,
    this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    this.hsncode,
    this.gdnId,
    this.taxId,
    this.rackId,
    this.addTaxId,
    this.unitId,
    this.nosInUnit,
    this.barcode,
    this.StockId,
    this.BatchNo,
    this.ExpiryDate,
    this.Notes,
    this.DiscountAmount,

  });



  Saless.fromJson(Map<String, dynamic> json) {
    itmName = json['itmName'];
    ItemSlNo = json['ItemSlNo'];
    //  shid = json['shid'];
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    disPercentage = json['disPercentage'];
    cgstPercentage = json['cgstPercentage'];
    sgstPercentage = json['sgstPercentage'];
    cessPercentage = json['cessPercentage'];
    discountAmount = json['discountAmount'];
    cgstAmount = json['cgstAmount'];
    sgstAmount = json['sgstAmount'];
    cessAmount = json['cessAmount'];
    igstPercentage = json['igstPercentage'];
    igstAmount = json['igstAmount'];
    taxPercentage = json['taxPercentage'];
    taxAmount = json['taxAmount'];
    taxInclusive = json['taxInclusive'];
    amountBeforeTax = json['amountBeforeTax'];
    amountIncludingTax = json['amountIncludingTax'];
    netTotal = json['netTotal'];
    hsncode = json['hsncode'];
    gdnId = json['gdnId'];
    taxId = json['taxId'];
    rackId = json['rackId'];
    addTaxId = json['addTaxId'];
    unitId = json['unitId'];
    nosInUnit = json['nosInUnit'];
    barcode = json['barcode'];
    StockId = json['StockId'];
    BatchNo = json['BatchNo'];
    ExpiryDate = json['ExpiryDate'];
    Notes = json['Notes'];
    DiscountAmount = json['DiscountAmount'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itmName'] = this.itmName;
    data['ItemSlNo'] = this.ItemSlNo;
    // data['shid'] = this.shid;
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['disPercentage'] = this.disPercentage;
    data['cgstPercentage'] = this.cgstPercentage;
    data['sgstPercentage'] = this.sgstPercentage;
    data['cessPercentage'] = this.cessPercentage;
    data['discountAmount'] = this.discountAmount;
    data['cgstAmount'] = this.cgstAmount;
    data['sgstAmount'] = this.sgstAmount;
    data['cessAmount'] = this.cessAmount;
    data['igstPercentage'] = this.igstPercentage;
    data['igstAmount'] = this.igstAmount;
    data['taxPercentage'] = this.taxPercentage;
    data['taxAmount'] = this.taxAmount;
    data['taxInclusive'] = this.taxInclusive;
    data['amountBeforeTax'] = this.amountBeforeTax;
    data['amountIncludingTax'] = this.amountIncludingTax;
    data['netTotal'] = this.netTotal;
    data['hsncode'] = this.hsncode;
    data['gdnId'] = this.gdnId;
    data['taxId'] = this.taxId;
    data['rackId'] = this.rackId;
    data['addTaxId'] = this.addTaxId;
    data['unitId'] = this.unitId;
    data['nosInUnit'] = this.nosInUnit;
    data['barcode'] = this.barcode;
    data['StockId'] = this.StockId;
    data['BatchNo'] = this.BatchNo;
    data['ExpiryDate'] = this.ExpiryDate;
    data['Notes'] = this.Notes;
    data['DiscountAmount'] = this.DiscountAmount;

    return data;
  }
}


class  UnitTypes {
  UnitTypes({
    this.id,
    this.unitId,
    this.itemid,
    this.mrp,
    this.srate,
    this.prate,
  });

  int id;
  int unitId;
  int itemid;
  double mrp;
  double srate;
  double prate;


  UnitTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitId = json['unitId'];
    itemid = json['itemid'];
    mrp = json['mrp'];
    srate = json['srate'];
    prate = json['prate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unitId'] = this.unitId;
    data['itemid'] = this.itemid;
    data['mrp'] = this.mrp;
    data['srate'] = this.srate;
    data['prate'] = this.prate;

    return data;
  }

}

class  UnitType {
  // "id": 2,
  // "description": "Box 10s",
  // "nos": 10.0,
  // "formalName": "Box 10",
  // "unitUnder": 1,
  // "isSimple": true,
  // "groupUnder": "Number"

  int id;
  dynamic description;
  double nos;
  dynamic formalName;
  int unitUnder;
  bool isSimple;
  dynamic groupUnder;



  UnitType(
      {
        this.id,
        this.description,
        this.nos,
        this.formalName,
        this.unitUnder,
        this.isSimple,
        this.groupUnder,
      });

  UnitType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    nos = json['nos'];
    formalName = json['formalName'];
    unitUnder = json['unitUnder'];
    isSimple = json['isSimple'];
    groupUnder = json['groupUnder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['nos'] = this.nos;
    data['formalName'] = this.formalName;
    data['unitUnder'] = this.unitUnder;
    data['isSimple'] = this.isSimple;
    data['groupUnder'] = this.groupUnder;

    return data;
  }
// Map<String, dynamic> toMap() {
//   return {
//     'id' : id,
//     'description' : description,
//     'nos' : nos,
//     // 'formalName' : formalName,
//     // 'unitUnder' : unitUnder,
//     // 'isSimple' : isSimple,
//     // 'groupUnder' : groupUnder,
//   };
// }
}








//-------------for sale edit-----------------------

class Salesedit {
  int ItemSlNo;
  int shid;
  int itemId;
  double qty;
  double rate;
  double disPercentage;
  double cgstPercentage;
  double sgstPercentage;
  double cessPercentage;
  double discountAmount;
  double cgstAmount;
  double sgstAmount;
  double cessAmount;
  double igstPercentage;
  double igstAmount;
  double taxPercentage;
  double taxAmount;
  bool taxInclusive;
  double amountBeforeTax;
  double amountIncludingTax;
  double netTotal;
  dynamic hsncode;
  int gdnId;
  int taxId;
  int rackId;
  int addTaxId;
  int unitId;
  dynamic nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic adlDiscAmount;
  dynamic adlDiscPercent;

  Salesedit({
    this.ItemSlNo,
    this.shid,
    this.itemId,
    this.qty,
    this.rate,
    this.disPercentage,
    this.cgstPercentage,
    this.sgstPercentage,
    this.cessPercentage,
    this.discountAmount,
    this.cgstAmount,
    this.sgstAmount,
    this.cessAmount,
    this.igstPercentage,
    this.igstAmount,
    this.taxPercentage,
    this.taxAmount,
    this.taxInclusive,
    this.amountBeforeTax,
    this.amountIncludingTax,
    this.netTotal,
    this.hsncode,
    this.gdnId,
    this.taxId,
    this.rackId,
    this.addTaxId,
    this.unitId,
    this.nosInUnit,
    this.barcode,
    this.StockId,
    this.BatchNo,
    this.ExpiryDate,
    this.Notes,
    this.adlDiscAmount,
    this.adlDiscPercent,
  });



  Salesedit.fromJson(Map<String, dynamic> json) {
    ItemSlNo = json['ItemSlNo'];
    shid = json['shid'];
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    disPercentage = json['disPercentage'];
    cgstPercentage = json['cgstPercentage'];
    sgstPercentage = json['sgstPercentage'];
    cessPercentage = json['cessPercentage'];
    discountAmount = json['discountAmount'];
    cgstAmount = json['cgstAmount'];
    sgstAmount = json['sgstAmount'];
    cessAmount = json['cessAmount'];
    igstPercentage = json['igstPercentage'];
    igstAmount = json['igstAmount'];
    taxPercentage = json['taxPercentage'];
    taxAmount = json['taxAmount'];
    taxInclusive = json['taxInclusive'];
    amountBeforeTax = json['amountBeforeTax'];
    amountIncludingTax = json['amountIncludingTax'];
    netTotal = json['netTotal'];
    hsncode = json['hsncode'];
    gdnId = json['gdnId'];
    taxId = json['taxId'];
    rackId = json['rackId'];
    addTaxId = json['addTaxId'];
    unitId = json['unitId'];
    nosInUnit = json['nosInUnit'];
    barcode = json['barcode'];
    StockId = json['StockId'];
    BatchNo = json['BatchNo'];
    ExpiryDate = json['ExpiryDate'];
    Notes = json['Notes'];
    adlDiscAmount = json['adlDiscAmount'];
    adlDiscPercent = json['adlDiscPercent'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ItemSlNo'] = this.ItemSlNo;
    data['shid'] = this.shid;
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['disPercentage'] = this.disPercentage;
    data['cgstPercentage'] = this.cgstPercentage;
    data['sgstPercentage'] = this.sgstPercentage;
    data['cessPercentage'] = this.cessPercentage;
    data['discountAmount'] = this.discountAmount;
    data['cgstAmount'] = this.cgstAmount;
    data['sgstAmount'] = this.sgstAmount;
    data['cessAmount'] = this.cessAmount;
    data['igstPercentage'] = this.igstPercentage;
    data['igstAmount'] = this.igstAmount;
    data['taxPercentage'] = this.taxPercentage;
    data['taxAmount'] = this.taxAmount;
    data['taxInclusive'] = this.taxInclusive;
    data['amountBeforeTax'] = this.amountBeforeTax;
    data['amountIncludingTax'] = this.amountIncludingTax;
    data['netTotal'] = this.netTotal;
    data['hsncode'] = this.hsncode;
    data['gdnId'] = this.gdnId;
    data['taxId'] = this.taxId;
    data['rackId'] = this.rackId;
    data['addTaxId'] = this.addTaxId;
    data['unitId'] = this.unitId;
    data['nosInUnit'] = this.nosInUnit;
    data['barcode'] = this.barcode;
    data['StockId'] = this.StockId;
    data['BatchNo'] = this.BatchNo;
    data['ExpiryDate'] = this.ExpiryDate;
    data['Notes'] = this.Notes;
    data['adlDiscAmount'] = this.adlDiscAmount;
    data['adlDiscPercent'] = this.adlDiscPercent;
    return data;
  }
}


//-------------for Gown----------------------
class  Godown{

  int gdnId;
  dynamic gdnDescription;



  Godown(
      {
        this.gdnId,
        this.gdnDescription,
      });

  Godown.fromJson(Map<String, dynamic> json) {
    gdnId = json['gdnId'];
    gdnDescription = json['gdnDescription'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gdnId'] = this.gdnId;
    data['gdnDescription'] = this.gdnDescription;
    return data;
  }
}


//
// import 'dart:async';
// import 'dart:developer';
// import 'dart:ffi';
//
// import 'package:android_intent/android_intent.dart';
// import 'package:barcode_scan/platform_wrapper.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_app/GT_Masters/AppTheam.dart';
// import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';
// import 'package:flutter_app/GT_Masters/Printing/New_Model_PdfPrint.dart';
// import 'package:flutter_app/GT_Masters/Printing/PDF_Printer.dart';
// import 'package:flutter_app/Local_Db/Local_db.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Company.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Godown.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_ItemMaster.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/LD_Model_Sales.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/LD_model_UnitTyp.dart';
// import 'package:flutter_app/Local_Db/Local_db_Model/Ld_Model_LedgerHeades.dart';
// import 'package:flutter_app/Local_Db/Offline_Print.dart';
// import 'package:flutter_app/Purchase.dart';
// import 'package:flutter_app/Purchase_Index.dart';
// import 'package:flutter_app/appbarWidget.dart';
// import 'package:flutter_app/models/customeradditem.dart';
// import 'package:flutter_app/models/customersearch.dart';
// import 'package:flutter_app/models/finishedgoods.dart';
// import 'package:flutter_app/models/paymentcondition.dart';
// import 'package:flutter_app/models/userdata.dart';
// import 'package:flutter_app/models/usersession.dart';
// import 'package:flutter_app/newtestpage.dart';
// import 'package:flutter_app/salesindex.dart';
// import 'package:flutter_app/salesmanhome.dart';
// import 'package:flutter_app/shopvisited.dart';
// import 'package:flutter_app/urlEnvironment/urlEnvironment.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'dart:io';
//
// import 'GT_Masters/Printing/Gst_Print_Foramt.dart';
//
//
//
// class Newsalespage extends StatefulWidget {
//
//   dynamic itemrowdata=[];
//   int passvalue;
//   dynamic passname;
//   Newsalespage({this.passvalue,this.passname,this.itemrowdata});
//
//
//
//
//   @override
//   _NewsalespageState createState() => _NewsalespageState();
//
// }
//
// class _NewsalespageState extends State<Newsalespage> {
//
//   static List<LD_Model_UnitTyp> offline_unit = <LD_Model_UnitTyp>[];
//   static List<LD_Model_Godown> offline_godown = <LD_Model_Godown>[];
//   static List<LD_Model_ItemMaster> offline_itemMaster = <LD_Model_ItemMaster>[];
//   static List<LD_Model_LedgerHeads> offline_LdgrMaster = <LD_Model_LedgerHeads>[];
//   //static List<LD_Model_Company> offline_CompanyMaster = <LD_Model_Company>[];
//   var  offline_CompanyMaster = [];
//
//   ///--------------------------
//   double TextBoxHeight=40;
//   double TextBoxCurve=10;
//   bool ItemsAdd_Widget_Visible=false;
//   AutoCompleteTextField searchTextField;
//   UserData userData;
//   String branchName;
//   dynamic userName;
//   dynamic password;
//   String token;
//   dynamic openingAmountBalance = 0.0;
//   double grandTotal = 0;
//   dynamic delivery = "";
//   double itmtxper=0.0;
//   dynamic itmqty = "";
//   double cessper=0.0;
//   double CgstPer=0.0;
//   double SgstPer=0.0;
//   double Igstper=0.0;
//   int TaxId=null;
//   bool TaxInOrExc;
//   dynamic Hsncode="";
//   dynamic btnname="";
//   // var formatter = NumberFormat('#,##,000.00');
//   var formatter = NumberFormat('#,##,##,##,##0.00');
//   int branchId;
//   int userId;
//   dynamic userArray;
//   dynamic serverDate;
//   UserSession usr;
//   var DateOnlyFormat = new DateFormat('yyy/MM/dd');
//   String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
//   TextEditingController salesdeliveryController = new TextEditingController();
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final formKey = GlobalKey<FormState>();
//   bool autovalidate = false;
//   List<dynamic> batchdata = [];
//   List<dynamic> multibatchdata = [];
//   dynamic user;
//   bool boxvisible=true;
//   AppTheam theam =AppTheam();
//
//   static List<FinishedGoods> goods = new List<FinishedGoods>();
//   static List<PaymentCondition> payment = new List<PaymentCondition>();
//   static List<UnitType> unit = new List<UnitType>();
//   static List<Godown> Gdwn = new List<Godown>();
//   dynamic SalesEditDatas;
//   dynamic Vouchnum;
//   int itemGdwnId=null;
//   double Srate;
//   dynamic Edate;
//   dynamic batchnum;
//   dynamic nosunt;
//   dynamic Brcode;
//   dynamic StkId;
//   BluetoothManager bluetoothManager = BluetoothManager.instance;
//   PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   var  _devicesMsg="";
//   int customerSelectedId;
//   String customerSelectedEmail;
//   String customerSelectedName;
//
//   TextEditingController controller = new TextEditingController();
//   FocusNode field1FocusNode = FocusNode(); //Create first FocusNode
//
//   String selectedLetter;
//   TextEditingController customerController = new TextEditingController();
//   TextEditingController godownController = new TextEditingController();
//   TextEditingController goodsController = new TextEditingController();
//   TextEditingController quantityController = new TextEditingController();
//   TextEditingController rateController = new TextEditingController();
//   TextEditingController generalRemarksController = new TextEditingController();
//   TextEditingController paymentController = new TextEditingController();
//   TextEditingController UnitController = new TextEditingController();
//   TextEditingController paymentTypeController = new TextEditingController();
//   TextEditingController InvNoController = new TextEditingController();
//   TextEditingController DiscountController = new TextEditingController();
//   TextEditingController Itemwise_DiscountController = new TextEditingController();
//
//
//
//   GlobalKey<AutoCompleteTextFieldState<Customer>> key =
//   new GlobalKey(); //only one autocomplte
//   String selectedPerson = "";
//   CustomerAdd customer;
//   Saless sale;
//   Salesedit slse;
//   int salesItemId = null;
//   int salesLedgerId = null;
//   int salesPaymentId = null;
//   int paymentType_Id = null;
//   var Tax_IdNull=null;
//   int unitId=null;
//   dynamic deliveryDate;
//   bool GSTtyp=false;// for check the GST type is IGST or SGST
// //   validation variables
//   bool customerSelect = false;
//   bool GodownSelect = false;
//   bool itemSelect = false;
//   bool paymentSelect = false;
//   bool unitSelect = false;
//   bool deliveryDateSelect = false;
//   bool rateSelect = false;
//   bool quantitySelect = false;
//   bool paymentTypeSelect = false;
//   int slnum=0;
//   CUWidgets cw=CUWidgets();
//   static List<Salesedit> salesedt = new List<Salesedit>();
//   static List<Saless> sales = new List<Saless>();
//   static List<CustomerAdd> customerItemAdd = new List<CustomerAdd>();
//   static List<Customer> users = new List<Customer>();
//   bool loading = true;
//   final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
//   bool negativeSalesAllow;
//   var dataForTicket;
//   var footerCaptions;
//   bool checkboxval = false;
//   // PrinterNetworkManager _printerManager = PrinterNetworkManager();
//   var Companydata;
//   var retunid;
//   bool TaxTypeGst;
//   var  paymentType=[{"id":0,"type":"Cash"},{"id":1,"type":"Credit"}];
//   bool Save_Pending=false;
//   double DiscountAmount=0.0;
//   double ItemWiseDiscountAmount=0.0;
//
//   FocusNode rateFocus = FocusNode();
//   FocusNode qtyFocus = FocusNode();
//   FocusNode generalFocus = FocusNode();
//
//   var DefultPrint_typ=null;
//   SharedPreferences pref;
//
//   dynamic slsname;
// //  get Token
//   read() async {
//     var v = pref.getString("userData");
//     print("USER DATA: $v");
//     var c = json.decode(v);
//
//     user = UserData.fromJson(c); // token gets this code user.user["token"]
//
//     setState(() {
//       branchId =int.parse(c["BranchId"]) ;
//       print("user data......${branchId.toString()}..........");
//       print(user.user["token"]);
//       token = user.user["token"]; //  passes this user.user["token"]
//       pref.setString("customerToken", user.user["token"]);
//       branchName = user.branchName;
//       password = user.password;
//       userName = user.user["userName"];
//       print("123.....");
//       print(branchName);
//       print(userName);
//       userId=user.user["userId"];
//       GetCompantPro(branchId);
//     });
//   }
//
//   bool internet_Connection=true;
//
//
//   Initial_internet_check() async {
//
//     var result = await (Connectivity().checkConnectivity());
//     {
//       if (result == ConnectivityResult.mobile ||
//           result == ConnectivityResult.wifi) {
//         setState(() {
//           internet_Connection=true;
//         });
//         return true;
//       } else if (result == ConnectivityResult.none) {
//
//         print("No internet Connection");
//         setState(() {
//           internet_Connection=false;
//         });
//       }
//     }
//   }
//
//
//   internet_check()async{
//
//     Connectivity().onConnectivityChanged.listen((event) {
//       print(event);
//       if(event==ConnectivityResult.none) {
//         print("Noi nernet");
//         setState(() {
//           internet_Connection=false;
//           GetOffline_data();
//         });
//         return event;
//       }
//       else{
//         internet_Connection=true;
//         print("Have inernet");
//
//       }
//     });
//
//
//   }
//
//
//   GetOffline_data()async{
//
//     var _unit=  await  Local_Db().GetUnitData();
//     var _godown=  await  Local_Db().GetGodownData();
//     var _itemMstr=  await  Local_Db().GetItemMasterData();
//     var _Ldgrmstr=  await  Local_Db().GetLedgerMasterData();
//     // var _Ldcmpny=  await  Local_Db().GetCompanyMasterData();
//
//     setState(() {
//       offline_unit=_unit;
//       offline_godown=_godown;
//       offline_itemMaster=_itemMstr;
//       offline_LdgrMaster=_Ldgrmstr;
//       //  offline_CompanyMaster=_Ldcmpny;
//     });
//
//     print("------GetOffline data----1-------");
//   }
//
//   Save_toLocalDb()async{
//
//     var req = [{
//       "voucherDate": DateOnlyFormat.format(DateTime.now()),
//       //serverDate.toString(),
//       "orderHeadId": null,
//       "orderDate": null,
//       "expDate": null,
//       "ledgerId": salesLedgerId,
//       "partyName": slsname,
//       "address1": null,
//       "address2": null,
//       "gstNo": null,
//       "phone": null,
//       "shipToName": null,
//       "shipToAddress1": null,
//       "shipToAddress2": null,
//       "shipToPhone": null,
//       "narration": generalRemarksController.text.toString(),
//       "amount":Net_Amt_Befor_Tax,// (grandTotal-DiscountAmount),
//       "userId": userId,
//       "branchId": branchId,
//       "otherAmt": 0.00,
//       "discountAmt": 0.00,
//       "creditPeriod": null,
//       "paymentCondition": paymentType_Id.toString() == "0"
//           ? "Cash"
//           : "Credit",
//       "paymentType": paymentType_Id,
//       "invoiceType": "BtoB",
//       "invoicePrefix": null,
//       "invoiceSuffix": null,
//       "cancelFlg": null,
//       "entryDate": null,
//       "slesManId": null,
//       "branchUpdated": false,
//       "saleTypeInterState": false,
//       "salesDetails": sales,
//       "salesExpense": [
//         //   {
//         //   "expenseLedgerId":1,
//         //   "amount": null,
//         //   "taxHeadId": null,
//         //   "taxAmt": null,
//         //   "cgstAmt": null,
//         //   "sgstAmt": null,
//         //   "igstAmt": null
//         // }
//       ]
//     }];
//     //  print("req $req");
//     var parm=json.encode(req);
//     var dd=json.decode(parm);
//     print(parm.runtimeType);
//     print(dd.runtimeType);
//
//     List <dynamic> tagsJson =dd;
//     List<LD_Model_Sales> ut = tagsJson.map((tagsJson) =>
//         LD_Model_Sales.fromJson(tagsJson)).toList();
//
//     //log("parm $parm");
//
//     var res_id=await Local_Db().PostToSales(ut);
//
//     print(res_id);
//     print("res_id");
//     Resetfunction();
//     showDialog(
//         context: context,
//         builder: (context) =>
//             AlertDialog(
//               title: Center(child: Text("Sales Save")),
//             ));
//     return;
//
//     // var res=await Local_Db().Get_Data_ForPrint(res_id);
//     //
//     // Offline_Print().Printerticket(:offline_CompanyMaster[0] ,dataForTicket:res[0] );
//
//
//
//
//
//   }
//
//
//   //--------------Get Tx Type-----------------------
//   GetTax() async {
//     var jsonres = await cw.CUget_With_Parm(
//         api: "MTaxes", Token: token);
//
//     if (jsonres != false) {
//       var res = jsonDecode(jsonres);
//       //   print(" Taxes= $res");
//
//       List<dynamic> data = res["taxList"];
//       print(" Taxas are");
//       print(data[0]["txId"]);
//       Tax_IdNull=data[0]["txId"];
//     }
//   }
//   // get customer selectapi
//   getCustomer() async {
//     try {
//       final response =
//       await http.get("${Env.baseUrl}${Env.CustomerURL}", headers: {
//         "Authorization": user.user["token"],
//       });
//       print(response.statusCode);
//
//       if (response.statusCode == 200) {
//         print('...................');
//         Map<String, dynamic> data = json.decode(response.body);
//         print("array is");
//         print(data["lst"]); //used  this to autocomplete
//         print("........");
//         // print(response.statusCode);
//         // print(data["lst"]);
//         userArray = data["lst"];
//         users = (data["lst"] as List)
//             .map<Customer>((customer) =>
//             Customer.fromJson(Map<String, dynamic>.from(customer)))
//             .toList();
// //        users=loadUsers(s.toString());
//         return users;
//       } else {
//         print("Error getting users");
//       }
//     } catch (e) {
//       print("Error getting users");
//     }
//   }
//
//   //get customer ledger balance
//   getCustomerLedgerBalance(int accountId) async {
//     try {
//       final response = await http.get("${Env.baseUrl}getsettings",
//           headers: {"accept": "application/json"});
//       print(response.statusCode);
//
//       if (response.statusCode == 200) {
//         print('...................');
//
//         // print(response.body);
//
//         List<dynamic> list = json.decode(response.body);
//         print(list[0]["workingDate"] +
//             "....................." +
//             list[0]["workingTime"]);
//         setState(() {
//           serverDate = list[0]["workingDate"];
//         });
//         var formatter =
//         new DateFormat('MM-dd-yyyy'); // this dd-MM-yyyy format i want
//
//         String formattedDate = formatter
//             .format(DateTime.parse(list[0]["workingDate"].substring(0, 10)));
//         print(formattedDate);
//
//         getLedger(accountId, formattedDate);
//       } else {
//         print("Error getting users");
//       }
//     } catch (e) {
//       print("Error getting users" +e.toString());
//     }
//     print("customer Id is");
//     print(accountId);
//   }
//
//   getLedger(dynamic acId, dynamic date) async {
//     print(acId);
//     print("the given date is");
//     print(date);
//     var url = "${Env.baseUrl}TaccLedgers/$acId/$date";
//     print("url:" + url);
//     try {
//       final response = await http.get(url, headers: {
//         "Authorization": user.user["token"],
//       });
// //      print(response.statusCode);
//       if (response.statusCode == 200) {
//         print(response.body);
//         var e = json.decode(response.body);
//         print(e["openingAmount"]);
//         setState(() {
//           if (e["openingAmount"] > 0.0) {
//             openingAmountBalance = e["openingAmount"];
//           } else {
//             print("opening amount is zero");
//           }
//         });
//       }
//     } catch (e) {
//       print("error" + e);
//     }
//   }
//
//
//
//   //--------------Get Inv no-----------------------
//   GetInvNo() async {
//     var jsonres = await cw.CUget_With_Parm(
//         api: "getsettings/1/gtsales", Token: token);
//
//     if (jsonres != false) {
//       var res = jsonDecode(jsonres);
//       print(res);
//       setState(() {
//         InvNoController.text=res[0]["vocherNo"].toString();
//       });
//
//     }
//   }
//
//
//
//
//   GeneralSettings()async{
//
//
//     final res =
//     await http.get("${Env.baseUrl}generalSettings", headers: {
//       "Authorization": user.user["token"],
//     });
//
//     if(res.statusCode<210) {
//       print(res);
//       var GenSettingsData = json.decode(res.body);
//       print(GenSettingsData[0]["applicationTaxTypeGst"]);
//       setState(() {
//         TaxTypeGst=GenSettingsData[0]["applicationTaxTypeGst"];
//
//         print("TaxType");
//         print(TaxTypeGst);
//         DefultPrint_typ=GenSettingsData[0]["salesPrinterType"];
//         negativeSalesAllow=GenSettingsData[0]["negativeSalesAllow"];
//       });
//     }
//   }
//
//
//
//   // get itemselectapi
//   getFinishedGoods() async {
//     String url = "${Env.baseUrl}GtItemMasters/1/1";
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//
//       print("goods Condition");
//       if(res.statusCode==200) {
//         //print(res.body);
//         print("json decoded");
//
//         var tagsJson = json.decode(res.body);
//         print(tagsJson);
//         List<dynamic> t = json.decode(res.body);
//         List<FinishedGoods> p = t
//             .map((t) => FinishedGoods.fromJson(t))
//             .toList();
//
//         //print(p);
//         goods = p;
//       }
//     } catch (e) {print("error on getFinishedGoods : $e");}
//   }
//
//
//
//   // get payment Condition
//   getPaymentCondition() async {
//     String url = "${Env.baseUrl}Mconditions";
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//
//       print("payment Condition");
//       if(res.statusCode==200) {
//         print(res.body);
//         print("json decoded");
//
//         var tagsJson = json.decode(res.body);
//         print(tagsJson);
//         List<dynamic> t = json.decode(res.body);
//         List<PaymentCondition> p =
//         t.map((t) => PaymentCondition.fromJson(t)).toList();
//
//         print("ppp $p");
//         payment = p;
//       }
//     } catch (e) {print("error on getPaymentCondition: $e");}
//   }
//
//
//
//   GetUnit() async {
//     String url = "${Env.baseUrl}GtUnits";
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//       print("Units");
//       print(res.body.toString());
//       if(res.statusCode==200) {
//         List <dynamic> tagsJson = json.decode(res.body)['gtunit'];
//         List<UnitType> ut = tagsJson.map((tagsJson) =>
//             UnitType.fromJson(tagsJson)).toList();
//         print("uuuu : $ut");
//         unit = ut;
//       }
//     } catch (e) {
//       print("error on  unit= $e");
//     }
//   }
//
//
//
//   GetGodown()async{
//     String url = "${Env.baseUrl}Mgodowns";
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//       print("Units");
//       if(res.statusCode==200) {
//         List <dynamic> tagsJson = json.decode(res.body)['mGodown'];
//         List<Godown> gd = tagsJson.map((tagsJson) =>
//             Godown.fromJson(tagsJson)).toList();
//         print("Godwon : $gd");
//         Gdwn = gd;
//         if(Gdwn.length==1){
//           godownController.text =tagsJson[0]["gdnDescription"];
//           itemGdwnId=tagsJson[0]["gdnId"];
//         }
//       }
//     } catch (e) {
//       print("error on  unit= $e");
//     }
//
//   }
//
//
//   ///------------multiple item select-------------------
//   var SelectedRowData=[];
//   var SelectedRowDataSAmple=[];
//   TextEditingController QtyController = new TextEditingController();
//   bool ShowAllItem=false;
//   var Net_VAt=0.0;
//   var Net_Amt_Befor_Tax=0.0;
//   ///-------------------------------
//
// //for test ..........
// //   salesSave() async {
// //
// //     print("sales length");
// //
// //     print(branchId);
// //     print(userId);
// //
// //
// //   }
//   //.........................
//
//
//
//   VlidationBeforeSave() async {
//     int TblDatalength=0;
//     if(btnname=="Save"){
//       TblDatalength=sales.length;
//     }else{
//       TblDatalength=SalesEditDatas.length;
//     }
//     if(TblDatalength< 1){
//
//       showDialog(
//           context: context,
//           builder: (context) =>
//               AlertDialog(
//                 title: Center(
//                   child: Text(
//                     "Please Add Item...",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
// //              content: Text("user data:   " + user.user["token"]),
//               ));
//       return;
//     }
//
//     if(paymentType_Id!=null) {
//       setState(() {
//         paymentTypeSelect=false;
//       });
//       if (paymentType_Id.toString() == "1") {
//         var Ldg_IdOnCash=await getsalesLedgerId(customerController.text);
//         if(Ldg_IdOnCash==null){
//           salesLedgerId=null;
//         }
//
//
//         if (salesLedgerId == null || customerController.text == "") {
//           setState(() {
//             print("salesLedgerId $salesLedgerId");
//             customerSelect = true;
//             return;
//           });
//         } else {
//           setState(()  {
//             customerSelect = false;
//             slsname=customerController.text;
//           });
//           salesSave();
//         }
//       } else {
//         setState(()  {
//           customerSelect = false;
//           slsname=customerController.text;
//         });
//         print("juio");
//         salesSave();
//
//       }
//     }
//     else{
//
//       setState(() {
//         paymentTypeSelect=true;
//       });
//     }
//
//   }
//
//
// //  sales save function ------------------------------------------------------
//
//   salesSave() async {
//     if(widget.passvalue==0 ||widget.passvalue==null ||(widget.itemrowdata).containsKey('ledgerName')) {
//       //  var exDate=DateTime.now();
//       setState(() {
//         if (godownController.text == "") {
//           print("Godown not selected");
//           GodownSelect = true;
//         }
//         else {
//           print("on");
//           GodownSelect = false;
//         }
//       });
//
//
// //------check off line or online
//       if(internet_Connection==false){
//         Save_toLocalDb();
//         print("sales oflibe");
//
//       }
//       else{
//         print("sales Online Save");
//
//
//         final url = "${Env.baseUrl}SalesHeaders";
//         // print("sales length");
//         // print(sales.length);
//         // print(sales);
//         // print("list length");
//         // print(customerItemAdd.length);
//         delivery = "";
//         delivery = salesdeliveryController.text.toString();
//         var remarks = generalRemarksController.text.toString();
//         // print("sales ledger Id");
//         // print(salesLedgerId);
//         // print("sales Item Id");
//         // print(salesItemId);
//         // print("sales payment Id");
//         // print(salesPaymentId);
//         // print("server date");
//         // print(serverDate);
//         // print("delivery date");
//         // print(deliveryDate);
//         // print("remarks");
//         if (widget.itemrowdata !=
//             null) { //add godown id for sals order converted data
//           print("Datas from sales order");
//           for (int i = 0; i < sales.length; i++) {
//             if (sales[i].gdnId == null || sales[i].gdnId == 0) {
//               print("gdnId is null");
//               sales[i].gdnId = itemGdwnId;
//             }
//           }
//         }
//
//
//         var param = json.encode(sales);
//         print("itms are : $param");
//
//         // print("Saless : $sales");
//         if (deliveryDateSelect || paymentSelect
//             || customerItemAdd.length <= 0 || sales.length <= 0 ||
//             godownController.text == "" || customerController.text == "" ||
//             paymentTypeController.text.toString() == "null") {
//           showDialog(
//               context: context,
//               builder: (context) =>
//                   AlertDialog(
//                     title: Text(
//                       "Please Check the fields",
//                       style: TextStyle(color: Colors.red),
//                     ),
// //              content: Text("user data:   " + user.user["token"]),
//                   ));
//           return;
//         } else {
//           var exDate = DateTime.parse(serverDate);
//           var param = json.encode(sales);
//           print("Validation Complited itms are : $param");
//           var req = {
//             "voucherDate": DateOnlyFormat.format(DateTime.now()),
//             //serverDate.toString(),
//             "orderHeadId": null,
//             "orderDate": null,
//             "expDate": DateOnlyFormat.format(exDate),
//             "ledgerId": salesLedgerId,
//             "partyName": slsname,
//             "address1": null,
//             "address2": null,
//             "gstNo": null,
//             "phone": null,
//             "shipToName": null,
//             "shipToAddress1": null,
//             "shipToAddress2": null,
//             "shipToPhone": null,
//             "narration": remarks == "" ? null : remarks,
//             "amount":Net_Amt_Befor_Tax,// grandTotal,
//             "userId": userId,
//             "branchId": branchId,
//             "otherAmt": 0.00,
//             "discountAmt": DiscountAmount,
//             "balanceAmount":(grandTotal-DiscountAmount),
//             "creditPeriod": null,
//             "paymentCondition": paymentType_Id.toString() == "0"
//                 ? "Cash"
//                 : "Credit",
//             "paymentType": paymentType_Id,
//             "invoiceType": "BtoB",
//             "invoicePrefix": null,
//             "invoiceSuffix": null,
//             "cancelFlg": null,
//             "entryDate": null,
//             "slesManId": null,
//             "branchUpdated": false,
//             "Tax_amt":Net_VAt,
//             "saleTypeInterState": false,
//             "salesDetails": sales,
//             "salesExpense": [
//               //   {
//               //   "expenseLedgerId":1,
//               //   "amount": null,
//               //   "taxHeadId": null,
//               //   "taxAmt": null,
//               //   "cgstAmt": null,
//               //   "sgstAmt": null,
//               //   "igstAmt": null
//               // }
//             ]
//           };
//           print("req $req");
//
//           var params = json.encode(req);
//           //  print(params.toString());
//           print("iouioiououi");
//           // debugPrint(params);
//           log(params);
//
//           setState(() {
//             Save_Pending = true;
//           });
//
//           var res = await http.post(url,
//               headers: {
//                 'accept': 'application/json',
//                 'content-type': 'application/json',
//                 'Authorization': user.user["token"],
//                 'deviceId': user.deviceId
//               },
//               body: params);
//
//           print("salesSave : " + res.statusCode.toString());
//           print("salesSave : " + res.body.toString());
//           if (res.statusCode == 500) {
//             var c = json.decode(res.body);
//             var msg = c['erromsg'].toString();
//             showDialog(
//                 context: context,
//                 builder: (context) =>
//                     AlertDialog(
//                       title: Text(msg),
//                     ));
//           }
//           else if (res.statusCode == 200 || res.statusCode == 201) {
//             print("401 : " + res.body.toString());
//             try {
//               String ms = "Out Of Stock";
//               var c = json.decode(res.body);
//               // var msg = c['outOfStockList']["data"].toString();
//               // print("return" + msg);
//               log("responce : "+c.toString());
//               if (json.decode(res.body).containsKey('outOfStockList'))
//                 // if (msg.length >0)
//                   {
//                 print("exist");
//                 // ms = msg;
//                 showDialog(
//                     context: context,
//                     builder: (context) =>
//                         AlertDialog(
//                           title: Text(ms),
//                         ));
//                 setState(() {
//                   setState(() {
//                     Save_Pending = false;
//                   });
//                 });
//               } else {
//                 retunid = await jsonDecode(res.body);
//                 // GetdataPrint(retunid['id']);
//                 setState(() {
//                   Resetfunction();
//                   customerItemAdd.clear();
//                   sales.clear();
//                   customerController.text = "";
//                   // salesdeliveryController.text = "";
//                   generalRemarksController.text = "";
//                   paymentController.text = "";
//                   salesLedgerId = null;
//                   salesItemId = null;
//                   salesPaymentId = null;
//                   grandTotal = 0;
//                 });
//
//                 showDialog(
//                     context: context,
//                     builder: (context) =>
//                         AlertDialog(
//                           title: Center(child: Text("Sales Saved...",style: TextStyle(color: Colors.green),)),
//                         ));
//                 rateSelect = false;
//                 quantitySelect = false;
//                 Timer(Duration(microseconds: 10,), () {
//                   print("Yeah, this line is printed after 2 seconds");
//                   salesdeliveryController.text =
//                       DateFormat("dd-MM-yyyy").format(DateTime.now());
//                   // GetdataPrint(retunid['id']);
//                   var _url = 'http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${retunid['id']}&uBr=$branchId&uNm=$userName&uP=$password';
//                   // UrlLaunch(_url);
//                   PdfPrint(retunid['id'],true,retunid);
//                   // Navigator.pop(context);
//                 });
//               }
//             }
//             catch (e) {
//               print("error in update $e");
//               cw.FailePopup(context);
//               setState(() {
//                 Save_Pending = false;
//               });
//             }
//           }
//         }
//       }
//
//
//
//
//
//       //update part----------------------------------------editsave editpart-----------------------------------------
//     }
//
//     else{
//
//       print("on else part");
//
//       int id =widget.passvalue;
//       final url = "${Env.baseUrl}SalesHeaders/$id";
//       print("id=   $id");
//       //print(salesedt.length);
//       //print(salesedt);
//       //print("list length");
//       //print(customerItemAdd.length);
//       delivery = "";
//       delivery = salesdeliveryController.text.toString();
//       var remarks = generalRemarksController.text.toString();
//
//       //print("sales ledger Id");
//       //print(salesLedgerId);
//       //print("sales Item Id");
//       //print(salesItemId);
//       //print("sales payment Id");
//       //print(salesPaymentId);
//       //print("server date");
//       //print(serverDate);
//       //print("delivery date");
//       //print(deliveryDate);
//       // print("remarks");
//       // print(SalesEditDatas);
//       //  var param = json.encode(salesedt);
//       // print("aaaasales : $param");
//
//       var Ldg_IdOnCash=await getsalesLedgerId(slsname);
//       print("Ldg_IdOnCash on edit ----$Ldg_IdOnCash");
//       var req = {
//         "id":widget.passvalue,
//         "voucherNo": SalesEditDatas["salesHeader"][0]["voucherNo"],                            //on edit
//         "voucherDate":DateOnlyFormat.format(DateTime.now()), //serverDate.toString(),
//         "orderHeadId": null,
//         "orderDate": null,
//         "expDate": SalesEditDatas["salesHeader"][0]["expDate"].toString(),
//         // "ledgerId":SalesEditDatas["salesHeader"][0]["ledgerId"].toString(),//salesLedgerId
//         "ledgerId":Ldg_IdOnCash==null?null:salesLedgerId,
//         "partyName": slsname,
//         "address1": null,
//         "address2": null,
//         "gstNo": null,
//         "phone": null,
//         "shipToName": null,
//         "shipToAddress1": null,
//         "shipToAddress2": null,
//         "shipToPhone": null,
//         "narration": remarks,
//         "amount":Net_Amt_Befor_Tax,// grandTotal,
//         "userId":  userId,
//         "branchId": branchId,
//         "otherAmt": 0.00,
//         "discountAmt": DiscountAmount,
//         "creditPeriod": null,
//         "paymentCondition": "",
//         "paymentType": 0,
//         "invoiceType": "BtoB",
//         "invoicePrefix": null,
//         "invoiceSuffix": null,
//         "cancelFlg": null,
//         "entryDate":SalesEditDatas["salesHeader"][0]["entryDate"].toString(),//null,// serverDate.toString(),
//         "slesManId": null,
//         "branchUpdated":false,
//         "saleTypeInterState":false,
//         "adjustAmount":0.0,
//         "adlDiscAmount":0.0,
//         "adlDiscPercent":0.0,
//         "balanceAmount":(grandTotal-DiscountAmount),
//         "cashReceived":0.0,
//         "Tax_amt":Net_VAt,
//         "otherAmountReceived":0.0,
//         "salesDetails": salesedt,
//         "salesExpense": []
//       };
//       // "salesExpense": [
//       //   {
//       //     "salesHeaderId": widget.passvalue,
//       //   "expenseLedgerId":null,
//       //   "amount": grandTotal,
//       //   "taxHeadId": null,
//       //   "taxAmt": 0,
//       //   "cgstAmt": 0,
//       //   "sgstAmt": 0,
//       //   "igstAmt": 0
//       // }
//       //   ]
//       print(req);
//       print(jsonEncode(salesedt).toString());
//
//
//       setState(() {
//         if (customerController.text == "") {
//           customerSelect = true;
//         } else {
//           customerSelect = false;
//         }
//
//         // if (salesPaymentId == 0 || paymentController.text == "") {
//         //   paymentSelect = true;
//         // } else {
//         //   paymentSelect = false;
//         // }
//         if (delivery != "") {
//           deliveryDateSelect = false;
//
//           return;
//         } else {
//           deliveryDateSelect = true;
//         }
//       });
//       // print("Saless : $sales");
//
//       setState(() {
//
//       });
//       if (customerSelect || deliveryDateSelect || paymentSelect
//           || customerItemAdd.length <= 0 ||salesedt.length <=0) {
//
//
//         showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text(
//                 "Please Check the fields",
//                 style: TextStyle(color: Colors.red),
//               ),
// //              content: Text("user data:   " + user.user["token"]),
//             ));
//       } else {
//         var params = json.encode(req);
//         print("final data");
//         debugPrint(params);
//
//
//
//         setState(() {
//           Save_Pending=true;
//         });
//         var res = await http.put(url,
//             headers: {
//               'accept': 'application/json',
//               'content-type': 'application/json',
//               'Authorization': user.user["token"],
//               'deviceId': user.deviceId
//             },
//             body: params);
//         //  print("saveddd");
//         print("SalesHeaders of edit : "+res.statusCode.toString());
// // testing------
//         if (res.statusCode == 204) {
//
//           showDialog(
//               context: context,
//               builder: (context) =>
//                   AlertDialog(
//                     title: Text("Sales Updated"),
//                   ));
//           rateSelect = false;
//           quantitySelect = false;
//
//
//           setState(() {
//             Resetfunction();
//             customerItemAdd.clear();
//             sales.clear();
//             salesedt.clear();
//             customerController.text = "";
//             salesdeliveryController.text = "";
//             generalRemarksController.text = "";
//             paymentController.text = "";
//             salesLedgerId=null;
//             salesItemId =null;
//             salesPaymentId =null;
//             grandTotal = 0;
//             Resetfunction();
//             var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=${widget.passvalue}&uBr=$branchId&uNm=$userName&uP=$password';
//             //UrlLaunch(_url);
//
//           });
//           Timer(Duration(seconds:1), () {
//             print("this line is printed after 2 seconds");
//             // Navigator.pop(context);
//             //   Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (context) => salesindex()));
//             PdfPrint(widget.passvalue,true,params);
//           });
//         }
//         //--------------------
//
//
//
//
//
//
//         if (res.statusCode == 200 ||
//             res.statusCode == 201 &&
//                 customerItemAdd.length > 0 &&
//                 salesedt.length > 0 &&
//                 salesLedgerId > 0 ) {
//           // print("401 : " + res.body.toString());
//           try {
//             String ms = "Out Of Stock";
//             var c = json.decode(res.body);
//             // var msg = c['outOfStockList']["data"].toString();
//             // print("return" + msg);
//             // print(msg.length);
//             if (json.decode(res.body).containsKey('outOfStockList'))
//               // if (msg.length >0)
//                 {
//               print("exist");
//               // ms = msg;
//               showDialog(
//                   context: context,
//                   builder: (context) =>
//                       AlertDialog(
//                         title: Text(ms),
//                       ));
//               setState(() {
//                 Save_Pending=true;
//               });
//             } else {
//               setState(() {
//                 customerItemAdd.clear();
//                 sales.clear();
//                 salesedt.clear();
//                 customerController.text = "";
//                 salesdeliveryController.text = "";
//                 generalRemarksController.text = "";
//                 paymentController.text = "";
//                 salesLedgerId =null;
//                 salesItemId =null;
//                 salesPaymentId=null;
//                 grandTotal = 0;
//                 Resetfunction();
//               });
//
//               showDialog(
//                   context: context,
//                   builder: (context) =>
//                       AlertDialog(
//                         title: Text("Sales Updated"),
//                       ));
//               rateSelect = false;
//               quantitySelect = false;
//               setState(() {
//                 Save_Pending=true;
//               });
//               Timer(Duration(seconds: 2), () {
//                 print("Yeah, this line is printed after 2 seconds");
//
//                 Navigator.pop(context);
//               });
//             }
//           }
//           catch(e){print("error in update $e");}
//           cw.FailePopup(context);
//           setState(() {
//             Save_Pending=true;
//           });
//         }
//
//       }
//     }
//   }
//
//
//
//
//   @override
//   void initState() {
//     GetOffline_data();
//     Initial_internet_check();
//     if(widget.passname.toString()!= "null") {
//       //   print("value rctptclln= " + widget.passvalue.toString());
//       customerController.text = widget.passname;
//       GetEditLedgerId();
//       getCustomerLedgerBalance(salesLedgerId);
//       slsname=widget.passname;
//       salesdeliveryController.text=widget.itemrowdata['voucherDate'];
//     }
//
//
//     //  print("......");
//     goodsController.text = "";
//     SharedPreferences.getInstance().then((value) {
//       pref = value;
//       read();
//       getCustomer();
//       getFinishedGoods();
//       getPaymentCondition();
//       GetUnit();
//       GetGodown();
//       GetTax();
//       GetInvNo();
//       GeneralSettings();
//       salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
//       //testing----------------------------------------------
//       if(widget.itemrowdata ==null)//for  sales create
//           {
//         print("itemrowdata...null");
//         btnname="Save";
//         getCustomerLedgerBalance(0);
//         //printer function...
//       }
//       else if((widget.itemrowdata).containsKey('ledgerName')) //from sales order
//           {
//         databindingSoh( widget.itemrowdata["id"]);
//         btnname="Save";
//         print("from  sales Header //sales oreder");
//         //printer function...
//       }
//       else
//       {
//         print("itemrowdata...have it"+  widget.itemrowdata["id"].toString()); // from sales list
//         databinding( widget.itemrowdata["id"]);
//         btnname="Update";
//       }
//
//       //-------------------------------------------
//       footerdata();
//       Priter_Initial_Part();
//     });
// //    getUsers();
//     super.initState();
//     customerController.addListener(customerLedgerIdListener);
//     goodsController.addListener(itemIdListener);
//     paymentController.addListener(paymentIdListener);
//     UnitController.addListener(unitIdListener);
//   }
//
//
//
//
//   GetEditLedgerId()async{
//
//     salesLedgerId=await getsalesLedgerId(widget.passname);
//     print("-----GetEditLedgerId--$salesLedgerId--");
//   }
//
//   getsalesLedgerId(lhName){
//     print("getsalesLedgerId");
//
//     var s;
//
//     if(internet_Connection==true){
//
//       final _results = users.where((product) => product.lhName.toString() == lhName.toString());
//
//       print(_results.toString());
//       for (Customer p in _results) {
//
//         s=p.id;
//
//         print(p.lhName.toString());
//         print("--------$s---------");
//       }
//       return s;
//     }
//
//     else
//
//     {
//       final _results = offline_LdgrMaster.where((product) => product.lhName.toString() == lhName.toString());
//
//       print(_results.toString());
//       for (LD_Model_LedgerHeads p in _results) {
//
//         s=p.id;
//
//         print(p.lhName.toString());
//         print("--------$s---------");
//       }
//       return s;
//     }
//   }
//
//
//
//
//
//
//   getItemIndex(dynamic item) {
//     var index = customerItemAdd.indexOf(item);
//     return index + 1;
//   }
//
//   customerLedgerIdListener() {
//     setState(() {
//       salesLedgerId ==null;
//       openingAmountBalance = 0;
//       print(customerController.text);
//       print("item");
//     });
//   }
//
//   itemIdListener() {
//     setState(() {
//       print("Item    .....................");
//       //salesItemId = 0;
//       print(goodsController.text);
//     });
//   }
//
//   paymentIdListener() {
//     print("payment");
//     salesPaymentId == null;
//
//     print(paymentController.text);
//   }
//
//   unitIdListener() {
//     print("Unit");
//     unitId == null;
//     print(UnitController.text);
//   }
//
//   validationQuantity() {
//     if (quantityController.text == "") {
//       quantitySelect = true;
//       validationRate();
//     } else {
//       quantitySelect = false;
//       validationRate();
//     }
//   }
//
//   validationRate() {
//     if (rateController.text == "" ||rateController.text == "0.0" ) {
//       rateSelect = true;
//       validationUnit();
//     } else {
//       rateSelect = false;
//       validationUnit();
//     }
//   }
//
//   validationUnit() {
//     if ( unitId ==null) {
//       unitSelect = true;
//
//     } else {
//       unitSelect = false;
//     }
//   }
//
//
// // add customer item----------------------------------------------------
//
//   addCustomerItem() {
//
//     print("add...... ");
//     setState(() {
//       if (salesItemId == null || goodsController.text == "") {
//         itemSelect = true;
//         validationQuantity();
// //      validationRate();
//       } else {
//         itemSelect = false;
//         validationQuantity();
// //      validationRate();
//       }
//     });
//
//     if (rateController.text == "" || unitId == null || rateController.text == "null"||
//         quantityController.text == "" ||
//         salesItemId == null ||rateController.text == "0.0") {
//       print("check fields");
//       print(salesItemId);
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text("check fields"),
// //              content: Text("user data:   " + user.user["token"]),
//           ));
//       return;
//     }
//     var amount = double.parse(quantityController.text) *(double.parse(rateController.text)-ItemWiseDiscountAmount);
//     // print(amount);
//     // print(customerItemAdd.length);
//     print(goodsController.text);
//     dynamic itmName=goodsController.text;
//     // print(quantityController.text);
//     // print(rateController.text);
// //    _markers.add(Marker(
// //        markerId: MarkerId("Marker id"),
// //    position: latLng,
// //    infoWindow: InfoWindow(
// //    title: 'Your Location',
// //    snippet: 'More info',
// //    ),
//     dynamic  aftertax=0;
//     dynamic  befortax=0;
//     var igst=0.00;
//
//
//
//     setState(() {
//       var rate= double.parse(rateController.text)-ItemWiseDiscountAmount;
//       // grandTotal = grandTotal + amount; // calc with out tax
//       //  dynamic  aftertax=rate+((rate/100)*(itmtxper+cessper));
//
//       // double cgst=double.parse(((rate/100)*CgstPer).toStringAsFixed(2));
//       // double sgst=double.parse(((rate/100)*SgstPer).toStringAsFixed(2));
//       dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2));
//
//       print("amount  $amount");
//
//
//       /// calc with tax
//       //    var totligst=igst*double.parse(quantityController.text);
//       //  var totlcgst=cgst*double.parse(quantityController.text);
//       // var totlsgst=sgst*double.parse(quantityController.text);
//       //    var taxOneItm =((rate/100)*(itmtxper+cessper));
//       //  var  ToatalTax=taxOneItm*double.parse(quantityController.text);
//       //    print("grandTotal before $grandTotal");
//       //   grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
//       //      aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
//       //    print("grandTotal after $grandTotal");
//       ///--------test calc with tax----------------
//
//
//
//       var taxOneItm;
//       var taxAmtOfCgst;
//       var taxAmtOfSgst;
//       var  ToatalTax;
//
//
//       if(TaxInOrExc==true){
//
// //  var WithOutTaxamt=((itmtxper+100)/100);
// // print("gjgik");
// //  print(WithOutTaxamt.toString());
// //  //taxOneItm=rate/WithOutTaxamt;
// //  taxOneItm=(rate/100)*itmtxper;
// //   taxAmtOfCgst=(WithOutTaxamt/2);
// //   taxAmtOfSgst=(WithOutTaxamt/2);
// //  // ToatalTax =taxOneItm*double.parse(quantityController.text);
// //   grandTotal = grandTotal + amount;
// //   aftertax= amount;
// //   befortax=taxOneItm*double.parse(quantityController.text);
//         var WithOutTaxamt=((itmtxper+100)/100);
//         taxOneItm=rate/WithOutTaxamt;
//         taxAmtOfCgst=(WithOutTaxamt/2);
//         taxAmtOfSgst=(WithOutTaxamt/2);
//         aftertax= amount;
//         befortax=taxOneItm*double.parse(quantityController.text);
//         grandTotal = grandTotal + aftertax;
//       }
//       else{
//
//         taxOneItm =((rate/100)*(itmtxper+cessper));
//         taxAmtOfCgst=(taxOneItm/2);
//         taxAmtOfSgst=(taxOneItm/2);
//         ToatalTax =taxOneItm*double.parse(quantityController.text);
//         grandTotal = grandTotal + ToatalTax + amount;
//         aftertax=ToatalTax + amount;
//         befortax=amount;
//       }
//
//
//       if(GSTtyp==true){
//         igst= Igst*double.parse(quantityController.text);
//         taxAmtOfCgst=0;
//         taxAmtOfSgst=0;
//       }
//
//       if(TaxTypeGst==false){
//
//         igst=0.0;
//         taxAmtOfCgst=0.0;
//         taxAmtOfSgst=0.0;
//
//       }
//
//
//       Net_VAt=Net_VAt+(aftertax-befortax);
//       print("aftertax".toString());
//       print(aftertax.toString());
//       print(befortax.toString());
//       print(Net_VAt.toString());
//       print((aftertax-befortax).toString());
//
//
//
//
//
//       Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;
//
//       // print("Final................");
//       // print(taxOneItm.toString());
//       // print("CGST = "+taxAmtOfCgst.toString());
//       // print(aftertax.toString());
//       // print("igst = "+igst.toString());
//
//       print("Final................");
//       print((customerItemAdd.length + 1).toString());
//       print(itmName.toString());
//
//       ++slnum;
//       if(widget.passvalue==null|| widget.passvalue==0  ||(widget.itemrowdata).containsKey('ledgerName'))
//       {
//         print("on save part item add");
//
//         sale = Saless(
//             itmName:itmName,
//             ItemSlNo:customerItemAdd.length + 1,//slnum,
//             itemId:salesItemId,
//             qty:double.parse(quantityController.text),
//             rate:double.parse(rateController.text),
//             disPercentage:0,
//             cgstPercentage:CgstPer,
//             sgstPercentage:SgstPer,
//             cessPercentage:0,
//             discountAmount:0,
//             cgstAmount:(taxAmtOfCgst *double.parse(quantityController.text)),
//             sgstAmount:(taxAmtOfSgst*double.parse(quantityController.text)),
//             cessAmount:0,
//             igstPercentage:Igstper,
//             igstAmount:igst,
//             taxPercentage:itmtxper,
//             taxAmount:aftertax-befortax,
//             //taxAmount:(((double.parse(rateController.text))/100)*(itmtxper))*double.parse(quantityController.text),
//             taxInclusive:TaxInOrExc,
//             amountBeforeTax:befortax,
//             amountIncludingTax:aftertax,
//             netTotal:aftertax,
//             hsncode:Hsncode,
//             gdnId:itemGdwnId,//1
//             taxId:TaxId??Tax_IdNull,
//             rackId:null,
//             addTaxId:TaxId??Tax_IdNull,
//             unitId:unitId,
//             nosInUnit:nosunt,
//             barcode:Brcode,
//             StockId:StkId,
//             BatchNo:batchnum,
//             ExpiryDate:Edate,
//             Notes:null,
//             DiscountAmount: ItemWiseDiscountAmount
//
//         );
//
//         sales.add(sale);
//         print(".............");
//         print(sale.itemId);
//         print(sale.qty);
//         print(sale.rate);
//         print(sales);
//         var param = json.encode(sales);
//         print("sales : $param");
//         print("............");
//
//
//
//       }
//       else
//       {
//         print("on edit part8888 ");
//
//         slse = Salesedit(
//           shid:widget.passvalue,
//           ItemSlNo:slnum,
//           itemId:salesItemId,
//           qty:double.parse(quantityController.text),
//           rate:double.parse(rateController.text),
//           disPercentage:0,
//           cgstPercentage:CgstPer,
//           sgstPercentage:SgstPer,
//           cessPercentage:0,
//           discountAmount:0,
//           cgstAmount:(taxAmtOfCgst*double.parse(quantityController.text)),
//           sgstAmount:(taxAmtOfSgst*double.parse(quantityController.text)),
//           cessAmount:0,
//           igstPercentage:Igstper,
//           igstAmount:igst,
//           taxPercentage:itmtxper,
//           taxAmount:aftertax-befortax,
//           //taxAmount:(((double.parse(rateController.text))/100)*(itmtxper))*double.parse(quantityController.text),
//           taxInclusive:false,
//           amountBeforeTax:befortax,
//           amountIncludingTax:aftertax,
//           netTotal:aftertax,
//           hsncode:Hsncode,
//           gdnId:itemGdwnId,
//           taxId:TaxId??Tax_IdNull,
//           rackId:null,
//           addTaxId:TaxId??Tax_IdNull,
//           unitId:unitId,
//           nosInUnit:nosunt,
//           barcode:Brcode,
//           StockId:StkId,
//           BatchNo:batchnum,
//           ExpiryDate:Edate,
//           Notes:null,
//           adlDiscAmount:null,
//           adlDiscPercent:null,
//           //DiscountAmount: ItemWiseDiscountAmount
//         );
//
//         salesedt.add(slse);
//         print(".............");
//         print(slse.itemId);
//         print(slse.qty);
//         print(slse.rate);
//         print(slse);
//         var param = json.encode(slse);
//         print("slse : $param");
//         print("............");
//
//       }
//     });
//
//
//     customer = CustomerAdd(
//         id: salesItemId,
//         slNo: customerItemAdd.length + 1,
//         item: goodsController.text,
//         quantity: double.parse(quantityController.text),
//         rate: double.parse(rateController.text),
//         txper:itmtxper,
//         cess:cessper,
//         NetAmt:aftertax,
//         amount: amount,
//         StkId:StkId,
//         txAmt:aftertax-befortax,
//         Disc_Amt: ItemWiseDiscountAmount
//
//     );
//
//     print(customer.item);
//     setState(() {
//       customerItemAdd.add(customer);
//       ItemsAdd_Widget_Visible=false;
//     });
//     print(customerItemAdd);
//     goodsController.text = "";
//     quantityController.text = "";
//     rateController.text = "";
//     UnitController.text="";
//     unitId=null;
//   }
//
//   // remove customer items
//   removeListElement(int id, int sl, double netamount,double taxAmt) {
//     print("on delete");
//     if(netamount==null){
//       netamount=0.00;
//     }
//
//     print(netamount.toString());
//     print(taxAmt.toString());
//     print("-----------remove--------");
//     print("sl num = $sl");
//
//     ///----test calc
//     setState(() {
//       grandTotal=  (grandTotal-netamount);
//       Net_VAt=Net_VAt-taxAmt;
//       Net_Amt_Befor_Tax=Net_Amt_Befor_Tax-(netamount-taxAmt);
//       print(netamount);
//     });
//     ///----test calc
//     customerItemAdd.removeWhere((element) => element.slNo == sl && element.id==id );
//     sales.removeWhere((element) => element.ItemSlNo == sl && element.itemId==id );
//     salesedt.removeWhere((element) => element.ItemSlNo == sl && element.itemId==id);
//
//     // grandTotal = grandTotal - amount;
//     setState(() {
//       //
//       // double taxamt=0.0;
//       // taxamt= amount+((amount/100)*(itmtxper+cessper));
//       // grandTotal=  (grandTotal-taxamt);
//       //
//
//       // grandTotal=  (grandTotal-amount); //with out tax
//
//       print("end deleted");
//       print(grandTotal);
//       print("sales.length= "+sales.length.toString());
//       print("salesedt.length= "+salesedt.length.toString());
//       if(sales.length==0 && salesedt.length==0){
//         grandTotal=0;
//         Net_Amt_Befor_Tax=0.0;
//         Net_VAt=0;
//       }
//       // slnum=slnum-1;
//     });
//
//
//   }
//
//
//   Future<bool> _onBackPressed() {
//     //  // Navigator.pop(context,salesLedgerId);
//     Navigator.pop(context);
//     customerItemAdd=[];
//     Resetfunction();
//
//
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //       builder: (context) => CustomerVisited(a:salesLedgerId.toString(),b:slsname.toString(),)),  );
//     //
//
//
//   }
//
//
//   //testing --------------------
//
//
//
//   //getbatch no----------itembatchcheck------------------
//   getbatch(id)async
//   {
//     String url = "${Env.baseUrl}GtStocks/$id/-1/";
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//       print("batch data GtStocks/$id/-1/");
//       // print(res);
//       if(res.statusCode<205) {
//         var tagsJson = await json.decode(res.body);
//         print("oi " + tagsJson.toString());
//         batchdata = tagsJson['data'] as List;
//         //  batchdata.forEach(print);
//         print("batchdata length");
//         // print(batchdata.length.toString());
//         print(batchdata);
//
//
//         if (batchdata.length > 1) {
//           boxvisible = true;
//
//           showDialog(
//               context: context,
//               builder: (context) =>
//                   Visibility(
//                     visible: boxvisible,
//                     child: AlertDialog(
//                       actions: [
//                         Container(
//                           height: 300,
//                           width: 350,
//                           child: Row(
// //            verticalDirection: VerticalDirection.down,
// //            crossAxisAlignment: CrossAxisAlignment.start,
//
//                             children: [
//                               // SizedBox(
//                               //   width: 60,
//                               // ),
//
//                               Expanded(
//                                   child: SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.vertical,
//                                       child: DataTable(
//                                         showCheckboxColumn: false,
//                                         columnSpacing: 17,
//                                         onSelectAll: (b) {},
//                                         sortAscending: true,
//                                         columns: <DataColumn>[
//                                           DataColumn(
//                                             label: Text('Name'),
//                                           ),
//                                           DataColumn(
//                                             label: Text('Rate'),
//                                           ),
//                                           DataColumn(
//                                             label: Text('Qty'),
//                                           ),
//                                           DataColumn(
//                                             label: Text('Expiry Date'),
//                                           ),
//                                           DataColumn(
//                                             label: Text('Batch No'),
//                                           ),
//                                           // DataColumn(
//                                           //   label: Text('Amount'),
//                                           // ),
//                                           // DataColumn(
//                                           //   label: Text('Add'),
//                                           // ),
//                                         ],
//                                         rows: batchdata
//                                             .map(
//                                               (itemRow) =>
//                                               DataRow(
//                                                 onSelectChanged: (a) {
//                                                   print(itemRow['id']);
//                                                   // id: 21
//                                                   multibatchitembinding(
//                                                       itemRow);
//
//                                                   Navigator.pop(context);
//                                                 },
//                                                 cells: [
//                                                   DataCell(
//                                                     Container(width: 150,
//                                                       child: Text(
//                                                           '${itemRow['itmName']
//                                                               .toString()}(${itemRow['gdnDescription']
//                                                               .toString()})'),
//                                                     ),
//                                                     showEditIcon: false,
//                                                     placeholder: false,
//                                                   ),
//                                                   DataCell(
//                                                     Text(
//                                                         '${itemRow['srate']
//                                                             .toString() ==
//                                                             "null"
//                                                             ? "-"
//                                                             : itemRow['srate']
//                                                             .toString()}'),
//                                                     showEditIcon: false,
//                                                     placeholder: false,
//                                                   ),
//                                                   DataCell(
//                                                     Text(
//                                                         '${itemRow['qty']
//                                                             .toString()}'),
//                                                     showEditIcon: false,
//                                                     placeholder: false,
//                                                   ),
//                                                   DataCell(
//                                                     GestureDetector(
//                                                       onTap: () {},
//                                                       child:
//                                                       //Text( '${DateFormat("dd-MM-yyyy").format(DateTime.parse(itemRow['expiryDate']))}'),
//                                                       Text(
//                                                           (itemRow['expiryDate']) ==
//                                                               null
//                                                               ? "-:-:-"
//                                                               : (DateFormat(
//                                                               "dd-MM-yyyy")
//                                                               .format(
//                                                               DateTime.parse(
//                                                                   itemRow['expiryDate'])))),
//                                                     ),
//                                                     showEditIcon: false,
//                                                     placeholder: false,
//                                                   ),
//                                                   DataCell(
//                                                     GestureDetector(
//                                                       onTap: () {},
//                                                       child: Text(
//                                                           '${itemRow['batchNo'] ??
//                                                               "-"}'),
//
//                                                     ),
//                                                     showEditIcon: false,
//                                                     placeholder: false,
//                                                   ),
//                                                   // DataCell(
//                                                   //   GestureDetector(
//                                                   //       onTap: () {
//                                                   //
//                                                   //       },
//                                                   //       child: Icon(Icons.add_circle_outline_sharp)),
//                                                   // ),
//                                                 ],
//                                               ),
//                                         )
//                                             .toList(),
//                                       ),
//                                     ),
//                                   )),
//                               SizedBox(
//                                 width: 3,
//                               )
//                             ],
//                           ),
//                         )
//                       ],
// //              content: Text("user data:   " + user.user["token"]),
//                     ),
//                   ));
//         }
//
//         else if (batchdata.length == 0) {
//           showDialog(
//             barrierDismissible: false,
//             context: context,
//             builder: (context) =>
//                 AlertDialog(
//                   actions: [
//                     Container(
//                         height: 60,
//                         width: 350,
//                         child: Center(
//                             child: Text("Stock Not Available...!",
//                               style: TextStyle(
//                                   color: Colors.redAccent, fontSize: 20),)
//                         )),
//
//                   ],
//                 ),
//           );
//           Timer(Duration(seconds: 1), () {
//             Navigator.pop(context);
//           });
//         }
//
//         else {
//           print("with one data");
//           print(batchdata[0]["itmName"]);
//
//           dynamic j = [];
//           j = {
//             "id": batchdata[0]["Id"],
//             "itemId": id,
//             "expiryDate": batchdata[0]["expiryDate"],
//             "srate": batchdata[0]["Rate"],
//             "batchNo": batchdata[0]["batchNo"],
//             "nos": batchdata[0]["nos"],
//             "barcode": batchdata[0]["barcode"],
//             "godownId": batchdata[0]["godownId"]
//           };
//           print(j);
//           multibatchitembinding(j);
//         }
//       }
//       else if(res.statusCode==404){
//
//
//         dynamic j = [];
//         if(negativeSalesAllow){
//
//           j = {
//             "id": id,
//             "itemId": id,
//             "expiryDate": null,
//             "srate": null,
//             "batchNo": null,
//             "nos": null,
//             "barcode": null,
//             "godownId":itemGdwnId
//           };
//           multibatchitembinding(j);
//
//
//         }else{
//           return showDialog(
//             barrierDismissible: true,
//             context: context,
//             builder: (context) =>
//                 AlertDialog(
//                   actions: [
//                     Container(
//                         height: 60,
//                         width: 350,
//                         child: Center(
//                             child: Text("Stock Not Available...!",
//                               style: TextStyle(
//                                   color: Colors.redAccent, fontSize: 20),)
//                         )),
//
//                   ],
//                 ),
//           );
//         }
//
//
//       }
//     } catch (e) {
//       print("error on  batch = $e");
//     }
//
//   }
//
//
//
//
// //multiple batch item binding-----
//   multibatchitembinding(rowdata)async {
//     print("888888 data bind multibatchitembinding");
//     print(rowdata);
//     Edate=rowdata['expiryDate'];
//     Srate=rowdata['srate']??0.00;
//     batchnum=rowdata['batchNo'];
//     nosunt=rowdata['nos'];
//     Brcode=rowdata['barcode'];
//     StkId=rowdata['id'];
//     rateController.text=Srate.toString();
//     int id=rowdata['itemId'];
//     salesItemId =id;
//     itemGdwnId=rowdata['godownId'].toString()=="null"?itemGdwnId:rowdata['godownId'];
//     // print(id.toString());
//     String url = "${Env.baseUrl}GtItemMasters/$salesItemId";
//     var tagsJson;
//     try {
//       final res =
//       await http.get(url, headers: {"Authorization": user.user["token"]});
//       print("batch data");
//       print(res.body.toString());
//       tagsJson = jsonDecode(res.body)["result"][0];
//     }
//     catch (e) {
//       print("error on  batch = $e");
//       var res= await Local_Db().Get_Selected_ItemData(salesItemId);
//       tagsJson=res[0];
//     }
//
//
//     // print("====555555====");
//     // print(tagsJson);
//     // print(tagsJson['description'].toString());
//
//     //goodsController.text =name;
//
//     // print("close.... $salesItemId");
//
//     // print( tagsJson["itmTaxInclusive"].toString());
//
//     // salesItemId = tagsJson["id"];
//     goodsController.text = tagsJson["itmName"];
//
//
//
//     // print("nnnnn $salesItemId");
//     // print("nnnnn "+goodsController.text);
//
//
//     (tagsJson["txPercentage"] == null ||tagsJson["txPercentage"] == "null") ? itmtxper=0.0:itmtxper =tagsJson["txPercentage"];
//     (tagsJson["atPercentage"] == null ||tagsJson["atPercentage"] == "null") ? cessper=0.0:cessper =tagsJson["atPercentage"];
//     (tagsJson["description"] == null ||tagsJson["description"] == "null") ?  UnitController.text="": UnitController.text =tagsJson["description"];
//     (tagsJson["itmUnitId"] == null ||tagsJson["itmUnitId"] == "null") ? unitId=null: unitId =tagsJson["itmUnitId"];
//     (tagsJson["itmHsn"] == null ||tagsJson["itmHsn"]  == "null") ?  Hsncode ="": Hsncode =tagsJson["itmHsn"];
//     (tagsJson["txCgstPercentage"] == null ||tagsJson["txCgstPercentage"] == "null") ?  CgstPer =0: CgstPer =tagsJson["txCgstPercentage"];
//     (tagsJson["txSgstPercentage"] == null ||tagsJson["txSgstPercentage"] == "null") ?  SgstPer =0: SgstPer =tagsJson["txSgstPercentage"];
//     (tagsJson["txIgstpercentage"] == null ||tagsJson["txIgstpercentage"] == "null") ?  Igstper =0: Igstper =tagsJson["txIgstpercentage"];
//     (tagsJson["itmTaxId"] == null ||tagsJson["itmTaxId"]  == "null") ?  TaxId=null: TaxId =tagsJson["itmTaxId"];
//
//
//     //------for offlinr data
//     if(tagsJson["itmTaxInclusive"].runtimeType==int){
//       TaxInOrExc=tagsJson["itmTaxInclusive"]==0?false:true;
//     }else
//     {
//       TaxInOrExc=tagsJson["itmTaxInclusive"];
//     }
//
//     if(Srate==0.0){
//       tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null"? Srate=0.00: Srate =tagsJson["itmSalesRate"];
//       setState(() {
//         rateController.text=Srate.toString();
//       });
//
//     }
//
//     // (tagsJson["itmSalesRate"] == null ||tagsJson["itmSalesRate"]  == "null") ? rateController.text="": Srate =tagsJson["itmSalesRate"];
//     //rateController.text=Srate.toString();
//     //Srate=rowdata['itmSalesRate'];
//     // print("11111111$SgstPer");
//     // print(tagsJson["description"]);
//     print  ("888888 data bind multibatchitembinding Completed");
//
//   }
//
//   //----------------------------
//
//
//   Resetfunction(){
//
//     GodownSelect=false;
//     ItemsAdd_Widget_Visible=false;
//     customerSelect = false;
//     deliveryDateSelect = false;
//     rateSelect = false;
//     quantitySelect = false;
//     itemSelect = false;
//     paymentSelect = false;
//     customerItemAdd.clear();
//     sales.clear();
//     customerController.text = "";
//     //salesdeliveryController.text = "";
//     generalRemarksController.text = "";
//     paymentController.text = "";
//     grandTotal = 0;
//     salesPaymentId = null;
//     salesItemId = null;
//     salesLedgerId = null;
//     UnitController.text="";
//     unitId=null;
//     unitSelect=false;
//     quantityController.text="";
//     goodsController.text="";
//     slnum=0;
//     salesedt.clear();
//     rateController.text="";
//     paymentTypeController.text="";
//     paymentType_Id=null;
//     paymentTypeSelect=false;
//     godownController.text="";
//     itemGdwnId=null;
//     Net_Amt_Befor_Tax=0.0;
//     Net_VAt=0.0;
//     GetInvNo();
//     GetGodown();
//     salesdeliveryController.text=DateFormat("dd-MM-yyyy").format(DateTime.now());
//     Save_Pending=false;
//
//     btnname="Save";
//     Itemwise_DiscountController.text="";
//     ItemWiseDiscountAmount=0.0;
//     DiscountAmount=0.0;
//     DiscountController.text="";
//
//   }
//
//
// //-------------------------------------------------------
//   itemReEditing(items)async{
//
//     print(items.StkId);
//     var itmStkid=items.StkId;
//     try {
//       final res =
//       await http.get(Env.baseUrl+"GtStocks/$itmStkid", headers: {"Authorization": user.user["token"]});
//
//
//       var tagsJson = json.decode(res.body);
//       print(tagsJson.toString());
//       print(tagsJson["expiryDate"].toString());
//       dynamic itemdata=[];
//       itemdata={
//         "id":itmStkid,
//         "itemId":items.id,
//         "expiryDate":tagsJson["expiryDate"],
//         "srate":tagsJson["srate"],
//         "batchNo":tagsJson["batchNo"],
//         "nos":null,
//         "barcode":tagsJson["barcode"],
//         "godownId":tagsJson["godownId"]
//       };
//       print(itemdata);
//       multibatchitembinding(itemdata);
//       // removeListElement(items.id,
//       //     items.slNo, items.NetAmt);
//
//     }catch(e)
//     {print("error on itemReEditing $e");}
//     // GtStocks/$id/1/"
//     // getbatch(items.StkId);
//     quantityController.text=items.quantity.toString();
//     // rateController.text=items.rate.toString();
//
//     // id: salesItemId,
//     // slNo: customerItemAdd.length + 1,
//     // item: goodsController.text,
//     // quantity: double.parse(quantityController.text),
//     // rate: double.parse(rateController.text),
//     // txper:itmtxper,
//     // cess
//
//
//
//   }
// //-------------------------------------------------------
// //--------------------------Barcode Reader----------------------
//
//   void qr_Barcode_Readfunction() async {
//     try {
//       print("in qr_Barcode_Readfunction ");
//       var result = await BarcodeScanner.scan();
//       // print("type");
//       // print(result.type);
//       // print("rawContent");
//       // print(result.rawContent);
//       // print("format");
//       // print(result.format);
//       // print("formatNote");
//       // print(result.formatNote);
//       final jsonres =
//       await http.get(Env.baseUrl+"GtitemMasters/1/${result.rawContent}/barcode", headers: {"Authorization": user.user["token"]});
//       print("batch data");
//       print(jsonres.statusCode);
//       var tagsJson = jsonDecode(jsonres.body);
//       print(tagsJson);
//       print(tagsJson["result"][0]["id"]);
//
//       print(result.formatNote);
//       setState(() {
//         getbatch(tagsJson["result"][0]["id"]);
//         quantityController.text="1";
//         // goodsController.text=result.rawContent.toString();
//         FocusScope.of(context).requestFocus(rateFocus);
//
//       });
//     }
//     catch(e) {  print("Error on qr_Barcode_Readfunction $e");}
//
//   }
//
//
//
//
//
//   ///-----------------------multiple item Select--------------------------------
//
//   ShowAllItemPopup(Itemdata){
//     showDialog(
//         context: context,
//         builder: (context) =>   AlertDialog(
//           shape:RoundedRectangleBorder(
//             side: BorderSide(color:  Colors.blueAccent, width: 1),
//             borderRadius: BorderRadius.circular(20),
//           ),
//
//           //  content: Itm_Slct_All_Popup(data: Itemdata,),
//           actions: [
//             // listreturn= Itm_Slct_All_Popup(data: Itemdata,)
//             Column(
//               children: [
//                 Container(color: Colors.white,
//                   height: MediaQuery.of(context).size.width/1.2,
//                   width: MediaQuery.of(context).size.width,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: DataTable(
//                         columnSpacing: 14,
//                         onSelectAll: (b) { },
//                         sortAscending: true,
//                         columns: <DataColumn>[
//                           DataColumn(
//                             label: Text('Name'),
//                           ),
//                           // DataColumn(
//                           //   label: Text('Qty'),
//                           // ),
//                           DataColumn(
//                             label: Text('Rate'),
//                           ),
//                         ],
//                         rows:goods
//                             .map(
//                               (itemRow)=>
//
//                               DataRow(
//                                 selected:SelectedRowData.contains(itemRow),
//                                 color:MaterialStateColor.resolveWith(
//                                       (states) {
//                                     if (SelectedRowData.contains(itemRow)) {
//                                       return Colors.teal;
//
//                                     } else {
//                                       return Colors.white;
//                                     }
//                                     setState(() {  });
//                                   },
//
//                                 ),
//
//                                 onSelectChanged: (bool selected) {
//                                   // print(itemRow.index);
//                                   SelectedRows(selected, itemRow);
//                                 },
//
//                                 cells: [
//                                   DataCell(
//                                     Container(
//                                       width: 150,
//                                       child: Text('${itemRow.itmName.toString()}'),
//                                     ),
//                                     showEditIcon: false,
//                                     placeholder: false,
//                                   ),
//                                   DataCell(
//                                     Text('${itemRow.itmSalesRate.toString()=="null"?
//                                     0.0:itemRow.itmSalesRate.toString()}'),
//                                     showEditIcon: false,
//                                     placeholder: false,
//                                   ),
//                                 ],
//                               ),
//
//                         )
//                             .toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(height: 50,width: MediaQuery.of(context).size.width,
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                     children: [
//
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left:2,right: 2),
//                           child: ElevatedButton(
//                               style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700), ) ,
//                               onPressed: (){
//                                 if(SelectedRowData.length<1){
//
//                                   showDialog(
//                                       barrierDismissible: false,
//                                       context: context,
//                                       builder: (context) =>   AlertDialog(
//                                         shape:RoundedRectangleBorder(
//                                           side: BorderSide(color:  Colors.red, width: 2),
//                                           borderRadius: BorderRadius.circular(20),
//                                         ),
//                                         title: Center(child: Text("Add Item...!")),));
//
//
//                                   Timer(Duration(milliseconds:1200),() {
//                                     Navigator.of(context, rootNavigator: true).pop();
//                                   });
//
//                                 }else{
//                                   Navigator.pop(context, SelectedRowData) ;
//                                   MultipleItemAddtoTable();
//                                 }
//                               },
//
//                               child: Text("Add to Cart")),
//                         ),
//                       ),
//
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left:2,right: 2),
//                           child: ElevatedButton(
//                               style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), ) ,
//                               onPressed: (){
//                                 Navigator.of(context, rootNavigator: true).pop();
//                               },
//                               child: Text("Cancel")),
//                         ),
//                       ),
//
//                       Container(height: 30,width: 30,
//                           decoration: BoxDecoration(color: Colors.teal,
//                               borderRadius: BorderRadius.circular(20)),
//                           child:Center(child: Text(SelectedRowData.length.toString())))
//                     ],
//                   ),)
//               ],
//             )
//           ],
//         ));
//
//   }
//
//
//
//   SelectedRows(bool stsus,FinishedGoods data)async{
//     print("SelectedRows");
//     print(data.itmUnitId);
//     if (stsus) {
//
//
//
//       showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return  AlertDialog(
//                 shape:RoundedRectangleBorder(
//                   side: BorderSide(color:  Colors.blueAccent, width: 1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 title: Center(child: Text(data.itmName)),
//                 content:   Container(
//                   width: 100,
//                   height: 30,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           autofocus: true,
//                           controller:QtyController,
//                           onFieldSubmitted: (val)  {
//                             print('onSubmited $val');
//                           },
//                           // focusNode: generalFocus,
//                           enabled: true,
//                           validator: (v) {
//                             if (v.isEmpty) return "Required";
//                             return null;
//                           },
// //
// //                  focusNode: field1FocusNode,
//                           cursorColor: Colors.black,
//
//                           scrollPadding:
//                           EdgeInsets.fromLTRB(0, 20, 20, 0),
//                           keyboardType: TextInputType.text,
//
//                           decoration: InputDecoration(
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(8),
//                             // border: OutlineInputBorder(
//                             //     borderRadius: BorderRadius.circular(10)),
//                             // curve brackets object
//                             hintText: "Quantity",
//                             hintStyle: TextStyle(
//                                 color: Colors.black, fontSize: 15),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 5,),
//                       ElevatedButton(onPressed: (){
//                         setState(() {
//                           Navigator.of(context, rootNavigator: true).pop();
//                           ItemPushToArray(data,QtyController.text);
//                         });
//                       }, child: Text("OK"))
//                     ],
//                   ),
//                 ),
//
//
//               );
//             },
//           );
//         },
//       );
//
//
//
//
//
//     }
//
//     else {
//
//
//
//
//
//       setState(() {
//         Navigator.of(context).pop();
//         SelectedRowData.remove(data);
//         SelectedRowDataSAmple.removeWhere((element) => element["id"] == data.id);
//
//         ShowAllItemPopup(goods);
//       });
//
//
//
//     }
//
//
//
//
//
//
//
//
//
//
//
//   }
//
//
//   ItemPushToArray(FinishedGoods data,qty){
//     print("ItemPushToArray");
//     print(data.itmUnitId.toString());
//
//     var json={
//       "id" :data.id,
//       "itmTaxInclusive":data.itmTaxInclusive,
//       "itmName" :data.itmName,
//       "qty":qty,
//       "itmImage" :data.itmImage,
//       "itmUserId" :data.itmUserId,
//       "itmBranchId":data.itmBranchId,
//       "txPercentage" :data.txPercentage,
//       "atPercentage" :data.atPercentage,
//       "description" :data.description,
//       "itmHsn" :data.itmHsn,
//       "unitId":data.itmUnitId,
//       "itmUnitId":data.itmUnitId,
//       "txCgstPercentage":data.txCgstPercentage,
//       "txSgstPercentage":data.txSgstPercentage,
//       "txIgstpercentage" :data.txIgstpercentage,
//       "itmTaxId" :data.itmTaxId,
//       "itmSalesRate" :data.itmSalesRate,
//       "itmStkTypeId":data.itmStkTypeId
//     };
//
//
//     SelectedRowData.add(data);
//     SelectedRowDataSAmple.add(json);
//     setState(() {
//       QtyController.text="";
//     });
//   }
//
//
//
//   MultipleItemAddtoTable (){
//
//     print(SelectedRowData.length.toString());
//
//
//     print("SelectedRowDataSAmple");
//     print(SelectedRowDataSAmple.length.toString());
//     print(json.encode(SelectedRowDataSAmple).toString());
//
//
//     var amount;
//     dynamic itmName=goodsController.text;
//     dynamic  aftertax=0;
//     dynamic  befortax=0;
//     var igst=0.00;
//     var rate;
//     //  dynamic Igst=double.parse(((rate/100)*Igstper).toStringAsFixed(2))
//     var taxOneItm;
//     var taxAmtOfCgst;
//     var taxAmtOfSgst;
//     var  ToatalTax;
//
//
//
//
//
//     for(int i=0;i<SelectedRowDataSAmple.length;i++){
//       itmtxper=SelectedRowDataSAmple[i]["txPercentage"]??0.0;
//       TaxInOrExc=SelectedRowDataSAmple[i]["itmTaxInclusive"]??false;
//       rate= SelectedRowDataSAmple[i]["itmSalesRate"]??0.0;
//       var Qty= double.parse(SelectedRowDataSAmple[i]["qty"]??0);
//       amount=rate*Qty;
//       if(TaxInOrExc==true){
//
//         var WithOutTaxamt=((SelectedRowDataSAmple[i]["txPercentage"]+100)/100);
//         taxOneItm=rate/WithOutTaxamt;
//         taxAmtOfCgst=(WithOutTaxamt/2);
//         taxAmtOfSgst=(WithOutTaxamt/2);
//         aftertax= amount;
//         befortax=taxOneItm*Qty;
//         grandTotal = grandTotal + aftertax;
//
//       }
//       else{
//
//         taxOneItm =((rate/100)*(SelectedRowDataSAmple[i]["txPercentage"]??0.0));
//         taxAmtOfCgst=(taxOneItm/2);
//         taxAmtOfSgst=(taxOneItm/2);
//         ToatalTax =taxOneItm*Qty;
//         grandTotal = grandTotal + ToatalTax + amount;
//         aftertax=ToatalTax + amount;
//         befortax=amount;
//       }
//
//       Net_VAt=Net_VAt+(aftertax-befortax);
//       Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+befortax;
//       // if(GSTtyp==true){
//       //   igst= Igst*double.parse(quantityController.text);
//       //   taxAmtOfCgst=0;
//       //   taxAmtOfSgst=0;
//       // }
//
//       if(TaxTypeGst==false){
//
//         igst=0.0;
//         taxAmtOfCgst=0.0;
//         taxAmtOfSgst=0.0;
//
//       }
//
//       if(btnname=="Save") {
//         sale = Saless(
//             itmName: SelectedRowDataSAmple[i]["itmName"],
//             // Total_amt:grandTotal,
//             amountBeforeTax: befortax,
//             amountIncludingTax: aftertax,
//             barcode: Brcode,
//             //batch:null,
//             cessAmount: 0,
//             cessPercentage: 0,
//             cgstAmount: taxAmtOfCgst *Qty,
//             cgstPercentage: SgstPer,
//             discountAmount: 0,
//             ExpiryDate: Edate,
//             gdnId: itemGdwnId,
//             igstAmount: igst,
//             igstPercentage: Igstper,
//             itemId: SelectedRowDataSAmple[i]["id"],
//             ItemSlNo: i,
//             netTotal: aftertax,
//             nosInUnit: nosunt,
//             Notes: null,
//             //purchaseRate:aftertax,
//             qty: Qty,
//             rate: rate,
//             sgstAmount: taxAmtOfSgst *Qty,
//             sgstPercentage: SgstPer,
//             taxAmount: aftertax - befortax,
//             taxId: SelectedRowDataSAmple[i]["itmTaxId"],
//             taxInclusive: false,
//             unitId: SelectedRowDataSAmple[i]["unitId"],
//             addTaxId: SelectedRowDataSAmple[i]["itmTaxId"],
//             taxPercentage: SelectedRowDataSAmple[i]["txPercentage"],
//             StockId: SelectedRowDataSAmple[i]["itmStkTypeId"],
//             DiscountAmount: ItemWiseDiscountAmount
//         );
//
//         sales.add(sale);
//         print("......save......");
//       }
//       else{
//
//
//         slse = Salesedit(
//           shid:widget.passvalue,
//           // shid: salesLedgerId,
//           //itmName: SelectedRowDataSAmple[i]["itmName"],
//           // Total_amt:grandTotal,
//           amountBeforeTax: befortax,
//           amountIncludingTax: aftertax,
//           barcode: Brcode,
//           //batch:null,
//           cessAmount: 0,
//           cessPercentage: 0,
//           cgstAmount: (taxAmtOfCgst *Qty),
//           cgstPercentage: SgstPer,
//           discountAmount: ItemWiseDiscountAmount,
//           ExpiryDate: Edate,
//           gdnId: itemGdwnId,
//           igstAmount: igst,
//           igstPercentage: Igstper,
//           itemId: SelectedRowDataSAmple[i]["id"],
//           ItemSlNo: i,
//           netTotal: aftertax,
//           nosInUnit: nosunt,
//           Notes: null,
//           //purchaseRate:aftertax,
//           qty: Qty,
//           rate: rate,
//           sgstAmount: (taxAmtOfSgst*Qty),
//           sgstPercentage: SgstPer,
//           taxAmount: aftertax - befortax,
//           taxId: SelectedRowDataSAmple[i]["itmTaxId"],
//           taxInclusive: false,
//           unitId: SelectedRowDataSAmple[i]["unitId"],
//           addTaxId: SelectedRowDataSAmple[i]["itmTaxId"],
//           taxPercentage: SelectedRowDataSAmple[i]["txPercentage"],
//           StockId: SelectedRowDataSAmple[i]["itmStkTypeId"],
//         );
//
//         salesedt.add(slse);
//         print("......Edit......");
//       }
//
//
//
//       customer = CustomerAdd(
//           id: SelectedRowDataSAmple[i]["id"],
//           slNo: i,
//           item: SelectedRowDataSAmple[i]["itmName"],
//           quantity:  double.parse(SelectedRowDataSAmple[i]["qty"]),
//           rate:  SelectedRowDataSAmple[i]["itmSalesRate"],
//           txper: SelectedRowDataSAmple[i]["txPercentage"],
//           cess: null,
//           NetAmt: aftertax,
//           amount:amount ,
//           StkId: SelectedRowDataSAmple[i]["itmStkTypeId"],
//           txAmt:aftertax-befortax,
//           Disc_Amt: ItemWiseDiscountAmount
//       );
//
//       customerItemAdd.add(customer);
//     }
//     print(customer);
//
//     //var bindData=[];
//     print(customerItemAdd.length);
//     print(sales.length);
//
//     setState(() {
//       ItemsAdd_Widget_Visible=false;
//     });
//   }
//   ///-------------------------------------------------------------------------------
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  SafeArea(
//       child: Scaffold(
// //      key: scaffoldKey,
//         appBar: PreferredSize(
//             preferredSize: Size.fromHeight(190.0),
//             child:  Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Sales")
//         ),
//         body: ListView(
//           children: <Widget>[
//             SizedBox(height: 10),
//
//
//             SizedBox(height:TextBoxHeight,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                 child: TypeAheadField(
//                     hideOnEmpty: true,
//                     textFieldConfiguration: TextFieldConfiguration(
//                         style: TextStyle(),
//                         controller: customerController,
//                         decoration: InputDecoration(
//                           errorStyle: TextStyle(color: Colors.red),
//                           errorText: customerSelect
//                               ? "Please Select Customer ?"
//                               : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.remove_circle),
//                             color: Colors.blue,
//                             onPressed: () {
//                               setState(() {
//                                 print("cleared");
//                                 customerController.text = "";
//                                 salesLedgerId = null;
//                                 openingAmountBalance = 0;
//                               });
//                             },
//                           ),
//
//                           isDense: true,
//                           contentPadding:
//                           EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(TextBoxCurve)),
//                           // i need very low size height
//                           labelText:
//                           'customer search', // i need to decrease height
//                         )),
//                     suggestionsBoxDecoration:
//                     SuggestionsBoxDecoration(elevation: 90.0),
//                     suggestionsCallback: (pattern) {
//
//                       if(internet_Connection==true){
//                         return users.where((user) =>
//                             user.lhName.toUpperCase().contains(pattern.toUpperCase()));
//                       }
//
//                       else{
//                         return offline_LdgrMaster.where((user) =>
//                             user.lhName.toUpperCase().contains(pattern.toUpperCase()));
//                       }
//
//
//                     },
//                     itemBuilder: (context, suggestion) {
//                       return Card(
//                         color: Colors.blue,
//                         child: ListTile(
//                           tileColor: theam.DropDownClr,
//                           title: Text(
//                             suggestion.lhName,
//                             style: TextStyle(color: Colors.white
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     onSuggestionSelected: (suggestion) {
//                       print(suggestion.lhName);
//                       print("selected");
//
//                       customerController.text = suggestion.lhName;
//                       print("close.... $salesLedgerId");
//                       slsname = suggestion.lhName;
//                       print(suggestion.id);
//                       print(".......sales Ledger id");
//                       salesLedgerId = suggestion.id;
//                       if (suggestion.id != null) {
//                         getCustomerLedgerBalance(suggestion.id);
//                       }
//                       print(salesLedgerId);
//                       print("...........");
//                     },
//                     errorBuilder: (BuildContext context, Object error) =>
//                         Text('$error',
//                             style: TextStyle(
//                                 color: Theme.of(context).errorColor)),
//                     transitionBuilder:
//                         (context, suggestionsBox, animationController) =>
//                         FadeTransition(
//                           child: suggestionsBox,
//                           opacity: CurvedAnimation(
//                               parent: animationController,
//                               curve: Curves.elasticIn),
//                         )),
//               ),
//             ),
//
//
//             Visibility(
//               visible: openingAmountBalance > 0,
//               child: SizedBox(
//                 height: 15,
//               ),
//             ),
//             Visibility(
//               visible: openingAmountBalance > 0,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(width: 30),
//                   Expanded(
//                     child: Text(
//                       "Current Balance:  " + openingAmountBalance.toString(),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             Visibility(
//               visible: openingAmountBalance > 0,
//               child: SizedBox(
//                 height: 9,
//               ),
//             ),
//
//             SizedBox(height:GodownSelect==true?60: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: TextFormField(
//                       style: TextStyle(fontSize: 15),
//                       showCursor: true,
//                       controller: salesdeliveryController,
//                       enabled: false,
//                       validator: (v) {
//                         if (v.isEmpty) return "Required";
//                         return null;
//                       },
// //
//                       // will disable paste operation
//                       focusNode: field1FocusNode,
//                       cursorColor: Colors.black,
//
//                       scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
//                       keyboardType: TextInputType.datetime,
//                       readOnly: true,
//
//                       onTap: () async {
//                         final DateTime now = DateTime.now();
//                         DateTime date = await showDatePicker(
//                             context: context,
//                             initialDatePickerMode: DatePickerMode.day,
//                             initialDate: now,
//                             firstDate: now.subtract(Duration(days: 1)),
//                             lastDate: DateTime(2080),
//                             builder: (BuildContext context, Widget child) {
//                               return Theme(
//                                 data: ThemeData.light(),
//                                 child: child,
//                               );
//                             });
//                         deliveryDate = date;
//                         var d = DateFormat("d-MM-yyyy").format(date);
//                         salesdeliveryController.text = d;
//                         // if (date != null) {
//                         //   print(date);
//                         //   if (date.day < DateTime.now().day) {
//                         //     print("invalid date select");
//                         //
//                         //     salesdeliveryController.text = "";
//                         //     return;
//                         //   } else {
//                         //     deliveryDate = date;
//                         //     var d = DateFormat("yyyy-MM-d").format(date);
//                         //     salesdeliveryController.text = d;
//                         //   }
//                         // }
//                       },
//                       decoration: InputDecoration(
//                         errorStyle: TextStyle(color: Colors.red),
//                         errorText: deliveryDateSelect ? "invalid date " : null,
//                         suffixIcon: Icon(
//                           Icons.calendar_today,
//                           color: Colors.blue,
//                           size: 24,
//                         ),
//                         isDense: true,
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//                         // curve brackets object
//                         hintText: "Inv: Date:dd/mm/yy",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//
//                         labelText: "Inv: Date",
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(width: 10),
//                   Expanded(
//                       child: TypeAheadField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                               style: TextStyle(),
//                               controller: godownController,
//                               decoration: InputDecoration(
//                                 errorStyle: TextStyle(color: Colors.red),
//                                 errorText: GodownSelect
//                                     ? "Please Select Godown ?"
//                                     : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                                 suffixIcon: IconButton(
//                                   icon: Icon(Icons.remove_circle),
//                                   color: Colors.blue,
//                                   onPressed: () {
//                                     setState(() {
//                                       print("cleared");
//                                       godownController.text = "";
//                                       itemGdwnId = null;
//                                     });
//                                   },
//                                 ),
//
//                                 isDense: true,
//                                 contentPadding:
//                                 EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(TextBoxCurve)),
//                                 // i need very low size height
//                                 labelText:
//                                 'Godown search', // i need to decrease height
//                               )),
//                           suggestionsBoxDecoration:
//                           SuggestionsBoxDecoration(elevation: 90.0),
//                           suggestionsCallback: (pattern) {
//                             if(internet_Connection==true) {
//                               print("Gdwn online");
//                               return Gdwn.where((gwn) =>
//                                   gwn.gdnDescription.toUpperCase().contains(
//                                       pattern.toUpperCase()));
//
//                             }
//                             else{
//                               print("offline_godown online");
//                               return offline_godown.where((gwn) =>
//                                   gwn.gdnDescription.toUpperCase().contains(
//                                       pattern.toUpperCase()));
//                             }
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return Card(
//                               color: Colors.blue,
//                               // shadowColor: Colors.blue,
//                               // So you upgraded flutter recently?
//                               // i upgarded more times
//                               // flutter cleaned
//                               // get pubed
//                               // outdated more times..try
//                               // but now result to bad...
//                               child: ListTile(
//                                 tileColor: theam.DropDownClr,
//                                 title: Text(
//                                   suggestion.gdnDescription,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             print(suggestion.gdnDescription);
//                             print("selected");
//                             print(suggestion.gdnId);
//                             godownController.text = suggestion.gdnDescription;
//                             itemGdwnId=suggestion.gdnId;
//                             print(".......${itemGdwnId.toString()}....");
//                           },
//                           errorBuilder: (BuildContext context, Object error) =>
//                               Text('$error',
//                                   style: TextStyle(
//                                       color: Theme.of(context).errorColor)),
//                           transitionBuilder:
//                               (context, suggestionsBox, animationController) =>
//                               FadeTransition(
//                                 child: suggestionsBox,
//                                 opacity: CurvedAnimation(
//                                     parent: animationController,
//                                     curve: Curves.elasticIn),
//                               ))),
//                   SizedBox(width: 10),
//                 ],
//               ),
//             ),
//
//
//
//
//             SizedBox(
//               width: 10,
//             ),
//
//             AddItemWidgets(context,ItemsAdd_Widget_Visible),
//
//
//             ///-----------------------Payment Condition---------------------------------
//             SizedBox(height:5),
//             SizedBox(height:paymentTypeSelect==true?60: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(width: 10),
//                   Expanded(
//                       child: TypeAheadField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                               style: TextStyle(),
//                               controller: paymentTypeController,
//                               decoration: InputDecoration(
//                                 errorStyle: TextStyle(color: Colors.red),
//                                 errorText: paymentTypeSelect
//                                     ? "Invalid Payment Typ"
//                                     : null,
//                                 suffixIcon: IconButton(
//                                   icon: Icon(Icons.remove_circle),
//                                   color: Colors.blue,
//                                   onPressed: () {
//                                     setState(() {
//                                       print("cleared");
//                                       paymentTypeController.text = "";
//                                       paymentType_Id=null;
//                                     });
//                                   },
//                                 ),
//
//                                 isDense: true,
//                                 contentPadding:
//                                 EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(TextBoxCurve)),
//                                 // i need very low size height
//                                 labelText:
//                                 'Payment Type', // i need to decrease height
//                               )),
//                           suggestionsBoxDecoration:
//                           SuggestionsBoxDecoration(elevation: 90.0),
//                           suggestionsCallback: (pattern) {
// //                        print(payment);
//                             return paymentType
// //                            .where((user) => goods.itmName == pattern);
//                                 .where((us) => us['type'].toString().contains(pattern));
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return Card(
//                               color: Colors.blue,
//                               // shadowColor: Colors.blue,
//                               child: ListTile(
//                                 tileColor: theam.DropDownClr,
//                                 title: Text(
//                                   suggestion["type"],
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             print(suggestion["type"],);
//                             print("Item selected");
//
//                             paymentTypeController.text = suggestion["type"];
//
//                             print(suggestion['id']);
//                             print("....... paymentType_Id id");
//                             paymentType_Id = suggestion["id"];
//
//                           },
//                           errorBuilder: (BuildContext context, Object error) =>
//                               Text('$error',
//                                   style: TextStyle(
//                                       color: Theme.of(context).errorColor)),
//                           transitionBuilder:
//                               (context, suggestionsBox, animationController) =>
//                               FadeTransition(
//                                 child: suggestionsBox,
//                                 opacity: CurvedAnimation(
//                                     parent: animationController,
//                                     curve: Curves.elasticIn),
//                               ))),
// //              SizedBox(height: 10),
//                   SizedBox(
//                     width: 1,
//                   ),
//                   Visibility(visible:!ItemsAdd_Widget_Visible,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10,right: 10),
//                       child:   ElevatedButton(style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),),
//                           onPressed: () {
//                             if (itemGdwnId == null) {
//                               setState(() {
//                                 GodownSelect = true;
//                               });
//
//                               return;
//                             }
//                             if (ShowAllItem == false) {
//                               setState(() {
//                                 GodownSelect = false;
//                                 ItemsAdd_Widget_Visible =
//                                 !ItemsAdd_Widget_Visible;
//                                 Itemwise_DiscountController.text="";
//                               });
//                             }
//
//                             else {
//                               setState(() {
//                                 Itemwise_DiscountController.text="";
//                                 print("uiopupu");
//                                 SelectedRowDataSAmple = [];
//                                 SelectedRowData = [];
//                                 ShowAllItemPopup(goods);
//                                 ItemsAdd_Widget_Visible =
//                                 !ItemsAdd_Widget_Visible;
//                                 GodownSelect = false;
//
//                               });
//                             }
//                           }, child:Text("ADD ITEMS",style: TextStyle(fontSize: 17),)),
//                     ),
//                   ),
//
//
//                   Visibility(visible:!ItemsAdd_Widget_Visible,
//                     child: Stack(
//                       children: [
//
//                         Positioned(left: 13,
//                             child: Text(" All",style: TextStyle(fontSize: 12),)),
//
//                         Checkbox(
//                           value:ShowAllItem,
//                           onChanged: (bool value) {
//                             setState(() {
//                               ShowAllItem = !ShowAllItem;
//
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox( width: 5,),
//
//                 ],
//               ),
//             ),
//
//
//
// //             Row(
// //               children: [
// //                 SizedBox(width: 10),
// //                 Expanded(
// //                     child: TypeAheadField(
// //                         textFieldConfiguration: TextFieldConfiguration(
// //                             style: TextStyle(),
// //                             controller: paymentController,
// //                             decoration: InputDecoration(
// //                               errorStyle: TextStyle(color: Colors.red),
// //                               errorText: paymentSelect
// //                                   ? "Invalid Payment Selected"
// //                                   : null,
// //                               suffixIcon: IconButton(
// //                                 icon: Icon(Icons.remove_circle),
// //                                 color: Colors.blue,
// //                                 onPressed: () {
// //                                   setState(() {
// //                                     print("cleared");
// //                                     paymentController.text = "";
// //                                     salesPaymentId = 0;
// //                                   });
// //                                 },
// //                               ),
// //
// //                               isDense: true,
// //                               contentPadding:
// //                               EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
// //                               border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(TextBoxCurve)),
// //                               // i need very low size height
// //                               labelText:
// //                               'Payment Condition', // i need to decrease height
// //                             )),
// //                         suggestionsBoxDecoration:
// //                         SuggestionsBoxDecoration(elevation: 90.0),
// //                         suggestionsCallback: (pattern) {
// // //                        print(payment);
// //                           return payment
// // //                            .where((user) => goods.itmName == pattern);
// //                               .where((us) => us.conDescription.contains(pattern));
// //                         },
// //                         itemBuilder: (context, suggestion) {
// //                           return Card(
// //                             color: Colors.blue,
// //                             // shadowColor: Colors.blue,
// //                             child: ListTile(
// //                               tileColor: theam.DropDownClr,
// //                               title: Text(
// //                                 suggestion.conDescription,
// //                                 style: TextStyle(color: Colors.white),
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         onSuggestionSelected: (suggestion) {
// //                           print(suggestion.conDescription);
// //                           print("Item selected");
// //
// //                           paymentController.text = suggestion.conDescription;
// //                           print("close.... $salesPaymentId");
// //                           salesPaymentId = 0;
// //
// //                           print(suggestion.id);
// //                           print(".......sales Item id");
// //                           salesPaymentId = suggestion.id;
// //                           print(salesPaymentId);
// //                           print("...........");
// //                         },
// //                         errorBuilder: (BuildContext context, Object error) =>
// //                             Text('$error',
// //                                 style: TextStyle(
// //                                     color: Theme.of(context).errorColor)),
// //                         transitionBuilder:
// //                             (context, suggestionsBox, animationController) =>
// //                             FadeTransition(
// //                               child: suggestionsBox,
// //                               opacity: CurvedAnimation(
// //                                   parent: animationController,
// //                                   curve: Curves.elasticIn),
// //                             ))),
// // //              SizedBox(height: 10),
// //                 SizedBox(
// //                   width: 10,
// //                 )
// //               ],
// //             ),
//             SizedBox(
//               height: 5,
//             ),
//             SizedBox(height: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       keyboardType:TextInputType.number ,
//                       controller:DiscountController,
//                       cursorColor: Colors.black,
//                       onChanged: (a){
//                         try{
//                           setState(() {
//
//                             var Disamt=double.parse(DiscountController.text);
//                             DiscountAmount=Disamt;
//                             // Parese. DiscountController.text
//                           });
//                         }catch(e){
//                           print("error on DiscountAmount $e");
//                           setState(() {
//                             DiscountAmount=0.0;
//                           });
//                         }
//                       },
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       decoration: InputDecoration(
//
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//                         labelText: "Discount",
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//
//                   Expanded(
//                     child: TextFormField(
//                       enabled: false,
//                       controller:InvNoController,
//                       cursorColor: Colors.black,
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       decoration: InputDecoration(
//                         isDense: false,
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//                         // curve brackets object
// //                    hintText: "Quantity",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//                         labelText: "Inv.No",
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 10,
//                   ),
//
//                 ],
//               ),
//             ),
//
//
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: generalRemarksController,
//                       focusNode: generalFocus,
//                       enabled: true,
//                       validator: (v) {
//                         if (v.isEmpty) return "Required";
//                         return null;
//                       },
// //
// //                  focusNode: field1FocusNode,
//                       cursorColor: Colors.black,
//
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       keyboardType: TextInputType.text,
//
//                       decoration: InputDecoration(
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                         isDense: true,
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//                         // curve brackets object
// //                    hintText: "Quantity",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//
//                         labelText: "General Remarks",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//             SizedBox(
//               height: 10,
//             ),
//             Row(mainAxisAlignment:MainAxisAlignment.center ,
//               children: [
//                 // SizedBox(
//                 //   width: 10,
//                 // ),
//                 Visibility(
//                   visible:Save_Pending==false,
//                   child: GestureDetector(
//                       onTap: () {
//                         print("Save");
//                         //salesSave();
//                         VlidationBeforeSave();
//                       },
//                       child:Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color:Save_Pending==true?Colors.grey:
//                           theam.saveBtn_Clr,
//                         ),
//                         width: 100,
//                         height: 40,
//                         child: Center(
//                           child: Text(
//                             btnname,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//
//                   ),
//                 ),
//
//                 SizedBox(width:MediaQuery.of(context).size.width  *0.44),
//                 GestureDetector(
//                     onTap: () {
//                       print("Reset");
//                       setState(() {
//
//                         // internet_check();
//                         Resetfunction();
//                       });
//                     },
//                     child:Container(alignment: Alignment.centerRight,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.indigo,
//                       ),
//                       width: 100,
//                       height: 40,
//                       child: Center(
//                         child: Text(
//                           "Reset",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     )
//
//                 ),
//                 // Padding(
//                 //   padding: EdgeInsets.only(left: 164.0, right: 0.0),
//                 //   child: RaisedButton(
//                 //     textColor: Colors.white,
//                 //     color: Colors.lightBlueAccent,
//                 //     child: Text("Reset"),
//                 //     onPressed: () {
//                 //       setState(() {
//                 //         customerSelect = false;
//                 //         deliveryDateSelect = false;
//                 //         rateSelect = false;
//                 //         quantitySelect = false;
//                 //         itemSelect = false;
//                 //         paymentSelect = false;
//                 //         customerItemAdd.clear();
//                 //         sales.clear();
//                 //         customerController.text = "";
//                 //         salesdeliveryController.text = "";
//                 //         generalRemarksController.text = "";
//                 //         paymentController.text = "";
//                 //         grandTotal = 0;
//                 //         salesPaymentId = 0;
//                 //         salesItemId = 0;
//                 //         salesLedgerId = 0;
//                 //       });
//                 //     },
//                 //     shape: new RoundedRectangleBorder(
//                 //       borderRadius: new BorderRadius.circular(TextBoxCurve),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//
//             //-----test-------
//             // GestureDetector(child: Text("rtrtzxrtrtrt",style: TextStyle(color: Colors.red),),
//             //   onTap: (){
//             //    // GetdataPrint(352);
//             //     GetGodown();
//             //   },),
//
//
//
//             SizedBox(
//               height: 0,
//               // width: 30,
//             ),
//             Visibility(
//               visible: customerItemAdd.length > 0,
//               child: Row(
//                 //verticalDirection: VerticalDirection.down,
//                 //crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // SizedBox(
//                   //   width: 1,
//                   // ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         columnSpacing: 10,
//                         dataRowHeight: 38,
//                         onSelectAll: (b) {},
//                         sortAscending: true,
//                         showCheckboxColumn: false,
//                         columns: <DataColumn>[
//                           DataColumn(
//                             label: Text('No',textAlign: TextAlign.left,),
//                           ),
//                           DataColumn(
//                             label: Text('Item'),
//                           ),
//                           DataColumn(
//                             label: Text('QTY'),
//                           ),
//                           DataColumn(
//                             label: Text('Rate'),
//                           ),
//                           DataColumn(
//                             label: Text('Disc'),
//                           ),
//                           DataColumn(
//                             label: Text('Tax %'),
//                           ),
//                           DataColumn(
//                             label: Text('Tax Amt'),
//                           ),
//                           DataColumn(
//                             label: Text('Amount'),
//                           ),
//                           DataColumn(
//                             label: Text(''),
//                           ),
//                         ],
//                         rows: customerItemAdd
//                             .map(
//                               (itemRow) => DataRow(
//                             onSelectChanged: (a){
//                               print(itemRow.item);
//
//
//                               showDialog(
//                                   context: context,
//                                   builder: (c) => AlertDialog(
//                                       title: Text("Are you sure to delete? ",textAlign: TextAlign.center,),
//                                       content:Text("${itemRow.item}",textAlign: TextAlign.center,style:TextStyle(color: Colors.teal,fontSize: 25,fontWeight: FontWeight.bold)),
//                                       actions: [
//                                         FlatButton(
//                                           child: Text("No",style: TextStyle(color: Colors.black),),
//                                           onPressed: () {
//                                             setState(() {
//                                               print("No...");
//                                               Navigator.pop(
//                                                   context); // this is proper..it will only pop the dialog which is again a screen
//                                             });
//                                           },
//                                         ),
//                                         FlatButton(
//                                           child: Text("Yes",style: TextStyle(color: Colors.red)),
//                                           onPressed: () {
//                                             setState(() {
//                                               print("Yes");
//                                               removeListElement(itemRow.id,
//                                                   itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
//                                               Navigator.pop(
//                                                   context);
//                                             });
//                                           },
//                                         )
//                                       ]));
//
//                             },
//                             cells: [
//                               DataCell(
//                                 Text(getItemIndex(itemRow).toString()),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Text(itemRow.item.toString()),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,child: Text(itemRow.quantity.toString())),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,child: Text((itemRow.rate??0.0).toString())),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,child: Text(itemRow.Disc_Amt.toString())),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,
//                                   child: Text((itemRow.txper)!=null?itemRow.txper.toString():0.0
//                                       .toString()),
//                                 ),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,
//                                   child: Text((itemRow.txAmt)!=null?itemRow.txAmt.toStringAsFixed(2):0.0
//                                   //((itemRow['amount']!=null))?formatter.format((itemRow['amount'])):"0.0"
//                                       .toString()),
//                                 ),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 Align(alignment: Alignment.centerRight,child: Text(formatter.format(itemRow.NetAmt).toString())),
//                                 showEditIcon: false,
//                                 placeholder: false,
//                               ),
//                               DataCell(
//                                 IconButton(icon: Icon(Icons.delete),
//                                   color: Colors.red,
//                                   onPressed: () {
//                                     setState(() {
//                                       removeListElement(itemRow.id,
//                                           itemRow.slNo, itemRow.NetAmt,itemRow.txAmt);
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                             .toList(),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   width: 40,
//                   // )
//                 ],
//               ),
//             ),
//
//
//             Visibility(
//                 visible:grandTotal > 0,
//                 child: Divider(color: Colors.black,)),
//             Visibility(
//                 visible: grandTotal > 0,
//                 child: Row(mainAxisAlignment:MainAxisAlignment.end,
//                   children: [
//                     Column(children: [
//                       Text('Total Amt : ',
//                           style: TextStyle(fontSize: 20,color: Colors.black,)),
//
//                       Text('Discount : ',
//                           style: TextStyle(fontSize: 20,color: Colors.black,)),
//
//                       Text('Total ${TaxTypeGst==true?"GST":"VAT"}  : ',
//                           style: TextStyle(fontSize: 20,color: Colors.black,)),
//                       Text('Net Amt   : ',
//                           style: TextStyle(fontSize: 20,color: Colors.black,)),
//
//                     ],),
//
//                     Column(crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(Net_Amt_Befor_Tax.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
//                         Text(DiscountAmount.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
//                         Text(Net_VAt.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
//                         Text(formatter.format(grandTotal-DiscountAmount),
//                             style: TextStyle(fontSize: 20,color: Colors.black,),textAlign: TextAlign.right),
//
//                       ],),
//                     SizedBox(width: MediaQuery.of(context).size.width/4,)
//                   ],)
// //         Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   SizedBox(
// //                     width: 90,
// //                   ),
// //                   Expanded(
// //                     child: TextField(
// //                       readOnly: true,
// //                       controller: controller,
// //                       style: TextStyle(
// //                           color: Colors.lightBlue,
// // //                      fontFamily: Font.AvenirLTProMedium.value,
// //                           fontSize: 17),
// //                       decoration: InputDecoration(
// //                         border: InputBorder.none,
// //                         // hintText: 'Total Amount : $grandTotal',
// //                         hintText: 'Total Amt : '+formatter.format(grandTotal),
// //                         hintStyle:  TextStyle(
// //                           fontSize: 20,
// //                           color: Colors.black,
// //                           backgroundColor: Colors.white10,
// // //                          fontFamily: Font.AvenirLTProBook.value)
// //                         )
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
//             ),
//             //
//             // IconButton(icon: Icon(Icons.ac_unit), onPressed: () async {
//             //
//             //
//             //
//             //
//             //   Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (context) =>
//             //               GST_Print_Format(Parm_Id: 17, title:"title",  Details_Data: "")
//             //               ));
//             //
//             //
//             //    }),
//
//             WillPopScope(
//
//               onWillPop: _onBackPressed,
//               child: Text(""),
//             ),
//             // SizedBox(height:500),
//             //  SizedBox(height: MediaQuery.of(context).viewInsets.top),
//             // SizedBox(height:  MediaQuery.of(context).size.width*1),
//
//           ],
//         ),
//
//
//         // resizeToAvoidBottomInset: false,
//
//
//         bottomSheet: Visibility(
//           visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
//           child: Container(color: Colors.white.withOpacity(0.9),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15,bottom: 15),
//               child: FloatingActionButton(
//
//                   backgroundColor: Colors.blue,
//                   hoverColor: Colors.red,  elevation: 5,
//
//                   child: Icon(Icons.home_filled),
//                   onPressed: (){
//                     Navigator.pushAndRemoveUntil(context,
//                         MaterialPageRoute(builder:(context) =>
//                             SalesManHome()), (route) => false);
//                     customerItemAdd=[];
//                   }),
//
//             ),
//           ),
//         ),
//         floatingActionButton:Visibility(
//           visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
//           child: SpeedDial(
//               animatedIcon:AnimatedIcons.menu_arrow,
//               overlayColor: Colors.blue,
//               children: [
//                 SpeedDialChild(
//                     child: Icon(Icons.add_business),
//                     backgroundColor: Colors.blue,
//                     label: "Purchase",
//                     onTap:(){
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>Purchase(
//                                 passvalue: null,
//                                 passname: null.toString(),
//                               )));
//                     } ),
//                 SpeedDialChild(
//                     child: Icon(Icons.description_outlined),
//                     backgroundColor: Colors.blue,
//                     label: "Sales Index",
//                     onTap:(){
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>salesindex()));
//                     } ),
//                 SpeedDialChild(
//                     child: Icon(Icons.description_outlined),
//                     backgroundColor: Colors.blue,
//                     label: "Purchase Index",
//                     onTap:(){
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>Purchase_Index()));
//                     } ),
//                 SpeedDialChild(
//                     child: Icon(Icons.request_quote_outlined),
//                     backgroundColor: Colors.blue,
//                     label: "Ledger Balance",
//                     onTap:(){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Newtestpage(passvalue:slsname.toString(),Shid:salesLedgerId)),  );
//                     } ),
//                 SpeedDialChild(
//                     child: Icon(Icons.remove_red_eye_outlined),
//                     backgroundColor: Colors.blue,
//                     label: "Shop Visited",
//                     onTap:(){
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => shopvisited(passvalue:salesLedgerId,passname:slsname.toString(),)));
//                     } ),
//               ]),
//         ),
//
//       ),
//     );
//   }
//   ///----------------------------------ItemsAdd part ----------------------------------------
//
//   Visibility AddItemWidgets(BuildContext context,bool visibility) {
//     return Visibility( visible: visibility,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10,right: 10,top: 3),
//         child: Container(decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),color: Colors.blueGrey.shade50),
//           child: Column(children: [
//             SizedBox(
//               height: 6,
//             ),
//             SizedBox(height: itemSelect==true?60: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(width: 10),
//
//                   // Text("IGST",style: TextStyle(fontSize: 12),),
//                   //
//                   // Checkbox(
//                   //   value: this.GSTtyp,
//                   //   onChanged: (bool value) {
//                   //     setState(() {
//                   //       this.GSTtyp = value;
//                   //
//                   //       print("GSTtyp $value");
//                   //     });
//                   //   },
//                   // ), //Checkbox
//
//                   Expanded(
//                       child: TypeAheadField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                               style: TextStyle(),
//                               controller: goodsController,
//                               decoration: InputDecoration(
//                                 errorStyle: TextStyle(color: Colors.red),
//                                 errorText: itemSelect
//                                     ? "Please Select product Item ?"
//                                     : null,
// //                            errorText: _validateName ? "please enter name" : null,
// //                            errorBorder:InputBorder.none ,
//                                 suffixIcon: IconButton(
//                                   icon: Icon(Icons.remove_circle),
//                                   color: Colors.blue,
//                                   onPressed: () {
//                                     setState(() {
//                                       print("cleared");
//                                       goodsController.text = "";
//                                       salesItemId = null;
//                                       openingAmountBalance = 0;
//                                       rateController.text="";
//                                     });
//                                   },
//                                 ),
//
//
//                                 prefixIcon:  IconButton(icon: Icon(Icons.qr_code,color: Colors.black,), onPressed: (){
//
//                                   qr_Barcode_Readfunction();
//                                 }),
//
//                                 isDense: true,
//                                 contentPadding:
//                                 EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(TextBoxCurve)),
//                                 // i need very low size height
//                                 labelText:
//                                 'Item search', // i need to decrease height
//                               )),
//                           suggestionsBoxDecoration:
//                           SuggestionsBoxDecoration(elevation: 90.0),
//                           suggestionsCallback: (pattern) {
//                             if(internet_Connection==true) {
//                               return goods.where((user) =>
//                                   user.itmName.trim().toLowerCase().contains(
//                                       pattern.trim().toLowerCase()));
//                             }
//                             else{
//                               return offline_itemMaster.where((user) =>
//                                   user.itmName.trim().toLowerCase().contains(
//                                       pattern.trim().toLowerCase()));
//                             }
//
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return Card(
//                               color: Colors.blue,
//                               // shadowColor: Colors.blue,
//                               child: ListTile(
//                                 tileColor: theam.DropDownClr,
//                                 title: Text(
//                                   suggestion.itmName,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             print(suggestion.itmName);
//                             print("item selected");
//                             setState(() {
//                               getbatch(suggestion.id);
//                               var j={
//                                 "id":suggestion.id,
//                                 "itemId":suggestion.id,
//                                 "expiryDate":null,
//                                 "srate":suggestion.itmSalesRate,
//                                 "batchNo":null,
//                                 "nos":null,
//                                 "barcode":suggestion.itmBarCode,
//                                 "godownId":itemGdwnId
//                               };
//                               // multibatchitembinding(j);
//                             });
//
//
//                             print(salesItemId);
//                             print("...........");
//
//                             //  print(".........$cessper..");
//                           },
//                           errorBuilder: (BuildContext context, Object error) =>
//                               Text('$error',
//                                   style: TextStyle(
//                                       color: Theme.of(context).errorColor)),
//                           transitionBuilder:
//                               (context, suggestionsBox, animationController) =>
//                               FadeTransition(
//                                 child: suggestionsBox,
//                                 opacity: CurvedAnimation(
//                                     parent: animationController,
//                                     curve: Curves.elasticIn),
//                               ))),
//                   SizedBox(
//                     width: 10,
//                     height: 5,
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             SizedBox(height:quantitySelect==true?60: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: quantityController,
//                       onEditingComplete: (){
//                         qtyFocus.unfocus();
//                         FocusScope.of(context).requestFocus(rateFocus);
//                       },
//                       focusNode: qtyFocus,
//                       enabled: true,
//                       validator: (v) {
//                         if (v.isEmpty) return "Required";
//                         return null;
//                       },
// //
//                       // will disable paste operation
// //                  focusNode: field1FocusNode,
//                       cursorColor: Colors.black,
//
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
//                       ],
//                       decoration: InputDecoration(
//                         errorStyle: TextStyle(color: Colors.red),
//                         errorText: quantitySelect ? "Invalid Qty" : null,
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                         isDense: true,
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//
//                         // curve brackets object
// //                    hintText: "Quantity",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//
//                         labelText: "Quantity",
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
// //----------------unit-------------------
//                   Expanded(
//                       child: TypeAheadField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                             controller:UnitController ,
//                             style: TextStyle(),
//                             decoration: InputDecoration(
//                               errorStyle: TextStyle(color: Colors.red),
//                               errorText: unitSelect
//                                   ? "Invalid Unit Selected"
//                                   : null,
//                               suffixIcon: IconButton(
//                                 icon: Icon(Icons.remove_circle),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   setState(() {
//                                     print("cleared");
//                                     UnitController.text = "";
//                                     //  salesPaymentId = 0;
//                                   });
//                                 },
//                               ),
//                               isDense: true,
//                               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(TextBoxCurve)),
//
//                               hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//                               labelText: "Unit",
//                             ),
//                           ),
//
//                           suggestionsBoxDecoration:
//                           SuggestionsBoxDecoration(elevation: 90.0),
//                           suggestionsCallback: (pattern) {
//                             print("internet_Connection");
//                             print(internet_Connection);
//                             print(unit.length.toString());
//                             print(offline_unit.length.toString());
//
//                             if(internet_Connection==true)
//                               return unit.where((unt) => unt.description.contains(pattern));
//                             return offline_unit.where((unt) => unt.description.contains(pattern));
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return Card(
//                               color: Colors.blue,
//                               child: ListTile(
//                                 tileColor: theam.DropDownClr,
//                                 title: Text(
//                                   suggestion.description,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             print(suggestion.description);
//                             print("Unit selected");
//
//                             UnitController.text = suggestion.description;
//                             print("close.... $unitId");
//                             unitId = null;
//
//                             print(suggestion.id);
//                             print(".......Unit id");
//                             unitId = suggestion.id;
//                             print(unitId);
//                             print("...........");
//                           },
//                           errorBuilder: (BuildContext context, Object error) =>
//                               Text('$error',
//                                   style: TextStyle(
//                                       color: Theme.of(context).errorColor)),
//                           transitionBuilder:
//                               (context, suggestionsBox, animationController) =>
//                               FadeTransition(
//                                 child: suggestionsBox,
//                                 opacity: CurvedAnimation(
//                                     parent: animationController,
//                                     curve: Curves.elasticIn),
//                               ))),
//                   SizedBox(
//                     width: 10,
//                   ),
//
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             SizedBox(height:quantitySelect==true?60: TextBoxHeight,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 10,
//                   ),
//
//                   Expanded(
//                     child: TextFormField(
//                       keyboardType:TextInputType.number ,
//                       controller:Itemwise_DiscountController,
//                       cursorColor: Colors.black,
//                       onChanged: (a){
//                         try{
//                           setState(() {
//
//                             var Disamt=double.parse(Itemwise_DiscountController.text);
//                             ItemWiseDiscountAmount=Disamt;
//
//                           });
//                         }catch(e){
//                           print("error on ItemWiseDiscountAmount $e");
//                           setState(() {
//                             ItemWiseDiscountAmount=0.0;
//                           });
//                         }
//                       },
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       decoration: InputDecoration(
//
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//                         labelText: "Discount",
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 4),
//
//
//                   Expanded(
//                     child: TextFormField(
//                       controller: rateController,
//                       focusNode: rateFocus,
//                       onEditingComplete: (){
//                         rateFocus.unfocus();
//                         FocusScope.of(context).requestFocus(generalFocus);
//                       },
//                       enabled: true,
//                       validator: (v) {
//                         if (v.isEmpty) return "Required";
//                         return null;
//                       },
// //
//                       cursorColor: Colors.black,
//
//                       scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                       keyboardType: TextInputType.number,
//
//                       inputFormatters: <TextInputFormatter>[
//                         WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}")),
//                       ],
//                       decoration: InputDecoration(
//
// //                    suffixIcon: Icon(
// //                      Icons.calendar_today,
// //                      color: Colors.blue,
// //                      size: 24,
// //                    ),
//                         errorStyle: TextStyle(color: Colors.red),
//                         errorText: rateSelect ? "Invalid Rate" : null,
//                         isDense: true,
//                         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 18.0),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(TextBoxCurve)),
//                         // curve brackets object
// //                    hintText: "Quantity",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//
//                         labelText: "Rate",
//                       ),
//                     ),
//                   ),
//                   // SizedBox(width: 4),
// //                   SizedBox.fromSize(
// //                     size: Size(45, 45), // button width and height
// //                     child: ClipOval(
// //                       child: Material(
// //                         color: Colors.lightBlueAccent, // button color
// //                         child: InkWell(
// //                           splashColor: Colors.green, // splash color
// //                           onTap: addCustomerItem,
// // //                      onPressed: ,
// //                           // button pressed
// //                           child: Icon(
// //                             Icons.add,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//
//
//             Row(
//
//               children: [
//
//                 SizedBox(
//                   width: 15,
//                 ),
//
//                 Text("IGST",style: TextStyle(fontSize: 12),),
//
//                 Checkbox(
//                   value: this.GSTtyp,
//                   onChanged: (bool value) {
//                     setState(() {
//                       this.GSTtyp = value;
//
//                       print("GSTtyp $value");
//                     });
//                   },
//                 ), //Ch
//
//
//                 Expanded(
//                   child: InkWell(
//                     onTap:addCustomerItem,
//                     child: Container(child: Center(child: Text("Add To Cart",style:
//                     TextStyle(color: Colors.black,fontSize: 25),)),color: Colors.green,
//                       height: 40,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 15,),
//
// //                 SizedBox.fromSize(
// //                   size: Size(45, 45), // button width and height
// //                   child: ClipOval(
// //                     child: Material(
// //                       color: Colors.lightBlueAccent, // button color
// //                       child: InkWell(
// //                         splashColor: Colors.green, // splash color
// //                         onTap: addCustomerItem,
// // //                      onPressed: ,
// //                         // button pressed
// //                         child: Icon(
// //                           Icons.add,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
//               ],
//             ),
//
//           ],),
//         ),
//       ),
//     );
//   }
//
//   ///------------------------------------------------------------------------
//
//
//
//
//   Future<Null> refreshList() async {
//
//     await Future.delayed(Duration(seconds: 1));
//
//     setState(() {
//
//     });
//
//     return null;
//   }
//
//   databinding(id) async{
//     print("databinding sales : $id");
//     double amount =0.0;
//     try {
//       final bindata =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: { //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       //  log("databinding sales edit"+bindata.body.toString());
//       print("databinding sales edit ${bindata.statusCode.toString()}");
//       print(bindata.statusCode);
//
//       var tagsJson = jsonDecode(bindata.body);
//
//
//
//
//       SalesEditDatas=tagsJson;
//
//       // print("databinding decoded  "+(tagsJson["salesHeader"][0]["voucherDate"]).toString());
//       paymentTypeController.text=tagsJson["salesHeader"][0]["paymentType"]=="0"?"Cash":"Credit";
//       (tagsJson["salesHeader"][0]["narration"] == null)? generalRemarksController.text="":generalRemarksController.text=tagsJson["salesHeader"][0]["narration"];
//       var bindDt="-:-:-";
//       print(tagsJson["salesHeader"][0]["voucherDate"]);
//       var vchDate =tagsJson["salesHeader"][0]["voucherDate"];
//       if(vchDate!=null)
//       {
//
//         var prsDt = DateTime.tryParse(
//             tagsJson["salesHeader"][0]["voucherDate"]);
//         bindDt = DateFormat("d-MM-yyyy").format(prsDt);
//       }
//
//
//       setState(() {
//         paymentType_Id=tagsJson["salesHeader"][0]["paymentType"];
//         paymentTypeController.text=tagsJson["salesHeader"][0]["paymentType"].toString()=="0"?
//         "Cash":"Credit";
//       });
//       salesdeliveryController.text=bindDt;
//       deliveryDate=bindDt;
//       Vouchnum=tagsJson["salesHeader"][0]["voucherNo"];
//       List <dynamic> binditm =tagsJson["salesDetails"]as List;
//       print("binditm");
//       print(binditm);
//       for(int i=0;i<binditm.length;i++)
//       {
//         Net_VAt=Net_VAt+(binditm[i]["taxAmount"]);
//         Net_Amt_Befor_Tax=Net_Amt_Befor_Tax+binditm[i]["amountBeforeTax"];
//         print(binditm[i]["itmName"]);
//         customer = CustomerAdd(
//           id: binditm[i]["itemId"],
//           slNo: customerItemAdd.length + 1,
//           item: binditm[i]["itmName"],
//           quantity:binditm[i]["qty"],
//           rate: binditm[i]["rate"],
//           txper: binditm[i]["taxPercentage"],
//           amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
//           StkId:binditm[i]["stockId"],
//           NetAmt: (binditm[i]["amountIncludingTax"]),
//           txAmt:binditm[i]["taxAmount"],
//           Disc_Amt:binditm[i]["discountAmount"],
//
//           //  txAmt:(binditm[i]["rate"]/100)*(binditm[i]["taxPercentage"]??0.0)
//           //txAmt: (binditm[i]["amountIncludingTax"]-(binditm[i]["rate"])*(binditm[i]["qty"]))
//         );
//
//         setState(() {
//           ++slnum;
//
//           //  grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]); // with out tax
//           // grandTotal=grandTotal+(binditm[i]["amountIncludingTax"]); // with  tax
//           //  grandTotal=Net_VAt+Net_Amt_Befor_Tax;
//           grandTotal=tagsJson["salesHeader"][0]["balanceAmount"];
//           slse = Salesedit(
//               ItemSlNo :slnum,
//               shid:widget.passvalue,
//               itemId: binditm[i]["itemId"],
//               qty: binditm[i]["qty"],
//               rate:binditm[i]["rate"],
//               disPercentage: binditm[i]["disPercentage"]== null?0:binditm[i]["disPercentage"],
//               cgstPercentage:binditm[i]["cgstPercentage"]== null?0:binditm[i]["cgstPercentage"],
//               sgstPercentage: binditm[i]["sgstPercentage"],
//               cessPercentage: binditm[i]["cessPercentage"],
//               discountAmount: binditm[i]["discountAmount"],
//               cgstAmount: binditm[i]["cgstAmount"],
//               sgstAmount: binditm[i]["sgstAmount"],
//               cessAmount: binditm[i]["cessAmount"],
//               igstPercentage: binditm[i]["igstPercentage"],
//               igstAmount: binditm[i]["igstAmount"],
//               taxPercentage: binditm[i]["taxPercentage"],
//               // taxPercentage:itmtxper == null?0:itmtxper,
//               taxAmount:binditm[i]["taxAmount"],
//               //  taxAmount: ((binditm[i]["rate"]/100)*(binditm[i]["taxPercentage"]))*(binditm[i]["qty"]),
//               taxInclusive :false,
//               amountBeforeTax: binditm[i]["amountBeforeTax"],
//               // amountBeforeTax: ( binditm[i]["rate"])* (binditm[i]["qty"]),
//               amountIncludingTax: binditm[i]["amountIncludingTax"],
//               //( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["taxPercentage"]),
//               netTotal:binditm[i]["amountIncludingTax"],
//               gdnId:binditm[i]["gdnId"],
//               taxId:binditm[i]["taxId"],
//               rackId:binditm[i]["rackId"],
//               addTaxId: binditm[i]["taxId"],
//               unitId: binditm[i]["unitId"],
//               nosInUnit: binditm[i]["nosInUnit"],
//               barcode: binditm[i]["barcode"],
//               StockId: binditm[i]["stockId"],
//               BatchNo: binditm[i]["batchNo"],
//               ExpiryDate: binditm[i]["expiryDate"],
//               Notes:binditm[i]["Notes"],
//               hsncode:binditm[i]["hsncode"],
//               adlDiscAmount:binditm[i]["adlDiscAmount"],
//               adlDiscPercent:binditm[i]["adlDiscPercent"]
//           );
//           // print("fff"+slse.rate.toString());
//           // print(slse);
//           var parampars = json.encode(slse);
//           salesedt.add(slse);
//         });
//         // print("gggggg"+ binditm[i]["rate"].toString());
//         setState(() {
//           // print("gggggg"+json.encode(slse));
//           customerItemAdd.add(customer);
//           //  grandTotal= grandTotal+ binditm[i]["rate"];
//         });
//       }
//
//     }catch(e){ print("databinding1 error $e");}
//   }
//
//
//
//
//   //for binde data from Soh -------------------------sohdata--------------------------------------------
//
//
// //---data binding old for salesorder-----
//
//   databindingSoh(id) async{
//     print("databinding : $id");
//     double amount =0.0;
//     var igst=0.00;
//     var aftertax;
//     try {
//       final bindata =
//       await http.get("${Env.baseUrl}Soheader/$id/3", headers: {
//         "Authorization": user.user["token"],
//       });
//       print("databinding  "+bindata.body);
//       print(bindata.statusCode);
//       var tagsJson = json.decode(bindata.body);
//
//
//       print("databinding decoded  "+tagsJson["data"]["voucherDate"]);
//
//       generalRemarksController.text=tagsJson["data"]["narration"];
//
//       var prsDt= DateTime.tryParse(tagsJson["data"]["voucherDate"]);
//       var bindDt= DateFormat("d-MM-yyyy").format(prsDt);
//       salesdeliveryController.text=bindDt;
//       deliveryDate=bindDt;
//       List <dynamic> binditm =tagsJson["data"]["sodetailed"]as List;
//       for(int i=0;i<binditm.length;i++)
//       {
//         print("Soh detail data");
//         print(binditm[i]["itemName"]);
//         print(binditm.length);
//         print(binditm[i]["rate"]);
//         /// tax calc...........
//         var rate=(binditm[i]["rate"]);
//         amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
//         //  double cgst=double.parse(((rate/100)*(binditm[i]["txCgstPercentage"])).toStringAsFixed(2));
//         //  double sgst=double.parse(((rate/100)*(binditm[i]["txSgstPercentage"])).toStringAsFixed(2));
//         dynamic Igst=double.parse(((rate/100)*(binditm[i]["txIgstpercentage"])).toStringAsFixed(2));
//         //  amount=((binditm[i]["rate"]))*((binditm[i]["qty"]));
//         //  print("amount  $amount");
//         //
//         //  var totligst=igst*(binditm[i]["qty"]);
//         //  var totlcgst=cgst*(binditm[i]["qty"]);
//         //  var totlsgst=sgst*(binditm[i]["qty"]);
//         //  var taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
//         //  var  ToatalTax=taxOneItm*(binditm[i]["qty"]);
//         //  print("grandTotal before $grandTotal");
//         //  grandTotal = grandTotal + ToatalTax + amount + totlcgst +totlsgst +totligst;
//         // var aftertax=ToatalTax + amount + totlcgst +totlsgst +totligst;
//         //  print("grandTotal after $grandTotal");
//
//         var taxOneItm =((rate/100)*(itmtxper));
//         var taxAmtOfCgst;
//         var taxAmtOfSgst;
//         var  ToatalTax;
//         dynamic  befortax=0;
//
//         if(binditm[i]["itmTaxInclusive"]==true){
//
//           var WithOutTaxamt=(((binditm[i]["txPercentage"])+100)/100);
//           print("WithOutTaxamt in inclusive of edit bind");
//           print(WithOutTaxamt.toString());
//           taxOneItm=rate/WithOutTaxamt;
//           taxAmtOfCgst=(WithOutTaxamt/2);
//           taxAmtOfSgst=(WithOutTaxamt/2);
//           // ToatalTax =taxOneItm*double.parse(quantityController.text);
//           grandTotal = grandTotal + amount;
//           aftertax= amount;
//           befortax=taxOneItm*(binditm[i]["qty"]);
//         }
//         else {
//
//           taxOneItm =((rate/100)*(binditm[i]["txPercentage"]));
//           taxAmtOfCgst=(taxOneItm/2);
//           taxAmtOfSgst=(taxOneItm/2);
//           ToatalTax =taxOneItm*(binditm[i]["qty"]);
//           grandTotal = grandTotal + ToatalTax + amount;
//           aftertax=ToatalTax + amount;
//           befortax=amount;
//
//         }
//
//
//         if(GSTtyp==true){
//           igst= Igst*double.parse(quantityController.text);
//           taxAmtOfCgst=0;
//           taxAmtOfSgst=0;
//         }
//
//
//         if(TaxTypeGst==false){
//
//           igst=0.0;
//           taxAmtOfCgst=0.0;
//           taxAmtOfSgst=0.0;
//
//         }
//
//         /// tax calc...........
//
//
//
//         customer = CustomerAdd(
//           id: binditm[i]["itemId"],
//           slNo: customerItemAdd.length + 1,
//           item: binditm[i]["itemName"],
//           quantity:binditm[i]["qty"],
//           rate: binditm[i]["rate"],
//           txper: binditm[i]["txPercentage"],
//           // cess:cessper,
//           amount: (binditm[i]["rate"])* (binditm[i]["qty"]),
//           StkId:binditm[i]["stockId"],
//           NetAmt: aftertax,
//           txAmt: aftertax-befortax,
//           Disc_Amt: binditm[i]["discountAmount"],
//         );
//
//         setState(() {
//           ++slnum;
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);
//
//           sale = Saless(
//             ItemSlNo :slnum,
//             shid:widget.passvalue,
//             itmName: binditm[i]["itemName"],
//             itemId: binditm[i]["itemId"],
//             qty: binditm[i]["qty"],
//             rate:binditm[i]["rate"],
//             disPercentage: 0,
//             cgstPercentage: (binditm[i]["txCgstPercentage"]),
//             sgstPercentage: (binditm[i]["txSgstPercentage"]),
//             cessPercentage: 0,
//             discountAmount:  0,
//             cgstAmount:  taxAmtOfCgst,
//             sgstAmount: taxAmtOfSgst,
//             cessAmount: 0,
//             igstPercentage:(binditm[i]["txIgstpercentage"]),
//             igstAmount:  igst,
//             taxPercentage:binditm[i]["taxPercentage"],
//             // taxPercentage:itmtxper == null?0:itmtxper,
//             taxAmount: ((binditm[i]["rate"]/100)*(binditm[i]["txPercentage"]))*(binditm[i]["qty"]),
//             taxInclusive :false,
//             amountBeforeTax:befortax, //( binditm[i]["rate"])* (binditm[i]["qty"]),
//             amountIncludingTax:aftertax,//( binditm[i]["rate"])* (binditm[i]["qty"])+ ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]),
//             netTotal:aftertax,
//             gdnId:binditm[i]["gdnId"],//1
//             taxId:binditm[i]["itmTaxId"],
//             rackId: null,
//             addTaxId: binditm[i]["itmTaxId"],
//             unitId: binditm[i]["unitId"],
//             nosInUnit: 6,
//             barcode:  null,
//             StockId: binditm[i]["stockId"],
//             BatchNo:null,// binditm[i]["batchNo"],
//             ExpiryDate:null,// binditm[i]["expiryDate"],
//             Notes:null,
//             hsncode:null,
//             DiscountAmount:binditm[i]["DiscountAmount"],
//             // adlDiscAmount:0,
//             // adlDiscPercent:0
//           );
//
//
//           print("1111111");
//           // print("Sohdata"+sale.rate.toString());
//           print(sale);
//           var parampars = json.encode(sale);
//           print("databindingSoh sales parampars : $parampars");
//           sales.add(sale);
//         });
//         print("Soh dara rate"+ binditm[i]["rate"].toString());
//         setState(() {
//           customerItemAdd.add(customer);
// //
// //        // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]);
//           // grandTotal=grandTotal+( binditm[i]["rate"])* (binditm[i]["qty"]) + ((binditm[i]["rate"]/100)*binditm[i]["txPercentage"]);
//
//
//         });
//       }
//     }catch(e){ print("databinding1 Soh1 error $e");}
//   }
//
//
//
// //----------------------------------------------------------
// //--------------------Print part-------------------------------------------
//
//   GetdataPrint(id) async {
//     print("sales for print : $id");
//     double amount = 0.0;
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesHeaders/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       dataForTicket = await jsonDecode(tagsJson.body);
//       // print("sales for print");
//       print(dataForTicket);
//
//       Timer(Duration(milliseconds: 1), () async{
//         // await wifiprinting();
//         blutoothprinting();
//         // _ticket(PaperSize.mm58);
//       });
//
//     } catch (e) {
//       print('error on databinding $e');
//     }
//   }
//
//
//
//   footerdata() async {
//     try {
//       print("footer data decoded  ");
//       final tagsJson =
//       await http.get("${Env.baseUrl}SalesInvoiceFooters/", headers: {
//         "Authorization": user.user["token"],
//       });
//
//       setState(() {
//         footerCaptions = jsonDecode(tagsJson.body);
//         print( "on footerCaptions :" +footerCaptions.toString());
//         // wifiprinting();
//       });
//
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   GetCompantPro(id)async{
//     print("GetCompantPro");
//     print(id.toString());
//     try {
//       final tagsJson =
//       await http.get("${Env.baseUrl}MCompanyProfiles/$id", headers: {
//         //Soheader //SalesHeaders
//         "Authorization": user.user["token"],
//       });
//       if(tagsJson.statusCode==200) {
//         Companydata = jsonDecode(tagsJson.body);
//       }
//       // print( "on GetCompantPro :" +Companydata.toString());
//     }
//     catch(e){
//       print("error on GetCompantPro : $e");
//     }
//   }
// //----------printing ticket generate--------------------------
//
//   Future<Ticket> _ticket(PaperSize paper) async {
//     // final ticket = Ticket(paper);
//     print('in');
//     final ticket = Ticket(paper);
//
//     List<dynamic> slsDet = dataForTicket["salesDetails"] as List;
//     dynamic VchNo = (dataForTicket["salesHeader"][0]["voucherNo"]) == null
//         ? "00"
//         : (dataForTicket["salesHeader"][0]["voucherNo"]).toString();
// // dynamic date=(dataForTicket["salesHeader"][0]["voucherDate"])==null?"-:-:-": DateFormat("yyyy-MM-dd hh:mm:ss").format((dataForTicket["salesHeader"][0]["voucherDate"]));
//     dynamic date = (DateFormat("dd/MM/yyy hh:mm:ss a").format(DateTime.now()).toString());
//     dynamic partyName=(dataForTicket["salesHeader"][0]["partyName"]) == null ||
//         (dataForTicket["salesHeader"][0]["partyName"])== ""
//         ? ""
//         : (dataForTicket["salesHeader"][0]["partyName"]).toString();
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:branchName.toString(),
//           width: 10,
//           styles: PosStyles(bold: true,
//             align: PosAlign.center,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:(Companydata["companyProfileAddress1"]).toString(),
//           width: 10,
//           styles:PosStyles(bold: false,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,)),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text: (Companydata["companyProfileAddress2"]).toString(),
//           width: 10,
//           styles:PosStyles(bold: false,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:  (Companydata["companyProfileAddress3"]).toString(),
//           width: 10,
//           styles:PosStyles(bold: false,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:(Companydata["companyProfileMobile"]).toString(),
//           width: 10,
//           styles:PosStyles(bold: false,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//
//     ticket.row([
//       PosColumn(text: ' ', width: 1),
//       PosColumn(
//           text:  (Companydata["companyProfileEmail"]).toString(),
//           width: 10,
//           styles:PosStyles(bold: false,underline: true,
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//           )),
//       PosColumn(text: ' ', width: 1)
//     ]);
//
//
//
//
//
//     ticket.text('GSTIN: ' +
//         ( Companydata["companyProfileGstNo"]).toString()+' ',
//         styles: PosStyles(bold: false,
//           align: PosAlign.center,
//           height: PosTextSize.size1,
//           width: PosTextSize.size1,
//         ));
//
//
//     ticket.text('Inv.NO : ' + VchNo.toString(),
//         styles: PosStyles(bold: true, width: PosTextSize.size1));
//     //ticket.emptyLines(1);
//     ticket.text('Date : $date');
//
//     //---------------------------------------------------------
//     if(partyName !="")
//     {
//       //ticket.emptyLines(1);
//       ticket.text('Name : $partyName');
//     }
//     if((dataForTicket["salesHeader"][0]["gstNo"]) !=null)
//     {
//       // ticket.emptyLines(1);
//       ticket.text('GST No :' +((dataForTicket["salesHeader"][0]["gstNo"])));
//     }
//     //---------------------------------------------------------
//
//     ticket.hr(ch: '_');
//     ticket.row([
//       PosColumn(
//         text:'No',
//         styles: PosStyles(align: PosAlign.left),
//         width:1,
//       ),
//       PosColumn(
//         text:'Item',
//         styles: PosStyles(bold: true,align: PosAlign.center),
//         width: 2,
//       ),
//       PosColumn(text: 'Qt', width: 1,styles: PosStyles(align: PosAlign.right ),),
//       PosColumn(text: 'Rate', width: 3,styles:PosStyles(align: PosAlign.center)),
//       PosColumn(text: 'Tax', width: 2,styles: PosStyles(align: PosAlign.center ),),
//       PosColumn(text: ' Amonunt', width: 3,styles: PosStyles(align: PosAlign.center ),),
//     ]);
//     ticket
//         .hr(); // for dot line or set ticket.hr(ch: 'charecter', linesAfter: 1);
//     var snlnum=0;
//     dynamic total = 0.000;
//     for (var i = 0; i < slsDet.length; i++) {
//       total = slsDet[i]["amountIncludingTax"] + total;
//       // ticket.emptyLines(1);
//       snlnum=snlnum+1;
//       ticket.row([
//         PosColumn(text: (snlnum.toString()),width: 1,styles: PosStyles(
//             align: PosAlign.left
//         )),
//
//         PosColumn(text: (slsDet[i]["itmName"]),
//             width: 11,styles:
//             PosStyles(align: PosAlign.left )),] );
//
//       // for space
//       ticket.row([
//         PosColumn(
//           text: (''),
//           width: 1,
//         ),
//         PosColumn(
//             text: (' '+((slsDet[i]["qty"])).toStringAsFixed(0)).toString(),styles:PosStyles(align: PosAlign.right ),
//             width: 2),
//         PosColumn(
//             text: (((slsDet[i]["rate"])).toStringAsFixed(2)).toString(),
//             width: 3,
//             styles: PosStyles(
//                 align: PosAlign.right
//             )),
//
//         PosColumn(
//             text: (' ' + ((slsDet[i]["taxPercentage"])).toStringAsFixed(2))
//                 .toString(),styles:PosStyles(align: PosAlign.right ),
//             width: 2),
//         PosColumn(
//             text: ((slsDet[i] ["amountIncludingTax"])).toStringAsFixed(2)
//             ,styles:PosStyles(align:PosAlign.right ),
//             width:4),
//       ]);
//     }
//
//
//     ticket.hr(ch:"=",len: 32);
//     ticket.row([
//       PosColumn(
//           text: 'Total',
//           width: 4,
//           styles: PosStyles(
//             bold: true,align:PosAlign.left,
//           )),
//       PosColumn(
//           text:'Rs '+(total.toStringAsFixed(2)).toString(),
//           width: 8,
//           styles: PosStyles(bold: true,align: PosAlign.right,)),
//     ]);
//     ticket.hr(
//         ch: '_',len: 32 );
//
//     // ticket.row([
//     //   PosColumn(text: ' ', width: 1),
//     //   PosColumn(
//     //       text: footerCaptions[0]['footerCaption'],
//     //       width: 10,
//     //       styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: ' ', width: 1)
//     // ]);
//     //
//     // ticket.row([
//     //   PosColumn(text: '  ', width: 1),
//     //   PosColumn(
//     //       text: footerCaptions[0]['footerText'],
//     //       width: 10,
//     //       styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: '  ', width: 1)
//     // ]);
//
//     ticket.feed(1);
//     ticket.text('Thank You...Visit again !!',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//
//     ticket.cut();
//     return ticket;
//   }
// // //..................................................
// //
// //   wifiprinting() async {
// //     try {
// //       print(" print in");
// //      _printerManager.selectPrinter('192.168.0.100');
// //      //_printerManager.selectPrinter(null);
// //       final res =
// //       await _printerManager.printTicket(await _ticket(PaperSize.mm80));
// //       print(" print in");
// //     } catch (e) {
// //       print("error on print $e");
// //     }
// //   }
//
//
//
//   Priter_Initial_Part(){
//     if (Platform.isAndroid) {
//       bluetoothManager.state.listen((val) {
//         print('state = $val');
//         if (!mounted) return;
//         if (val == 12) {
//           print('on');
//           searchPrinter();
//         } else if (val == 10) {
//           print('off');
//           setState(() => _devicesMsg = 'Bluetooth Disconnect!');
//           blutoothEnable();
//         }
//       });
//     } else {
//       searchPrinter();
//     }
//
//
//   }
//
//   void searchPrinter() {
//     try {
//       _printerManager.startScan(Duration(seconds: 2));
//       _printerManager.scanResults.listen((val) {
//         if (!mounted) return;
//         setState(() =>_devices = val);
//         if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
//       });
//     }
//     catch(e){print("result for scan print $e");}
//   }
//
//   blutoothprinting(){
//     print(" on blutoothprinting");
//     for(int i=0;i<_devices.length;i++){
//       if(_devices[i].address=="00:11:22:33:44:55"){
//         print("find _devices");
//         print(_devices.length.toString());
//         print(_devices[i].address);
//         print(_devices[i].name);
//         print(i.toString());
//         _startPrint(_devices[i]);
//         // dispose();
//         break;
//       }
//     }
//
//     print("not find _devices");
//
//   }
//
//   Future<void> _startPrint(PrinterBluetooth printer) async {
//     _printerManager.selectPrinter(printer);
//     final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: Text(result.msg),
//       ),
//     );
//   }
//
//
// /*Show dialog if blutooth not enabled and open settings blutooth*/
//   Future blutoothEnable() async {
//     if (Theme.of(context).platform == TargetPlatform.android) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 "Blutooth is Off ?",
//                 style: TextStyle(color: Colors.red),
//               ),
//               content:
//               const Text('Please make sure you enabled Blutooth for Printing'),
//               actions: <Widget>[
//
//                 SizedBox(width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     children: [
//                       FlatButton(
//                           child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                       Spacer(),
//                       FlatButton(
//                           child: Text('Enable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                           onPressed: () {
//                             final AndroidIntent intent = AndroidIntent(
//                                 action:
//                                 'android.settings.BLUETOOTH_SETTINGS');
//                             intent.launch();
//                             Navigator.of(context, rootNavigator: true).pop();
//                             // _gpsService();
//                           }),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           });
//     }
//   }
//
//   ///-----------------URL Print--------------------------------------
//   UrlLaunch(url)async{
//     //  var  _url ='http://gterpdemo.qizo.in/#/GtMoblieSalesPrint?Sid=1&uBr=$branchId&uNm=$userName&uP=$password';
//     print("yuyuiyi");
//     print(url);
//     if (!await launch(url)) throw 'Could not launch $url';
//   }
//
//
//
//
//   ///---------------------------PDF Print--------------------------------------
//
//
//
//   //Vat Tax Invoice
//   // Vat Simplified
//   // Vat A4
//   // Vat 3 Inch
//   // Vat 2 Inch
//
//
//   //var s="Vat Tax Invoice";
//
//
//
//   PdfPrint(id,isGst,data){
//
//     if(isGst==false) {
//
//
//       if (DefultPrint_typ.toString().contains("Tax Invoice") ||
//           DefultPrint_typ.toString().contains("Simplified")) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     New_Model_PdfPrint(Parm_Id: id,
//                       Page_Type: DefultPrint_typ.contains("Tax Invoice") == true
//                           ? true
//                           : false,)));
//       }
//       else {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     Pdf_Print(Parm_Id: id,
//                       Page_Type: DefultPrint_typ.contains("4") == true
//                           ? "A4"
//                           : "3 Inch",)));
//       }
//     }
//     else{
// //in gst typ  indian typ
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   GST_Print_Format(Parm_Id: id,
//                     title:"title",
//                     Details_Data:data,
//                   )));
//
//
//     }
//   }
//
// //----------------------Print part End-----------------------------------------
//
//
//
//
//
//
// }
//
//
//
//
// class Saless {
//   String itmName;
//   int ItemSlNo;
//   int shid;
//   int itemId;
//   double qty;
//   double rate;
//   double disPercentage;
//   double cgstPercentage;
//   double sgstPercentage;
//   double cessPercentage;
//   double discountAmount;
//   double cgstAmount;
//   double sgstAmount;
//   double cessAmount;
//   double igstPercentage;
//   double igstAmount;
//   double taxPercentage;
//   double taxAmount;
//   bool taxInclusive;
//   double amountBeforeTax;
//   double amountIncludingTax;
//   double netTotal;
//   // dynamic hsncode;
//   int gdnId;
//   int taxId;
//   int rackId;
//   int addTaxId;
//   int unitId;
//   dynamic nosInUnit;
//   dynamic barcode;
//   dynamic StockId;
//   dynamic BatchNo;
//   dynamic ExpiryDate;
//   dynamic Notes;
//   dynamic hsncode;
//   dynamic DiscountAmount;
//
//   Saless({
//     this.itmName,
//     this.ItemSlNo,
//     this.shid,
//     this.itemId,
//     this.qty,
//     this.rate,
//     this.disPercentage,
//     this.cgstPercentage,
//     this.sgstPercentage,
//     this.cessPercentage,
//     this.discountAmount,
//     this.cgstAmount,
//     this.sgstAmount,
//     this.cessAmount,
//     this.igstPercentage,
//     this.igstAmount,
//     this.taxPercentage,
//     this.taxAmount,
//     this.taxInclusive,
//     this.amountBeforeTax,
//     this.amountIncludingTax,
//     this.netTotal,
//     this.hsncode,
//     this.gdnId,
//     this.taxId,
//     this.rackId,
//     this.addTaxId,
//     this.unitId,
//     this.nosInUnit,
//     this.barcode,
//     this.StockId,
//     this.BatchNo,
//     this.ExpiryDate,
//     this.Notes,
//     this.DiscountAmount,
//
//   });
//
//
//
//   Saless.fromJson(Map<String, dynamic> json) {
//     itmName = json['itmName'];
//     ItemSlNo = json['ItemSlNo'];
//     //  shid = json['shid'];
//     itemId = json['itemId'];
//     qty = json['qty'];
//     rate = json['rate'];
//     disPercentage = json['disPercentage'];
//     cgstPercentage = json['cgstPercentage'];
//     sgstPercentage = json['sgstPercentage'];
//     cessPercentage = json['cessPercentage'];
//     discountAmount = json['discountAmount'];
//     cgstAmount = json['cgstAmount'];
//     sgstAmount = json['sgstAmount'];
//     cessAmount = json['cessAmount'];
//     igstPercentage = json['igstPercentage'];
//     igstAmount = json['igstAmount'];
//     taxPercentage = json['taxPercentage'];
//     taxAmount = json['taxAmount'];
//     taxInclusive = json['taxInclusive'];
//     amountBeforeTax = json['amountBeforeTax'];
//     amountIncludingTax = json['amountIncludingTax'];
//     netTotal = json['netTotal'];
//     hsncode = json['hsncode'];
//     gdnId = json['gdnId'];
//     taxId = json['taxId'];
//     rackId = json['rackId'];
//     addTaxId = json['addTaxId'];
//     unitId = json['unitId'];
//     nosInUnit = json['nosInUnit'];
//     barcode = json['barcode'];
//     StockId = json['StockId'];
//     BatchNo = json['BatchNo'];
//     ExpiryDate = json['ExpiryDate'];
//     Notes = json['Notes'];
//     DiscountAmount = json['DiscountAmount'];
//
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['itmName'] = this.itmName;
//     data['ItemSlNo'] = this.ItemSlNo;
//     // data['shid'] = this.shid;
//     data['itemId'] = this.itemId;
//     data['qty'] = this.qty;
//     data['rate'] = this.rate;
//     data['disPercentage'] = this.disPercentage;
//     data['cgstPercentage'] = this.cgstPercentage;
//     data['sgstPercentage'] = this.sgstPercentage;
//     data['cessPercentage'] = this.cessPercentage;
//     data['discountAmount'] = this.discountAmount;
//     data['cgstAmount'] = this.cgstAmount;
//     data['sgstAmount'] = this.sgstAmount;
//     data['cessAmount'] = this.cessAmount;
//     data['igstPercentage'] = this.igstPercentage;
//     data['igstAmount'] = this.igstAmount;
//     data['taxPercentage'] = this.taxPercentage;
//     data['taxAmount'] = this.taxAmount;
//     data['taxInclusive'] = this.taxInclusive;
//     data['amountBeforeTax'] = this.amountBeforeTax;
//     data['amountIncludingTax'] = this.amountIncludingTax;
//     data['netTotal'] = this.netTotal;
//     data['hsncode'] = this.hsncode;
//     data['gdnId'] = this.gdnId;
//     data['taxId'] = this.taxId;
//     data['rackId'] = this.rackId;
//     data['addTaxId'] = this.addTaxId;
//     data['unitId'] = this.unitId;
//     data['nosInUnit'] = this.nosInUnit;
//     data['barcode'] = this.barcode;
//     data['StockId'] = this.StockId;
//     data['BatchNo'] = this.BatchNo;
//     data['ExpiryDate'] = this.ExpiryDate;
//     data['Notes'] = this.Notes;
//     data['DiscountAmount'] = this.DiscountAmount;
//
//     return data;
//   }
// }
//
//
//
//
// class  UnitType {
//   // "id": 2,
//   // "description": "Box 10s",
//   // "nos": 10.0,
//   // "formalName": "Box 10",
//   // "unitUnder": 1,
//   // "isSimple": true,
//   // "groupUnder": "Number"
//
//   int id;
//   dynamic description;
//   double nos;
//   dynamic formalName;
//   int unitUnder;
//   bool isSimple;
//   dynamic groupUnder;
//
//
//
//   UnitType(
//       {
//         this.id,
//         this.description,
//         this.nos,
//         this.formalName,
//         this.unitUnder,
//         this.isSimple,
//         this.groupUnder,
//       });
//
//   UnitType.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     nos = json['nos'];
//     formalName = json['formalName'];
//     unitUnder = json['unitUnder'];
//     isSimple = json['isSimple'];
//     groupUnder = json['groupUnder'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['description'] = this.description;
//     data['nos'] = this.nos;
//     data['formalName'] = this.formalName;
//     data['unitUnder'] = this.unitUnder;
//     data['isSimple'] = this.isSimple;
//     data['groupUnder'] = this.groupUnder;
//
//     return data;
//   }
// // Map<String, dynamic> toMap() {
// //   return {
// //     'id' : id,
// //     'description' : description,
// //     'nos' : nos,
// //     // 'formalName' : formalName,
// //     // 'unitUnder' : unitUnder,
// //     // 'isSimple' : isSimple,
// //     // 'groupUnder' : groupUnder,
// //   };
// // }
// }
//
//
//
//
//
//
//
//
// //-------------for sale edit-----------------------
//
// class Salesedit {
//   int ItemSlNo;
//   int shid;
//   int itemId;
//   double qty;
//   double rate;
//   double disPercentage;
//   double cgstPercentage;
//   double sgstPercentage;
//   double cessPercentage;
//   double discountAmount;
//   double cgstAmount;
//   double sgstAmount;
//   double cessAmount;
//   double igstPercentage;
//   double igstAmount;
//   double taxPercentage;
//   double taxAmount;
//   bool taxInclusive;
//   double amountBeforeTax;
//   double amountIncludingTax;
//   double netTotal;
//   dynamic hsncode;
//   int gdnId;
//   int taxId;
//   int rackId;
//   int addTaxId;
//   int unitId;
//   dynamic nosInUnit;
//   dynamic barcode;
//   dynamic StockId;
//   dynamic BatchNo;
//   dynamic ExpiryDate;
//   dynamic Notes;
//   dynamic adlDiscAmount;
//   dynamic adlDiscPercent;
//
//   Salesedit({
//     this.ItemSlNo,
//     this.shid,
//     this.itemId,
//     this.qty,
//     this.rate,
//     this.disPercentage,
//     this.cgstPercentage,
//     this.sgstPercentage,
//     this.cessPercentage,
//     this.discountAmount,
//     this.cgstAmount,
//     this.sgstAmount,
//     this.cessAmount,
//     this.igstPercentage,
//     this.igstAmount,
//     this.taxPercentage,
//     this.taxAmount,
//     this.taxInclusive,
//     this.amountBeforeTax,
//     this.amountIncludingTax,
//     this.netTotal,
//     this.hsncode,
//     this.gdnId,
//     this.taxId,
//     this.rackId,
//     this.addTaxId,
//     this.unitId,
//     this.nosInUnit,
//     this.barcode,
//     this.StockId,
//     this.BatchNo,
//     this.ExpiryDate,
//     this.Notes,
//     this.adlDiscAmount,
//     this.adlDiscPercent,
//   });
//
//
//
//   Salesedit.fromJson(Map<String, dynamic> json) {
//     ItemSlNo = json['ItemSlNo'];
//     shid = json['shid'];
//     itemId = json['itemId'];
//     qty = json['qty'];
//     rate = json['rate'];
//     disPercentage = json['disPercentage'];
//     cgstPercentage = json['cgstPercentage'];
//     sgstPercentage = json['sgstPercentage'];
//     cessPercentage = json['cessPercentage'];
//     discountAmount = json['discountAmount'];
//     cgstAmount = json['cgstAmount'];
//     sgstAmount = json['sgstAmount'];
//     cessAmount = json['cessAmount'];
//     igstPercentage = json['igstPercentage'];
//     igstAmount = json['igstAmount'];
//     taxPercentage = json['taxPercentage'];
//     taxAmount = json['taxAmount'];
//     taxInclusive = json['taxInclusive'];
//     amountBeforeTax = json['amountBeforeTax'];
//     amountIncludingTax = json['amountIncludingTax'];
//     netTotal = json['netTotal'];
//     hsncode = json['hsncode'];
//     gdnId = json['gdnId'];
//     taxId = json['taxId'];
//     rackId = json['rackId'];
//     addTaxId = json['addTaxId'];
//     unitId = json['unitId'];
//     nosInUnit = json['nosInUnit'];
//     barcode = json['barcode'];
//     StockId = json['StockId'];
//     BatchNo = json['BatchNo'];
//     ExpiryDate = json['ExpiryDate'];
//     Notes = json['Notes'];
//     adlDiscAmount = json['adlDiscAmount'];
//     adlDiscPercent = json['adlDiscPercent'];
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//
//     data['ItemSlNo'] = this.ItemSlNo;
//     data['shid'] = this.shid;
//     data['itemId'] = this.itemId;
//     data['qty'] = this.qty;
//     data['rate'] = this.rate;
//     data['disPercentage'] = this.disPercentage;
//     data['cgstPercentage'] = this.cgstPercentage;
//     data['sgstPercentage'] = this.sgstPercentage;
//     data['cessPercentage'] = this.cessPercentage;
//     data['discountAmount'] = this.discountAmount;
//     data['cgstAmount'] = this.cgstAmount;
//     data['sgstAmount'] = this.sgstAmount;
//     data['cessAmount'] = this.cessAmount;
//     data['igstPercentage'] = this.igstPercentage;
//     data['igstAmount'] = this.igstAmount;
//     data['taxPercentage'] = this.taxPercentage;
//     data['taxAmount'] = this.taxAmount;
//     data['taxInclusive'] = this.taxInclusive;
//     data['amountBeforeTax'] = this.amountBeforeTax;
//     data['amountIncludingTax'] = this.amountIncludingTax;
//     data['netTotal'] = this.netTotal;
//     data['hsncode'] = this.hsncode;
//     data['gdnId'] = this.gdnId;
//     data['taxId'] = this.taxId;
//     data['rackId'] = this.rackId;
//     data['addTaxId'] = this.addTaxId;
//     data['unitId'] = this.unitId;
//     data['nosInUnit'] = this.nosInUnit;
//     data['barcode'] = this.barcode;
//     data['StockId'] = this.StockId;
//     data['BatchNo'] = this.BatchNo;
//     data['ExpiryDate'] = this.ExpiryDate;
//     data['Notes'] = this.Notes;
//     data['adlDiscAmount'] = this.adlDiscAmount;
//     data['adlDiscPercent'] = this.adlDiscPercent;
//     return data;
//   }
// }
//
//
// //-------------for Gown----------------------
// class  Godown{
//
//   int gdnId;
//   dynamic gdnDescription;
//
//
//
//   Godown(
//       {
//         this.gdnId,
//         this.gdnDescription,
//       });
//
//   Godown.fromJson(Map<String, dynamic> json) {
//     gdnId = json['gdnId'];
//     gdnDescription = json['gdnDescription'];
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['gdnId'] = this.gdnId;
//     data['gdnDescription'] = this.gdnDescription;
//     return data;
//   }
// }
//
