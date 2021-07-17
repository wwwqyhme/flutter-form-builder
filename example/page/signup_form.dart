import 'package:flutter/material.dart';
import 'package:forme/forme.dart';

/// from https://github.com/sherazmahar/Flutter-Login-Signup-UI
class SignupFormPage extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupFormPage> {
  bool checkBoxValue = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  final FormeKey formeKey = FormeKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
            height: _height,
            width: _width,
            margin: EdgeInsets.only(bottom: 5),
            child: Forme(
              quietlyValidate: true,
              onWillPop: () async {
                return true;
              },
              key: formeKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Opacity(opacity: 0.88, child: CustomAppBar()),
                    clipShape(),
                    form(),
                    acceptTermsTextRow(),
                    SizedBox(
                      height: _height / 35,
                    ),
                    button(),
                    //signInTextRow(),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                print('Adding photo');
              },
              child: Icon(
                Icons.add_a_photo,
                size: _large ? 40 : (_medium ? 33 : 31),
                color: Colors.orange[200],
              )),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Column(
        children: <Widget>[
          firstNameTextFormField(),
          SizedBox(height: _height / 60.0),
          lastNameTextFormField(),
          SizedBox(height: _height / 60.0),
          emailTextFormField(),
          SizedBox(height: _height / 60.0),
          phoneTextFormField(),
          SizedBox(height: _height / 60.0),
          passwordTextFormField(),
        ],
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
      name: 'firstName',
      formeKey: formeKey,
      listener: FormeValueFieldListener(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValidate: FormeValidates.size(min: 5, errorText: 'at least 5 length'),
        onAsyncValidate: (f, v) => Future.delayed(Duration(seconds: 2),
            () => v == 'admin' ? null : 'username exists'),
      ),
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Last Name",
      name: 'lastName',
      formeKey: formeKey,
      listener: FormeValueFieldListener(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onValidate: FormeValidates.size(
            min: 6, errorText: 'Last Name\'s must bigger than 6'),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
      name: 'email',
      formeKey: formeKey,
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Mobile Number",
      name: 'mobile',
      formeKey: formeKey,
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
      name: 'password',
      formeKey: formeKey,
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
        margin: EdgeInsets.only(top: _height / 100.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FormeSingleSwitch(
                  name: 'accept',
                  listener: FormeValueFieldListener(
                    onValidate: FormeValidates.equals(true,
                        errorText: 'you must accept all terms and conditions'),
                  ),
                ),
                Text(
                  "I accept all terms and conditions",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: _large ? 12 : (_medium ? 11 : 10)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  return ValueListenableBuilder<FormeValidateError?>(
                      valueListenable:
                          formeKey.valueField('accept').errorTextListenable,
                      builder: (context, a, b) {
                        if (a != null && a.invalid)
                          return Text(
                            a.text!,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          );
                        return SizedBox();
                      });
                })
              ],
            ),
          ],
        ));
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
            textStyle:
                MaterialStateProperty.all(TextStyle(color: Colors.white)),
            padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          ),
          onPressed: () {
            formeKey.reset();
          },
          child: Container(
            alignment: Alignment.center,
            width:
                _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(
                colors: <Color>[Colors.pinkAccent[200]!, Colors.redAccent],
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'CLEAR',
              style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
            textStyle:
                MaterialStateProperty.all(TextStyle(color: Colors.white)),
            padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
          ),
          onPressed: () {
            formeKey.validate().then((value) {
              value.invalidFields.forEach((element) {
                print(
                    '${element.controller.name} ${element.isValueChangedDuringValidation}');
              });
              value.firstInvalidField?.controller.requestFocus();
            });
          },
          child: Container(
            alignment: Alignment.center,
            width:
                _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(
                colors: <Color>[Colors.orange[200]!, Colors.pinkAccent],
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'SIGN UP',
              style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}

class ResponsiveWidget {
  static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
  }

  static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >= 1080;
  }

  static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 70);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 5);
    var secondControlPoint = Offset(size.width * .75, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height / 10,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.pinkAccent]),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? icon;
  late final double _width;
  late final double _pixelRatio;
  late final bool large;
  late final bool medium;
  final String name;
  final FormeKey formeKey;
  final FormeValueFieldListener<String, FormeTextFieldController>? listener;

  CustomTextField({
    this.hint,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.listener,
    required this.name,
    required this.formeKey,
  });

  @override
  Widget build(BuildContext context) {
    print(name);
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: large ? 12 : (medium ? 10 : 8),
        child: Stack(
          children: [
            FormeTextField(
              name: name,
              listener: FormeValueFieldListener(
                autovalidateMode: listener?.autovalidateMode,
                onValidate: listener?.onValidate,
                onAsyncValidate: listener?.onAsyncValidate,
                onErrorChanged: (m, a) {
                  InputBorder border;
                  if (a == null || !a.invalid) {
                    border = OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none);
                  } else {
                    border = OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: Colors.orange[200]!, width: 2));
                  }
                  m.updateModel(FormeTextFieldModel(
                      decoration: InputDecoration(
                          focusedBorder: border, enabledBorder: border)));
                },
              ),
              model: FormeTextFieldModel(
                keyboardType: keyboardType,
                maxLines: 1,
                obscureText: obscureText,
                cursorColor: Colors.orange[200],
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: Colors.orange[200], size: 20),
                  hintText: hint,
                  suffixIconConstraints: BoxConstraints.tightFor(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (obscureText)
                        Builder(builder: (context) {
                          FormeValueFieldController<String, FormeTextFieldModel>
                              controller = FormeFieldController.of(context);
                          return IconButton(
                              onPressed: () {
                                controller.updateModel(FormeTextFieldModel(
                                  obscureText:
                                      !(controller.model.obscureText ?? false),
                                ));
                                (context as Element).markNeedsBuild();
                              },
                              icon: Icon(
                                  (controller.model.obscureText ?? false)
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.orange[200],
                                  size: 24));
                        }),
                      Builder(
                        builder: (context) {
                          FormeValueFieldController<String, FormeModel>
                              controller = FormeFieldController.of(context);
                          return ValueListenableBuilder2<bool, String?>(
                              controller.focusListenable,
                              controller.valueListenable,
                              builder: (context, a, b, c) {
                            if (a && b != null && b.length > 0) {
                              return IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Colors.orange[200], size: 24),
                                  onPressed: () {
                                    controller.value = '';
                                  });
                            }
                            return SizedBox();
                          });
                        },
                      ),
                      Builder(
                        builder: (context) {
                          FormeValueFieldController<String, FormeModel>
                              controller = FormeFieldController.of(context);
                          return ValueListenableBuilder<FormeValidateError?>(
                              valueListenable: controller.errorTextListenable,
                              builder: (context, errorText, child) {
                                if (errorText == null) return SizedBox();
                                if (errorText.validating) {
                                  return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.orange[200]!),
                                      ),
                                    ),
                                  );
                                } else
                                  return errorText.invalid
                                      ? const IconButton(
                                          onPressed: null,
                                          icon: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ))
                                      : IconButton(
                                          onPressed: null,
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ));
                              });
                        },
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Positioned(
                bottom: 5,
                left: 48,
                child: Builder(builder: (context) {
                  return ValueListenableBuilder<FormeValidateError?>(
                      valueListenable:
                          formeKey.valueField(name).errorTextListenable,
                      builder: (context, a, b) {
                        return a == null || !a.invalid
                            ? SizedBox()
                            : Text(a.text!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: large ? 12 : 10,
                                ));
                      });
                })),
          ],
        ));
  }
}
