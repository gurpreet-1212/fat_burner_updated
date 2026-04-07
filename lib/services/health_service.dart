import 'dart:io';

import 'package:health/health.dart';
import 'package:fat_burner/models/health_data_model.dart';

class HealthService {
  HealthService._();
  static final HealthService instance = HealthService._();

  final Health _health = Health();

  static const List<HealthDataType> _typesToRead = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WEIGHT,
  ];

  static const List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  bool _configured = false;

  /// Configure plugin
  Future<void> configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  /// Request permissions
  Future<bool> requestAuthorization() async {
    await configure();
    return _health.requestAuthorization(_typesToRead, permissions: _permissions);
  }

  /// Check permissions
  Future<bool> hasPermissions() async {
    await configure();
    final result =
        await _health.hasPermissions(_typesToRead, permissions: _permissions);
    return result ?? false;
  }

  /// Get today's steps
  Future<int> getTodaySteps() async {
    await configure();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final steps = await _health.getTotalStepsInInterval(midnight, now);
    return steps ?? 0;
  }

  /// Get today's calories
  Future<int> getTodayCaloriesBurned() async {
    await configure();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final data = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.ACTIVE_ENERGY_BURNED],
      startTime: midnight,
      endTime: now,
    );

    double total = 0;

    for (final point in data) {
      if (point.value is NumericHealthValue) {
        total += (point.value as NumericHealthValue).numericValue;
      }
    }

    return total.round();
  }

  /// Get latest weight
  Future<double?> getLatestWeight() async {
    await configure();
    final now = DateTime.now();
    final past = now.subtract(const Duration(days: 365));

    final data = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.WEIGHT],
      startTime: past,
      endTime: now,
    );

    if (data.isEmpty) return null;

    data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

    final latest = data.first;

    if (latest.value is NumericHealthValue) {
      return (latest.value as NumericHealthValue).numericValue.toDouble();
    }

    return null;
  }

  /// Combined model (optional)
  Future<HealthDataModel?> getTodayHealthData(String userId) async {
    await configure();

    final steps = await getTodaySteps();
    final caloriesBurned = await getTodayCaloriesBurned();
    final weight = await getLatestWeight();

    return HealthDataModel(
      id: 'today-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      date: DateTime.now(),
      steps: steps,
      weight: weight,
      caloriesBurned: caloriesBurned,
      caloriesConsumed: null,
    );
  }

  /// ⭐ Normalize health data
  Map<String, dynamic> normalizeHealthData(Map<String, dynamic> rawData) {
    int steps = (rawData['steps'] ?? 0) as int;
    double calories = (rawData['calories'] ?? 0).toDouble();
    double distance = (rawData['distance'] ?? 0).toDouble();

    // Prevent negative values
    if (steps < 0) steps = 0;
    if (calories < 0) calories = 0;
    if (distance < 0) distance = 0;

    // Convert meters → km (if needed)
    double distanceKm = distance;
    if (distance > 1000) {
      distanceKm = distance / 1000;
    }

    return {
      'steps': steps,
      'calories': calories,
      'distance': distanceKm,
    };
  }

  /// ⭐ MAIN FUNCTION (USE THIS IN DASHBOARD)
  Future<Map<String, dynamic>> fetchBasicHealthData() async {
    await configure();

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    final data = await _health.getHealthDataFromTypes(
      startTime: midnight,
      endTime: now,
      types: types,
    );

    int steps = 0;
    double calories = 0;
    double distance = 0;

    for (final point in data) {
      if (point.value is NumericHealthValue) {
        final value = (point.value as NumericHealthValue).numericValue;

        switch (point.type) {
          case HealthDataType.STEPS:
            steps += value.toInt();
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += value;
            break;
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            distance += value;
            break;
          default:
            break;
        }
      }
    }

    final rawData = {
      'steps': steps,
      'calories': calories,
      'distance': distance,
    };

    return normalizeHealthData(rawData);
  }

  /// Check availability
  Future<bool> isAvailable() async {
    if (Platform.isAndroid) {
      return _health.isHealthConnectAvailable();
    }
    return true;
  }
}