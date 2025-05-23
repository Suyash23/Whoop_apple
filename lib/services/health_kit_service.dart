import 'package:flutter/services.dart';

class HealthKitService {
  static const MethodChannel _channel = MethodChannel('com.example.whoop_clone_app/healthkit');

  /// Requests authorization from the user to access HealthKit data.
  ///
  /// Native Swift: Implement HealthKit authorization request for required types
  /// (heart rate, HRV, sleep, activity, respiratory rate).
  static Future<void> requestAuthorization() async {
    try {
      await _channel.invokeMethod('requestAuthorization');
      print("HealthKit authorization request sent.");
    } on PlatformException catch (e) {
      print("Failed to request HealthKit authorization: '${e.message}'.");
    }
  }

  // --- Heart Rate ---

  /// Starts continuous heart rate monitoring using HealthKit.
  ///
  /// Native Swift: Implement HealthKit query to start continuous HR monitoring.
  /// Consider background app refresh and workout sessions for higher frequency.
  /// Handle permissions.
  static Future<void> startContinuousHeartRateMonitoring() async {
    try {
      await _channel.invokeMethod('startContinuousHeartRateMonitoring');
      print("Attempting to start continuous heart rate monitoring.");
    } on PlatformException catch (e) {
      print("Failed to start continuous heart rate monitoring: '${e.message}'.");
    }
  }

  /// Stops continuous heart rate monitoring.
  ///
  /// Native Swift: Stop the continuous HR monitoring query.
  static Future<void> stopContinuousHeartRateMonitoring() async {
    try {
      await _channel.invokeMethod('stopContinuousHeartRateMonitoring');
      print("Attempting to stop continuous heart rate monitoring.");
    } on PlatformException catch (e) {
      print("Failed to stop continuous heart rate monitoring: '${e.message}'.");
    }
  }

  /// Fetches heart rate data between the specified start and end times.
  ///
  /// [start] - The start DateTime for the data query.
  /// [end] - The end DateTime for the data query.
  /// Returns a list of heart rate samples, where each sample is a Map.
  /// Conceptual data structure for a sample: {'timestamp': 'ISO8601_string', 'value': double}
  ///
  /// Native Swift: Fetch HR samples from HealthKit between start and end.
  /// Return data in a structured format (e.g., List of Maps).
  static Future<List<Map<String, dynamic>>> fetchHeartRateData(DateTime start, DateTime end) async {
    try {
      final List<dynamic>? data = await _channel.invokeListMethod('fetchHeartRateData', {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      });
      print("Heart rate data fetched for period: $start to $end");
      return data?.cast<Map<String, dynamic>>() ?? [];
    } on PlatformException catch (e) {
      print("Failed to fetch heart rate data: '${e.message}'.");
      return [];
    }
  }

  // --- Workouts ---

  /// Starts a HealthKit workout session for the given activity type.
  ///
  /// [activityType] - A string representing the type of workout (e.g., 'running', 'cycling').
  /// Native Swift: Start a HealthKit workout session.
  /// This can help with higher frequency data collection.
  static Future<void> startWorkout(String activityType) async {
    try {
      await _channel.invokeMethod('startWorkout', {'activityType': activityType});
      print("Workout started: $activityType");
    } on PlatformException catch (e) {
      print("Failed to start workout: '${e.message}'.");
    }
  }

  /// Stops the active HealthKit workout session.
  ///
  /// Native Swift: Stop the active HealthKit workout session.
  static Future<void> stopWorkout() async {
    try {
      await _channel.invokeMethod('stopWorkout');
      print("Workout stopped.");
    } on PlatformException catch (e) {
      print("Failed to stop workout: '${e.message}'.");
    }
  }

  // --- Sleep ---

  /// Triggers sleep tracking in HealthKit.
  ///
  /// [start] - Boolean indicating whether to start (true) or stop (false) sleep tracking.
  /// This method might be used for manual sleep tracking if needed, or could be
  /// adapted to query automatically detected sleep.
  ///
  /// Native Swift: If implementing manual sleep start/stop, interact with HealthKit.
  /// Or, this could be a method to query automatically detected sleep.
  static Future<void> triggerSleepTracking(bool start) async {
    try {
      await _channel.invokeMethod('triggerSleepTracking', {'start': start});
      print("Sleep tracking trigger sent: ${start ? 'start' : 'stop'}.");
    } on PlatformException catch (e) {
      print("Failed to trigger sleep tracking: '${e.message}'.");
    }
  }

  /// Fetches sleep analysis data from HealthKit for a given night/date.
  ///
  /// [date] - The date for which to fetch sleep data.
  /// Returns a Map containing sleep data.
  /// Conceptual data structure: {'startDate': 'ISO8601_string', 'endDate': 'ISO8601_string', 'stages': List<Map>}
  ///
  /// Native Swift: Fetch sleep analysis data from HealthKit for a given night.
  /// This might include sleep stages if available.
  static Future<Map<String, dynamic>?> fetchSleepData(DateTime date) async {
    try {
      final Map<dynamic, dynamic>? data = await _channel.invokeMapMethod('fetchSleepData', {
        'date': date.toIso8601String(),
      });
      print("Sleep data fetched for date: $date");
      return data?.cast<String, dynamic>();
    } on PlatformException catch (e) {
      print("Failed to fetch sleep data: '${e.message}'.");
      return null;
    }
  }

  // --- Other potential methods ---

  /// Fetches the Resting Heart Rate (RHR) for a specific date.
  ///
  /// [date] - The date for which to fetch RHR.
  /// Returns the RHR value as a double, or null if not available.
  ///
  /// Native Swift: Fetch RHR for a specific date.
  static Future<double?> fetchRestingHeartRate(DateTime date) async {
    try {
      final double? rhr = await _channel.invokeMethod<double>('fetchRestingHeartRate', {
        'date': date.toIso8601String(),
      });
      print("Resting heart rate fetched for date $date: $rhr");
      return rhr;
    } on PlatformException catch (e) {
      print("Failed to fetch resting heart rate: '${e.message}'.");
      return null;
    }
  }

  /// Fetches Heart Rate Variability (HRV - SDNN) for a specific date.
  ///
  /// [date] - The date for which to fetch HRV.
  /// Returns the HRV value as a double, or null if not available.
  ///
  /// Native Swift: Fetch HRV (SDNN) for a specific date.
  static Future<double?> fetchHeartRateVariability(DateTime date) async {
    try {
      final double? hrv = await _channel.invokeMethod<double>('fetchHeartRateVariability', {
        'date': date.toIso8601String(),
      });
      print("Heart rate variability fetched for date $date: $hrv");
      return hrv;
    } on PlatformException catch (e) {
      print("Failed to fetch heart rate variability: '${e.message}'.");
      return null;
    }
  }
}
