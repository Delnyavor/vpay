import 'package:flutter/material.dart';

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacity;
  late Tween<double> tween;
  late ScrollPosition _position;

  Opacity _opacity = Opacity(
    opacity: 1.0,
  );

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    tween = Tween<double>(begin: 0, end: 1);
    opacity = tween.animate(animationController);
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)!.position;
    _position.addListener(_visiblePositionListener);
    _visiblePositionListener();
  }

  void _removeListener() {
    _position.removeListener(_visiblePositionListener);
  }

  void _visiblePositionListener() {
    final FlexibleSpaceBarSettings settings = context
        .dependOnInheritedWidgetOfExactType(aspect: FlexibleSpaceBarSettings)!;
    bool visible = settings.currentExtent == settings.minExtent;
    if (visible == true) {
      setState(() {
        _opacity = Opacity(
          opacity: 1,
        );
      });
    } else {
      setState(() {
        _opacity = Opacity(
          opacity: 0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity.opacity,
      duration: Duration(milliseconds: 200),
      child: widget.child,
    );
  }
}
