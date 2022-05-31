import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_start/screens/zekrList/components/zekr_card.dart';

class ZekrList extends StatefulWidget {
  const ZekrList({Key? key}) : super(key: key);

  @override
  State<ZekrList> createState() => _ZekrListState();
}

class _ZekrListState extends State<ZekrList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.fitHeight),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    margin: const EdgeInsets.all(16),
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: const Center(
                      child: Text(
                        'لیست اذکار',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          ZekrCard(
                            zekr: 'یا قوی',
                            zekrCount: 116,
                            zekrCounted: 16,
                          ),
                          ZekrCard(
                            zekr: 'اللهم صل علی محمد و آل محمد',
                            zekrCount: 100,
                            zekrCounted: 16,
                          ),
                          ZekrCard(
                            zekr: 'یا میسر',
                            zekrCount: 310,
                            zekrCounted: 16,
                          ),
                          ZekrCard(
                            zekr: 'یا منعم',
                            zekrCount: 200,
                            zekrCounted: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
