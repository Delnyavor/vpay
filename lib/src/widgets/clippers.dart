import 'package:flutter/material.dart';

class CurvedClipper extends CustomClipper<Path> {
  double w, h;
  @override
  Path getClip(Size size) {
    w = size.width;
    h = size.height;

    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(w * 0.0, h * 0.11, w * 0.1, h * 0.17);
    path.lineTo(w * 0.87, h * 0.17);
    path.quadraticBezierTo(w , h * 0, w, h);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
