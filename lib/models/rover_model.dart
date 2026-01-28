class Rover {
  final String roverId;
  final String roverName;
  final String connectionStatus;
  final double? latitude;
  final double? longitude;
  final int batteryLevel;

  Rover({
    required this.roverId,
    required this.roverName,
    required this.connectionStatus,
    this.latitude,
    this.longitude,
    this.batteryLevel = 0,
  });

  factory Rover.fromJson(Map<String, dynamic> json) {
    return Rover(
      roverId: json['roverId'] ?? '',
      roverName: json['roverName'] ?? 'Rover-1',
      connectionStatus: json['connectionStatus'] ?? 'disconnected',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      batteryLevel: json['batteryLevel'] ?? 0,
    );
  }
}