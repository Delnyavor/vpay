import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vpay/src/dao/chat_dao.dart';
import 'package:vpay/src/models/category.dart';
import 'package:vpay/src/pages/chat/chat_page.dart';
import 'package:vpay/src/utils/route_transitions.dart';
import 'package:vpay/src/components/slideshow.dart';

class DetailsPage extends StatefulWidget {
  final Product? product;
  DetailsPage({this.product});
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> bottomBarOffsetAnimation;

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
      body: Stack(
        children: [
          scrollView(),
          bottomBar(),
        ],
      ),
    );
  }

  Widget scrollView() {
    return CustomScrollView(
      slivers: <Widget>[
        sliverAppBar(),
        SliverList(delegate: SliverChildListDelegate([slideShow()])),
        SliverList(delegate: SliverChildListDelegate([itemName()])),
        SliverList(delegate: SliverChildListDelegate([description()])),
        SliverList(delegate: SliverChildListDelegate([sellerInfo()])),
      ],
    );
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      iconTheme: IconThemeData(color: Colors.black87),
      primary: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  Widget slideShow() {
    return SlideShow(
      controller: animationController,
    );
  }

  Widget itemName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.product!.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(width: 15),
          favoriteButton(),
        ],
      ),
    );
  }

  Widget favoriteButton() {
    return Icon(
      Icons.favorite_outline_rounded,
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('Description'),
          SizedBox(height: 5),
          Text(
            '''So that there is no discrepancy in sound between the beginning and the end: the tone should not be too soft or too loud, but rather, like a properly built organ, the ensemble should remain unaltered and constant ''',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 13,
              height: 1.7,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Theme(
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
            SizedBox(height: 100),
          ],
        ),
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
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 0),
              color: Colors.black12,
            )
          ]),
          child: bottomBarContents(),
        ),
      ),
    );
  }

  Widget bottomBarContents() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.wallet, size: 18),
              SizedBox(width: 6),
              price('GHC 1,500'),
            ],
          ),
          SizedBox(width: 50),
          tradeButton()
        ],
      ),
    );
  }

  Widget tradeButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.indigoAccent[700],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(Icons.shopping_basket),
        onPressed: () async {
          await ChatDao().createChatRoom('vendorId', 'userId');
          Navigator.push(context, fadeInRoute(ChatPage()));
        },
      ),
    );
  }
}
