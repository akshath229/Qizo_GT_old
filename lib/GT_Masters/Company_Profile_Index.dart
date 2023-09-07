import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/GT_Masters/AppTheam.dart';
import 'package:flutter_app/GT_Masters/Company_Profile.dart';
import 'package:flutter_app/GT_Masters/Masters_HomePage.dart';
import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';
import 'package:flutter_app/appbarWidget.dart';
import 'package:flutter_app/models/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ledgerBalanceCreate.dart';
import 'Models/LedgerHeadesModel.dart';

class Company_Profile_Index extends StatefulWidget {
  @override
  _Company_Profile_IndexState createState() => _Company_Profile_IndexState();
}

class _Company_Profile_IndexState extends State<Company_Profile_Index> {

  AppTheam theam=AppTheam();
  static List<Company_Profile_Model> Cmpny_Prf = new List<Company_Profile_Model>();

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

  bool Status=false;
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetCompany_Profile();
      });
    });
  }
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


  CUWidgets cw=CUWidgets();

  GetCompany_Profile()async{
    var res =await cw.CUget_With_Parm(Token: token,api: "MCompanyProfiles");
    if(res!=false){
      setState(() {
        Status=true;

        var CmpPrf=json.decode(res) as List;
        Cmpny_Prf=CmpPrf.map((e) => Company_Profile_Model.fromJson(e)).toList();
      });
    }
  }


  DataTableIndex(i){

    var index = Cmpny_Prf.indexOf(i);
    return index + 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(child:Appbarcustomwidget(uname: userName, branch: branchName, pref: pref, title:"Ledger Index"), preferredSize:Size.fromHeight(80)),
      body:
      SingleChildScrollView(scrollDirection: Axis.horizontal,
        child:SingleChildScrollView(scrollDirection:Axis.vertical,

            child:Status==true?Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: theam.TableHeadRowClr,
                columnSpacing: 14,
                onSelectAll: (b) {},
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('No',style: theam.TableFont,),
                  ),
                  DataColumn(
                    label: Text('Name',style: theam.TableFont),
                  ),
                  DataColumn(
                    label: Text('Contact',style: theam.TableFont),
                  ),
                  DataColumn(
                    label: Text('Email',style: theam.TableFont),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                  // DataColumn(
                  //   label: Text('Alias Name'),
                  // ),
                  // DataColumn(
                  //   label: Text('Amount'),
                  // ),
                  // DataColumn(
                  //   label: Text('Add'),
                  // ),
                ],
                rows: Cmpny_Prf
                    .map(
                      (itemRow) => DataRow(
                    cells: [
                      DataCell(
                        Text(DataTableIndex(itemRow).toString()),
                        showEditIcon: false,
                        placeholder: false,
                      ),

                      DataCell(
                        Container(width: 150,
                          child: Text(
                              '${itemRow.companyProfileName.toString()}'),
                        ),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(
                            '${itemRow.companyProfileContact.toString()=="null"?"-":itemRow.companyProfileContact.toString()}'),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        Text(
                            '${itemRow.companyProfileEmail.toString()=="null"?"-":itemRow.companyProfileEmail.toString()}'),
                        showEditIcon: false,
                        placeholder: false,
                      ),
                      DataCell(
                        PopupMenuButton<int>(
                          onSelected:(a){
                            print("saf $a");
                          } ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),

                          ),
                          color:theam.EditpopupClr,
                          itemBuilder: (context) => [
                            PopupMenuItem(height: 30,
                              child:
                              Container(
                                child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                  GestureDetector(child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(Icons.edit,color: Colors.white,),
                                  ),
                                    onTap: (){
                                      Navigator.pop(context);
                                      print("edit ${itemRow.companyProfileId}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>Company_Profile(parmId:itemRow.companyProfileId,)
                                          ));
                                    },

                                  ),
                                  // Spacer(),
                                  // GestureDetector(child: Padding(
                                  //   padding: const EdgeInsets.only(left: 5,right: 5),
                                  //   child: Icon(Icons.delete,color: Colors.white,),
                                  // ),
                                  //   onTap: (){
                                  //     Navigator.pop(context);
                                  //     print("delete");
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>Company_Profile()
                                  //         ));
                                  //
                                  //   },
                                  //
                                  //
                                  // )
                                ],),
                              ),)
                          ],
                          icon: Icon(Icons.more_horiz),
                          //offset: Offset()
                        ),
                        showEditIcon: false,
                        placeholder: false,
                      ),

                    ],
                  ),
                )
                    .toList(),
              ),
            ):
            SizedBox(height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:Center(child: Text("Loading...")),)
        ),



      ),


      // bottomSheet: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: FloatingActionButton(backgroundColor: Colors.blue.shade800,
      //         child:Icon(Icons.add_circle_outline, size: 30,),
      //         onPressed:() {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>Company_Profile(id: 9,)
      //               ));
      //         }
      //     )),
    ));
  }
}



class Company_Profile_Model{

  Company_Profile_Model({
  this.companyProfileId,
  this.companyProfileName,
  this.companyProfileShortName,
  this.companyProfileMailingName,
  this.companyProfileAddress1,
  this.companyProfileAddress2,
  this.companyProfileAddress3,
  this.companyProfileGstNo,
  this.companyProfilePan,
  this.companyProfileMobile,
  this.companyProfileContact,
  this.companyProfileEmail,
  this.companyProfileWeb,
  this.companyProfileBankName,
  this.companyProfileAccountNo,
  this.companyProfileBranch,
  this.companyProfileIfsc,
  this.companyProfileImagePath,
  this.companyProfileIsPrintHead,
  this.companyProfileStateId,
  this.companyProfileLedgerId,
  this.companyProfilePin,
  this.companyProfileNameLatin,
  this.buildingNo,
  this.buildingNoLatin,
  this.streetName,
  this.streetNameLatin,
  this.district,
  this.districtLatin,
  this.city,
  this.cityLatin,
  this.country,
  this.countryLatin,
  this.pinNo,
  this.pinNoLatin,
  this.companyProfileLedger,
  this.companyProfileState,
  });

  int companyProfileId;
  String companyProfileName;
  String companyProfileShortName;
  dynamic companyProfileMailingName;
  String companyProfileAddress1;
  String companyProfileAddress2;
  String companyProfileAddress3;
  String companyProfileGstNo;
  String companyProfilePan;
  String companyProfileMobile;
  String companyProfileContact;
  String companyProfileEmail;
  dynamic companyProfileWeb;
  String companyProfileBankName;
  String companyProfileAccountNo;
  String companyProfileBranch;
  String companyProfileIfsc;
  String companyProfileImagePath;
  dynamic companyProfileIsPrintHead;
  int companyProfileStateId;
  dynamic companyProfileLedgerId;
  dynamic companyProfilePin;
  String companyProfileNameLatin;
  String buildingNo;
  String buildingNoLatin;
  String streetName;
  String streetNameLatin;
  String district;
  String districtLatin;
  String city;
  String cityLatin;
  String country;
  String countryLatin;
  String pinNo;
  String pinNoLatin;
  dynamic companyProfileLedger;
  dynamic companyProfileState;

  factory Company_Profile_Model.fromJson(Map<String, dynamic> json) => Company_Profile_Model(
  companyProfileId: json["companyProfileId"],
  companyProfileName: json["companyProfileName"],
  companyProfileShortName: json["companyProfileShortName"],
  companyProfileMailingName: json["companyProfileMailingName"],
  companyProfileAddress1: json["companyProfileAddress1"],
  companyProfileAddress2: json["companyProfileAddress2"],
  companyProfileAddress3: json["companyProfileAddress3"],
  companyProfileGstNo: json["companyProfileGstNo"],
  companyProfilePan: json["companyProfilePan"],
  companyProfileMobile: json["companyProfileMobile"],
  companyProfileContact: json["companyProfileContact"],
  companyProfileEmail: json["companyProfileEmail"],
  companyProfileWeb: json["companyProfileWeb"],
  companyProfileBankName: json["companyProfileBankName"],
  companyProfileAccountNo: json["companyProfileAccountNo"],
  companyProfileBranch: json["companyProfileBranch"],
  companyProfileIfsc: json["companyProfileIfsc"],
  companyProfileImagePath: json["companyProfileImagePath"],
  companyProfileIsPrintHead: json["companyProfileIsPrintHead"],
  companyProfileStateId: json["companyProfileStateId"],
  companyProfileLedgerId: json["companyProfileLedgerId"],
  companyProfilePin: json["companyProfilePin"],
  companyProfileNameLatin: json["companyProfileNameLatin"],
  buildingNo: json["buildingNo"],
  buildingNoLatin: json["buildingNoLatin"],
  streetName: json["streetName"],
  streetNameLatin: json["streetNameLatin"],
  district: json["district"],
  districtLatin: json["districtLatin"],
  city: json["city"],
  cityLatin: json["cityLatin"],
  country: json["country"],
  countryLatin: json["countryLatin"],
  pinNo: json["pinNo"],
  pinNoLatin: json["pinNoLatin"],
  companyProfileLedger: json["companyProfileLedger"],
  companyProfileState: json["companyProfileState"],
  );

  Map<String, dynamic> toJson() => {
  "companyProfileId": companyProfileId,
  "companyProfileName": companyProfileName,
  "companyProfileShortName": companyProfileShortName,
  "companyProfileMailingName": companyProfileMailingName,
  "companyProfileAddress1": companyProfileAddress1,
  "companyProfileAddress2": companyProfileAddress2,
  "companyProfileAddress3": companyProfileAddress3,
  "companyProfileGstNo": companyProfileGstNo,
  "companyProfilePan": companyProfilePan,
  "companyProfileMobile": companyProfileMobile,
  "companyProfileContact": companyProfileContact,
  "companyProfileEmail": companyProfileEmail,
  "companyProfileWeb": companyProfileWeb,
  "companyProfileBankName": companyProfileBankName,
  "companyProfileAccountNo": companyProfileAccountNo,
  "companyProfileBranch": companyProfileBranch,
  "companyProfileIfsc": companyProfileIfsc,
  "companyProfileImagePath": companyProfileImagePath,
  "companyProfileIsPrintHead": companyProfileIsPrintHead,
  "companyProfileStateId": companyProfileStateId,
  "companyProfileLedgerId": companyProfileLedgerId,
  "companyProfilePin": companyProfilePin,
  "companyProfileNameLatin": companyProfileNameLatin,
  "buildingNo": buildingNo,
  "buildingNoLatin": buildingNoLatin,
  "streetName": streetName,
  "streetNameLatin": streetNameLatin,
  "district": district,
  "districtLatin": districtLatin,
  "city": city,
  "cityLatin": cityLatin,
  "country": country,
  "countryLatin": countryLatin,
  "pinNo": pinNo,
  "pinNoLatin": pinNoLatin,
  "companyProfileLedger": companyProfileLedger,
  "companyProfileState": companyProfileState,
  };





}
