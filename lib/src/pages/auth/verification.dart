import 'package:flutter/material.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';

import 'auth_methods.dart';

class FinalisationPage extends StatefulWidget {
  @override
  _FinalisationPageState createState() => _FinalisationPageState();
}

class _FinalisationPageState extends State<FinalisationPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obfuscation = true;
  bool _isLoading = false;
  String _email, _password;
  FocusNode focusNode1, focusNode2;
  double devicePixelRatio;
  BuildContext snackBarContext;
  double dpr;

  @override
  void initState() {
    super.initState();
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    dpr = MediaQuery.of(context).devicePixelRatio;
  }

  bool isPortrait() {
    return (MediaQuery.of(context).orientation == Orientation.portrait);
  }

  bool isKeyboardVisible() {
    return (MediaQuery.of(context).viewInsets.bottom > 200);
  }

  @override
  Widget build(BuildContext context) {
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) => Column(
          children: <Widget>[
            Flexible(child: body()),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return (isPortrait())
        ? Container(
            alignment: Alignment.topCenter,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 25),
            child: Text('vPay', style: Theme.of(context).textTheme.headline3),
          )
        : SizedBox.shrink();
  }

  Widget body() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
          minHeight:
              isKeyboardVisible() ? MediaQuery.of(context).size.height : 0,
          maxHeight: MediaQuery.of(context).size.height),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            topBanner(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.flexSize(30, dpr),
                ResponsiveSize.flexSize(30, dpr),
                ResponsiveSize.flexSize(30, dpr),
                0,
              ),
              child: Form(
                key: _formKey,
                child: form(),
              ),
            ),
            // bottom()
          ],
        ),
      ),
    );
  }

  Widget topBanner() {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        logo(),
        SizedBox(
          height: ResponsiveSize.flexSize(50, dpr),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Finish',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 28, color: Colors.lightBlue[600]),
                ),
                Text(
                  "By signing up, you agree to Vpay's terms and conditions",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 2, color: Colors.grey[600]),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveSize.flexSize(15, dpr),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      // color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextFormField(
            focusNode: focusNode1,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey[700],
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              focusNode1.dispose();
              FocusScope.of(context).requestFocus(focusNode2);
            },
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
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              focusNode1.dispose();
            },
            obscureText: _obfuscation,
            validator: validatePassword,
            onSaved: (String val) {
              _password = val;
            },
          ),
          SizedBox(
            height: ResponsiveSize.flexSize(20, dpr),
          ),
          submitWidget()
        ],
      ),
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
      child: Text(
        'REGISTER',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5),
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
}
//
