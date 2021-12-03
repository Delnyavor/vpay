import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vpay/src/pages/home/landing.dart';
import 'package:vpay/src/provider/chat_provider.dart';
import 'package:vpay/src/provider/products_provider.dart';
import 'src/pages/auth/userdetails.dart';
import 'src/pages/auth/signup.dart';

import 'src/pages/auth/login.dart';
import 'src/pages/auth/verification.dart';
import 'src/pages/product details/details_page.dart';
import 'src/utils/screen_adaptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),

        // ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        title: 'Vpay',
        theme: ThemeData(
          // primaryColor: Color(0xff2dc8ac),
          // accentColor: Color(0xff0080F6),
          primaryColor: Color(0xff004aff),
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Landing(),
          Routes.login: (context) => LoginPage(),
          Routes.signup: (context) => SignUpPage(),
          Routes.userdetails: (context) => UserDetails(),
          Routes.finalisation: (context) => FinalisationPage(),
          Routes.landing: (context) => LandingPage(),
          // Routes.modal: (context) => MyModal(),
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
  Landing();

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late double deviceWidth;
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
        child: TextButton(
          child: Text('Hello'),
          onPressed: () {
            FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;

            // ignore: unnecessary_null_comparison
            if (user != null)
              Navigator.pushNamed(context, Routes.inventory);
            else
              Navigator.pushNamed(context, Routes.landing);
          },
        ),
      ),
    );
  }
}
