import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

//curveDuration
final int curveDuration = 1500;

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      // color: Colors.grey,
      child: AspectRatio(
        aspectRatio: 1.4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: GraphLines(),
            ),
            GraphCurvePainter(),
            FlexData(),
          ],
        ),
      ),
    );
  }
}

class GraphCurvePainter extends StatefulWidget {
  @override
  _GraphCurvePainterState createState() => _GraphCurvePainterState();
}

class _GraphCurvePainterState extends State<GraphCurvePainter>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      //curveDuration
      duration: Duration(milliseconds: 2500),
    ); //Time for the animations to begin running. Use a shared AnimationController?
    Future.delayed(Duration(milliseconds: 100), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<double> values = [300, 1350, 790, 2700, 520, 200, 1300];
    return InkWell(
      onTap: () {
        controller
          ..reset()
          ..forward();
      },
      child: ClipRect(
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(pi),
            child: CustomPaint(
              painter: GraphCurve(
                  divisions: 6,
                  progress: controller.value,
                  values: values,
                  maxValue: 3000),
            ),
          ),
        ),
      ),
    );
  }
}

class GraphCurve extends CustomPainter {
  GraphCurve({this.divisions, this.progress, this.maxValue, this.values});
  double maxValue;
  List<double> values = <double>[];
  int divisions;
  double progress;

  Paint _paint = Paint()
    ..color = Color(0xf00080F6)
// Color(0xdd00A0EF)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  Path createPath(Size size) {
    var h = size.height;
    var w = (size.width - 20) / divisions;

    Path path = Path();
    path.addPolygon([
      for (int i = 0; i < values.length; i++)
        Offset(
          w * i + 10,
          h * (values[i] / maxValue),
        )
    ], false);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath(size);
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric metric in pathMetrics) {
      Path extractPath = metric.extractPath(
        0.0,
        metric.length * progress,
      );
      canvas.drawPath(extractPath, _paint);
    }
  }

  @override
  bool shouldRepaint(GraphCurve oldDelegate) {
    return true;
  }
}

class GraphLines extends CustomPainter {
  GraphLines({this.divisions = 6});
  int divisions;

  Paint _paint = Paint()
    ..color = Colors.black26
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.bevel;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    Path dashPath = Path();
    double dashWidth = 5.0;
    double dashSpace = 4.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        int division = 0;
        while (division <= divisions) {
          dashPath.addPath(
              pathMetric.extractPath(distance, distance + dashWidth),
              // Offset(0, -size.height / divisions * division),
              Offset(10 + ((size.width - 20) / divisions) * division, 0));
          division++;
        }
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FlexData extends StatefulWidget {
  @override
  _FlexDataState createState() => _FlexDataState();
}

class _FlexDataState extends State<FlexData>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  List<num> values = [300, 1350, 790, 2700, 520, 200, 1300];
  int divisions = 6;
  double maxValue = 3000;
  double divisionRatio;
  double divisionWidth;
  double height = 0;
  List<Widget> list = <Widget>[];

  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      //curveDuration
      duration: Duration(milliseconds: 2500),
    )..addListener(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getSize();
    //TODO: Time for the animations to begin running. Use a shared AnimationController?
    Future.delayed(Duration(milliseconds: 100), () {
      controller.forward();
    });
  }

  void getSize() {
    Future.delayed(Duration(milliseconds: 100), () {
      RenderBox box = key.currentContext.findRenderObject();

      setState(() {
        divisionWidth = (box.size.width - 20) / divisions;
        height = box.size.height;
      });

      print(height);
      createWidgets();
    });
  }

  Interval calculateInterval(int index) {
    double divisionRatio = controller.upperBound / values.length;
    double begin = index * divisionRatio;
    double end = (index + 1) * divisionRatio;
    return Interval(begin, end);
  }

  void createWidgets() {
    for (int i = 0; i < values.length; i++) {
      if (i < values.length - 1) {
        list.add(Node(
          interval: calculateInterval(i),
          controller: controller,
          value: values[i],
          divisionWidth: divisionWidth,
          height: height,
          maxValue: maxValue,
          index: i,
        ));
      } else {
        list.add(
          Node(
            interval: calculateInterval(i),
            controller: controller,
            isAtEnd: true,
            value: values[i],
            divisionWidth: divisionWidth,
            height: height,
            maxValue: maxValue,
            index: i,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: flexPoints(),
    );
  }

  Widget flexPoints() {
    print(height);

    return height == 0 ? Container() : buildPoints();
  }

  Widget buildPoints() {
    print('building');

    return Stack(
      children: list,
    );
  }
}

class Node extends StatefulWidget {
  final num value;
  final double divisionWidth, height;
  final int index;
  final double maxValue;
  final bool isAtEnd;
  final Interval interval;
  final AnimationController controller;
  Node(
      {this.value,
      this.divisionWidth,
      this.height,
      this.index,
      this.maxValue,
      this.isAtEnd = false,
      this.interval,
      this.controller});
  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  Animation<double> opacityAnimation, bounceIn1, bounceIn2;
  Animation scaleAnimation;
  bool clicked = false;

  @override
  void initState() {
    super.initState();

    double difference(double val) =>
        (widget.interval.end - widget.interval.begin) * val +
        widget.interval.begin;

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        widget.interval.begin,
        difference(0.7),
      ),
    ));

    bounceIn1 = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          widget.interval.begin,
          difference(0.7),
        ),
      ),
    );

    print("${widget.interval.begin}, ${widget.interval.end} ");
    bounceIn2 = Tween<double>(begin: 1.4, end: 0.8).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(difference(0.75), widget.interval.end),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //The value 6.5 here is half of the Node width: padding + border
      left: widget.divisionWidth * widget.index + 3, // 6.5 minus the offset; ,
      bottom: widget.value / widget.maxValue * widget.height - 6.5,
      child: nodeBuilder(),
    );
  }

  Widget nodeBuilder() {
    return AnimatedBuilder(
      animation: opacityAnimation,
      builder: (BuildContext context, Widget child) {
        return ScaleTransition(
          scale: bounceIn1,
          child: ScaleTransition(
            scale: bounceIn2,
            child:
                FadeTransition(opacity: opacityAnimation, child: nodeWidget()),
          ),
        );
      },
    );
  }

  Widget nodeWidget() {
    return Center(
      child: Stack(
        children: [
          // Align(alignment: Alignment.bottomCenter, child: nodeDot()),
          nodeDot(),
          // Align(alignment: Alignment.bottomLeft, child: nodeData())
        ],
      ),
    );
  }

  Widget nodeDot() {
    return PhysicalModel(
      elevation: 2,
      color: Colors.grey[800],
      shadowColor: Colors.grey[200],
      shape: BoxShape.circle,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          color: Color(0xf00080F6),
        ),
      ),
    );
  }

  Widget nodeData() {
    return SizedBox(
      height: 30,
      width: 60,
      child: Card(
        elevation: 4,
        child: Text('${widget.value}'),
      ),
    );
  }
}
