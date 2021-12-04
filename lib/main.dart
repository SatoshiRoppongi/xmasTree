// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

final Color primaryColor = Colors.orange;
const TargetPlatform platform = TargetPlatform.android;

void main() {
  runApp(XmasTree());
}

class XmasTreePainter extends CustomPainter {
  static const seedRadius = 2.0;
  static const scaleFactor = 4;
  static const tau = math.pi * 2;

  static final phi = (math.sqrt(5) + 1) / 2;

  final int seeds;

  XmasTreePainter(this.seeds);

  @override
  void paint(Canvas canvas, Size size) {
    // 三角（塗りつぶし）

    var paint = Paint();
    paint.color = Colors.green;

    var path = Path();

    // クリスマスツリー頂点の座標
    Offset topPos = Offset(size.width / 2, size.height / 5);

    int i = 3;

    // クリスマスツリー頂点からの距離 dft: distance from top
    double dft = 0;

    // クリスマスツリーを構成する三角形の1辺の長さ
    double sideLength = 0;

    for (i = 3; i < 20; i++) {
      // クリスマスツリー頂点からの距離 dft: distance from top
      dft = topPos.dy + (1 / 2) * math.pow(i + 1, 2).toDouble();
      // クリスマスツリーを構成する三角形の1辺の長さ
      sideLength = 10 * (i + 1);

      path
        ..moveTo(topPos.dx, dft)
        ..lineTo(topPos.dx - sideLength * math.sin(math.pi / 6),
            dft + sideLength * math.cos(math.pi / 6))
        ..lineTo(topPos.dx + sideLength / 2,
            dft + sideLength * math.cos(math.pi / 6));
    }

    path.close();

    canvas.drawPath(path, paint);

    paint.color = Colors.brown;
    var rect = Rect.fromLTWH(topPos.dx - i,
        dft + sideLength * math.cos(math.pi / 6), 2 * i.toDouble(), i * 3);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(XmasTreePainter oldDelegate) {
    return false; // oldDelegate.seeds != seeds;
  }

  // Draw a small circle representing a seed centered at (x,y).
  void drawSeed(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    canvas.drawCircle(Offset(x, y), seedRadius, paint);
  }
}

class XmasTree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _XmasTreeState();
  }
}

class _XmasTreeState extends State<XmasTree> {
  double seeds = 100.0;

  int get seedCount => seeds.floor();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        platform: platform,
        brightness: Brightness.dark,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: primaryColor,
          primaryColorLight: primaryColor,
          primaryColorDark: primaryColor,
          valueIndicatorTextStyle: const DefaultTextStyle.fallback().style,
        ),
      ),
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: CustomPaint(
                    painter: XmasTreePainter(seedCount),
                  ),
                ),
              ),
              Text("Showing $seedCount seeds"),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
                child: Slider.adaptive(
                  min: 20,
                  max: 2000,
                  value: seeds,
                  onChanged: (newValue) {
                    setState(() {
                      seeds = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
