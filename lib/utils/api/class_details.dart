import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../model/class_detail_model.dart';
import '../api_urls.dart';

var box = GetStorage();

class ClassDetails {
  updateUserAge(user_id) async {
    var Url = "${ApiUrls.getClassDetails}$user_id";
    log("Url is $Url");
    http.Response response = await http.get(
      Uri.parse(Url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${box.read("access")}",
      },
    );
    print(response.body);
    log(response.body);
    log(response.body);
    log(response.body);
    if (response.statusCode == 200) {

      ClassDetailUi p = classDetailUiFromJson(response.body);

      return p;
    } else if (response.statusCode == 400) {
      log("400" + response.body);
    } else {
      Get.rawSnackbar(
          message: "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
          backgroundColor: Colors.red);
    }
  }

  /// exchange class validate api
  exchangeClassValidate(class_id) async {
    var Url = "${ApiUrls.exchangeClassValidate}";
    log("Url is $Url");
    Map<String,dynamic> data ={

        "pangea_class_room_id": "!PwFcwprrUZEZTdadZG:pangea.chat",
        "student_id":"${box.read("ClientID")}"

    };
    http.Response response = await http.post(
      Uri.parse(Url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${box.read("access")}",
      },
      body: jsonEncode(data),
    );
    print(response.body);
    log(response.body);
    log(response.body);
    log(response.body);
    if (response.statusCode == 200) {

      ClassDetailUi p = classDetailUiFromJson(response.body);

      return p;
    } else if (response.statusCode == 400) {
      log("400" + response.body);
    } else {
      Get.rawSnackbar(
          message: "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
          backgroundColor: Colors.red);
    }
  }

  /// exchange class api
  exchangeClass(user_id) async {
    var Url = "${ApiUrls.getClassDetails}$user_id";
    log("Url is $Url");
    http.Response response = await http.get(
      Uri.parse(Url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${box.read("access")}",
      },
    );
    print(response.body);
    log(response.body);
    log(response.body);
    log(response.body);
    if (response.statusCode == 200) {

      ClassDetailUi p = classDetailUiFromJson(response.body);

      return p;
    } else if (response.statusCode == 400) {
      log("400" + response.body);
    } else {
      Get.rawSnackbar(
          message: "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
          backgroundColor: Colors.red);
    }
  }
}
