import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  void _onNavTapped(int index) {
    if (index == 3) return;
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
      case 4:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020604),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        onTabTapped: _onNavTapped,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFf59e0b).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.trending_up_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Performance metrics & insights',
              style: TextStyle(
                color: Color(0xFF86efac),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics - FULLY ROUNDED
              const Text(
                "Key Metrics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildMetricsGrid(),
              const SizedBox(height: 32),

              // Trend Analysis
              const Text(
                "Trend Analysis",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildTrendCard(),
              const SizedBox(height: 32),

              // Recent Activity
              const Text(
                "Recent Activity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final metrics = [
      {
        'label': 'Soil Moisture',
        'value': '65%',
        'status': 'Normal',
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF3b82f6),
      },
      {
        'label': 'Temperature',
        'value': '24°C',
        'status': 'Optimal',
        'icon': Icons.thermostat_rounded,
        'color': const Color(0xFF10b981),
      },
      {
        'label': 'Soil pH',
        'value': '6.8',
        'status': 'Neutral',
        'icon': Icons.science_rounded,
        'color': const Color(0xFFf59e0b),
      },
      {
        'label': 'Nutrients',
        'value': 'Good',
        'status': 'Balanced',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFF8b5cf6),
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
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        final color = metric['color'] as Color;
        return Container(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.3),
                          color.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      metric['icon'] as IconData,
                      color: color,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      metric['status'] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                metric['label'] as String,
                style: const TextStyle(
                  color: Color(0xFF94a3b8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                metric['value'] as String,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1e293b).withValues(alpha: 0.8),
            const Color(0xFF0f172a).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10b981).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+15%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMiniBarChart(),
          const SizedBox(height: 20),
          const Text(
            'Your fields show consistent improvement across all metrics. Keep up the excellent work!',
            style: TextStyle(
              color: Color(0xFF94a3b8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart() {
    final data = [
      {'label': 'Mon', 'value': 0.6, 'color': const Color(0xFF3b82f6)},
      {'label': 'Tue', 'value': 0.7, 'color': const Color(0xFF10b981)},
      {'label': 'Wed', 'value': 0.65, 'color': const Color(0xFF3b82f6)},
      {'label': 'Thu', 'value': 0.8, 'color': const Color(0xFF10b981)},
      {'label': 'Fri', 'value': 0.75, 'color': const Color(0xFF10b981)},
      {'label': 'Sat', 'value': 0.9, 'color': const Color(0xFF10b981)},
      {'label': 'Sun', 'value': 0.85, 'color': const Color(0xFF10b981)},
    ];

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final color = item['color'] as Color;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 80 * (item['value'] as double),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      color: Color(0xFF64748b),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {
        'title': 'Field 1 Irrigation',
        'subtitle': 'Completed 2h ago',
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF10b981),
        'progress': 1.0,
      },
      {
        'title': 'Field 2 Survey',
        'subtitle': 'In progress - 75% complete',
        'icon': Icons.explore_rounded,
        'color': const Color(0xFF3b82f6),
        'progress': 0.75,
      },
      {
        'title': 'Field 3 Soil Test',
        'subtitle': 'Scheduled for tomorrow',
        'icon': Icons.science_rounded,
        'color': const Color(0xFFf59e0b),
        'progress': 0.0,
      },
    ];

    return Column(
      children: activities.map((activity) {
        final color = activity['color'] as Color;
        final progress = activity['progress'] as double;
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.3),
                          color.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['subtitle'] as String,
                          style: const TextStyle(
                            color: Color(0xFF94a3b8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (progress > 0 && progress < 1)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          backgroundColor: color.withValues(alpha: 0.2),
                        ),
                      ),
                    )
                  else if (progress == 1)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: color,
                        size: 20,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        color: color,
                        size: 20,
                      ),
                    ),
                ],
              ),
              if (progress > 0 && progress < 1) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}