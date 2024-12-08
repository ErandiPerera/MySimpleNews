import 'package:flutter/material.dart';
import 'package:mynewsapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'providers/news_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
    ChangeNotifierProvider(
      create: (context) => NewsProvider()),
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
