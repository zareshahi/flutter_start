import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zekr_shomar/screens/zekrList/add_zekr.dart';
import 'package:zekr_shomar/screens/zekrList/components/zekr_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zekr_shomar/screens/zekrShomar/zekr_shomar.dart';
import 'package:http/http.dart' as http;

class ZekrList extends StatefulWidget {
  const ZekrList({Key? key}) : super(key: key);

  @override
  State<ZekrList> createState() => _ZekrListState();
}

class _ZekrListState extends State<ZekrList> {
  int zekrLen = 0;
  List zekrList = [];
  var url = Uri.parse('http://192.168.1.105:5642/zekr');

  Future<void> getDailyZekr() async {
    final prefs = await SharedPreferences.getInstance();
    var zekr0 = prefs.getString('zekr0');
    var zekrMap = jsonDecode(zekr0 ?? '');
    DateTime date = DateTime.now();
    switch (date.weekday) {
      case 1:
        // monday - دوشنبه
        zekrMap['zekr'] = 'یا قاضی الحاجات';
        break;
      case 2:
        // tuesday - سه شنبه
        zekrMap['zekr'] = 'یا ارحم الراحمین';
        break;
      case 3:
        // wednesday - چهارشنبه
        zekrMap['zekr'] = 'یا حی و یا قیوم';
        break;
      case 4:
        // thursday - پنج شنبه
        zekrMap['zekr'] = 'لا اله الا الله الملک الحق المبین';
        break;
      case 5:
        // friday - جمعه
        zekrMap['zekr'] = 'اللهم صل علی محمد و آل محمد';
        break;
      case 6:
        // saturday - شنبه
        zekrMap['zekr'] = 'یا رب العالمین';
        break;
      case 7:
        // sunday - یکشنبه
        zekrMap['zekr'] = 'یا ذالجلال و الاکرام';
        break;
      default:
        zekrMap['zekr'] = 'اللهم صل علی محمد و آل محمد';
        break;
    }
    zekrMap['zekrCount'] = 100;
    prefs.setString('zekr0', jsonEncode(zekrMap));
  }

  Future getOnlineZekrList() async {
    final prefs = await SharedPreferences.getInstance();
    // remove old online zekr values
    for (int i = 1; i < 101; i++) {
      try {
        // remove values in local storage
        prefs.remove('zekr$i');
      } catch (e) {
        continue;
      }
    }
    try {
      http.Response response =
          await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        //Creating a list to store input data;
        for (var singleZekr in responseData) {
          Map zekrMap = {
            'id': singleZekr["id"],
            'zekr': singleZekr["zekr"],
            'zekrCount': singleZekr["zekrcount"],
            'zekrCounted': singleZekr["zekrcounted"]
          };
          prefs.setString('zekr${singleZekr["id"]}', jsonEncode(zekrMap));
        }
        getZekrList();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load zekr');
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text('دریافت اذکار آنلاین با خطا مواجه شد'),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  Future<void> getZekrList() async {
    zekrList = [];
    final prefs = await SharedPreferences.getInstance();
    // add daily zekr
    if (prefs.getString('zekr0') != null) {
      // check if daily zekr not deleted
      await getDailyZekr();
      zekrList.add(jsonDecode(prefs.getString('zekr0') ?? ''));
    }
    // add other zekrs
    setState(() {
      // add offline zekrs
      var lastZekrId = prefs.getInt('lastZekrId') ?? 0;
      for (int i = 1; i <= lastZekrId; i++) {
        try {
          Map zekrMap = jsonDecode(prefs.getString('zekr$i') ?? '');
          zekrList.add(zekrMap);
        } on Exception {
          continue;
        }
      }
    });
  }

  Future<void> initZekr() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setBool('initZekr', true); // only for reset storage
    bool initZekr = prefs.getBool('initZekr') ?? true;
    if (initZekr) {
      prefs.setString(
          'zekr0',
          jsonEncode({
            'id': 0,
            'zekr': 'ذکر ایام هفته',
            'zekrCount': 100,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr102',
          jsonEncode({
            'id': 102,
            'zekr': 'اللهم صل علی محمد و آل محمد',
            'zekrCount': 100,
            'zekrCounted': 0
          }));
      prefs.setString(
          'zekr103',
          jsonEncode({
            'id': 103,
            'zekr': 'یا میسر',
            'zekrCount': 310,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr104',
          jsonEncode({
            'id': 104,
            'zekr': 'یا منعم',
            'zekrCount': 200,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr105',
          jsonEncode({
            'id': 105,
            'zekr': 'یا غنی',
            'zekrCount': 100,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr106',
          jsonEncode({
            'id': 106,
            'zekr': 'یا مبدل',
            'zekrCount': 76,
            'zekrCounted': 0
          }));
      prefs.setString(
          'zekr107',
          jsonEncode({
            'id': 107,
            'zekr': 'یا قوی',
            'zekrCount': 116,
            'zekrCounted': 0,
          }));
      prefs.setInt('zekrLen', 7);
      prefs.setInt('lastZekrId', 107);
      prefs.setBool('initZekr', false);
    }
  }

  @override
  void initState() {
    super.initState();
    initZekr();
    getZekrList();
    getOnlineZekrList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ZekrShomar(zekrId: 'mainZekr'),
          ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddZekr(),
              ),
            );
          },
          tooltip: 'اضافه کردن ذکر',
          child: const Icon(Icons.add),
        ),
        body: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.fitHeight),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.all(16),
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: const Center(
                        child: Text(
                          'لیست اذکار',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: RefreshIndicator(
                          onRefresh: getOnlineZekrList,
                          child: ListView.builder(
                            itemCount: zekrList.length,
                            itemBuilder: (context, index) {
                              return ZekrCard(
                                zekrId: 'zekr${zekrList[index]["id"]}',
                                zekr: zekrList[index]['zekr'],
                                zekrCount: zekrList[index]['zekrCount'],
                                zekrCounted: zekrList[index]['zekrCounted'],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
