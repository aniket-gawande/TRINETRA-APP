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
          _buildNavItem(context, 'Home', '/'),
          if (user != null) ...[
            _buildNavItem(context, 'Map Planner', '/planner'),
            _buildNavItem(context, 'Dashboard', '/dashboard'),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ] else
            _buildNavItem(context, 'Login', '/login'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }

  String _getUserEmail(dynamic user) {
    if (user == null) return '';
    // Handle both Firebase User objects and String (mock auth)
    if (user is String) return user;
    if (user.runtimeType.toString().contains('User')) {
      return user.email ?? '';
    }
    return user.toString();
  }
}