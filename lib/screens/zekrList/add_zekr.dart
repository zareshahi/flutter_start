import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zekr_shomar/screens/zekrList/zekr_list.dart';

class AddZekr extends StatefulWidget {
  // inputs for edit zekr
  final String? editZekr;
  final String? editZekrId;
  final int? editZekrCount;
  final int? editZekrCounted;
  const AddZekr(
      {Key? key,
      this.editZekr,
      this.editZekrId,
      this.editZekrCount,
      this.editZekrCounted})
      : super(key: key);

  @override
  State<AddZekr> createState() => _AddZekrState();
}

class _AddZekrState extends State<AddZekr> {
  final _formKey = GlobalKey<FormState>();
  final _zekr = TextEditingController();
  final _zekrCount = TextEditingController();
  @override
  void initState() {
    super.initState();
    _zekr.text = widget.editZekr ?? '';
    if (widget.editZekrCount != null) {
      _zekrCount.text = widget.editZekrCount.toString();
    }
  }

  void _saveZekr(String zekr, int zekrCount) async {
    // on save key pressed
    final prefs = await SharedPreferences.getInstance();
    int lastZekrId = prefs.getInt('lastZekrId') ?? 0;
    int zekrLen = prefs.getInt('zekrLen') ?? 0;
    if (widget.editZekr == null) {
      // when we add a new zekr
      Map zekrMap = {
        'id': lastZekrId + 1,
        'zekr': zekr,
        'zekrCount': zekrCount,
        'zekrCounted': 0
      };
      prefs.setString('zekr${lastZekrId + 1}', jsonEncode(zekrMap));
      prefs.setInt('lastZekrId', lastZekrId + 1);
      prefs.setInt('zekrLen', zekrLen + 1);
    } else {
      // when we want to edit a zekr
      Map zekrMap = {
        'id': int.parse(widget.editZekrId!.replaceAll(RegExp(r'[^0-9]'), '')),
        'zekr': zekr,
        'zekrCount': zekrCount,
        'zekrCounted': widget.editZekrCounted ?? 0
      };
      prefs.setString(widget.editZekrId!, jsonEncode(zekrMap));
    }
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ZekrList()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.editZekr == null) ...[
                const Text(
                  'اضافه کردن ذکر',
                  style: TextStyle(fontSize: 20),
                )
              ] else ...[
                const Text(
                  'ویرایش ذکر',
                  style: TextStyle(fontSize: 20),
                ),
              ],
              const SizedBox(
                height: 16,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: _zekr,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'نام ذکر',
                  ),
                  onSaved: (String? value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا یک متن وارد نمایید';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: _zekrCount,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'تعداد ذکر',
                  ),
                  onSaved: (String? value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا یک عدد صحیح وارد نمایید';
                    }
                    try {
                      int.parse(value);
                      return null;
                    } on Exception {
                      return 'لطفا یک عدد صحیح وارد نمایید';
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    _saveZekr(_zekr.text, int.parse(_zekrCount.text));
                    const snackBar = SnackBar(
                      content: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text('ذکر ذخیره شد'),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('ذخیره'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
