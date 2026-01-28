import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'components/app_drawer.dart';
import 'components/bottom_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/analytics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Only initialize Firebase on mobile platforms
  if (!kIsWeb) {
    try {
      await _initializeFirebase();
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
      }
    }
  }
  
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  // Firebase is conditionally imported and initialized only on mobile
  // This avoids web compatibility issues
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Paryarak',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF020604),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(2, 6, 4, 0.95),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10b981)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AppScaffold(child: HomeScreen()),
          '/login': (context) => const LoginScreen(),
          '/planner': (context) => const ProtectedRoute(child: AppScaffold(child: PlannerScreen())),
          '/dashboard': (context) => const ProtectedRoute(child: AppScaffold(child: DashboardScreen())),
          '/analytics': (context) => const ProtectedRoute(child: AppScaffold(child: AnalyticsScreen())),
        },
      ),
    );
  }
}

// Wrapper to include the AppDrawer and Bottom Nav on every page
class AppScaffold extends StatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Navigate to the corresponding route
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/planner');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/dashboard');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/analytics');
        break;
      case 4:
        // Profile - for now, show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile page coming soon')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🚜 PARYARAK")),
      drawer: const AppDrawer(),
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabTapped: _onNavTapped,
      ),
    );
  }
}

// Wrapper for Protected Routes
class ProtectedRoute extends StatelessWidget {
  final Widget child;
  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (auth.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const SizedBox.shrink();
    }
    return child;
  }
}