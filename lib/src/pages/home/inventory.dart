// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vpay/src/models/category.dart';
// import 'package:vpay/src/provider/products_provider.dart';
// import 'package:vpay/src/utils/screen_adaptor.dart';
// import 'package:vpay/src/widgets/category_widgets.dart';
// import 'package:vpay/src/widgets/search_widget.dart';
// import 'package:vpay/src/widgets/slivers.dart';

// class InventoryPage extends StatefulWidget {
//   @override
//   _InventoryPageState createState() => _InventoryPageState();
// }

// class _InventoryPageState extends State<InventoryPage>
//     with TickerProviderStateMixin {
//   ProductsProvider repo;
//   Color primaryColor, seconaryColor;
//   double dpr;
//   List<Category> categories = [];

//   TabController tabController;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     primaryColor = Theme.of(context).primaryColor;
//     seconaryColor = Theme.of(context).accentColor;
//     repo = Provider.of<ProductsProvider>(context);
//     dpr = MediaQuery.of(context).devicePixelRatio;

//     categories = repo.categories;
//     tabController = TabController(length: categories.length, vsync: this);
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Theme.of(context).primaryColor,
//       body: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               primaryColor,
//               primaryColor.withBlue(240).withGreen(180).withRed(0)
//             ],
//             stops: [0.6, 1],
//           ),
//         ),
//         child: SafeArea(
//           child: NestedScrollView(
//             headerSliverBuilder:
//                 (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
//               appBar(),
//               SliverHeader(
//                 pinned: false,
//                 floating: false,
//                 minHeight: ResponsiveSize.flexSize(80, dpr),
//                 maxHeight: ResponsiveSize.flexSize(80, dpr),
//                 child: tabBar(),
//               ),
//             ],
//             body: tabViews(),
//           ),
//         ),
//       ),
//     );
//   }

//   SliverAppBar appBar() {
//     return SliverAppBar(
//       iconTheme: IconThemeData(color: Colors.white),
//       primary: true,
//       elevation: 0,
//       floating: false,
//       pinned: false,
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       leading: IconButton(
//         onPressed: () {},
//         icon: Icon(Icons.keyboard_arrow_left),
//       ),
//       actions: <Widget>[
//         Transform(transform: Matrix4.rotationY(pi), child: Icon(Icons.sort))
//       ],
//       expandedHeight: 250,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: true,
//         title: SizedBox(
//           height: ResponsiveSize.flexSize(
//               125 + MediaQuery.of(context).padding.top, dpr),
//           width: ResponsiveSize.flexSize(300, dpr),
//           child: Center(
//             child: Text(
//               "Inventory",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: Size.fromHeight(80),
//         child: SearchWidget(),
//       ),
//     );
//   }

//   Widget tabBar() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0, top: 12),
//       child: TabBar(
//         controller: tabController,
//         labelColor: Colors.white,
//         isScrollable: true,
//         indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
//         unselectedLabelColor: Colors.white38,
//         indicatorColor: Colors.orangeAccent,
//         indicatorSize: TabBarIndicatorSize.tab,
//         tabs: [
//           for (final category in categories)
//             Tab(
//               text: category.name,
//             )
//         ],
//       ),
//     );
//   }

//   Widget tabViews() {
//     return TabBarView(
//       controller: tabController,
//       children: <Widget>[
//         for (final category in categories)
//           tabViewContent(
//             category,
//           )
//       ],
//     );
//   }

//   Widget tabViewContent(Category category) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('products')
//           .where('category', isEqualTo: category.name)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return new Text('${snapshot.error}');
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return new Center(
//               child: new CircularProgressIndicator(
//                 backgroundColor: Colors.white,
//               ),
//             );
//           default:
//             List<Product> products =
//                 snapshot.data.docs.map((e) => Product.fromSnapshot(e)).toList();
//             return categoryWidget(products);
//         }
//       },
//     );
//   }

//   Widget categoryWidget(List<Product> products) {
//     Orientation orientation = MediaQuery.of(context).orientation;

//     return products.isEmpty
//         ? Center(child: Text('Nothing here yet'))
//         : GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//                 childAspectRatio: 1 / 1.25),
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             addAutomaticKeepAlives: true,
//             scrollDirection: Axis.vertical,
//             itemCount: products.length,
//             itemBuilder: (BuildContext context, int index) {
//               print('building products $index');
//               return ProductWidget(
//                 product: products[index],
//                 textTheme: Theme.of(context).textTheme,
//               );
//             },
//           );
//   }
// }
