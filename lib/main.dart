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

  String zekrId = 'zekr2';

  @override
  void initState() {
    getPrefs();
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<String> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    zekrId = prefs.getString('mainZekr') ?? 'zekr2';
    return zekrId;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return FutureBuilder(
              future: getPrefs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: Styles.themeData(
                        themeChangeProvider.darkTheme, context),
                    home: ZekrShomar(
                      zekrId: zekrId,
                    ),
                  );
                } else {
                  // Returns empty container untill the data is loaded
                  return Container();
                }
              });
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
