import 'package:flutter/material.dart';
import 'package:flutter_application_11_chat/screens/welcome_screen.dart';
import 'package:flutter_application_11_chat/screens/login_screen.dart';
import 'package:flutter_application_11_chat/screens/registration_screen.dart';
import 'package:flutter_application_11_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  FlashChat({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
