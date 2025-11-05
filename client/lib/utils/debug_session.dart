import 'dart:convert';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'dart:developer' as dev;

Future<void> debugLogSession() async {
  final session = await HiveSessionStorage().getSession();
  if (session == null) {
    dev.log("Session is null - no user logged in");
  } else {
    dev.log("SESSION TOKEN: ${session.token}");
    dev.log("SESSION USER RAW STRING: ${session.user}");
    try {
      final userMap = jsonDecode(session.user);
      dev.log("Parsed User Data: $userMap");
    } catch (e) {
      dev.log("Failed to parse user JSON: $e");
    }
  }
}
