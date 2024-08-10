// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:io';

import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String phoneNumber;
  VerifyPhoneScreen(
      {Key? key, required this.phoneNumber,})
      : super(key: key);
  final LoginController loginController = Get.find<LoginController>();
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final pinEditingControllerlogin = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        loginController.maxSecond=61;
        loginController.time!.cancel();
        loginController.update();
        return true;
      },
      child: Scaffold(
        appBar: kIsWeb
            ? AppBar(
          leading: SizedBox(),
          backgroundColor: Color.fromARGB(255, 245, 235, 235),
        )
            : AppBar(
          elevation: 1,
          backgroundColor: Color.fromARGB(255, 245, 235, 235),
          title: Text(
            'Verify Phone',
            style: Get.textTheme.titleMedium,
          ).tr(),
          leading: IconButton(
              onPressed: () {
                Get.delete<LoginController>(force: true);
                Get.back();
              },
              icon: Icon(
                kIsWeb
                    ? Icons.arrow_back
                    : Platform.isIOS
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        backgroundColor: Color.fromARGB(255, 245, 235, 235),
        body: Center(
          child: SizedBox(
            width: Get.width - Get.width * 0.1,
            child: Column(
              children: [
                // Image.asset(
                //   "assets/images/app_icon.png",
                //   fit: BoxFit.cover,
                //   width: 14.h,
                //   height: 14.h,
                // ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'OTP Send to ${loginController.countryCode}-$phoneNumber',
                  style: TextStyle(color: Colors.green),
                ).tr(),
                SizedBox(
                  height: 30,
                ),
                PinInputTextField(
                  pinLength: 6,
                  decoration: BoxLooseDecoration(
                    strokeColorBuilder: PinListenColorBuilder(
                        Colors.grey.shade400, Colors.grey.shade400),
                  ),
                  controller: pinEditingControllerlogin,
                  textInputAction: TextInputAction.done,
                  enabled: true,
                  keyboardType: TextInputType.number,
                  onSubmit: (pin) {
                    loginController.smsCode = pin;
                    loginController.update();
                  },
                  onChanged: (pin) {
                    loginController.smsCode = pin;
                    loginController.update();
                    // debugPrint('onChanged execute. pin:$pin');
                  },
                  enableInteractiveSelection: false,
                ),
                // OtpTextField(
                //   numberOfFields: 6,
                //   showFieldAsBox: true,
                //   onCodeChanged: (value) {},
                //   onSubmit: (value) {
                //     loginController.smsCode = value;
                //     loginController.update();
                //   },
                //   filled: true,
                //   fillColor: Colors.white,
                //   fieldWidth: 48,
                //   borderColor: Colors.transparent,
                //   enabledBorderColor: Colors.transparent,
                //   focusedBorderColor: Colors.transparent,
                //   borderRadius: BorderRadius.circular(10),
                //   margin: EdgeInsets.only(right: 4),
                // ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: kIsWeb ? Get.width * 0.25 : double.infinity,
                  child: GetBuilder<LoginController>(builder: (c) {
                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          Map<String, dynamic> arg = {};
                          arg["phone"] = "${phoneNumber}";
                          arg["countryCode"] = "+91";
                          arg["otp"] = "${loginController.smsCode}";
                          global.showOnlyLoaderDialog(context);
                          loginController.otplessFlutterPlugin.startHeadless(loginController.onHeadlessResultVerify, arg);
                          // PhoneAuthCredential credential =
                          // PhoneAuthProvider.credential(
                          //   verificationId: verificationId,
                          //   smsCode: loginController.smsCode,
                          // );
                          // global.showOnlyLoaderDialog(context);
                          // await auth.signInWithCredential(credential);
                          // await loginController
                          //     .loginAndSignupUser(int.parse(phoneNumber));
                        } catch (e) {
                          global.hideLoader();

                          global.showToast(
                            message: "OTP INVALID",
                            textColor: Colors.white,
                            bgColor: Colors.red,
                          );
                          print("Exception " + e.toString());
                        }
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        backgroundColor:
                        MaterialStateProperty.all(Get.theme.primaryColor),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    );
                  }
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GetBuilder<LoginController>(builder: (c) {
                  return SizedBox(
                      child: loginController.maxSecond != 0
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: kIsWeb
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                            Text(
                            'Resend OTP Available in ${loginController.maxSecond} s',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ).tr()
                        ],
                      )
                          : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: kIsWeb
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resend OTP Available',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ).tr(),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    loginController.maxSecond = 60;
                                    // loginController.second = 0;
                                    loginController.update();
                                    loginController.timer();
                                    loginController.phoneController.text =
                                        phoneNumber;
                                    global.showOnlyLoaderDialog(context);
                                    loginController.startHeadlessWithWhatsapp('phone');
                                  },
                                  child: Text(
                                    'Resend OTP on SMS',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ).tr(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.only(
                                            left: 25, right: 25)),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Get.theme.primaryColor),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            fontSize: 12,
                                            color: Colors.black)),
                                  ),
                                ),
                              ],
                            )
                          ]));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
