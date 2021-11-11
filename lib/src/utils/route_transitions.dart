import 'package:flutter/material.dart';

PageRoute fadeInRoute(Widget route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));

      return FadeTransition(
        opacity: animation.drive(tween),
        child: child,
      );
    },
  );
}

PageRoute slideInRoute(Widget route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          .chain(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
