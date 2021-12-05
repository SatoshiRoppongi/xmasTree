// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

final Color primaryColor = Colors.orange;
// const TargetPlatform platform = TargetPlatform.android;

void main() {
  runApp(XmasTree());
}

class XmasTreePainter extends CustomPainter {
  final int treeSize;

  XmasTreePainter(this.treeSize);

  @override
  void paint(Canvas canvas, Size size) {
    // 三角（塗りつぶし）

    var paint = Paint();
    paint.color = Colors.green;

    var leaves = Path();

    // クリスマスツリー頂点の座標
    Offset topPos = Offset(size.width / 2, size.height / 5);

    int i = 3;

    // クリスマスツリー頂点からの距離 dft: distance from top
    double dft = 0;

    // クリスマスツリーを構成する三角形の1辺の長さ
    double sideLength = 0;

    for (i = 0; i < treeSize; i++) {
      dft = topPos.dy + (1 / 2) * math.pow(i + 1, 2).toDouble();
      sideLength = 10 * (i + 1);

      leaves
        ..moveTo(topPos.dx, dft)
        ..lineTo(topPos.dx - sideLength * math.sin(math.pi / 6),
            dft + sideLength * math.cos(math.pi / 6))
        ..lineTo(topPos.dx + sideLength / 2,
            dft + sideLength * math.cos(math.pi / 6));
    }

    leaves.close();
    canvas.drawPath(leaves, paint);

    // もみの木のみき
    var trunkLeft = topPos.dx - i;
    var trunkTop = dft + sideLength * math.cos(math.pi / 6);
    var trunkWidth = 2 * i.toDouble();
    var trunkHeight = i.toDouble();

    paint.color = Colors.brown;
    var trunk = Rect.fromLTWH(trunkLeft, trunkTop, trunkWidth, trunkHeight);

    canvas.drawRect(trunk, paint);

    // スタンドカバー
    var standLeft = trunkLeft - i;
    var standTop = trunkTop + trunkHeight;
    var standWidth = 2 * trunkWidth;
    var standHeight = 2 * trunkHeight;
    var stand = Rect.fromLTWH(standLeft, standTop, standWidth, standHeight);
    canvas.drawRect(stand, paint);

    // ガーランド
    var garland = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // for (int j = 0; j < 3; j++) {
    final garlandPath = Path();
      double randomPosY = math.Random().nextDouble() * (trunkTop - topPos.dy);
      garlandPath.moveTo(topPos.dx + 50, randomPosY);
      
      garlandPath.quadraticBezierTo(
          topPos.dx + 45, randomPosY + 35, topPos.dx - 30, randomPosY + 50);
    
      garlandPath.close();
      canvas.drawPath(garlandPath, garland);
    // }

    // ボール
    List<MaterialColor> colorList = [
      Colors.red,
      Colors.blue,
      Colors.lightGreen
    ];
    for (int j = 0; j < 30; j++) {
      double randomPosY = math.Random().nextDouble() * (trunkTop - topPos.dy);
      double randomPosX =
          2 * (math.Random().nextDouble() - (1 / 2)) * randomPosY / 4;
      int randomColorIndex = math.Random().nextInt(colorList.length);
      paint.color = colorList[randomColorIndex];
      canvas.drawCircle(Offset(topPos.dx + randomPosX, topPos.dy + randomPosY),
          i * size.width / 1000, paint);
    }

    paint.color = Colors.yellow;
    var star = Path();

    double radius = i.toDouble();
    // star..moveTo(topPos.dx, topPos.dy + radius);
    for (int j = 0; j < 6; j++) {
      var angle = -math.pi / 10 + j * 4 * math.pi / 5;
      star.lineTo(radius * math.cos(angle) + topPos.dx,
          radius * math.sin(angle) + topPos.dy);
    }
    star.close();

    canvas.drawPath(star, paint);
  }

  @override
  bool shouldRepaint(XmasTreePainter oldDelegate) {
    // return false; // oldDelegate.seeds != seeds;
    return oldDelegate.treeSize != treeSize;
  }
}

class XmasTree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _XmasTreeState();
  }
}

class _XmasTreeState extends State<XmasTree> {
  int treeSize = 20;

  int get seedCount => treeSize;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        // platform: platform,
        brightness: Brightness.dark,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: primaryColor,
          primaryColorLight: primaryColor,
          primaryColorDark: primaryColor,
          valueIndicatorTextStyle: const DefaultTextStyle.fallback().style,
        ),
      ),
      */
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    painter: XmasTreePainter(treeSize),
                  ),
                ),
              ),
              Text("木の大きさ $treeSize"),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 400),
                child: Slider.adaptive(
                  min: 3,
                  max: 30,
                  value: treeSize.toDouble(),
                  onChanged: (newValue) {
                    setState(() {
                      treeSize = newValue.toInt();
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
