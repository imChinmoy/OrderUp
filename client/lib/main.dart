import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'features/auth/presentation/screens/login_screen.dart';
import 'core/colors.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.mainOrange,
          secondary: AppColors.mainOrangeDark,
          surface: AppColors.secondaryDark,
        ),
        scaffoldBackgroundColor: AppColors.primaryDark,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
