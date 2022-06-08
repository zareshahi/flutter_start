import 'package:flutter/material.dart';
import 'package:zekr_shomar/screens/zekrList/add_zekr.dart';
import 'package:zekr_shomar/screens/zekrShomar/zekr_shomar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zekr_shomar/services/storage_manager.dart';

class ZekrCard extends StatefulWidget {
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

  @override
  State<ZekrCard> createState() => _ZekrCardState();
}

class _ZekrCardState extends State<ZekrCard> {
  DateTime date = DateTime.now();
  String day = '';

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
  void initState() {
    super.initState();
    setState(() {
      switch (date.weekday) {
        case 1:
          day = 'دوشنبه';
          break;
        case 2:
          day = 'سه شنبه';
          break;
        case 3:
          day = 'چهارشنبه';
          break;
        case 4:
          day = 'پنج شنبه';
          break;
        case 5:
          // friday
          day = 'جمعه';
          break;
        case 6:
          // saturday
          day = 'شنبه';
          break;
        case 7:
          // sunday
          day = 'یکشنبه';
          break;
        default:
          break;
      }
    });
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
                    content:
                        Text("آیا میخواهید ذکر «${widget.zekr}» را پاک کنید؟"),
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
                          removeZekr(widget.zekrId);
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                );
              });
        } else {
          // Navigate to edit page;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddZekr(
                editZekr: widget.zekr,
                editZekrId: widget.zekrId,
                editZekrCount: widget.zekrCount,
                editZekrCounted: widget.zekrCounted,
              ),
            ),
          );
          return null;
        }
      },
      child: GestureDetector(
        onTap: () {
          setMainZekr(widget.zekrId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ZekrShomar(
                zekrId: widget.zekrId,
                // zekr: zekr,
                // zekrCount: zekrCount,
                // zekrCounted: zekrCounted
              ),
            ),
          );
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
                    widget.zekrCount.toString(),
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
                          widget.zekr,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 24),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.zekrCounted} :شمرده شده',
                            style: const TextStyle(color: Colors.black),
                          ),
                          if (widget.zekrId == 'zekr1') ...[
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
                              child: Text(
                                'ذکر روز $day',
                                style: const TextStyle(
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
