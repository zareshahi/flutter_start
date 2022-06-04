import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_start/screens/settings/settings.dart';
import 'package:flutter_start/screens/zekrList/zekr_list.dart';
import 'package:flutter_start/services/storage_manager.dart';
import 'package:get/get.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZekrShomar extends StatefulWidget {
  final String zekrId;
  final String zekr;
  final int zekrCount;
  int zekrCounted;
  ZekrShomar(
      {Key? key,
      required this.zekrId,
      required this.zekr,
      required this.zekrCount,
      required this.zekrCounted})
      : super(key: key);

  @override
  State<ZekrShomar> createState() => _ZekrShomarState();
}

class _ZekrShomarState extends State<ZekrShomar> {
  bool? _isVibrate;
  double? _fontSize;
  Map zekrMap = {
    'zekr': 'اللهم صل علی محمد و آل محمد',
    'zekrCount': 100,
    'zekrCounted': 0,
  };

  Future _counterCount() async {
    await getPrefs();
    setState(() {
      zekrMap['zekrCounted']++;
      saveZekr();
      if (_isVibrate ?? false) {
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
      zekrMap =
          jsonDecode(prefs.getString(widget.zekrId) ?? jsonEncode(zekrMap));
    });
  }

  void saveZekr() {
    StorageManager.saveData(widget.zekrId, jsonEncode(zekrMap));
  }

  void _resetCounter() {
    Get.snackbar("اطلاع", "شمارنده بازنشانی شد",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(16));
    setState(() {
      zekrMap['zekrCounted'] = 0;
      saveZekr();
    });
  }

  void _showAlertDialog(BuildContext context) {
    // TODO: rtl direction
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
      title: const Text("هشدار"),
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
        return alert;
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هشدار'),
            content: const Text('آیا میخواهید از برنامه خارج شوید؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('نه'),
              ),
              TextButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text('بله'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
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
                _showAlertDialog(context);
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
