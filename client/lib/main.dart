import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart'; // ✅ Keep this
import 'features/auth/data/models/session_model.dart';
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
  await Hive.openBox("menu_cache");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
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
      routerConfig: router, // Useing router instead of home
    );
  }
}