import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import '../components/bottom_nav_bar.dart'; // Import added

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final LatLng _defaultCenter = const LatLng(20.5937, 78.9629);
  late final MapController _mapController;
  
  List<LatLng> _pathPoints = [];
  LatLng? _userLocation;
  bool _isLoadingLocation = true;
  String _statusMessage = 'Fetching your location...';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchUserLocation();
  }
  
  // Navigation handler
  void _onNavTapped(int index) {
    if (index == 1) return; // Already on Planner
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/');
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

  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
            _statusMessage = 'Location permission denied. Using default location.';
            _userLocation = _defaultCenter;
          });
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).catchError((e) async {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
      });

      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
          _statusMessage = 'Location fetched! Tap map to create path.';
        });
        _mapController.move(_userLocation!, 15.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _statusMessage = 'Error fetching location: ${e.toString().split('\n').first}';
          _userLocation = _defaultCenter;
        });
      }
    }
  }

  void _addPathPoint(LatLng point) {
    setState(() {
      _pathPoints.add(point);
      _statusMessage = 'Path point added! (${_pathPoints.length} points)';
    });
  }

  void _clearPath() {
    setState(() {
      _pathPoints.clear();
      _statusMessage = 'Path cleared. Tap map to create new path.';
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020604),
      // Added Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTabTapped: _onNavTapped,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.route_rounded,
            color: const Color(0xFF10b981),
            size: 28,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Path Planner',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Plan rover routes',
              style: TextStyle(
                color: Color(0xFF86efac),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? _defaultCenter,
              initialZoom: _userLocation != null ? 15.0 : 5.0,
              onTap: (tapPosition, point) {
                _addPathPoint(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trinetra.app',
              ),
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10b981).withValues(alpha: 0.3),
                          border: Border.all(
                            color: const Color(0xFF10b981),
                            width: 3,
                          ),
                        ),
                        width: 30,
                        height: 30,
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xFF10b981),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < _pathPoints.length; i++)
                    Marker(
                      point: _pathPoints[i],
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3b82f6).withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(0xFF3b82f6),
                            width: 2,
                          ),
                        ),
                        width: 25,
                        height: 25,
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Color(0xFF3b82f6),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (_pathPoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _pathPoints,
                      color: const Color(0xFF3b82f6),
                      strokeWidth: 3.0,
                    ),
                  ],
                ),
            ],
          ),
          
          if (_isLoadingLocation)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF10b981),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Fetching your location...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1e293b),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF334155),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0f172a).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _pathPoints.isEmpty
                              ? Icons.info_outline
                              : Icons.check_circle_outline,
                          color: _pathPoints.isEmpty
                              ? const Color(0xFF94a3b8)
                              : const Color(0xFF10b981),
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (_pathPoints.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0f172a).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.route,
                            color: Color(0xFF3b82f6),
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Path: ${_pathPoints.length} waypoints',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3b82f6)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${_calculatePathDistance().toStringAsFixed(2)} km',
                              style: const TextStyle(
                                color: Color(0xFF3b82f6),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clearPath,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1f2937),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.clear, size: 18),
                          label: const Text('Clear Path'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pathPoints.isEmpty
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Path saved with ${_pathPoints.length} waypoints',
                                      ),
                                      backgroundColor: const Color(0xFF10b981),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10b981),
                            disabledBackgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('Save Path'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePathDistance() {
    if (_pathPoints.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    for (int i = 0; i < _pathPoints.length - 1; i++) {
      const double earthRadiusKm = 6371; 
      
      final lat1 = _pathPoints[i].latitude * pi / 180;
      final lat2 = _pathPoints[i + 1].latitude * pi / 180;
      final dLat = (_pathPoints[i + 1].latitude - _pathPoints[i].latitude) * pi / 180;
      final dLng = (_pathPoints[i + 1].longitude - _pathPoints[i].longitude) * pi / 180;
      
      final a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
      final c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final distance = earthRadiusKm * c;
      
      totalDistance += distance;
    }
    return totalDistance;
  }
}