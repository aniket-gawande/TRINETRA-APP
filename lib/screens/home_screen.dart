import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../components/bottom_nav_bar.dart'; // Import added

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation handler
  void _onNavTapped(int index) {
    if (index == 0) return; // Already on Home
    switch (index) {
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
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFF020604),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b),
        elevation: 0,
        title: const Text(
          '🚜 PARYARAK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      // Added Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onTabTapped: _onNavTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064e3b), Color(0xFF047857)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF10b981).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.home_rounded,
                      color: Color(0xFF10b981),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Rover Dashboard & Overview',
                            style: TextStyle(
                              color: Color(0xFF86efac),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // 1. Header Section (Greeting & Status)
              _buildHeader(user),
              
              const SizedBox(height: 32),

              // 2. Hero / Status Card
              _buildHeroCard(context, user),

              const SizedBox(height: 32),

              // 3. Quick Actions Grid
              const Text(
                "Quick Actions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickActions(context, user),

              const SizedBox(height: 32),

              // 4. System Features / Statistics
              const Text(
                "System Intelligence",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureGrid(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    String displayName = "PARYARAK";
    if (user != null) {
      if (user.runtimeType.toString().contains('UserModel')) {
        displayName = user.displayName ?? "Farmer";
      } else if (user is String) {
        displayName = user.split('@')[0].toUpperCase();
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user != null ? "Welcome back," : "Welcome to",
              style: const TextStyle(
                color: Color(0xFF94a3b8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF10b981), Color(0xFF34d399)],
              ).createShader(bounds),
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1e293b).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Icon(
            user != null ? Icons.person : Icons.home,
            color: const Color(0xFF10b981),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064e3b), Color(0xFF065f46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10b981).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.wifi, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Rover Status: Standby",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "System is ready for new path planning operations.",
            style: TextStyle(
              color: Color(0xFFecfdf5),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (user != null) {
                  Navigator.pushNamed(context, '/planner');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF064e3b),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                user != null ? "Start Mission" : "Login to Connect",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, user) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            title: "Map Planner",
            icon: Icons.map,
            color: const Color(0xFF3b82f6),
            onTap: () => user != null 
                ? Navigator.pushNamed(context, '/planner')
                : Navigator.pushNamed(context, '/login'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            title: "Analytics",
            icon: Icons.bar_chart,
            color: const Color(0xFF8b5cf6),
            onTap: () => user != null 
                ? Navigator.pushNamed(context, '/dashboard')
                : Navigator.pushNamed(context, '/login'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1e293b).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': Icons.water_drop, 'label': 'Soil Health', 'value': 'Good'},
      {'icon': Icons.opacity, 'label': 'Moisture', 'value': '45%'},
      {'icon': Icons.battery_full, 'label': 'Battery', 'value': '87%'},
      {'icon': Icons.sunny, 'label': 'Temp', 'value': '24°C'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1e293b).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155).withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(features[index]['icon'] as IconData, color: const Color(0xFF94a3b8), size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    features[index]['label'] as String,
                    style: const TextStyle(
                      color: Color(0xFF94a3b8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    features[index]['value'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}