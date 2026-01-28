import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF334155),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1e293b),
        selectedItemColor: const Color(0xFF10b981),
        unselectedItemColor: const Color(0xFF64748b),
        elevation: 0,
        showSelectedLabels: true, // Ensure labels show
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        items: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.route_rounded, 'Planner', 1),
          _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 2),
          _buildNavItem(Icons.trending_up_rounded, 'Analytics', 3),
          _buildNavItem(Icons.person_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 28,
        color: selectedIndex == index
            ? const Color(0xFF10b981)
            : const Color(0xFF64748b),
      ),
      label: label,
    );
  }
}