import 'package:flutter/material.dart';
import 'package:flutter_application_11_chat/screens/login_screen.dart';
import 'package:flutter_application_11_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_11_chat/widget.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  var val;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation tween;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    tween =
        ColorTween(begin: Colors.white, end: Colors.grey).animate(controller);

    controller.reverse(from: 100);

    animation.addStatusListener((status) {
      if (animation.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tween.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'hi',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 80,
                  ),
                ),
                DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        animatedTexts: [WavyAnimatedText('FAST CHAT')])),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Button(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              on_pressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            Button(
              color: Colors.blueAccent,
              text: 'Register',
              on_pressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
