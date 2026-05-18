import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youscout_mobile/core/router/routes.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:youscout_mobile/features/auth/presentation/screens/auth_screen.dart';
import 'package:youscout_mobile/features/feed/presentation/screens/feed_screen.dart';
import 'package:youscout_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:youscout_mobile/features/upload/presentation/screens/upload_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);

  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.isAuthenticated;

      if (state.matchedLocation == Routes.splash) {
        return isAuthenticated ? Routes.feed : Routes.auth;
      }
      if (!isAuthenticated && state.matchedLocation != Routes.auth) {
        return Routes.auth;
      }
      if (isAuthenticated && state.matchedLocation == Routes.auth) {
        return Routes.feed;
      }
      return null;
    },
    refreshListenable: _AuthStateListenable(ref, authNotifier),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const _SplashScreen()),
      GoRoute(path: Routes.auth, builder: (_, __) => const AuthScreen()),
      ShellRoute(
        builder: (context, state, child) => _MainScaffold(child: child),
        routes: [
          GoRoute(path: Routes.feed, builder: (_, __) => const FeedScreen()),
          GoRoute(path: Routes.upload, builder: (_, __) => const UploadScreen()),
          GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _MainScaffold extends StatefulWidget {
  final Widget child;
  const _MainScaffold({required this.child});

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _currentIndex = 0;

  static const _tabs = [Routes.feed, Routes.upload, Routes.profile];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          context.go(_tabs[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Upload'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Bridges Riverpod auth state → GoRouter listenable
class _AuthStateListenable extends ChangeNotifier {
  final Ref _ref;

  _AuthStateListenable(this._ref, AuthNotifier _) {
    _ref.listen(authNotifierProvider, (__, ___) => notifyListeners());
  }
}
