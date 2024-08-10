import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/customer_support_controller.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/themeController.dart';
import 'package:AstrowayCustomer/firebase_options.dart';
import 'package:AstrowayCustomer/theme/nativeTheme.dart';
import 'package:AstrowayCustomer/utils/FallbackLocalizationDelegate.dart';
import 'package:AstrowayCustomer/utils/binding/networkBinding.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/call/accept_call_screen.dart';
import 'package:AstrowayCustomer/views/call/incoming_call_request.dart';
import 'package:AstrowayCustomer/views/call/oneToOneVideo/onetooneVideo.dart';
import 'package:AstrowayCustomer/views/chat/chat_screen.dart';
import 'package:AstrowayCustomer/views/chat/incoming_chat_request.dart';
import 'package:AstrowayCustomer/views/live_astrologer/live_astrologer_screen.dart';
import 'package:AstrowayCustomer/views/splashScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'controllers/timer_controller.dart';
// import 'com.otpless.otplessflutter.OtplessFlutterPlugin';
// import 'android.content.Intent';

bool isWeb = false;

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final _localNotifications = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  global.sp = await SharedPreferences.getInstance();
  if (global.sp!.getString("currentUser") != null) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    global.generalPayload = json.encode(message.data['body']);
    var messageData;
    if (message.data['body'] != null) {
      messageData = json.decode((message.data['body']));
    }
    if (message.data["title"] ==
        "For starting the timer in other audions for video and audio") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      if (liveController.isImInLive == true) {
        int waitListId = int.parse(message.data["waitListId"].toString());
        String channelName = message.data['channelName'];
        liveController.joinUserName = message.data['name'] ?? "User";
        liveController.joinUserProfile = message.data['profile'] ?? "";
        await liveController.getWaitList(channelName);

        int index5 = liveController.waitList
            .indexWhere((element) => element.id == waitListId);
        if (index5 != -1) {
          liveController.endTime = DateTime.now().millisecondsSinceEpoch +
              1000 * int.parse(liveController.waitList[index5].time);
          liveController.update();
        }
      }
    } else if (message.data["title"] == "For Live accept/reject") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      if (liveController.isImInLive == true) {
        String astroName = message.data["astroName"];
        int astroId = message.data['astroId'] != null
            ? int.parse(message.data['astroId'].toString())
            : 0;
        String channel = message.data['channel'];
        String token = message.data['token'];
        String astrologerProfile = message.data['astroProfile'] ?? "";
        String requestType = message.data['requestType'];
        int id = message.data['id'] != null
            ? int.parse(message.data['id'].toString())
            : 0;
        double charge = message.data['charge'] != null
            ? double.parse(message.data['charge'].toString())
            : 0;
        double videoCallCharge = message.data['videoCallCharge'] != null
            ? double.parse(message.data['videoCallCharge'].toString())
            : 0;
        String astrologerFcmToken =
            message.data['fcmToken'] != null ? message.data['fcmToken'] : "";
        await bottomController.getAstrologerbyId(astroId);
        bool isFollow = bottomController.astrologerbyId[0].isFollow!;
        // not show notification just show dialog for accept/reject for live stream
        liveController.accpetDeclineContfirmationDialogForLiveStreaming(
          astroId: astroId,
          astroName: astroName,
          channel: channel,
          token: token,
          requestType: requestType,
          id: id,
          charge: charge,
          astrologerFcmToken2: astrologerFcmToken,
          astrologerProfile: astrologerProfile,
          videoCallCharge: videoCallCharge,
          isFollow: isFollow,
        );
      }
    } else if (message.data["title"] ==
        "For accepting time while user already splitted") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      int timeInInt = int.parse(message.data["timeInInt"].toString());

      liveController.endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * int.parse(timeInInt.toString());
      liveController.joinUserName = message.data["joinUserName"] ?? "";
      liveController.joinUserProfile = message.data["joinUserProfile"] ?? "";
      liveController.update();
    } else if (message.data["title"] ==
        "Notification for customer support status update") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      var message1 = jsonDecode(message.data['body']);
      if (customerSupportController.isIn) {
        customerSupportController.status = message1["status"] ?? "WAITING";
        customerSupportController.update();
      }
    } else if (message.data["title"] == "End chat from astrologer") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      chatController.showBottomAcceptChat = false;
      global.sp = await SharedPreferences.getInstance();
      global.sp!.remove('chatBottom');
      global.sp!.setInt('chatBottom', 0);
      chatController.chatBottom = false;
      chatController.isAstrologerEndedChat = true;
      chatController.update();
    } else if (message.data["title"] == "Astrologer Leave call") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      callController.showBottomAcceptCall = false;
      global.sp!.remove('callBottom');
      global.sp!.setInt('callBottom', 0);
      callController.callBottom = false;
      callController.update();
    } else if (messageData['notificationType'] == 4) {
      await bottomController.getLiveAstrologerList();
      bottomController.liveAstrologer = bottomController.liveAstrologer;
      bottomController.update();
      if (messageData['isFollow'] == 1) {
        //1 means user follow that astrologer
      } else {
        Future.delayed(Duration(milliseconds: 500)).then((value) async {
          await _localNotifications.cancelAll();
        });
      }
    } else if (messageData['notificationType'] == 3) {
      log('fcm token :- ${messageData["fcmToken"]}');
      chatController.showBottomAcceptChatRequest(
        astrologerId: messageData["astrologerId"],
        chatId: messageData["chatId"],
        astroName: messageData["astrologerName"] == null
            ? "Astrologer"
            : messageData["astrologerName"],
        astroProfile:
            messageData["profile"] == null ? "" : messageData["profile"],
        firebaseChatId: messageData["firebaseChatId"],
        fcmToken: messageData["fcmToken"],
        duration: messageData['call_duration'],
      );
    } else if (messageData['notificationType'] == 1) {
      log('fcmtoken for call:- ${messageData["fcmToken"]}');
      callController.showBottomAcceptCallRequest(
          channelName: messageData["channelName"] ?? "",
          astrologerId: messageData["astrologerId"] ?? 0,
          callId: messageData["callId"],
          token: messageData["token"] ?? "",
          astroName: messageData["astrologerName"] ?? "Astrologer",
          astroProfile: messageData["profile"] ?? "",
          fcmToken: messageData["fcmToken"] ?? "",
          callType: messageData["call_type"],
          duration: messageData['duration']);
    } else if (messageData['notificationType'] == 14) {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      await bottomController.getLiveAstrologerList();
    }
  } else {
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      await _localNotifications.cancelAll();
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    isWeb = true;
    log('is on web running');
  } else {
    isWeb = false;
  }

  //INIT BASED ON PLATFORM
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //   webProvider:
  //       ReCaptchaV3Provider('6LfT6YgpAAAAAF3OI5kEx72bGmhVGybK0c8lPjJ8'),
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.appAttest,
  // );

  await EasyLocalization.ensureInitialized();

  //await Firebase.initializeApp();
  HttpOverrides.global = PostHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  HttpOverrides.global = new MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Get.theme.primaryColor,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('bn', 'IN'),
        Locale('es', 'ES'),
        Locale('gu', 'IN'),
        Locale('kn', 'IN'),
        Locale('ml', 'IN'),
        Locale('mr', 'IN'), //marathi
        Locale('ta', 'IN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
  await fetchLinkData();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

Future fetchLinkData() async {}

BottomNavigationController bottomController =
    Get.put(BottomNavigationController());

LiveController liveController = Get.put(LiveController());
CustomerSupportController customerSupportController =
    Get.put(CustomerSupportController());
ChatController chatController = Get.put(ChatController());
CallController callController = Get.put(CallController());

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Atroguru local notifications',
    'High Importance Notifications for Atroguru',
    importance: Importance.defaultImportance,
  );
  AudioPlayer player = new AudioPlayer();

  @override
  void initState() {
    super.initState();
    //Sent Notification When App is Running || Background Message is Automatically Sent by Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("onMessageRecived");
      if (message.data["title"] == "For Live accept/reject") {
        if (liveController.isImInLive == true) {
          String astroName = message.data["astroName"];
          int astroId = message.data['astroId'] != null
              ? int.parse(message.data['astroId'].toString())
              : 0;
          String channel = message.data['channel'];
          String token = message.data['token'];
          String astrologerProfile = message.data['astroProfile'] ?? "";
          String requestType = message.data['requestType'];
          int id = message.data['id'] != null
              ? int.parse(message.data['id'].toString())
              : 0;
          double charge = message.data['charge'] != null
              ? double.parse(message.data['charge'].toString())
              : 0;
          double videoCallCharge = message.data['videoCallCharge'] != null
              ? double.parse(message.data['videoCallCharge'].toString())
              : 0;
          String astrologerFcmToken =
              message.data['fcmToken'] != null ? message.data['fcmToken'] : "";
          await bottomController.getAstrologerbyId(astroId);
          bool isFollow = bottomController.astrologerbyId[0].isFollow!;
          // not show notification just show dialog for accept/reject for live stream
          liveController.accpetDeclineContfirmationDialogForLiveStreaming(
            astroId: astroId,
            astroName: astroName,
            channel: channel,
            token: token,
            requestType: requestType,
            id: id,
            charge: charge,
            astrologerFcmToken2: astrologerFcmToken,
            astrologerProfile: astrologerProfile,
            videoCallCharge: videoCallCharge,
            isFollow: isFollow,
          );
        }
      } else if (message.data["title"] ==
          "For starting the timer in other audions for video and audio") {
        if (liveController.isImInLive == true) {
          int waitListId = int.parse(message.data["waitListId"].toString());
          String channelName = message.data['channelName'];
          liveController.joinUserName = message.data['name'] ?? "User";
          liveController.joinUserProfile = message.data['profile'] ?? "";
          await liveController.getWaitList(channelName);

          int index5 = liveController.waitList
              .indexWhere((element) => element.id == waitListId);
          if (index5 != -1) {
            liveController.endTime = DateTime.now().millisecondsSinceEpoch +
                1000 * int.parse(liveController.waitList[index5].time);
            liveController.update();
          }
        }
      } else if (message.data["title"] ==
          "For accepting time while user already splitted") {
        int timeInInt = int.parse(message.data["timeInInt"].toString());
        liveController.endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * int.parse(timeInInt.toString());
        liveController.joinUserName = message.data["joinUserName"] ?? "";
        liveController.joinUserProfile = message.data["joinUserProfile"] ?? "";
        liveController.update();
      } else if (message.data["title"] ==
          "Notification for customer support status update") {
        var message1 = jsonDecode(message.data['body']);
        if (customerSupportController.isIn) {
          customerSupportController.status = message1["status"] ?? "WAITING";
          customerSupportController.update();
        }
      } else if (message.data["title"] == "End chat from astrologer") {
        chatController.showBottomAcceptChat = false;
        global.sp = await SharedPreferences.getInstance();
        global.sp!.remove('chatBottom');
        global.sp!.setInt('chatBottom', 0);
        chatController.chatBottom = false;
        chatController.isAstrologerEndedChat = true;
        chatController.update();
      } else if (message.data["title"] == "Astrologer Leave call") {
        callController.showBottomAcceptCall = false;
        global.sp!.remove('callBottom');
        global.sp!.setInt('callBottom', 0);
        callController.callBottom = false;
        callController.update();
      } else {
        try {
          if (message.data.isNotEmpty) {
            var messageData = json.decode((message.data['body']));
            if (messageData['notificationType'] != null) {
              if (messageData['notificationType'] == 3) {
                await player.setSource(AssetSource('ringtone.mp3'));
                await player.resume();
                showDialog(
                    context: Get.context!,
                    barrierDismissible:
                        false, // user must tap button for close dialog!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        content: Container(
                          height: 170,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: messageData["profile"] == ""
                                    ? Image.asset(
                                        Images.deafultUser,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 40,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            '${global.imgBaseurl}${messageData["profile"]}',
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            CircleAvatar(
                                                radius: 48,
                                                backgroundImage: imageProvider),
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          Images.deafultUser,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 40,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "${message.data["title"]}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        global.showOnlyLoaderDialog(context);
                                        await chatController.rejectedChat(
                                            int.parse(messageData["chatId"]
                                                .toString()));
                                        global.hideLoader();
                                        global
                                            .callOnFcmApiSendPushNotifications(
                                                fcmTokem: [
                                              messageData["fcmToken"]
                                            ],
                                                title:
                                                    'End chat from customer');
                                        BottomNavigationController
                                            bottomNavigationController =
                                            Get.find<
                                                BottomNavigationController>();
                                        bottomNavigationController.setIndex(
                                            0, 0);
                                        Get.back();
                                        Get.to(() => BottomNavigationBarScreen(
                                              index: 0,
                                            ));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            "Reject",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ).tr(),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await _localNotifications.cancelAll();
                                        global.showOnlyLoaderDialog(context);
                                        await chatController.acceptedChat(
                                            int.parse(messageData["chatId"]
                                                .toString()));
                                        global
                                            .callOnFcmApiSendPushNotifications(
                                                fcmTokem: [
                                              messageData["fcmToken"]
                                            ],
                                                title:
                                                    'Start simple chat timer');
                                        global.hideLoader();
                                        chatController.isInchat = true;
                                        chatController.isEndChat = false;
                                        TimerController timerController =
                                            Get.find<TimerController>();
                                        timerController.startTimer();
                                        chatController.update();
                                        await player.stop();
                                        chatController.isAstrologerEndedChat ==
                                                true
                                            ? global.showToast(
                                                message:
                                                    'Astrologer ended chat',
                                                textColor: global.textColor,
                                                bgColor:
                                                    global.toastBackGoundColor,
                                              )
                                            : Get.to(() => AcceptChatScreen(
                                                  flagId: 1,
                                                  astrologerName: messageData[
                                                              "astrologerName"] ==
                                                          null
                                                      ? "Astrologer"
                                                      : messageData[
                                                          "astrologerName"],
                                                  profileImage: messageData[
                                                              "profile"] ==
                                                          null
                                                      ? ""
                                                      : messageData["profile"]
                                                          .toString(),
                                                  fireBasechatId: messageData[
                                                          "firebaseChatId"]
                                                      .toString(),
                                                  astrologerId: messageData[
                                                      "astrologerId"],
                                                  chatId: messageData["chatId"],
                                                  fcmToken:
                                                      messageData["fcmToken"],
                                                  duration: messageData[
                                                          'chat_duration']
                                                      .toString(),
                                                ));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ).tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actionsPadding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                      );
                    });
                chatController.showBottomAcceptChatRequest(
                  astrologerId: messageData["astrologerId"],
                  chatId: messageData["chatId"],
                  astroName: messageData["astrologerName"] == null
                      ? "Astrologer"
                      : messageData["astrologerName"],
                  astroProfile: messageData["profile"] == null
                      ? ""
                      : messageData["profile"],
                  firebaseChatId: messageData["firebaseChatId"],
                  fcmToken: messageData["fcmToken"],
                  duration: messageData['call_duration'],
                );
                foregroundNotification(message, messageData['icon']);
                await FirebaseMessaging.instance
                    .setForegroundNotificationPresentationOptions(
                        alert: true, badge: true, sound: true);
                log("check4");
              } else if (messageData['notificationType'] == 1) {
                await player.setSource(AssetSource('ringtone.mp3'));
                await player.resume();
                showDialog(
                    context: Get.context!,
                    barrierDismissible:
                        false, // user must tap button for close dialog!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        content: Container(
                          height: 180,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: messageData["profile"] == ""
                                    ? Image.asset(
                                        Images.deafultUser,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 40,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            '${global.imgBaseurl}${messageData["profile"]}',
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            CircleAvatar(
                                                radius: 48,
                                                backgroundImage: imageProvider),
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          Images.deafultUser,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 40,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "${message.data["title"]}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        global.showOnlyLoaderDialog(context);
                                        await chatController.rejectedChat(
                                            messageData["callId"]);
                                        global.hideLoader();
                                        global
                                            .callOnFcmApiSendPushNotifications(
                                                fcmTokem: [
                                              messageData["fcmToken"]
                                            ],
                                                title:
                                                    'End chat from customer');
                                        BottomNavigationController
                                            bottomNavigationController =
                                            Get.find<
                                                BottomNavigationController>();
                                        await player.stop();
                                        bottomNavigationController.setIndex(
                                            0, 0);
                                        Get.to(() => BottomNavigationBarScreen(
                                              index: 0,
                                            ));
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            "Reject",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ).tr(),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await _localNotifications.cancelAll();
                                        if (messageData['call_type']
                                                .toString() ==
                                            "11") {
                                          Get.to(() =>
                                              //body['call_type'].toString()=="11"?
                                              // OneToOneLiveScreen():
                                              OneToOneLiveScreen(
                                                channelname:
                                                    messageData["channelName"],
                                                callId: messageData["callId"],
                                                fcmToken: messageData["token"]
                                                    .toString(),
                                                end_time:
                                                    messageData['call_duration']
                                                        .toString(),
                                              ));
                                        } else {
                                          global.showOnlyLoaderDialog(context);
                                          await callController.acceptedCall(
                                              messageData["callId"]);
                                          global.hideLoader();
                                          Get.to(() => AcceptCallScreen(
                                                astrologerId:
                                                    messageData["astrologerId"],
                                                astrologerName: messageData[
                                                            "astrologerName"] ==
                                                        null
                                                    ? "Astrologer"
                                                    : messageData[
                                                        "astrologerName"],
                                                astrologerProfile: messageData[
                                                            "profile"] ==
                                                        null
                                                    ? ""
                                                    : messageData["profile"],
                                                token: messageData["token"],
                                                callChannel:
                                                    messageData["channelName"],
                                                callId: messageData["callId"],
                                                duration:
                                                    messageData['call_duration']
                                                        .toString(),
                                              ));
                                        }
                                        await player.stop();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ).tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actionsPadding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                      );
                    });

                callController.showBottomAcceptCallRequest(
                    channelName: messageData["channelName"] ?? "",
                    astrologerId: messageData["astrologerId"] ?? 0,
                    callId: messageData["callId"],
                    token: messageData["token"] ?? "",
                    astroName: messageData["astrologerName"] ?? "Astrologer",
                    astroProfile: messageData["profile"] ?? "",
                    fcmToken: messageData["fcmToken"] ?? "",
                    callType: messageData['call_type'],
                    duration: messageData['duration']);
                foregroundNotification(message, messageData['icon']);
                await FirebaseMessaging.instance
                    .setForegroundNotificationPresentationOptions(
                        alert: true, badge: true, sound: true);
              } else if (messageData['notificationType'] == 4) {
                await bottomController.getLiveAstrologerList();
                if (messageData['isFollow'] == 1) {
                  //1 means user follow that astrologer
                  foregroundNotification(message, messageData['icon']);
                  await FirebaseMessaging.instance
                      .setForegroundNotificationPresentationOptions(
                          alert: true, badge: true, sound: true);
                }
              } else if (messageData['notificationType'] == 14) {
                await bottomController.getLiveAstrologerList();
              } else {
                foregroundNotification(message, messageData['icon']);
                await FirebaseMessaging.instance
                    .setForegroundNotificationPresentationOptions(
                        alert: true, badge: true, sound: true);
              }
              if (messageData['notificationType'] == 4) {
              } else if (messageData['notificationType'] == 14) {
              } else {
                foregroundNotification(message, messageData['']);
                await FirebaseMessaging.instance
                    .setForegroundNotificationPresentationOptions(
                        alert: true, badge: true, sound: true);
              }
            } else {
              foregroundNotification(message, messageData['icon']);
              await FirebaseMessaging.instance
                  .setForegroundNotificationPresentationOptions(
                      alert: true, badge: true, sound: true);
            }
          } else {
            foregroundNotification(
                message, json.decode((message.data['body']))['icon'] ?? "");
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
                    alert: true, badge: true, sound: true);
          }
        } catch (e) {
          foregroundNotification(
              message, json.decode((message.data['body']))['icon'] ?? "");
          await FirebaseMessaging.instance
              .setForegroundNotificationPresentationOptions(
                  alert: true, badge: true, sound: true);
        }
      }
    });
    //Perform On Tap Operation On Notification Click when app is in backgroud Or in Kill Mode
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onSelectNotification(json.encode(message.data));
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        global.generalPayload = json.encode(message.data);
      }
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> foregroundNotification(
      RemoteMessage payload, String imageUrl) async {
    final String? largeIconPath =
        await _downloadAndSaveFile("${imgBaseurl}${imageUrl}", 'largeIcon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        return;
      },
    );
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initialSetting = InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      onSelectNotification(json.encode(payload.data));
    });

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channel.id, channel.name,
        importance: Importance.max,
        priority: Priority.high,
        icon: "@mipmap/ic_launcher",
        playSound: true,
        largeIcon: FilePathAndroidBitmap(largeIconPath!)
        // styleInformation: BigPictureStyleInformation(
        //   FilePathAndroidBitmap("assets/images/whatsapp.png"), // Big image (Android-specific)
        // ),
        );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
    
      await flutterLocalNotificationsPlugin.show(
        0,
        payload.data["title"],
        payload.data["description"],
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    }
  }

  Future<void> onSelectNotification(String payload) async {
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      Map<dynamic, dynamic> messageData;
      try {
        messageData = json.decode(payload);
        Map<dynamic, dynamic> body;
        body = jsonDecode(messageData['body']);
        log("onNotification click");
        log("${body["notificationType"]}");
        log("${body}");
        if (body["notificationType"] == 1) {
          await player.stop();
          body['call_type'].toString() == "11"
              ? Get.to(() => OneToOneLiveScreen(
                    channelname: body["channelName"],
                    callId: body["callId"],
                    fcmToken: body["token"],
                    end_time: body['call_duration'].toString(),
                  ))
              : Get.to(() => IncomingCallRequest(
                    astrologerId: body["astrologerId"],
                    astrologerName: body["astrologerName"] == null
                        ? "Astrologer"
                        : body["astrologerName"],
                    astrologerProfile:
                        body["profile"] == null ? "" : body["profile"],
                    token: body["token"],
                    channel: body["channelName"],
                    callId: body["callId"],
                    fcmToken: body["fcmToken"] ?? "",
                    duration: body['call_duration'].toString(),
                  ));
        } else if (body["notificationType"] == 3) {
          await player.stop();
          if (chatController.isAstrologerEndedChat == true) {
            global.showToast(
              message: 'Astrologer ended chat',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            Get.to(() => IncomingChatRequest(
                  astrologerName: body["astrologerName"] == null
                      ? "Astrologer"
                      : body["astrologerName"],
                  profile: body["profile"] == null ? "" : body["profile"],
                  fireBasechatId: body["firebaseChatId"],
                  chatId: body["chatId"],
                  astrologerId: body["astrologerId"],
                  fcmToken: body["fcmToken"],
                  duration: body['chat_duration'].toString(),
                ));
          }
        } else if (body["notificationType"] == 4) {
          String? token = body['token'].toString();
          String channelName = body["channelName"].toString();
          // token = await bottomController.getTokenFromChannelName(channelName);
          String astrologerName = body["name"].toString();
          int astrologerId = int.parse(body["astrologerId"].toString());
          double charge = double.parse(body["charge"].toString());
          double videoCallCharge =
              double.parse(body["videoCallRate"].toString());
          bottomController.anotherLiveAstrologers = bottomController
              .liveAstrologer
              .where((element) => element.astrologerId != astrologerId)
              .toList();
          bottomController.update();
          await liveController.getWaitList(channelName);
          int index2 = liveController.waitList
              .indexWhere((element) => element.userId == global.currentUserId);
          if (index2 != -1) {
            liveController.isImInWaitList = true;
            liveController.update();
          } else {
            liveController.isImInWaitList = false;
            liveController.update();
          }
          liveController.isImInLive = true;
          liveController.isJoinAsChat = false;
          liveController.isLeaveCalled = false;
          await bottomController.getAstrologerbyId(astrologerId);
          bool isFollow = bottomController.astrologerbyId[0].isFollow!;
          liveController.update();
          Get.to(() => LiveAstrologerScreen(
                token: token,
                channel: channelName,
                astrologerName: astrologerName,
                astrologerId: astrologerId,
                isFromHome: true,
                charge: charge,
                isForLiveCallAcceptDecline: false,
                videoCallCharge: videoCallCharge,
                isFollow: isFollow,
              ));
        } else {
          print('other notification');
          BottomNavigationController bottomNavigationController =
              Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(1, 0);
          Get.off(() => BottomNavigationBarScreen(index: 1));
        }
      } catch (e) {
        print(
          'Exception in onSelectNotification main.dart:- ${e.toString()}',
        );
      }
    }
  }

  // final String apiKey = "AIzaSyDwps2hHZbsri0yg4NPUYdQoj5BOsZmWK0";

  ThemeController themeController = Get.put(ThemeController());
  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<SplashController>(builder: (s) {
        return ResponsiveSizer(
          builder: (context, orientation, deviceType) {
            return GetMaterialApp(
              navigatorKey: Get.key,
              debugShowCheckedModeBanner: false,
              enableLog: true,
              theme: nativeTheme(),
              initialBinding: NetworkBinding(),
              locale: context.locale,
              localizationsDelegates: [
                ...context.localizationDelegates,
                FallbackLocalizationDelegate()
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('hi', 'IN'),
                Locale('bn', 'IN'),
                Locale('es', 'ES'),
                Locale('gu', 'IN'),
                Locale('kn', 'IN'),
                Locale('ml', 'IN'),
                Locale('mr', 'IN'), //marathi
                Locale('ta', 'IN'),
              ],
              title: 'Astroway CustomerApp',
              initialRoute: "SplashScreen",
              home: SplashScreen(),
            );
          },
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
