import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholar_chat/firebase_options.dart';
import 'package:scholar_chat/screens/chat_screen.dart';
import 'package:scholar_chat/screens/loading_screen.dart';
import 'package:scholar_chat/screens/login_screen.dart';
import 'package:scholar_chat/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

bool darkmode = false;
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'login', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: 'loading',
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      name: 'chat',
      path: '/chat/:email',
      builder: (context, state) =>  ChatScreen(
        email:state.pathParameters['email']! ,
      ),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      darkTheme: darkmode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Chat',
    );
  }
}
