import 'package:flutter/material.dart';
import 'package:zekr_shomar/screens/zekrList/add_zekr.dart';
import 'package:zekr_shomar/screens/zekrShomar/zekr_shomar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zekr_shomar/services/storage_manager.dart';

class ZekrCard extends StatelessWidget {
  const ZekrCard(
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

  Future<void> removeZekr(String zekrId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StorageManager.deleteData(zekrId);
    int zekrLen = prefs.getInt('zekrLen') ?? 0;
    prefs.setInt('zekrLen', zekrLen - 1);
  }

  Widget slideRightBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.red,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Text(
              "حذف ذکر",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 6,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.blue,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Text(
              "ویرایش ذکر",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 6,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dismissible(
      key: UniqueKey(),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Delete Zekr
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    content: Text("آیا میخواهید ذکر «$zekr» را پاک کنید؟"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "لغو",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "پاک کردن",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          // Delete the item
                          removeZekr(zekrId);
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                );
              });
        } else {
          // Navigate to edit page;
          Get.to(AddZekr(
            editZekr: zekr,
            editZekrId: zekrId,
            editZekrCount: zekrCount,
            editZekrCounted: zekrCounted,
          ));
          return null;
        }
      },
      child: GestureDetector(
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
                          style: const TextStyle(
                              color: Colors.black, fontSize: 24),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '$zekrCounted :شمرده شده',
                            style: const TextStyle(color: Colors.black),
                          ),
                          if (zekrId == 'zekr1') ...[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              margin: const EdgeInsets.only(left: 4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'ذکر روز',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
