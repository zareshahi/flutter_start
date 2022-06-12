import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zekr_shomar/screens/settings/settings.dart';
import 'package:zekr_shomar/screens/zekrList/zekr_list.dart';
import 'package:zekr_shomar/services/storage_manager.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  void _countOnlineZekr() async {
    if (zekrMap['id'] < 101 && zekrMap['id'] > 0) {
      try {
        // get last online number
        http.Response getResponse = await http
            .get(Uri.parse(
                'http://192.168.1.105:5642/zekr?id=eq.${zekrMap['id']}'))
            .timeout(const Duration(seconds: 5));
        if (getResponse.statusCode == 200) {
          var responseData = jsonDecode(getResponse.body);
          //Creating a list to store input data;
          for (var singleZekr in responseData) {
            zekrMap = {
              'id': singleZekr["id"],
              'zekr': singleZekr["zekr"],
              'zekrCount': singleZekr["zekrcount"],
              'zekrCounted': zekrMap['zekrCounted'],
              'onlineZekrCounted': singleZekr["zekrcounted"]
            };
          }
        } else {
          throw Exception('error in connection');
        }
        // send Data
        var data = jsonEncode({
          'id': zekrMap['id'],
          'zekr': zekrMap['zekr'],
          'zekrcount': zekrMap['zekrCount'],
          'zekrcounted': zekrMap['onlineZekrCounted'] + 1
        });
        http.Response response = await http.put(
            Uri.parse('http://192.168.1.105:5642/zekr?id=eq.${zekrMap['id']}'),
            body: data,
            headers: {
              "Content-Type": "application/json"
            }).timeout(const Duration(seconds: 5));
        if (response.statusCode == 204) {
          // ok
          // Count
          setState(() {
            zekrMap['zekrCounted']++;
            zekrMap['onlineZekrCounted']++;
          });
          saveZekr();
        } else {
          throw Exception('error in connection');
        }
      } catch (e) {
        // connection lost or throw exception
        // vibrate for notify to user
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
        // show snackbar message to user
        const snackBar = SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('ارسال آنلاین ذکر با خطا مواجه شد'),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future _counterCount() async {
    await getPrefs();
    setState(() {
      if (zekrMap['zekrCounted'] >= zekrMap['zekrCount'] ||
          zekrMap['onlineZekrCounted'] >= zekrMap['zekrCount']) {
        // Counter reaches end
        if (zekrMap['id'] < 101 && zekrMap['id'] > 0) {
          // online mode
          const snackBar = SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('شمارش ذکر به پایان رسید'),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // offline mode
          _showResetAlertDialog(context, 'شمارش ذکر به پایان رسید');
        }
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
        sleep(const Duration(milliseconds: 200));
        HapticFeedback.vibrate();
      } else {
        // counting remaining
        if ((zekrMap['zekrCounted'] == zekrMap['zekrCount'] - 1) ||
            (zekrMap['onlineZekrCounted'] == zekrMap['zekrCount'] - 1)) {
          // Counter reaches end
          if (zekrMap['id'] < 101 && zekrMap['id'] > 0) {
            // online mode
            const snackBar = SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('شمارش ذکر به پایان رسید'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            // offline mode
            _showResetAlertDialog(context, 'شمارش ذکر به پایان رسید');
          }
          // vibrate alert for user to notify ending
          HapticFeedback.vibrate();
          sleep(const Duration(milliseconds: 200));
          HapticFeedback.vibrate();
          sleep(const Duration(milliseconds: 200));
          HapticFeedback.vibrate();
        }
        // if counting remain - counter work
        if (zekrMap['id'] < 101 && zekrMap['id'] > 0) {
          // online Zekr counting
          _countOnlineZekr();
        } else {
          // offlie zekr counting
          zekrMap['zekrCounted']++;
          saveZekr();
        }
        // check vibrate enabled in settings
        if (_isVibrate ?? false) {
          // vibrate by count
          HapticFeedback.vibrate();
        }
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
    Size size = MediaQuery.of(context).size;
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
                        if (zekrMap['onlineZekrCounted'] != null) ...[
                          const SizedBox(height: 26),
                          const Text(
                            'مقدار شمرده شده آنلاین تا کنون',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${zekrMap["onlineZekrCounted"]}',
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                        SizedBox(
                          height: size.height / 8,
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
              child: const Icon(Icons.list),
              label: 'لیست اذکار',
              // backgroundColor: Colors.amberAccent,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ZekrList()));
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
              child: const Icon(Icons.settings),
              label: 'تنظیمات',
              // backgroundColor: Colors.amberAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            // SpeedDialChild(
            //   child: const Icon(Icons.info),
            //   label: 'درباره ما',
            //   // backgroundColor: Colors.amberAccent,
            //   onTap: () {/* Do something */},
            // ),
          ],
        ),
      ),
    );
  }
}
