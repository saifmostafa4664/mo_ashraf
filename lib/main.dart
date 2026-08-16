import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mo_ashraf/firebase_options.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MATeamApp());
}

class MATeamApp extends StatelessWidget {
  const MATeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MA TEAM | Mohamed Ashraf - High-End Retoucher',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
