import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';
import 'auth_methods.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obfuscation = true;
  bool _isLoading = false;
  String _email, _password;
  FocusNode focusNode1, focusNode2;
  Animation<double> animation;
  Animation<double> opAnimation;
  Tween<double> tween, opacityTween;
  AnimationController controller;
  AnimationController opController;
  ScrollController scrollController;
  BuildContext snackBarContext;
  double devicePixelRatio, deviceHeight, deviceWidth;
  double dpr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
    hideIllustration();
    opController.reset();
    if (deviceHeight >= baseHeight) {
      opController.forward();
    }
    dpr = MediaQuery.of(context).devicePixelRatio;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    opController.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    opController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    scrollController = ScrollController();
    tween = Tween<double>(
      begin: 300,
      end: 0,
    );
    opacityTween = Tween<double>(
      begin: 0,
      end: 1,
    );
    animation = tween.animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0, 0.5, curve: Curves.easeIn)),
    );
    opAnimation = opacityTween.animate(
      CurvedAnimation(
          parent: opController,
          curve: Interval(0, 1, curve: Curves.easeInOutQuad)),
    );
  }

  bool isPortrait() {
    return (MediaQuery.of(context).orientation == Orientation.portrait);
  }

  bool isKeyboardVisible() {
    return (MediaQuery.of(context).viewInsets.bottom > 200);
  }

  void hideIllustration() {
    if (isKeyboardVisible())
      controller.forward();
    else
      controller.reverse();
  }

  void scrollListener(ScrollUpdateNotification notification) {
    try {
      print(scrollController.offset);
      // If user scrolls up by 10 pixels from the bottom
      if (!notification.dragDetails.delta.direction.isNegative &&
          notification.metrics.maxScrollExtent - scrollController.offset > 10) {
        opController.reverse();
      }
      //if user scrolls down until the last 40 pixels
      if (notification.dragDetails.delta.direction.isNegative &&
          notification.metrics.maxScrollExtent - scrollController.offset < 40) {
        opController.forward();
      }
    } catch (e) {
      print(e);
      if (scrollController.offset == notification.metrics.maxScrollExtent) {
        opController.forward();
        print('end');
      }
    }
  }

  void init() {
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
          snackBarContext = context;
          return Stack(alignment: Alignment.center, children: [
            body(),
            Positioned(
                bottom: ResponsiveSize.flexHeight(20, deviceHeight),
                child: Center(child: bottom()))
          ]);
        },
      ),
    );
  }

  Widget body() {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            scrollListener(notification);
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              topBanner(),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: form(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return (isPortrait())
        ? Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 50, bottom: 25),
            child: Text('vPay', style: Theme.of(context).textTheme.headline2),
          )
        : SizedBox.shrink();
  }

  Widget topBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPortrait()) logo(),
        if (isPortrait())
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) => Container(
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
                  'Welcome',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 28, color: Colors.lightBlue[600]),
                ),
                Text(
                  "Sign in to continue",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
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
    // print(
    //   ResponsiveSize.flexHeight(25, deviceHeight),
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextFormField(
          focusNode: focusNode1,
          decoration: InputDecoration(
            hintText: 'Email Address',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[700]),
            prefixIcon: Icon(
              Icons.person_outline,
              size: ResponsiveSize.flexSize(24, dpr),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          onSaved: (String val) {
            _email = val;
          },
        ),
        SizedBox(
          height: ResponsiveSize.flexSize(25, dpr),
        ),
        TextFormField(
          focusNode: focusNode2,
          decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[700]),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: ResponsiveSize.flexSize(24, dpr),
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                    _obfuscation ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obfuscation = !_obfuscation;
                  });
                },
              )),
          keyboardType: TextInputType.text,
          onEditingComplete: () {
            print('object');
          },
          obscureText: _obfuscation,
          validator: validatePassword,
          onSaved: (String val) {
            _password = val;
          },
        ),
        SizedBox(height: ResponsiveSize.flexHeight(25, deviceHeight)),
        submitWidget(),
        SizedBox(height: ResponsiveSize.flexHeight(25, deviceHeight)),
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length < 8) {
      return 'Pasword must be at least 8 characters long';
    } else if (!value.contains(RegExp(r'[0-9]{1,}'))) {
      return 'Password must be alphanumeric';
    } else
      return null;
  }

  Future<bool> validateInputs() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else
      return false;
  }

  Widget submitWidget() {
    return _isLoading
        ? Container(
            margin: EdgeInsets.symmetric(
              vertical: ResponsiveSize.flexSize(20, dpr),
            ),
            height: ResponsiveSize.flexSize(30, dpr),
            width: ResponsiveSize.flexSize(30, dpr),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1.5,
            ))
        : Container(
            margin: EdgeInsets.symmetric(
              vertical: ResponsiveSize.flexSize(20, dpr),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Color(0x33000000), blurRadius: 2, spreadRadius: 0.1),
                BoxShadow(
                    color: Color(0x332D96F6),
                    blurRadius: 15,
                    offset: Offset(0, 5)),
              ],
            ),
            child: submitButton());
  }

  Widget submitButton() {
    return FlatButton(
      color: Colors.lightBlue,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 9.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Hero(
        tag: 'hero',
        child: Text(
          'LOG IN',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5),
        ),
      ),
      onPressed: () {
        submit();
      },
    );
  }

  void submit() {
    setState(() {
      _isLoading = true;
    });
    validateInputs().then(
      (validated) {
        if (validated) {
          print('$_email , $_password');
          signIn(snackBarContext,
              email: _email, password: _password, errorFunc: resetState);
        } else
          resetState();
      },
    );
  }

  void resetState() {
    setState(() {
      _isLoading = false;
    });
  }

  Widget bottom() {
    return AnimatedBuilder(
      animation: opController,
      builder: (BuildContext context, Widget child) => Container(
        padding: const EdgeInsets.only(bottom: 30.0, top: 20),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: opAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Don't already have an account? ",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(width: 5),
              InkWell(
                child: Text(
                  'Sign up',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.lightBlue),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('signup');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
