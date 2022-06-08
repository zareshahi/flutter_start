import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zekr_shomar/screens/settings/settings.dart';
import 'package:zekr_shomar/screens/zekrList/zekr_list.dart';
import 'package:zekr_shomar/services/storage_manager.dart';
import 'package:get/get.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZekrShomar extends StatefulWidget {
  final String zekrId;
  const ZekrShomar({
    Key? key,
    required this.zekrId,
  }) : super(key: key);

  @override
  State<ZekrShomar> createState() => _ZekrShomarState();
}

class _ZekrShomarState extends State<ZekrShomar> {
  bool? _isVibrate;
  double? _fontSize;
  Map zekrMap = {
    'id': 2,
    'zekr': 'اللهم صل علی محمد و آل محمد',
    'zekrCount': 100,
    'zekrCounted': 0,
  };
  String zekrId = 'zekr2';

  Future _counterCount() async {
    await getPrefs();
    setState(() {
      if (zekrMap['zekrCounted'] < zekrMap['zekrCount']) {
        // counting remaining
        if (zekrMap['zekrCounted'] == zekrMap['zekrCount'] - 1) {
          // Counter reaches end
          _showResetAlertDialog(context, 'شمارش ذکر به پایان رسید');
          HapticFeedback.vibrate();
          sleep(const Duration(milliseconds: 200));
          HapticFeedback.vibrate();
          sleep(const Duration(milliseconds: 200));
          HapticFeedback.vibrate();
        }
        zekrMap['zekrCounted']++;
        saveZekr();
        if (_isVibrate ?? false) {
          HapticFeedback.vibrate();
        }
      } else {
        // Counter reaches end
        _showResetAlertDialog(context, 'شمارش ذکر به پایان رسید');
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
      }
    });
  }

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVibrate = prefs.getBool("vibrate");
      _fontSize = prefs.getDouble('fontSize');
    });
  }

  Future getZekr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      zekrMap = jsonDecode(prefs.getString(zekrId) ?? jsonEncode(zekrMap));
    });
  }

  void saveZekr() {
    StorageManager.saveData(zekrId, jsonEncode(zekrMap));
  }

  void _resetCounter() {
    setState(() {
      zekrMap['zekrCounted'] = 0;
      saveZekr();
    });
    const snackBar = SnackBar(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text('شمارنده بازنشانی شد'),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showResetAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("خیر"),
      onPressed: () {
        Navigator.pop(context, 'cancle');
      },
    );
    Widget continueButton = TextButton(
      child: const Text("بله"),
      onPressed: () {
        _resetCounter();
        Navigator.pop(context, 'ok');
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(message),
      content: const Text("آیا می‌خواهید شمارنده صفر شود"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(textDirection: TextDirection.rtl, child: alert);
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('هشدار'),
                    content: const Text('آیا میخواهید از برنامه خارج شوید؟'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('نه'),
                      ),
                      TextButton(
                        onPressed: () => SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop'),
                        child: const Text('بله'),
                      ),
                    ],
                  ),
                ))) ??
        false;
  }

  getZekrId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.zekrId == 'mainZekr') {
      zekrId = prefs.getString('mainZekr') ?? '';
    } else {
      zekrId = widget.zekrId;
    }
  }

  @override
  void initState() {
    super.initState();
    getZekrId();
    getZekr();
    getPrefs();
    PerfectVolumeControl.stream.listen((volume) {
      _counterCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _counterCount,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          zekrMap['zekr'],
                          style: const TextStyle(fontSize: 32),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        Text(
                          '${zekrMap['zekrCounted']}',
                          style: TextStyle(fontSize: _fontSize ?? 50),
                        ),
                        SizedBox(
                          height: Get.height / 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _showAlertDialog(context);
        //   },
        //   tooltip: 'بازنشانی',
        //   child: const Icon(Icons.settings_backup_restore),

        // ),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          // backgroundColor: Colors.amber,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.settings),
              label: 'تنظیمات',
              // backgroundColor: Colors.amberAccent,
              onTap: () {
                Get.to(() => const Settings());
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.list),
              label: 'لیست اذکار',
              // backgroundColor: Colors.amberAccent,
              onTap: () {
                Get.to(() => const ZekrList());
                /* Do something */
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.settings_backup_restore),
              label: 'صفر کردن شمارنده',
              // backgroundColor: Colors.amberAccent,
              onTap: () {
                _showResetAlertDialog(context, 'هشدار');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.info),
              label: 'درباره ما',
              // backgroundColor: Colors.amberAccent,
              onTap: () {/* Do something */},
            ),
          ],
        ),
      ),
    );
  }
}
