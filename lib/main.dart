import 'package:app2/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_router.dart';
import 'root_page.dart';
import 'themes.dart';

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

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.read(firebaseAuthProvider);
    final themeStateChanges = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterPhoto',
      theme: themeStateChanges.theme,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}
