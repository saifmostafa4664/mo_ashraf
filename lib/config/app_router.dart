import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mo_ashraf/portfolio/portfolio_page.dart';
import 'package:mo_ashraf/admin/login_page.dart';
import 'package:mo_ashraf/admin/dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const PortfolioPage()),
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return const LoginPage();
          }
          return const DashboardPage();
        },
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
    errorBuilder: (context, state) => const PortfolioPage(),
  );
}
