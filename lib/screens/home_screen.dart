import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../components/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    if (index == 0) return;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1e293b).withValues(alpha: 0.95),
                const Color(0xFF0f172a).withValues(alpha: 0.95),
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10b981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10b981).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                '🚜',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'PARYARAK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onTabTapped: _onNavTapped,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header - COMPLETELY REDESIGNED
                _buildWelcomeHeader(user),
                const SizedBox(height: 24),

                // Hero Status Card - FULLY ROUNDED
                _buildHeroStatusCard(context, user),
                const SizedBox(height: 28),

                // Quick Actions - REDESIGNED
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickActionsGrid(context, user),
                const SizedBox(height: 28),

                // System Intelligence - REDESIGNED
                const Text(
                  "System Intelligence",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSystemIntelligenceGrid(),
                const SizedBox(height: 28),

                // Field Status Overview - NEW SECTION
                const Text(
                  "Field Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldStatusCards(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(user) {
    String displayName = "PARYARAK";
    if (user != null) {
      if (user.runtimeType.toString().contains('UserModel')) {
        displayName = user.displayName ?? "Farmer";
      } else if (user is String) {
        displayName = user.split('@')[0].toUpperCase();
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF064e3b),
            const Color(0xFF047857),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10b981).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user != null ? "Welcome back," : "Welcome to",
                    style: const TextStyle(
                      color: Color(0xFFd1fae5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10b981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "System Online",
                      style: TextStyle(
                        color: Color(0xFFd1fae5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              user != null ? Icons.person_rounded : Icons.eco_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatusCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e3a8a), Color(0xFF1e40af)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3b82f6).withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10b981).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 8,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.wifi_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(
                Icons.agriculture_rounded,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Text(
                "Rover Status",
                style: TextStyle(
                  color: Color(0xFFbfdbfe),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ready for Mission",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "All systems operational. Deploy rover for path planning and field monitoring operations.",
            style: TextStyle(
              color: Color(0xFFdbeafe),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (user != null) {
                  Navigator.pushNamed(context, '/planner');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1e40af),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                shadowColor: Colors.white.withValues(alpha: 0.5),
              ),
              icon: Icon(
                user != null ? Icons.rocket_launch_rounded : Icons.login_rounded,
                size: 22,
              ),
              label: Text(
                user != null ? "Deploy Rover" : "Login to Start",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, user) {
    final actions = [
      {
        'title': 'Map Planner',
        'subtitle': 'Create routes',
        'icon': Icons.map_rounded,
        'color': const Color(0xFF3b82f6),
        'route': '/planner',
      },
      {
        'title': 'Dashboard',
        'subtitle': 'View analytics',
        'icon': Icons.dashboard_rounded,
        'color': const Color(0xFF8b5cf6),
        'route': '/dashboard',
      },
      {
        'title': 'Analytics',
        'subtitle': 'Data insights',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFFf59e0b),
        'route': '/analytics',
      },
      {
        'title': 'Profile',
        'subtitle': 'Your account',
        'icon': Icons.person_rounded,
        'color': const Color(0xFF10b981),
        'route': '/profile',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = action['color'] as Color;
        return _buildQuickActionCard(
          context,
          title: action['title'] as String,
          subtitle: action['subtitle'] as String,
          icon: action['icon'] as IconData,
          color: color,
          onTap: () => user != null
              ? Navigator.pushNamed(context, action['route'] as String)
              : Navigator.pushNamed(context, '/login'),
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: color.withValues(alpha: 0.3),
        highlightColor: color.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.3),
                      color.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemIntelligenceGrid() {
    final features = [
      {
        'icon': Icons.water_drop_rounded,
        'label': 'Soil Health',
        'value': 'Excellent',
        'color': const Color(0xFF10b981),
      },
      {
        'icon': Icons.thermostat_rounded,
        'label': 'Temperature',
        'value': '24°C',
        'color': const Color(0xFF3b82f6),
      },
      {
        'icon': Icons.battery_charging_full_rounded,
        'label': 'Battery',
        'value': '87%',
        'color': const Color(0xFF8b5cf6),
      },
      {
        'icon': Icons.opacity_rounded,
        'label': 'Moisture',
        'value': '65%',
        'color': const Color(0xFFf59e0b),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        final color = feature['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: color,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['label'] as String,
                    style: const TextStyle(
                      color: Color(0xFF94a3b8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['value'] as String,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldStatusCards() {
    final fields = [
      {
        'name': 'Field Alpha',
        'status': 'Active',
        'progress': 0.85,
        'color': const Color(0xFF10b981),
      },
      {
        'name': 'Field Beta',
        'status': 'Monitoring',
        'progress': 0.60,
        'color': const Color(0xFF3b82f6),
      },
      {
        'name': 'Field Gamma',
        'status': 'Pending',
        'progress': 0.30,
        'color': const Color(0xFFf59e0b),
      },
    ];

    return Column(
      children: fields.map((field) {
        final color = field['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          field['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            field['status'] as String,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: field['progress'] as double,
                        backgroundColor: color.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}