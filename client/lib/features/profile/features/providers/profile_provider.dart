import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';

final profileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final session = await HiveSessionStorage().getSession();

  if (session == null) {
    dev.log("No session found in Hive storage.");
    return null;
  }

  dev.log("Session Token: ${session.token}");
  dev.log("Session Raw User JSON: ${session.user}");

  try {
    dynamic firstDecode = jsonDecode(session.user);

    // ✅ If first decode returns a STRING, decode again
    if (firstDecode is String) {
      dev.log("Detected nested JSON string. Decoding again...");
      firstDecode = jsonDecode(firstDecode);
    }

    dev.log("Parsed user data: $firstDecode");
    return firstDecode;
  } catch (e) {
    dev.log("Failed to parse session user JSON: $e");
    return null;
  }
});
