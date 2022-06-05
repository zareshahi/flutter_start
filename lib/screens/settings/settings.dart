import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_start/services/dark_theme_provider.dart';
import 'package:flutter_start/services/storage_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool? _isVibrate;
  bool? _isDark;
  double? _fontSize;

  Future getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVibrate = prefs.getBool("vibrate");
      _isDark = prefs.getBool("darkMode");
      _fontSize = prefs.getDouble('fontSize');
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoSwitch(
                    value: _isVibrate ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isVibrate = value;
                        StorageManager.saveData('vibrate', value);
                      });
                    }),
                const SizedBox(
                  width: 8,
                ),
                const Text('لرزش هنگام شمارش'),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoSwitch(
                    value: _isDark ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isDark = value;
                        themeChange.darkTheme = value;
                        StorageManager.saveData('darkMode', value);
                      });
                    }),
                const SizedBox(
                  width: 8,
                ),
                const Text('حالت شب'),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _fontSize ?? 50,
                  max: 100,
                  label: _fontSize?.round().toString() ?? '',
                  onChanged: (value) => {
                    setState(() {
                      _fontSize = value;
                      StorageManager.saveData('fontSize', value);
                    })
                  },
                ),
                Text(_fontSize?.round().toString() ?? '50'),
                const SizedBox(
                  width: 16,
                ),
                const Text('اندازه فونت شمارنده'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
