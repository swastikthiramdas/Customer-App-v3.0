import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/main.dart';
import 'package:AstrowayCustomer/model/login_model.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

import '../model/device_info_login_model.dart';
import '../utils/global.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/verifyPhoneScreen.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  SplashController splashController = Get.find<SplashController>();
  String validationId = "";
  double second = 0;
  var maxSecond;
  String countryCode = "+91";
  Timer? time;
  Timer? time2;
  String smsCode = "";
  //String verificationId = "";
  String? errorText;
  APIHelper apiHelper = APIHelper();
  String selectedCountryCode = "+91";
  var flag = '🇮🇳';

  @override
  void onInit() {
    super.onInit();
  }

  // Future<void> verifyOtpPhone(String otp) async {
  //   if (Platform.isAndroid) {
  //     otplessFlutterPlugin.initHeadless(appId);
  //     otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
  //     debugPrint("init headless sdk is called for android");
  //   }
  //   // if (Platform.isIOS && !isInitIos) {
  //   otplessFlutterPlugin.initHeadless(appId);
  //   otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
  //   isInitIos = true;
  //   debugPrint("init headless sdk is called for ios");
  //   Map<String, dynamic> arg = {'phone':'8958994842','countryCode':"+91",'otp':'$otp'};
  //   otplessFlutterPlugin.startHeadless(onHeadlessResultVerify, arg);
  // }
  void onHeadlessResultVerify(dynamic result) async {
    dataResponse = result;
    log(" result is verify ${dataResponse}");
    // whatsapplogindetailsModelFromJson(dataResponse);

    if (dataResponse['statusCode'].toString() == "200") {
      final response = await http.post(
        Uri.parse('$baseUrl/getOtlResponse'),
        body: json.encode({"token": dataResponse['response']['token']}),
        headers: await global.getApiHeaders(false),
      );
      print("stattuscodee");
      print("'$baseUrl/getOtlResponse'");
      print("${response.statusCode}");
      Map data = json.decode(response.body);
      if (response.statusCode == 200) {
        await loginAndSignupUser(
            int.parse(data['authentication_details']['phone']['phone_number']
                .toString()),
            "");
      } else {
        hideLoader();
      }
    } else {
      hideLoader();
    }
  }

  Future<void> startHeadlessWithWhatsapp(String type) async {
    print("entered in verification");
    print("----------------------");
    if (Platform.isAndroid) {
      otplessFlutterPlugin.initHeadless(appId);
      otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
      debugPrint("init headless sdk is called for android");
    }
    // if (Platform.isIOS && !isInitIos) {
    otplessFlutterPlugin.initHeadless(appId);
    otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
    isInitIos = true;
    debugPrint("init headless sdk is called for ios");
    Map<String, dynamic> arg = type == "phone"
        ? {'phone': '${phoneController.text}', 'countryCode': "+91"}
        : {
            'channelType': "$type",
          };
    type == "phone"
        ? otplessFlutterPlugin.startHeadless(onHeadlessResultPhone, arg)
        : otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

  void onHeadlessResult(dynamic result) async {
    dataResponse = result;
    log(" My result is ${dataResponse}");
    if (dataResponse['response']['status'].toString() == "SUCCESS") {
      if (dataResponse['response']['identities'][0]['identityType']
              .toString() ==
          "EMAIL") {
        await loginAndSignupUser(
            null,
            dataResponse['response']['identities'][0]['identityValue']
                .toString());
      } else {
        final response = await http.post(
          Uri.parse('$baseUrl/getOtlResponse'),
          body: json.encode({"token": dataResponse['response']['token']}),
          headers: await global.getApiHeaders(false),
        );
        print("stattuscodee");
        print("'$baseUrl/getOtlResponse'");
        print("${response.statusCode}");
        Map data = json.decode(response.body);
        if (response.statusCode == 200) {
          await loginAndSignupUser(
              int.parse(data['authentication_details']['phone']['phone_number']
                  .toString()),
              "");
        }
      }
    } else {
      hideLoader();
    }
    // whatsapplogindetailsModelFromJson(dataResponse);
  }

  void onHeadlessResultPhone(dynamic result) {
    log(" result is1 ${dataResponse}");
    dataResponse = result;
    log(" result is ${dataResponse}");
    hideLoader();
    if (dataResponse['statusCode'] == 200) {
      timer();
      Get.to(() => VerifyPhoneScreen(
            phoneNumber: phoneController.text.trim(),
          ));
    }
    // whatsapplogindetailsModelFromJson(dataResponse);
  }

  final otplessFlutterPlugin = Otpless();
  var loaderVisibility = true;
  final TextEditingController urlTextContoller = TextEditingController();
  Map dataResponse = {};
  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;
  static const String appId = "EGN337D0735VTPMTqwer";

  @override
  void dispose() {
    // _stream = null;
    super.dispose();
    // ignore: unnecessary_statements
    print("despose");
  }

  timer() {
    maxSecond = 60;
    update();
    print("maxSecond:- ${maxSecond}");
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
      }
    });
  }

  updateCountryCode(value) {
    countryCode = value.toString();
    print('countryCode -> $countryCode');
    update();
  }

  bool validedPhone() {
    // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String pattern =
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
    RegExp regExp = new RegExp(pattern);
    if (phoneController.text.length == 0) {
      errorText = 'Please enter mobile number';
      update();
      return false;
    } else if (!regExp.hasMatch(phoneController.text)) {
      errorText = 'Please enter valid mobile number';
      update();
      return false;
    } else {
      return true;
    }
  }

  // truecaller(BuildContext context) {
  //   _stream = TcSdk.streamCallbackData;
  //   TcSdk.initializeSDK(
  //     sdkOption: TcSdkOptions.OPTION_VERIFY_ALL_USERS,
  //   );
  //   TcSdk.isOAuthFlowUsable.then((isOAuthFlowUsable) {
  //     if (isOAuthFlowUsable) {
  //       TcSdk.setOAuthState(Uuid().v1());
  //       TcSdk.setOAuthScopes(['profile', 'phone', 'openid', 'offline_access']);
  //       TcSdk.generateRandomCodeVerifier.then((codeVerifier) {
  //         TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) {
  //           if (codeChallenge != null) {
  //             this.codeVerifier = codeVerifier;
  //             TcSdk.setCodeChallenge(codeChallenge);
  //             TcSdk.getAuthorizationCode;
  //           } else {
  //             final snackBar = SnackBar(content: Text("Device not supported"));
  //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //             print("***Code challenge NULL***");
  //           }
  //         });
  //       });
  //     } else {
  //       final snackBar = SnackBar(content: Text("Not Usable"));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       print("***Not usable***");
  //     }
  //   });

  //   _stream!.listen((event) {
  //     switch (event.result) {
  //       case TcSdkCallbackResult.success:
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("${TcSdkCallbackResult.success}")));

  //         break;
  //       case TcSdkCallbackResult.failure:
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text("${event.error!.message}${event.error!.code}")));

  //         break;
  //       case TcSdkCallbackResult.verification:
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Your are not a truecaller user.")));
  //         break;
  //       default:
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(SnackBar(content: Text("Something went wrong")));
  //     }
  //   });
  // }

  // verifyOTP(context) async {
  //   try {
  //     global.showOnlyLoaderDialog(context);
  //     //  FirebaseAuth _auth = FirebaseAuth.instance;
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '${countryCode + phoneController.text.trim()}',
  //       verificationCompleted: (PhoneAuthCredential credential) {},
  //       verificationFailed: (FirebaseAuthException e) {
  //         global.hideLoader();
  //         print('exceptionlogin $e');
  //         global.showToast(
  //           message: '$e',
  //           textColor: global.textColor,
  //           bgColor: global.toastBackGoundColor,
  //         );
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         print("codeSent");
  //         //validationId = verificationId;
  //         update();
  //         //timer();
  //         global.hideLoader();
  //         Get.to(() => VerifyPhoneScreen(
  //               phoneNumber: phoneController.text.trim(),
  //
  //             ));
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //
  //     log("mobile numeber");
  //     log("${countryCode + phoneController.text.trim()}");
  //   } on Exception catch (e) {
  //     String errorMessage = 'An error occurred, please try again later.';
  //     if (e is FirebaseAuthException) {
  //       String errorCode = e.code;
  //       switch (errorCode) {
  //         case 'invalid-verification-code':
  //           errorMessage = 'The verification code entered is incorrect.';
  //           break;
  //         case 'invalid-verification-id':
  //           errorMessage = 'The verification ID is invalid.';
  //           break;
  //         case 'invalid-phone-number':
  //           errorMessage = 'The phone number is invalid.';
  //           break;
  //         case 'too-many-requests':
  //           errorMessage = 'Too many requests, please try again later.';
  //           break;
  //         default:
  //           // Handle other Firebase authentication errors
  //           errorMessage =
  //               'An unexpected error occurred, please try again later.';
  //       }
  //       global.showToast(
  //           message: errorMessage,
  //           textColor: Colors.white,
  //           bgColor: Colors.black);
  //       debugPrint('Fail: $errorMessage');
  //     }
  //   }
  // }

  loginAndSignupUser(int? phoneNumber, String email) async {
    try {
      await global.getDeviceData();
      LoginModel loginModel = LoginModel();
      loginModel.contactNo = phoneNumber.toString();
      email.toString() == "" ? null : loginModel.email = email.toString();
      loginModel.countryCode = countryCode.toString();
      loginModel.deviceInfo = DeviceInfoLoginModel();
      loginModel.deviceInfo?.appId = global.appId;
      loginModel.deviceInfo?.appVersion = global.appVersion;
      loginModel.deviceInfo?.deviceId = global.deviceId;
      loginModel.deviceInfo?.deviceLocation = global.deviceLocation ?? "";
      loginModel.deviceInfo?.deviceManufacturer = global.deviceManufacturer;
      loginModel.deviceInfo?.deviceModel = global.deviceManufacturer;
      loginModel.deviceInfo?.fcmToken = global.fcmToken;
      loginModel.deviceInfo?.appVersion = global.appVersion;

      await apiHelper.loginSignUp(loginModel).then((result) async {
        if (result.status == "200") {
          var recordId = result.recordList["recordList"];
          var token = result.recordList["token"];
          var tokenType = result.recordList["token_type"];
          await global.saveCurrentUser(recordId["id"], token, tokenType);
          await splashController.getCurrentUserData();
          await global.getCurrentUser();
          print('success');
          // global.hideLoader();
          final homeController = Get.find<HomeController>();
          homeController.myOrders.clear();
          time?.cancel();
          update();

          // global.hideLoader();
          // bottomController.astrologerList.clear();
          // bottomController.getAstrologerList(isLazyLoading: false);
          bottomController.setIndex(0, 0);
          Get.off(() => BottomNavigationBarScreen(index: 0));
        } else {
          global.hideLoader();
          // global.hideLoader();
          global.showToast(
            message: 'Failed to sign in',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
      });
    } catch (e) {
      global.hideLoader();
      print("Exception in loginAndSignupUser():-" + e.toString());
    }
  }
}
