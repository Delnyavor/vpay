import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/pages/home/inventory.dart';
import 'package:vpay/src/pages/home/landing.dart';
import 'package:vpay/src/provider/products_provider.dart';
import 'package:vpay/src/widgets/modal.dart';
import 'src/pages/auth/userdetails.dart';
import 'src/pages/auth/signup.dart';

import 'src/pages/auth/login.dart';
import 'src/pages/auth/verification.dart';
import 'src/pages/product details/details_page.dart';
import 'src/utils/screen_adaptor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),

        // ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xff2dc8ac),
          accentColor: Color(0xff6E60D0),
          fontFamily: GoogleFonts.lato().fontFamily,
          textTheme: GoogleFonts.latoTextTheme().copyWith(
            bodyText2: TextStyle(
              letterSpacing: 0,
            ),
            button: TextStyle(letterSpacing: 0, fontSize: 13),
            headline4: TextStyle(
                letterSpacing: 0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.w500),
            headline3: TextStyle(
                letterSpacing: 0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.w500),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Landing(),
          Routes.login: (context) => LoginPage(),
          Routes.signup: (context) => SignUpPage(),
          Routes.userdetails: (context) => UserDetails(),
          Routes.finalisation: (context) => FinalisationPage(),
          Routes.inventory: (context) => InventoryPage(),
          Routes.landing: (context) => LandingPage(),
          Routes.modal: (context) => MyModal(),
          Routes.product: (context) => DetailsPage()
        },
      ),
    );
  }
}

class Routes {
  static String landing = 'landing';
  static String login = 'login';
  static String signup = 'signup';
  static String userdetails = 'userdetails';
  static String finalisation = 'finalisation';
  static String inventory = 'inventory';
  static String modal = 'modal';
  static String product = 'product';
}

class Landing extends StatefulWidget {
  Landing({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  double deviceWidth;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ResponsiveSize.devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    deviceWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Hello'),
          onPressed: () {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.currentUser().then((user) {
              if (user != null)
                Navigator.pushNamed(context, 'inventory');
              else
                Navigator.pushNamed(context, Routes.landing);
            });
          },
        ),
      ),
    );
  }
}
