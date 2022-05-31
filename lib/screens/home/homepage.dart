import 'package:flutter/material.dart';
import 'package:flutter_start/module/widget.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final TextStyle _h1TextStyle =
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Hi Ali',
                style: _h1TextStyle,
              ),
              const CircleAvatar(
                backgroundImage: AssetImage('images/profile.png'),
              )
            ]),
            const Text(
              '10 Task Pending',
              style: TextStyle(fontSize: 16, color: Colors.deepOrange),
            ),
            const SizedBox(height: 32),
            Expanded(
                child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: 280,
                    height: 64,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                        size: 36,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 21, color: Colors.grey.shade400),
                      )
                    ]),
                  ),
                  const CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 32,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 32,
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Category',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CategoryItem('Mobile App', '10 Tasks', 'images/profile.png'),
                  CategoryItem('Website App', '10 Tasks', 'images/profile.png')
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Ongoing tasks',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('see more',
                        style:
                            TextStyle(fontSize: 16, color: Colors.deepOrange))
                  ]),
              const SizedBox(
                height: 24,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'data',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 36,
                            height: 22,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(16)),
                            child: const Text(
                              '6d',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Team Members',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: const [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/profile.png'),
                                      radius: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/profile.png'),
                                      radius: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/profile.png'),
                                      radius: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.access_time_filled_outlined,
                                      color: Colors.deepOrange,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '2:30 PM',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      '9:30 PM',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  children: [
                                    CustomPaint(
                                      painter:
                                          MyPainter(100, Colors.green.shade100),
                                      child: Container(),
                                    ),
                                    const CustomPaint(
                                      painter: MyPainter(46, Colors.green),
                                      child: Center(
                                        child: Text(
                                          '46' '%',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ])
                    ]),
              )
            ]))
          ],
        ),
      )),
    );
  }
}

class MyPainter extends CustomPainter {
  final double angle;
  final Color? color;
  const MyPainter(this.angle, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color ?? Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
        Rect.fromLTRB(
            0, 0, size.width, size.height), // const Offset(0,0) & size
        -math.pi / 2,
        math.pi * 2 * (angle / 100),
        false,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw true;
  }
}
