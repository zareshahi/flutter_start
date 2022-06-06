import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zekr_shomar/screens/zekrList/zekr_list.dart';

class AddZekr extends StatelessWidget {
  AddZekr({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _zekr = TextEditingController();
  final _zekrCount = TextEditingController();

  void _saveZekr(String zekr, int zekrCount) async {
    final prefs = await SharedPreferences.getInstance();
    int zekrLen = prefs.getInt('zekrLen') ?? 0;
    Map zekrMap = {
      'id': zekrLen + 1,
      'zekr': zekr,
      'zekrCount': zekrCount,
      'zekrCounted': 0
    };
    prefs.setString('zekr${zekrLen + 1}', jsonEncode(zekrMap));
    prefs.setInt('zekrLen', zekrLen + 1);
    Get.to(const ZekrList());
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
              const Text(
                'اضافه کردن ذکر',
                style: TextStyle(fontSize: 20),
              ),
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
                    // _saveZekr(_zekr.text, int.parse(_zekrCount.text));
                    Get.snackbar("اطلاع", "ذکر ذخیره شد",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        isDismissible: true,
                        dismissDirection: DismissDirection.horizontal,
                        margin: const EdgeInsets.all(16));
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
