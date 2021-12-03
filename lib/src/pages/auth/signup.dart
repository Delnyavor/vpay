import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String _businessName, _paymentNumber;
  late Animation<double> animation;
  late Tween<double> tween;
  late AnimationController controller;
  late BuildContext snackBarContext;
  late FocusNode node1, node2;
  late double devicePixelRatio, deviceHeight, deviceWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    runAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    node1 = FocusNode(canRequestFocus: true);
    node2 = FocusNode(canRequestFocus: true);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    tween = Tween<double>(
      begin: 300,
      end: 0,
    );
    animation = tween.animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0, 0.5, curve: Curves.ease)),
    );
  }

  bool isPortrait() {
    return (MediaQuery.of(context).orientation == Orientation.portrait);
  }

  bool isKeyboardVisible() {
    return (MediaQuery.of(context).viewInsets.bottom > 150);
  }

  void init() {
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
  }

  void runAnimation() {
    if (isKeyboardVisible())
      controller.forward();
    else
      controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        snackBarContext = context;
        return body();
      }),
    );
  }

  Widget logo() {
    return (isPortrait())
        ? Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 25, bottom: 25),
            child: Text('vPay', style: Theme.of(context).textTheme.headline3))
        : SizedBox.shrink();
  }

  Widget body() {
    return Container(
      // color: Colors.grey,
      constraints: BoxConstraints(
          minHeight:
              isKeyboardVisible() ? MediaQuery.of(context).size.height : 0,
          maxHeight: MediaQuery.of(context).size.height),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: form(),
              ),
            ),
            bottom()
          ],
        ),
      ),
    );
  }

  Widget topBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPortrait()) logo(),
        if (isPortrait())
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) => Container(
              constraints: BoxConstraints(maxHeight: animation.value),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Image.asset(
                  'assets/onboard1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let\'s get started',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 28, color: Colors.lightBlue[600]),
                ),
                Text(
                  "Create a free account",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(height: 1.6, color: Colors.grey[700]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      // color: Colors.green,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            decoration: InputDecoration(
              hintText: 'Business Name',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.business,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              node1.dispose();
              FocusScope.of(context).requestFocus(node2);
            },
            validator: (String? value) {
              if (value!.isEmpty)
                return "Please fill out all fields";
              else
                return null;
            },
            onSaved: (String? val) {
              _businessName = val!;
            },
          ),
          SizedBox(
            height: 25,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'MoMo Number',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.phone,
              ),
            ),
            keyboardType: TextInputType.number,
            onEditingComplete: () {
              node2.dispose();
              submit();
            },
            validator: (String? value) {
              if (value!.length < 10) {
                return 'Number is less than ten digits';
              } else
                return null;
            },
            onSaved: (String? val) {
              _paymentNumber = val!;
            },
          ),
          SizedBox(
            height: 20,
          ),
          submitWidget(),
        ],
      ),
    );
  }

  Widget submitWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Color(0x33000000), blurRadius: 2, spreadRadius: 0.1),
              BoxShadow(
                  color: Color(0x442D96F6),
                  blurRadius: 10,
                  offset: Offset(0, 5)),
            ],
          ),
          child: submitButton()),
    );
  }

  Future<bool> validateInputs() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else
      return false;
  }

  Widget submitButton() {
    return SizedBox(
      // height: 30,
      // width: 30,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 30,
        icon: Hero(
          tag: 'hero',
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          submit();
        },
      ),
    );
  }

  void submit() {
    validateInputs().then(
      (validated) {
        if (validated) {
          print('$_businessName , "$_paymentNumber"');
          Navigator.pushNamed(context, 'userdetails');
        }
      },
    );
  }

  Widget bottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account? ",
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(width: 2),
          InkWell(
            child: Text(
              'Sign in',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.lightBlue),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
    );
  }
}
