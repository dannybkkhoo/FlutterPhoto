import 'package:app2/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_router.dart';
import 'root_page.dart';

void main() async {
  //Call this first to make sure we can make other system level calls safely
  WidgetsFlutterBinding.ensureInitialized();
  //Status bar style on Android/iOS
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  //Must initialize firebase first
  await Firebase.initializeApp();

  //Since we're using Riverpod instead of standard providers, all providers are instantiated in top_level_providers.dart
  runApp(
    ProviderScope(
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterPhoto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
