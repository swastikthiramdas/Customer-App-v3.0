// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:AstrowayCustomer/controllers/dropDownController.dart';
import 'package:AstrowayCustomer/controllers/kundliMatchingController.dart';
import 'package:AstrowayCustomer/model/getPdfKundali_model.dart';
import 'package:AstrowayCustomer/model/getPdfPrice_model.dart';
import 'package:AstrowayCustomer/model/kundli.dart';
import 'package:AstrowayCustomer/model/kundliBasicDetailMode.dart';
import 'package:AstrowayCustomer/model/kundli_model.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class KundliController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  TextEditingController birthKundliPlaceController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editGenderController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  String? selectedTime;
  double? lat;
  double? long;
  double? timeZone;
  var pdf = pw.Document();

  String emptyScreenText = "You haven\'t added any kundli yet!";

  bool isDisable = true;
  bool isTimeOfBirthKnow = false;
  bool isSelectedLanEng = true;
  bool isSelectedLanHin = false;
  bool isNorthIn = true;
  bool isSouthIn = false;
  bool isShowMore = false;
  bool isDataTable = false;
  int kundliTabInitialIndex = 5;

  var kundliList = <KundliModel>[];
  var kundaliBasicList = <KundliBasicModel>[];
  var searchKundliList = <KundliModel>[];
  KundliBasicDetail? kundliBasicDetail;
  KundliBasicPanchangDetail? kundliBasicPanchangDetail;
  KundliAvakhdaDetail? kundliAvakhadaDetail;
  KundliPlanetsDetail? kundliPlanetsDetail;
  GemstoneModel? gemstoneList;
  DropDownController dropDownController = Get.find<DropDownController>();
  List<List<VimshattariModel>>? vimshattariList = [];
  var planetList = [];
  TabController? tabController;
  KundliPlanetsDetail sunDetails = KundliPlanetsDetail();
  KundliPlanetsDetail moonDetails = KundliPlanetsDetail();
  KundliPlanetsDetail marsDetails = KundliPlanetsDetail();
  KundliPlanetsDetail mercuryDetails = KundliPlanetsDetail();
  KundliPlanetsDetail jupiterDetails = KundliPlanetsDetail();
  KundliPlanetsDetail venusDetails = KundliPlanetsDetail();
  KundliPlanetsDetail saturnDetails = KundliPlanetsDetail();
  KundliPlanetsDetail rahuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ketuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ascendantDetails = KundliPlanetsDetail();
  bool? isSadesati;
  bool? isKalsarpa;
  String? generalDesc;
  GetPdfKundaliModel? pdfKundaliData;
  GetPdfPrice? pdfPriceData;

  List _kundaliData = [];
  List get kundaliData => _kundaliData;
  int startHouse = 0;

  List name = [];

  APIHelper apiHelper = new APIHelper();
  String prefix = '';
  List<KundliGender> gender = [
    KundliGender(title: 'Male', isSelected: false, image: Images.male),
    KundliGender(title: 'Female', isSelected: false, image: Images.female),
    KundliGender(title: 'Other', isSelected: false, image: Images.otherGender),
  ];
  int initialIndex = 0;
  List kundliTitle = [
    'Hey there! \nWhat is Your name ?',
    'What is your gender?',
    'Enter your birth date',
    'Enter your birth time',
    'Where were you born?'
  ];
  List<Kundli> listIcon = [
    Kundli(icon: Icons.person, isSelected: true),
    Kundli(icon: Icons.search, isSelected: false),
    Kundli(icon: Icons.calendar_month, isSelected: false),
    Kundli(icon: Icons.punch_clock_outlined, isSelected: false),
    Kundli(icon: Icons.location_city, isSelected: false),
  ];

  List<KundliDetailTab> reportTab = [
    KundliDetailTab(title: 'General', isSelected: true),
    // KundliDetailTab(title: 'Planetary', isSelected: false),
    // KundliDetailTab(title: 'Vimshottari Dasha', isSelected: false),
    // KundliDetailTab(title: 'Yoga', isSelected: false),
  ];

  // List<KundliDetailTab> remediesTab = [KundliDetailTab(title: 'Rudraksha', isSelected: true), KundliDetailTab(title: 'Gemstones', isSelected: false)];
  List<KundliDetailTab> remediesTab = [
    KundliDetailTab(title: 'Gemstones', isSelected: false)
  ];
  List<KundliDetailTab> rudrakshaTab = [
    KundliDetailTab(title: '3-Mukhi', isSelected: true),
    KundliDetailTab(title: '12-Mukhi', isSelected: false),
    KundliDetailTab(title: '11-Mukhi', isSelected: false),
  ];
  List<KundliDetailTab> doshaTab = [
    KundliDetailTab(title: 'Manglik', isSelected: true),
    KundliDetailTab(title: 'Kalsarpa', isSelected: false),
    KundliDetailTab(title: 'Sadesati', isSelected: false),
  ];

  // List<KundliDetailTab> dashaTab = [KundliDetailTab(title: 'Vimshattari', isSelected: true), KundliDetailTab(title: 'Yogini', isSelected: false)];
  List<KundliDetailTab> dashaTab = [
    KundliDetailTab(title: 'Vimshattari', isSelected: true)
  ];

  List<KundliDetailTab> ashtakvargaTab = [
    KundliDetailTab(title: 'Sav', isSelected: true),
    KundliDetailTab(title: 'Asc', isSelected: false),
    KundliDetailTab(title: 'jupiter', isSelected: false),
    KundliDetailTab(title: 'Mars', isSelected: false),
    KundliDetailTab(title: 'Mercury', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Saturn', isSelected: false),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Venus', isSelected: false)
  ];

  List<KundliDetailTab> divisionalTab = [
    KundliDetailTab(title: 'Chalit', isSelected: true),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Hora(D-2)', isSelected: false),
    KundliDetailTab(title: 'Drekkana(D-3)', isSelected: false),
    KundliDetailTab(title: 'Chaturthamsa(D-4)', isSelected: false),
    KundliDetailTab(title: 'Scaptamsa(D-7)', isSelected: false),
    KundliDetailTab(title: 'Dasamsa(D-10)', isSelected: false),
    KundliDetailTab(title: 'Dwadasamsa(D-12)', isSelected: false),
    KundliDetailTab(title: 'Shodasamsa(D-16)', isSelected: false),
    KundliDetailTab(title: 'Vimsamsa(D-20)', isSelected: false),
    KundliDetailTab(title: 'Chaturvimsamsa', isSelected: false),
    KundliDetailTab(title: 'Saptavisamsa', isSelected: false),
    KundliDetailTab(title: 'Trimsamsa(D-30)', isSelected: false),
    KundliDetailTab(title: 'Khavedamsa(D-40)', isSelected: false),
    KundliDetailTab(title: 'Akshavedamsa(D-45)', isSelected: false),
    KundliDetailTab(title: 'Shastiamsa(D-60)', isSelected: false)
  ];

  List<KundliDetailTab> chartKundliTab = [
    KundliDetailTab(title: 'General', isSelected: true),
    KundliDetailTab(title: 'Planetary', isSelected: false),
    KundliDetailTab(title: 'Yoga', isSelected: false),
  ];
  List<KundliDetailTab> planetTab = [
    KundliDetailTab(title: 'Sign', isSelected: true),
    KundliDetailTab(title: 'Nakshatra', isSelected: false)
  ];
  List<KundliDetails> basicDetails = [
    KundliDetails(title: 'Name', value: 'Yami'),
    KundliDetails(title: 'Date', value: '02 january 1996'),
    KundliDetails(title: 'Time', value: '01:46 PM'),
    KundliDetails(title: 'Place', value: 'New Delhi,Delhi,india'),
    KundliDetails(title: 'Latitude', value: '28.64'),
    KundliDetails(title: 'Longitude', value: '77.22'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
    KundliDetails(title: 'Ayanamsha', value: '23.80117'),
  ];
  List<KundliDetails> panchangDetails = [
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Karan', value: 'Vishti'),
    KundliDetails(title: 'Yog', value: 'Sadhya'),
    KundliDetails(title: 'Nakshtra', value: 'Krittika'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
  ];

  List<KundliDetails> avakhadaDetails = [
    KundliDetails(title: 'Varna', value: 'Kshattriya'),
    KundliDetails(title: 'Vashya', value: 'Chatushpada'),
    KundliDetails(title: 'Yoni', value: 'Chaga'),
    KundliDetails(title: 'GAn', value: 'NewRakshasa'),
    KundliDetails(title: 'Nadi', value: 'Antya'),
    KundliDetails(title: 'Sign', value: 'Aries'),
    KundliDetails(title: 'Sign Lord', value: 'Mars'),
    KundliDetails(title: 'Nakshatra-charan', value: 'Krittika'),
    KundliDetails(title: 'Yog', value: 'Dashya'),
    KundliDetails(title: 'Karan', value: 'Cishti'),
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Tatva', value: 'Fire'),
    KundliDetails(title: 'Name alphabet', value: 'S'),
    KundliDetails(title: 'Paya', value: 'Iron'),
  ];
  List<Widget> screens = [
    // BasicKundliScreen(),
    // ChartsScreen(),
    // KPScreen(),
    // AshtakvargaScreen(),
    // KundliDashaScreen(),
    // KundliReportScreen(),
  ];

  final List<Map<String, String>> listOfVishattari = [
    {"planet": "SU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "MO", "start": "6-Jun-2000", "end": "16-Feb-2001"},
    {"planet": "MA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "RA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "JU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "SA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "ME", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "VE", "start": "16-Feb-1996", "end": "16-Feb-1998"},
  ];

  final List<Map<String, String>> listOfPlanets = [
    {
      "planet": "SU",
      "cups": "6",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "planet": "Moon",
      "cups": "4",
      "sign": "Libra",
      "signLord": "sa",
      "starLord": "Ve",
      "subLord": "Ve"
    },
    {
      "planet": "Mars",
      "cups": "2",
      "sign": "Libra",
      "signLord": "Ju",
      "starLord": "Me",
      "subLord": "Ma"
    },
    {
      "planet": "Rahu",
      "cups": "6",
      "sign": "Gemni",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "planet": "Jupiter",
      "cups": "10",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Sa",
      "subLord": "Ra"
    },
    {
      "planet": "Saturn",
      "cups": "1",
      "sign": "Libra",
      "signLord": "Me",
      "starLord": "Ma",
      "subLord": "Sa"
    },
    {
      "planet": "Mercury",
      "cups": "12",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "planet": "Ketu",
      "cups": "1",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Su"
    },
    {
      "planet": "Venus",
      "cups": "6",
      "sign": "Libra",
      "signLord": "Ma",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "planet": "Neptune",
      "cups": "10",
      "sign": "Aries",
      "signLord": "Ve",
      "starLord": "Ju",
      "subLord": "Ju"
    },
    {
      "planet": "Uranus",
      "cups": "8",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "planet": "Pluto",
      "cups": "7",
      "sign": "capricorn",
      "signLord": "Me",
      "starLord": "Ju",
      "subLord": "Me"
    },
  ];
  final List<Map<String, String>> listOfCups = [
    {
      "cups": "1",
      "degree": "9.86",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "cups": "2",
      "degree": "40.6",
      "sign": "Libra",
      "signLord": "sa",
      "starLord": "Ve",
      "subLord": "Ve"
    },
    {
      "cups": "3",
      "degree": "65.16",
      "sign": "Libra",
      "signLord": "Ju",
      "starLord": "Me",
      "subLord": "Ma"
    },
    {
      "cups": "4",
      "degree": "88.66",
      "sign": "Gemni",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "cups": "5",
      "degree": "111.26",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Sa",
      "subLord": "Ra"
    },
    {
      "cups": "6",
      "degree": "88.61",
      "sign": "Libra",
      "signLord": "Me",
      "starLord": "Ma",
      "subLord": "Sa"
    },
    {
      "cups": "7",
      "degree": "115.12",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "cups": "8",
      "degree": "116.21",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Su"
    },
    {
      "cups": "9",
      "degree": "116.26",
      "sign": "Libra",
      "signLord": "Ma",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "cups": "10",
      "degree": "210.67",
      "sign": "Aries",
      "signLord": "Ve",
      "starLord": "Ju",
      "subLord": "Ju"
    },
    {
      "cups": "11",
      "degree": "278.99",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me"
    },
    {
      "cups": "12",
      "degree": "328.90",
      "sign": "capricorn",
      "signLord": "Me",
      "starLord": "Ju",
      "subLord": "Me"
    },
  ];
  final List<Map<String, String>> listOfPlanetsSign = [
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "Venus",
      "sign": "Aries",
      "signLord": "Jupiter",
      "degree": "22 \u00b0",
      "house": "11"
    },
    {
      "planet": "Ascendant",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "9"
    },
    {
      "planet": "Moon",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "10"
    },
    {
      "planet": "Ascendant",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "Venus",
      "sign": "Aries",
      "signLord": "Jupiter",
      "degree": "22 \u00b0",
      "house": "8"
    },
    {
      "planet": "Rahu",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "Rahu",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "Ketu",
      "sign": "Capricorn",
      "signLord": "Saturn",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Saturn",
      "degree": "22 \u00b0",
      "house": "7"
    },
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1"
    },
    {
      "planet": "pluto",
      "sign": "Scorpio",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "10"
    },
  ];
  DateTime editDOB = DateTime.now();
  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 6);
    // birthPlaceController.text = 'New Delhi, Delhi, India';
    _init();
    //getKundliList();
    super.onInit();
  }

  _init() async {

    await getKundliList();
  }

  backStepForCreateKundli(int index) {
    initialIndex = index;
  }

  updateIcon(index) {
    listIcon[index].isSelected = true;
    for (int i = 0; i < listIcon.length; i++) {
      if (i == index) {
        listIcon[index].isSelected = true;
        continue;
      } else {
        listIcon[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectTab(index) {
    reportTab[index].isSelected = true;
    for (int i = 0; i < reportTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        reportTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  shareKundli(String pdfLink) async {
    try {
      await FlutterShare.share(
              title:
                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
              text:
                  "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career.Check my Kundali with .You should also try and see your Kundali ! $pdfLink")
          .then((value) {})
          .catchError((e) {
        print("ajsndkjns");
        print(e);
      });
    } catch (e) {
      print('Excpetion in share kundli $e');
    }
  }

  selectRemediesTab(int index) {
    remediesTab[index].isSelected = true;
    for (int i = 0; i < remediesTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        remediesTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectRudrakshaTab(index) {
    rudrakshaTab[index].isSelected = true;
    for (int i = 0; i < rudrakshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        rudrakshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDoshaTab(int index) {
    doshaTab[index].isSelected = true;
    for (int i = 0; i < doshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        doshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDashaTab(int index) {
    dashaTab[index].isSelected = true;
    for (int i = 0; i < dashaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        dashaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectashtakvargaTab(int index) {
    ashtakvargaTab[index].isSelected = true;
    for (int i = 0; i < ashtakvargaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        ashtakvargaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDivisionTab(int index) {
    divisionalTab[index].isSelected = true;
    for (int i = 0; i < divisionalTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        divisionalTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectPlanetTab(int index) {
    planetTab[index].isSelected = true;
    for (int i = 0; i < planetTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        planetTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectChartKundliTab(int index) {
    chartKundliTab[index].isSelected = true;
    for (int i = 0; i < chartKundliTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        chartKundliTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateBg(int index) {
    selectedGender = gender[index].title;
    for (int i = 0; i < gender.length; i++) {
      if (i == index) {
        continue;
      } else {
        gender[i].isSelected = false;
      }
    }
    gender[index].isSelected = true;
    update();
  }

  updateAllBg() {
    for (int i = 0; i < gender.length; i++) {
      gender[i].isSelected = false;
    }

    update();
  }

  updateIsDisable() {
    // ignore: unrelated_type_equality_checks
    if (userNameController.text != "") {
      isDisable = false;
      update();
    } else {
      isDisable = true;
      update();
    }
  }

  updateCheck(value) {
    isTimeOfBirthKnow = value;
    update();
  }

  updateInitialIndex() {
    if (initialIndex < 5) {
      initialIndex = initialIndex + 1;
    } else {
      initialIndex = 0;
    }
    update();
  }

  updateListIndex(int index) {
    if (index < 5) {
      index += 1;
    } else {
      index = 0;
    }
  }

  langugeUpdate({required bool isEng, required bool isHin}) {
    isSelectedLanEng = isEng;
    isSelectedLanHin = isHin;
    update();
  }

  northSouthUpdate({required bool isNorth, required bool isSouth}) {
    isNorthIn = isNorth;
    isSouthIn = isSouth;
    update();
  }

  changeTapIndex(int index) {
    kundliTabInitialIndex = index;
    update();
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  String? dropDownGender;
  List item = ['Male', 'Female', 'Other'];
  String innitialValue(int callId, List<String> item) {
    if (callId == 1) {
      return dropDownGender ?? item[0];
    } else {
      return 'no data';
    }
  }

  void genderChoose(String value) {
    dropDownGender = value;
    update();
  }

  getKundliList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundli().then((result) {
            if (result.status == "200") {
              kundliList = result.recordList;
              searchKundliList = kundliList;
              print("getKundaliList");
              print("${searchKundliList[0].latitude}");
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'FAil to get kundli',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  Future<int> pdfPrice() async {
    int value = 0;
    try {
      await apiHelper.getPdfPrice().then((result) {
        print("getKundaliPrice");
        print("${result.recordList}");
        print("${result.status}");
        if (result.status == "200") {
          Map<String, dynamic> data = jsonDecode(result.recordList);
          pdfPriceData = GetPdfPrice.fromJson(data);
          print("getKundaliPrice");
          print("${pdfPriceData!.recordList}");
          value = 1;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          value = 0;
          // pdfKundaliData=null;
        }
      });
    } catch (e) {
      print("getpdfprice():- $e");
      value = 0;
    }
    return value;
  }

  Future pdfKundali(String id) async {
    try {
      await apiHelper.getPdfKundli(id).then((result) {
        if (result.status == "200") {
          Map<String, dynamic> data = jsonDecode(result.recordList);
          pdfKundaliData = GetPdfKundaliModel.fromJson(data);
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getpdfKundali():- $e");
    }
  }

  getKundliListById(int index) async {
    try {
      editNameController.text = searchKundliList[index].name;
      editBirthDateController.text = formatDate(
          searchKundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      editBirthTimeController.text =
          searchKundliList[index].birthTime.toString();
      editBirthPlaceController.text =
          searchKundliList[index].birthPlace.toString();
      editDOB = searchKundliList[index].birthDate;
      update();
      genderChoose(searchKundliList[index].gender);
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  String? userName;
  getName(String text) {
    userName = text;
    update();
  }

  getselectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  getSelectedTime(DateTime date) {
    selectedTime = DateFormat.Hm().format(date);
    update();
  }

  addKundliData(String pdfType,int amount) async {
    List<KundliModel> kundliModel = [
      KundliModel(
          name: userName!,
          gender: selectedGender!,
          birthDate: selectedDate ?? DateTime(1996),
          birthTime: selectedTime ?? DateFormat.jm().format(DateTime.now()),
          birthPlace: birthKundliPlaceController.text,
          latitude: lat,
          longitude: long,
          timezone: timeZone,
          pdf_type: pdfType,
        forMatch: 0,
          lang: dropDownController.kundaliLang.toString()=="English"?'en':(
              dropDownController.kundaliLang.toString()=="Tamil"?'ta':(
                  dropDownController.kundaliLang.toString()=="Kannada"?'ka':
                  (
                      dropDownController.kundaliLang.toString()=="Telugu"?'te':
                      (
                          dropDownController.kundaliLang.toString()=="Hindi"?'hi':
                          (
                              dropDownController.kundaliLang.toString()=="Malayalam"?'ml':
                              (
                                  dropDownController.kundaliLang.toString()=="Spanish"?'sp':
                                  (
                                      dropDownController.kundaliLang.toString()=="French"?'fr':'en'
                                  )
                              )
                          )
                      )
                  )
              )
          )

      )
    ];
    print("languageselect");
    print("${dropDownController.kundaliLang.toString()}");
    update();

    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.addKundli(kundliModel,amount,false).then((result) {
          if (result.status == "200") {
            print('success');
          } else {
            global.showToast(
              message: 'Failed to create kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getGeoCodingLatLong(
      {double? latitude,
      double? longitude,
      int? flagId,
      KundliMatchingController? kundliMatchingController}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .geoCoding(lat: latitude, long: longitude)
              .then((result) {
            if (result.status == "true") {
              if (flagId == 1) {
                kundliMatchingController!.boyTimezone =
                    double.parse(result.recordList['timezone'].toString());
                kundliMatchingController.update();
              } else if (flagId == 2) {
                kundliMatchingController!.girlTimezone =
                    double.parse(result.recordList['timezone'].toString());
                kundliMatchingController.update();
              } else {
                timeZone =
                    double.parse(result.recordList['timezone'].toString());
              }

              print("timezone");
              print("$timeZone");
              update();
            } else {
              global.showToast(
                message: 'NOt Avalilable',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getGeoCodingLatLong():' + e.toString());
    }
  }

  DateTime? pickedDate;
  updateKundliData(int id) async {
    KundliModel kundliModel = KundliModel(
      name: editNameController.text,
      gender: dropDownGender!,
      birthDate: pickedDate ?? editDOB,
      birthTime: editBirthTimeController.text,
      birthPlace: editBirthPlaceController.text,
      latitude: lat,
      longitude: long,
    );
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateKundli(id, kundliModel).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Your kundli has been updated',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Failed to update kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  deleteKundli(int id) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteKundli(id).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Deleted Successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Deleted Fail',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  searchKundli(String kundliName) {
    List<KundliModel> result = [];
    if (kundliName.isEmpty) {
      result = kundliList;
    } else {
      result = kundliList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(kundliName.toLowerCase()))
          .toList();
    }
    searchKundliList = result;
    if (searchKundliList.isEmpty) {
      emptyScreenText = "Search result not found";
    }
    update();
  }

  getBasicDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKundliBasicDetails(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliBasicDetail = KundliBasicDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Fail to getKundliBasicDetails ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicDetail():' + e.toString());
    }
  }

  getBasicPanchangDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKundliBasicPanchangDetails(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliBasicPanchangDetail =
                  KundliBasicPanchangDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Fail to getKundliBasicPanchangDetails',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicPanchangDetail():' + e.toString());
    }
  }

  getBasicAvakhadaDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getAvakhadaDetails(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliAvakhadaDetail = KundliAvakhdaDetail.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Failed to getAvakhadaDetails',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getBasicAvakhadaDetail():' + e.toString());
    }
  }

  getSadesatiDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getSadesati(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              isSadesati = result['sadhesati_status'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Panchang Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSadesatiDetail():' + e.toString());
    }
  }

  getKalsarpaDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKalsarpa(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              isKalsarpa = result['present'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Panchang Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getKalsarpaDetail():' + e.toString());
    }
  }

  getChartPlanetsDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getPlanetsDetail(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              planetList = result;
              sunDetails = KundliPlanetsDetail.fromJson(planetList[0]);
              moonDetails = KundliPlanetsDetail.fromJson(planetList[1]);
              marsDetails = KundliPlanetsDetail.fromJson(planetList[2]);
              mercuryDetails = KundliPlanetsDetail.fromJson(planetList[3]);
              jupiterDetails = KundliPlanetsDetail.fromJson(planetList[4]);
              venusDetails = KundliPlanetsDetail.fromJson(planetList[5]);
              saturnDetails = KundliPlanetsDetail.fromJson(planetList[6]);
              rahuDetails = KundliPlanetsDetail.fromJson(planetList[7]);
              ketuDetails = KundliPlanetsDetail.fromJson(planetList[8]);
              ascendantDetails = KundliPlanetsDetail.fromJson(planetList[9]);

              if (planetList[9]['sign'].toString() == "Aries") {
                //1
                startHouse = 1;
                update();
              } else if (planetList[9]['sign'].toString() == "Taurus") {
                //2

                startHouse = 2;
                update();
              } else if (planetList[9]['sign'].toString() == "Gemini") {
                //3

                startHouse = 3;
                update();
              } else if (planetList[9]['sign'].toString() == "Cancer") {
                //4

                startHouse = 4;
                update();
              } else if (planetList[9]['sign'].toString() == "Leo") {
                //5
                startHouse = 5;
                update();
              } else if (planetList[9]['sign'].toString() == "Virgo") {
                //6
                startHouse = 6;
                update();
              } else if (planetList[9]['sign'].toString() == "Libra") {
                //7
                startHouse = 7;
                update();
              } else if (planetList[9]['sign'].toString() == "Scorpio") {
                //8
                startHouse = 8;
                update();
              } else if (planetList[9]['sign'].toString() == "Sagittarius") {
                //9
                startHouse = 9;
                update();
              } else if (planetList[9]['sign'].toString() == "Capricornus") {
                //10
                startHouse = 10;
                update();
              } else if (planetList[9]['sign'].toString() == "Aquarius") {
                startHouse = 11;
                update();
              } else if (planetList[9]['sign'].toString() == "Pisces") {
                startHouse = 13;
                update();
              } else {
                startHouse = 1;
                update();
              }
              List temp1 = [],
                  temp2 = [],
                  temp3 = [],
                  temp4 = [],
                  temp5 = [],
                  temp6 = [],
                  temp7 = [],
                  temp8 = [],
                  temp9 = [],
                  temp10 = [],
                  temp11 = [],
                  temp12 = [];

              kundaliData.clear();
              for (int i = 0; i < planetList.length; i++) {
                if (planetList[i]['house'].toString() == "1" ||
                    planetList[i]['name'].toString() == "Ascendant") {
                  temp1.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "2") {
                  temp2.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "3") {
                  temp3.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "4") {
                  temp4.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "5") {
                  temp5.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "6") {
                  temp6.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "7") {
                  temp7.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "8") {
                  temp8.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "9") {
                  temp9.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "10") {
                  temp10.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "11") {
                  temp11.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else if (planetList[i]['house'].toString() == "12") {
                  temp12.add({
                    "house": planetList[i]['house'],
                    "sign": planetList[i]['name'],
                    "degre": planetList[i]['normDegree']
                  });
                } else {
                  print("houseNumberNotDefine");
                }
              }

              _kundaliData.add(temp1);
              update();
              _kundaliData.add(temp2);
              _kundaliData.add(temp3);
              _kundaliData.add(temp4);
              _kundaliData.add(temp5);
              _kundaliData.add(temp6);
              _kundaliData.add(temp7);
              _kundaliData.add(temp8);
              _kundaliData.add(temp9);
              _kundaliData.add(temp10);
              _kundaliData.add(temp11);
              _kundaliData.add(temp12);
              name.addAll(_kundaliData);
              update();
            } else {
              global.showToast(
                message: 'Failed to Plantes Detail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getChartPlanetsDetail():' + e.toString());
    }
  }

  getGemstoneDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      gemstoneList = null;

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getGemstone(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              gemstoneList = GemstoneModel.fromJson(map);

              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get Get gemstone',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getVimshattariDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getVimshattari(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              vimshattariList!.add(result);

              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get vimshattari',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getAntardashaDetail(
      {String? antarName,
      int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getAntardasha(
                  antarDasha: antarName,
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get getAntardashaDetail',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getPatyantarDashaDetail(
      {String? anterName,
      String? patyantarName,
      int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getPatynatarDasha(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get getPatyantarDashaDetail',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getSookshmaDashaDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getSookshmaDasha(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get SookshmaDasha',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getPranaDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getPrana(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              vimshattariList!.add(result);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get  Get vimshattari',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAntarDasha():' + e.toString());
    }
  }

  getReportDescDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getReport(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result != null) {
              generalDesc = result['asc_report']['report'];
              update();
            } else {
              global.showToast(
                message: 'Failed to Report',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSadesatiDetail():' + e.toString());
    }
  }

  addPlanetKundliData(int id) async {
    global.checkBody().then((result) async {
      if (result) {
        apiHelper.addPlanetKundli(id).then((result) {
          if (result.status == "200") {
            print('success');
          } else {
            global.showToast(
              message: 'Failed to add kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }
}
