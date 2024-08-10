import 'dart:async';
import 'dart:convert';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';

import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/model/current_user_model.dart';
import 'package:AstrowayCustomer/model/systemFlagModel.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/loginScreen.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/astrologerProfile/astrologerProfile.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/call/incoming_call_request.dart';
import '../views/call/oneToOneVideo/onetooneVideo.dart';
import '../views/chat/incoming_chat_request.dart';

class SplashController extends GetxController {
  APIHelper apiHelper = APIHelper();
  CurrentUserModel? currentUser;
  CurrentUserModel? currentUserPayment;
  String? appShareLinkForLiveSreaming;
  String? version;
  double? totalGst;
  var syatemFlag = <SystemFlag>[];
  String appName = "";
  String currentLanguageCode = 'en';
  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    await getSystemFlag();
    appName = global.getSystemFlagValueForLogin(global.systemFlagNameList.appName);
    global.sp = await SharedPreferences.getInstance();
    currentLanguageCode = global.sp!.getString('currentLanguage') ?? 'en';
    global.sp!.setString('currentLanguage', currentLanguageCode);
    print("currentLanguageinSplash");
    print("${global.sp!.getString('currentLanguage')}");
    update();
    Timer(const Duration(seconds: 5), () async {
      try {
        bool isLogin = await global.isLogin();

        print("isLoginsplashscreen");
        print("${isLogin}");
        if (isLogin) {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          await global.checkBody().then((result) async {
            if (result) {
              await apiHelper.validateSession().then((result) async {
                if (result.status == "200") {
                  currentUser = result.recordList;
                  global.saveUser(currentUser!);
                  global.user = currentUser!;
                  await getCurrentUserData();
                  await global.getCurrentUser();
                  if (global.generalPayload != null) {
                    Map<String, dynamic> convetedPayLoad = json.decode(global.generalPayload);
                    Map<String, dynamic> body = jsonDecode(convetedPayLoad['body']);
                    if (body["notificationType"] == 1) {
                      body['call_type'].toString()=="11"?
                      Get.to(() =>
                      //body['call_type'].toString()=="11"?
                      // OneToOneLiveScreen():
                      OneToOneLiveScreen(
                        channelname: body["channelName"],
                        callId: body["callId"],
                          fcmToken: body["token"],
                        end_time: body['call_duration'].toString(),
                      )):
                      Get.to(() => IncomingCallRequest(
                        astrologerId: body["astrologerId"],
                        astrologerName: body["astrologerName"] == null ? "Astrologer" : body["astrologerName"],
                        astrologerProfile: body["profile"] == null ? "" : body["profile"],
                        token: body["token"],
                        channel: body["channelName"],
                        callId: body["callId"],
                        fcmToken: body["fcmToken"] ?? "",
                        duration: body['call_duration'].toString(),
                      ));
                    } else if (body["notificationType"] == 3) {
                      Get.to(() => IncomingChatRequest(
                          astrologerName: body["astrologerName"] == null ? "Astrologer" : body["astrologerName"],
                          profile: body["profile"] == null ? "" : body["profile"],
                          fireBasechatId: body["firebaseChatId"],
                          chatId: body["chatId"],
                          astrologerId: body["astrologerId"],
                          fcmToken: body["fcmToken"],
                          duration: body['chat_duration'].toString()
                      ));
                    }
                    else if (body["notificationType"] == 4) {
                      print('live astrologer');
                      Get.find<ReviewController>().getReviewData(body["astrologerId"]);
                      await Get.find<BottomNavigationController>().getAstrologerbyId(body["astrologerId"]);
                      Get.to(() => AstrologerProfile(index: 0));
                    } else {
                      print('other notification');

                      BottomNavigationController bottomNavigationController =
                      Get.find<BottomNavigationController>();
                      bottomNavigationController.setIndex(1, 0);
                      Get.off(() => BottomNavigationBarScreen(index: 1));
                    }
                  } else {
                    BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                    bottomNavigationController.setIndex(0, 0);

                    Get.off(() => BottomNavigationBarScreen(index: 0));
                  }
                } else {
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                    version = packageInfo.version;
                    update();
                  });
                  HomeController homeController = Get.find<HomeController>();
                  sp = await SharedPreferences.getInstance();
                  sp!.remove("currentUser");
                  sp!.remove("currentUserId");
                  sp!.remove("token");
                  sp!.remove("tokenType");
                  user = CurrentUserModel();
                  sp!.clear();


                  homeController.myOrders.clear();
                  Get.off(() => LoginScreen());
                }
              });
            }
          });
        }
        else {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          Get.off(() => LoginScreen());
        }
      } catch (e) {
        print('Exception in _inIt():' + e.toString());
      }
    });
  }

  Future<void> createAstrologerShareLink() async {
    try {
      await FlutterShare.share(
        title: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        text: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        linkUrl: '$appShareLinkForLiveSreaming',
      );
    } catch (e) {
      print("Exception - global.dart - referAndEarn():" + e.toString());
    }
  }

  getCurrentUserData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getCurrentUser().then((result) {
            if (result.status == "200") {
              currentUser = result.recordList;
              global.saveUser(currentUser!);
              global.user = currentUser!;
              print('current user profile from splash ${global.user.profile}');
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getCurrentUserData():' + e.toString());
    }
  }

  getSystemFlag() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getSystemFlag().then((result) {
            if (result.status == "200") {
              syatemFlag = result.recordList;
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getSystemFlag():' + e.toString());
    }
  }
}