import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/app.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Check for a stored JWT before rendering the first frame.
  // Routes directly to Feed (valid token) or Auth (no token / 401).
  await container.read(authNotifierProvider.notifier).checkSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const YouScoutApp(),
    ),
  );
}
