import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_start/screens/zekrList/components/zekr_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZekrList extends StatefulWidget {
  const ZekrList({Key? key}) : super(key: key);

  @override
  State<ZekrList> createState() => _ZekrListState();
}

class _ZekrListState extends State<ZekrList> {
  int zekrLen = 0;
  List zekrList = [];

  Future<void> getZekrList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      zekrLen = prefs.getInt('zekrLen') ?? 0;
      for (int i = 1; i <= zekrLen; i++) {
        Map zekrMap = jsonDecode(prefs.getString('zekr$i') ?? '');
        zekrList.add(zekrMap);
      }
    });
  }

  Future<void> initZekr() async {
    final prefs = await SharedPreferences.getInstance();
    bool initZekr = prefs.getBool('initZekr') ?? true;
    if (initZekr) {
      prefs.setString(
          'zekr1',
          jsonEncode({
            'id': 1,
            'zekr': 'یا قوی',
            'zekrCount': 116,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr2',
          jsonEncode({
            'id': 2,
            'zekr': 'اللهم صل علی محمد و آل محمد',
            'zekrCount': 100,
            'zekrCounted': 0
          }));
      prefs.setString(
          'zekr3',
          jsonEncode({
            'id': 3,
            'zekr': 'یا میسر',
            'zekrCount': 310,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr4',
          jsonEncode({
            'id': 4,
            'zekr': 'یا منعم',
            'zekrCount': 200,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr5',
          jsonEncode({
            'id': 5,
            'zekr': 'یا غنی',
            'zekrCount': 100,
            'zekrCounted': 0,
          }));
      prefs.setString(
          'zekr6',
          jsonEncode(
              {'id': 6, 'zekr': 'یا مبدل', 'zekrCount': 76, 'zekrCounted': 0}));
      prefs.setInt('zekrLen', 6);
      prefs.setBool('initZekr', false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initZekr();
    getZekrList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      child: ListView.builder(
                        itemCount: zekrList.length,
                        itemBuilder: (context, index) {
                          return ZekrCard(
                            zekrId: 'zekr${index + 1}',
                            zekr: zekrList[index]['zekr'],
                            zekrCount: zekrList[index]['zekrCount'],
                            zekrCounted: zekrList[index]['zekrCounted'],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
