import 'dart:convert';
import 'dart:developer';
import 'package:client/features/menu/presentation/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/data/models/session_model.dart';

import 'features/auth/presentation/screens/login_screen.dart';
//import 'features/menu/presentation/screens/home_screen.dart';
import 'features/admin/presentation/screens/admin_screen.dart';
import 'core/colors.dart';

const String _sessionBoxName = 'sessionBox';
const String _sessionKey = 'current_session';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SessionModelAdapter());
  }

  await Hive.openBox<SessionModel>(_sessionBoxName);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<Widget> _determineStartScreen() async {
    final box = Hive.box<SessionModel>(_sessionBoxName);
    final sessionModel = box.get(_sessionKey);

    if (sessionModel == null || sessionModel.token.isEmpty) {
      log('No valid session found, navigating to LoginScreen.');
      return const LoginScreen();
    }

    try {
      if (sessionModel.user.isEmpty) {
        log('Session found but user data is empty, navigating to LoginScreen.');
        return const LoginScreen();
      }

      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        jsonDecode(sessionModel.user),
      );

      final role = userMap['role'] as String? ?? '';

      if (role == 'admin') {
        log("User is Admin, navigating to AdminScreen. Role: $role");
        return const AdminScreen();
      } else if (role == 'student') {
        log("User is Student, navigating to HomeScreen. Role: $role");
        return const MainNavigationScreen();
      } else {
        log(
          "User role is '$role', navigating to HomeScreen (or Login if unexpected).",
        );
        return const MainNavigationScreen();
      }
    } catch (e) {
      log(
        'Error parsing session data: ${e.toString()}, navigating to LoginScreen.',
      );
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: AppColors.primaryDark,
              body: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

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
          home: snapshot.data,
        );
      },
    );
  }
}
