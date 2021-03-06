import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:base_flutter/base/controller/base_controller.dart';
import 'package:base_flutter/base/networking/services/auth_api.dart';
import 'package:base_flutter/models/token/token_manager.dart';
import 'package:base_flutter/routes/router_name.dart';
import 'package:base_flutter/utils/log.dart';
import 'package:base_flutter/utils/popup.dart';

class VerificationCodeController extends BaseController {
  final AuthAPI _api = AuthAPI();
  TextEditingController codeController = TextEditingController();
  RxBool isNextButtonEnabled = false.obs;
  String refId = "3de72e1b-16a9-499e-8219-1f831c00e017";

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    _binding();
  }

  void _binding() {
    codeController.addListener(() {
      isNextButtonEnabled.value = codeController.text.trim().isNotEmpty;
    });
  }

  void startVerify() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      var response = await _api.activateCode(codeController.text);
      isLoading.value = false;
      if (response.accessToken.isNotEmpty) {
        TokenManager.saveAccessToken(response.accessToken);
        Get.offNamed(RouterName.tabbar);
      }
    } catch (error) {
      logDebug("login error $error");
      handleError(error);
    }
  }

  void getCode() async {
    if (isLoading.value) return;
    try {
      var response = await _api.getCode(refId);
      isLoading.value = false;
      if (response.code.isNotEmpty) {
        codeController.text = response.code;
        Popup.instance.showSnackBar(
            message: "Your code is ${response.code}",
            type: SnackbarType.success);
      }
    } catch (error) {
      logDebug("login error $error");
      handleError(error);
    }
  }
}
