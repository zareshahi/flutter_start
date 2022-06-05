import 'package:flutter/material.dart';
import 'package:flutter_start/screens/zekrShomar/zekr_shomar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZekrCard extends StatelessWidget {
  ZekrCard(
      {Key? key,
      required this.zekrId,
      required this.zekr,
      required this.zekrCount,
      required this.zekrCounted})
      : super(key: key);
  final String zekrId;
  final String zekr;
  final int zekrCount;
  final int zekrCounted;

  Future<void> setMainZekr(String zekrId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mainZekr', zekrId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setMainZekr(zekrId);
        Get.to(ZekrShomar(
          zekrId: zekrId,
          // zekr: zekr,
          // zekrCount: zekrCount,
          // zekrCounted: zekrCounted
        ));
      },
      child: Container(
          width: size.width,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          height: 96,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: Text(
                  zekrCount.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 32),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        zekr,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    ),
                    Text(
                      '$zekrCounted :شمرده شده',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
