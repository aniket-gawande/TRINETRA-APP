import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Drawer(
      backgroundColor: const Color(0xFF020604), // Matches your CSS background
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🚜 PARYARAK', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF10b981))),
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getUserEmail(user),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_rounded, color: const Color(0xFF10b981), size: 28),
            title: const Text('Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          if (user != null) ...[
            ListTile(
              leading: Icon(Icons.route_rounded, color: const Color(0xFF3b82f6), size: 28),
              title: const Text('Map Planner', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pushReplacementNamed(context, '/planner'),
            ),
            ListTile(
              leading: Icon(Icons.dashboard_rounded, color: const Color(0xFF8b5cf6), size: 28),
              title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.trending_up_rounded, color: const Color(0xFFf59e0b), size: 28),
              title: const Text('Analytics', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pushReplacementNamed(context, '/analytics'),
            ),
            const Divider(color: Color(0xFF334155)),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: Colors.red, size: 28),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ] else
            ListTile(
              leading: Icon(Icons.login_rounded, color: const Color(0xFF10b981), size: 28),
              title: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
        ],
      ),
    );
  }

  String _getUserEmail(dynamic user) {
    if (user == null) return '';
    // Handle UserModel from auth_provider
    if (user.runtimeType.toString().contains('UserModel')) {
      return user.email ?? '';
    }
    // Handle Firebase User objects
    if (user is String) return user;
    if (user.runtimeType.toString().contains('User')) {
      return user.email ?? '';
    }
    return user.toString();
  }
}