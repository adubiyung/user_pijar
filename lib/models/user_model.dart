import 'dart:convert';
import 'package:http/http.dart' as http;

class UserModel {
  // dynamic userID;
  // dynamic roleID;
  dynamic userPassword;
  // dynamic userFullname;
  // dynamic userNIK;
  // dynamic userBirthdate;
  // dynamic userAddress1;
  // dynamic userAddress2;
  // dynamic userEmail;
  // dynamic userPhone;
  // dynamic userBalance;
  // dynamic userPoint;
  // dynamic userStatus;
  // dynamic userKTP;
  // dynamic userPicture;
  // dynamic createdBy;
  // dynamic createdDate;
  // dynamic updatedBy;
  // dynamic updatedDate;
  // dynamic otpValidDate;
  // dynamic userToken;
  // dynamic method;
  dynamic message;
  dynamic status;

  UserModel(
      { //this.userID,
      // this.roleID,
      this.userPassword,
      // this.userFullname,
      // this.userNIK,
      // this.userBirthdate,
      // this.userAddress1,
      // this.userAddress2,
      // this.userEmail,
      // this.userPhone,
      // this.userBalance,
      // this.userPoint,
      // this.userStatus,
      // this.userKTP,
      // this.userPicture,
      // this.createdBy,
      // this.createdDate,
      // this.updatedBy,
      // this.updatedDate,
      // this.otpValidDate,
      // this.userToken,
      // this.method,
      this.message,
      this.status});

  // factory method ini digunakan untuk menampung hasil response json api get all
  // UserModel.fromJson ==> UserModel adalah nama class ini, fromJson adalah nama methodnya
  // type yang dibaca adalah Map<String, dynamic> maksudnya String adalah key api, dan dynamic adalah value api
  // value menggunakan type dynamic karna untuk menghandle type data value yang bermacam-macam
  // factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
  //       userID: json["user_id"],
  //       roleID: json["role_id"],
  //       userPassword: json["user_password"],
  //       userFullname: json["user_fullname"],
  //       userNIK: json["user_nik"],
  //       userBirthdate: json["user_birthdate"],
  //       userAddress1: json["user_address1"],
  //       userAddress2: json["user_address2"],
  //       userEmail: json["user_email"],
  //       userPhone: json["user_phone"],
  //       userBalance: json["user_balance"],
  //       userPoint: json["user_point"],
  //       userStatus: json["user_status"],
  //       userKTP: json["user_ktp"],
  //       userPicture: json["user_profile_pict"],
  //       createdBy: json["created_by"],
  //       createdDate: json["created_date"],
  //       updatedBy: json["updated_by"],
  //       updatedDate: json["updated_date"],
  //       otpValidDate: json["otp_valid_date"],
  //       userToken: json["user_token"],
  //     );

  // Map<String, dynamic> authNumber() =>
  //     {"user_phone": userPhone, "method": method};

  factory UserModel.resAuthNumber(Map<String, dynamic> json) {
    return UserModel(
        userPassword: json["data"],
        message: json["message"],
        status: json["status"]);
  }

  static Future<UserModel> authNumberPost(String number, String method) async {
    String url = "https://pijarbackend.digitalevent.id/api/loginact";

    var request = await http.post(url,
        body: '{"user_phone": "$number", "method": "$method"}');

    var jsonObject = json.decode(request.body);
    return UserModel.resAuthNumber(jsonObject);
  }
}

// fungsi model ini digunakan untuk melakukan convert data json object yang diterima
// UserModel jsonAuthNumber(String source) {
//   final jsonData = json.decode(source);
//   return UserModel.resAuthNumber(jsonData);
// }

// UserModel postFromJson(String str) {
//   final jsonData = json.decode(str);
//   return UserModel.fromJson(jsonData);
// }

// String postToJson(UserModel data) {
//   final dyn = data.authNumber();
//   return json.encode(dyn);
// }

// List<UserModel> allPostsFromJson(String str) {
//   final jsonData = json.decode(str);
//   return new List<UserModel>.from(jsonData.map((x) => UserModel.fromJson(x)));
// }

// String allPostsToJson(List<UserModel> data) {
//   final dyn = new List<dynamic>.from(data.map((x) => x.authNumber()));
//   return json.encode(dyn);
// }
