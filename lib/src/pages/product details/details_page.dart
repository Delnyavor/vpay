import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/pages/chat/chat_page.dart';
import 'package:vpay/src/utils/route_transitions.dart';
import 'package:vpay/src/components/buttons.dart';
import 'package:vpay/src/components/slideshow.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  DetailsPage({this.product});
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<Offset> bottomBarOffsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    bottomBarOffsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(
          parent: animationController,
          curve: Interval(0, 0.7, curve: Curves.bounceIn)),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          body(),
          bottomBar(),
        ],
      ),
    );
  }

  Widget body() {
    return ListView(
        padding: const EdgeInsets.only(
          bottom: 100,
        ),
        children: [
          slideShow(),
          SizedBox(height: 25),
          detailsSection(),
        ]);
  }

  Widget slideShow() {
    return SlideShow(
      controller: animationController,
    );
  }

  Widget detailsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: details(),
    );
  }

  Widget details() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 26.0,
        vertical: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemName(),
          SizedBox(height: 25),
          description(),
          SizedBox(height: 35),
          sellerInfo(),
        ],
      ),
    );
  }

  Widget itemName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            'An Appropriately Descriptive Item Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(width: 15),
        favoriteButton()
      ],
    );
  }

  Widget favoriteButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.favorite_outline_rounded,
      ),
    );
  }

  Widget description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Description'),
        SizedBox(height: 5),
        Text(
          '''So that there is no discrepancy in sound between the beginning and the end: the tone should not be too soft or too loud, but rather, like a properly built organ, the ensemble should remain unaltered and constant ''',
          style: TextStyle(
            fontSize: 13,
            height: 1.7,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget sellerInfo() {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontSize: 13,
            height: 1.7,
            color: Colors.black,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('Seller Info'),
          SizedBox(height: 10),
          sellerNameAndRating(),
          SizedBox(height: 5),
          additionalSellerActions(),
        ],
      ),
    );
  }

  Widget price(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.5,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget sellerNameAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'John Smith',
          style: TextStyle(
            fontSize: 13,
            height: 1.7,
          ),
        ),
        Column(
          children: [
            Text(
              '98.7% User Rating',
              style: TextStyle(
                fontSize: 13,
                height: 1.7,
                color: Colors.indigoAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget additionalSellerActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View other offers',
          style: TextStyle(
            fontSize: 13,
            height: 1.7,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Save this Seller',
          style: TextStyle(
            fontSize: 13,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget bottomBar() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: bottomBarOffsetAnimation,
        builder: (context, builderChild) => SlideTransition(
          position: bottomBarOffsetAnimation,
          child: builderChild,
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          width: MediaQuery.of(context).size.width,
          child: bottomBarContents(),
        ),
      ),
    );
  }

  Widget bottomBarContents() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(FontAwesomeIcons.wallet, size: 18),
          SizedBox(width: 6),
          price('GHC 1,500'),
          tradeButton()
        ],
      ),
    );
  }

  Widget tradeButton() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 70),
        child: textButton(
          context,
          label: 'Purchase',
          function: () {
            Navigator.push(context, fadeInRoute(ChatPage()));
          },
          shrink: false,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
          buttonStyle: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.indigoAccent[700],
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
