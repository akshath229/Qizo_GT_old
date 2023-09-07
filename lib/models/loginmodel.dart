

class GetCompany {
  int companyProfileId;
  String companyProfileName;
  String  companyProfileShortName;
  String companyProfileMailingName;
  String companyProfileAddress1;
  String companyProfileAddress2;
  String companyProfileAddress3;
  String companyProfileGstNo;
  String companyProfilePan;
  String companyProfileMobile;
  String companyProfileContact;
  String companyProfileEmail;
  String companyProfileWeb;
  String companyProfileBankName;
  String companyProfileAccountNo;
  String companyProfileBranch;
  String companyProfileIfsc;
  String companyProfileImagePath;
  String companyProfileIsPrintHead;
  int companyProfileStateId;
  int companyProfileLedgerId;

  GetCompany(
      {this.companyProfileId,
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
        this.companyProfileLedgerId});

  GetCompany.fromJson(Map<String, dynamic> json) {
    companyProfileId = json['companyProfileId'];
    companyProfileName = json['companyProfileName'];
    companyProfileShortName = json['companyProfileShortName'];
    companyProfileMailingName = json['companyProfileMailingName'];
    companyProfileAddress1 = json['companyProfileAddress1'];
    companyProfileAddress2 = json['companyProfileAddress2'];
    companyProfileAddress3 = json['companyProfileAddress3'];
    companyProfileGstNo = json['companyProfileGstNo'];
    companyProfilePan = json['companyProfilePan'];
    companyProfileMobile = json['companyProfileMobile'];
    companyProfileContact = json['companyProfileContact'];
    companyProfileEmail = json['companyProfileEmail'];
    companyProfileWeb = json['companyProfileWeb'];
    companyProfileBankName = json['companyProfileBankName'];
    companyProfileAccountNo = json['companyProfileAccountNo'];
    companyProfileBranch = json['companyProfileBranch'];
    companyProfileIfsc = json['companyProfileIfsc'];
    companyProfileImagePath = json['companyProfileImagePath'];
    companyProfileIsPrintHead = json['companyProfileIsPrintHead'];
    companyProfileStateId = json['companyProfileStateId'];
    companyProfileLedgerId = json['companyProfileLedgerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyProfileId'] = this.companyProfileId;
    data['companyProfileName'] = this.companyProfileName;
    data['companyProfileShortName'] = this.companyProfileShortName;
    data['companyProfileMailingName'] = this.companyProfileMailingName;
    data['companyProfileAddress1'] = this.companyProfileAddress1;
    data['companyProfileAddress2'] = this.companyProfileAddress2;
    data['companyProfileAddress3'] = this.companyProfileAddress3;
    data['companyProfileGstNo'] = this.companyProfileGstNo;
    data['companyProfilePan'] = this.companyProfilePan;
    data['companyProfileMobile'] = this.companyProfileMobile;
    data['companyProfileContact'] = this.companyProfileContact;
    data['companyProfileEmail'] = this.companyProfileEmail;
    data['companyProfileWeb'] = this.companyProfileWeb;
    data['companyProfileBankName'] = this.companyProfileBankName;
    data['companyProfileAccountNo'] = this.companyProfileAccountNo;
    data['companyProfileBranch'] = this.companyProfileBranch;
    data['companyProfileIfsc'] = this.companyProfileIfsc;
    data['companyProfileImagePath'] = this.companyProfileImagePath;
    data['companyProfileIsPrintHead'] = this.companyProfileIsPrintHead;
    data['companyProfileStateId'] = this.companyProfileStateId;
    data['companyProfileLedgerId'] = this.companyProfileLedgerId;
    return data;
  }
}
