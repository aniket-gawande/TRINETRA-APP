import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'components/app_drawer.dart';
// You will create these screens next
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/planner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
          // Add Dashboard screen here similarly
        },
      ),
    );
  }
}

// Wrapper to include the AppDrawer on every page
class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🚜 PARYARAK")),
      drawer: const AppDrawer(),
      body: child,
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