import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacs/constants/enum.dart';
import 'package:kacs/services/api_services.dart';
import 'package:kacs/utils/utils.dart';

class SignInController extends GetxController {
  final _api = ApiService();

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  final rxRequestStatus = Status.COMPLETED.obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  void loginApi() {
    setRxRequestStatus(Status.LOADING);
    Map data = {"identifier": emailController.value.text};
    // Map data = {"email": emailController.value.text, "password": passwordController.value.text};
    _api.loginApi(data).then((response) {
      setRxRequestStatus(Status.COMPLETED);

      if (response != null) {
        // Get.toNamed("/otp")!.then((value) {

        // });
        Get.toNamed('/otp', arguments: {"userDetails": response});

        // Utils.showToast("Login successfully");
      } else {
        // Utils.showToast("Error");
      }
    });
  }
}
