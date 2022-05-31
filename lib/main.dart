import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_start/module/dark_theme_styles.dart';
import 'package:flutter_start/screens/zekrShomar/zekr_shomar.dart';
import 'package:flutter_start/services/dark_theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  String zekr = 'اللهم صل علی محمد و آل محمد';
  int zekrCount = 100;
  int zekrCounted = 0;
  String? _mainZekr;
  Map _mainZekrMap = {
    'zekr': 'اللهم صل علی محمد و آل محمد',
    'zekrCount': 100,
    'zekrCounted': 0,
  };

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getPrefs();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mainZekr = prefs.getString('mainZekr');
    if (_mainZekr != null) {
      _mainZekrMap = jsonDecode(_mainZekr ?? "");
      zekr = _mainZekrMap['zekr'];
      zekrCount = _mainZekrMap['zekrCount'];
      zekrCounted = _mainZekrMap['zekrCounted'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: ZekrShomar(
              zekr: zekr,
              zekrCount: zekrCount,
              zekrCounted: zekrCounted,
            ),
          );
        },
      ),
    );
    // GetMaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData.light(),
    //   darkTheme: ThemeData.dark(),
    //   home: const Salavat(),
    // );
  }
}
