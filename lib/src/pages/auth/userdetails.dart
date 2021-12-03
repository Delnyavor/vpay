import 'package:flutter/material.dart';
import 'package:vpay/src/utils/screen_adaptor.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  late FocusNode node1, node2, node3, node4;
  late String _firstName, _lastName, _merchantId, _location;
  late double devicePixelRatio;
  late double dpr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dpr = MediaQuery.of(context).devicePixelRatio;
  }

  void initState() {
    super.initState();
    node1 = FocusNode(canRequestFocus: true);
    node2 = FocusNode(canRequestFocus: true);
    node3 = FocusNode(canRequestFocus: true);
    node4 = FocusNode(canRequestFocus: true);
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
      body: Column(
        children: <Widget>[
          Flexible(child: body()),
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      alignment: Alignment.bottomCenter,
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      // maxHeight: MediaQuery.of(context).size.height),
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
            Align(alignment: Alignment.centerRight, child: bottom()),
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

  Widget topBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 28, color: Colors.lightBlue[600]),
                ),
                Text(
                  "Just a few more details",
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            decoration: InputDecoration(
              hintText: 'First Name',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey[700],
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty)
                return "Field is empty";
              else
                return null;
            },
            onEditingComplete: () {
              print("object");
              node1.unfocus();
              FocusScope.of(context).requestFocus(node2);
            },
            onSaved: (String? val) {
              _firstName = val!;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            focusNode: node2,
            decoration: InputDecoration(
              hintText: 'Last Name',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.people_outline,
                color: Colors.grey[700],
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Field is empty';
              } else
                return null;
            },
            onEditingComplete: () {
              print("object");
              node2.unfocus();
              FocusScope.of(context).requestFocus(node3);
            },
            onSaved: (String? val) {
              _lastName = val!;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            focusNode: node3,
            decoration: InputDecoration(
              hintText: 'Merchant Id',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.assignment_ind,
                color: Colors.grey[700],
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              node3.unfocus();
              FocusScope.of(context).requestFocus(node4);
            },
            validator: (String? value) {
              if (value!.isEmpty)
                return "Field is empty";
              else
                return null;
            },
            onSaved: (String? val) {
              _merchantId = val!;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            focusNode: node4,
            decoration: InputDecoration(
              hintText: 'Business Address',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.grey[700],
              ),
            ),
            keyboardType: TextInputType.text,

            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              print("object");
              node4.unfocus();
              submit();
            },
            // validator: (String? value) {
            //   if (value.length < 10) {
            //     return 'Number is invalid';
            //   } else
            //     return null;
            // },

            onSaved: (String? val) {
              _location = val!;
            },
          ),
          SizedBox(
            height: ResponsiveSize.flexSize(20, dpr),
          ),
          submitWidget(),
        ],
      ),
    );
  }

  Future<bool> validateInputs() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else
      return false;
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

  Widget submitButton() {
    return SizedBox(
      // height: 30,
      // width: 30,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 30,
        icon: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
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
          Navigator.pushNamed(context, 'finalisation');
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
//
