import 'package:flutter/material.dart';
import 'dart:math';

import 'clippers.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class Header extends StatelessWidget {
  Header(this.child);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 90.0,
        maxHeight: 300.0,
        child: Container(
            padding: EdgeInsets.only(top: 30),
            color: Colors.blue,
            child: child),
      ),
    );
  }
}

class CutHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      // floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 25.0,
        maxHeight: 25.0,
        child: Transform.translate(
          offset: Offset(0, -5),
          child: ClipPath(clipper: CurvedClipper(), child: AppBar()),
        ),
      ),
    );
  }
}

// class CatHeader extends StatelessWidget {
//   final double maxHeight;
//   CatHeader({this.maxHeight});
//   @override
//   Widget build(BuildContext context) {
//     return SliverPersistentHeader(
//       pinned: true,
//       floating: false,
//       delegate: _SliverAppBarDelegate(
//         minHeight: 70.0,
//         maxHeight: maxHeight ?? 70.0,
//         child: CategoryHeader(),
//       ),
//     );
//   }
// }

class SliverHeader extends StatelessWidget {
  SliverHeader(
      {this.child,
      this.minHeight = kToolbarHeight,
      this.maxHeight = kToolbarHeight,
      this.pinned = false,
      this.floating = false});
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _SliverAppBarDelegate(
        minHeight: minHeight,
        maxHeight: maxHeight ?? double.infinity,
        child: child,
      ),
    );
  }
}
