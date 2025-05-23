import 'package:flutter/services.dart';

class WatchConnectivityChannels {
  static const MethodChannel _channel = MethodChannel('com.example.whoop_clone_app/watchconnectivity');

  // --- iPhone receiving data from Watch ---
  // This might be set up as a listener on the native side that then uses
  // EventChannel or invokes methods on a Dart callback handler.
  // For simplicity here, we can define methods that the native side would call.
  // Or, a method to fetch data if the watch queues it.

  /// Sets up listeners for data coming from the Apple Watch.
  ///
  /// [onDataReceived] - A callback function that will be invoked when data is received from the watch.
  /// The data is expected to be a Map<String, dynamic>.
  ///
  /// Native Swift (iPhone): Initialize Watch Connectivity session and set up listeners
  /// for messages or context updates from the Apple Watch.
  /// When data is received, it should call a Dart method (e.g., via EventChannel or by invoking a registered callback).
  /// For now, this is a conceptual setup.
  static Future<void> setupWatchConnectivityListeners(Function(Map<String, dynamic> data) onDataReceived) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDataReceivedFromWatch') {
        if (call.arguments is Map) {
          onDataReceived(Map<String, dynamic>.from(call.arguments as Map));
        }
      }
    });
    try {
      await _channel.invokeMethod('initializeWatchConnectivity');
      print("Watch Connectivity listeners setup initiated on Flutter side.");
      // Native Swift (AppDelegate or a dedicated manager):
      // 1. Initialize WCSession and activate it.
      // 2. Implement WCSessionDelegate methods (e.g., session:didReceiveMessage:, session:didReceiveApplicationContext:).
      // 3. When data is received in these delegate methods, use the Flutter MethodChannel
      //    to send it to the Dart side:
      //    `flutterChannel.invokeMethod("onDataReceivedFromWatch", arguments: dataPayload)`
      //    where `dataPayload` is the Map<String, Any> received from the watch.
    } on PlatformException catch (e) {
      print("Failed to initialize Watch Connectivity listeners: '${e.message}'.");
    }
  }

  // --- iPhone sending data/commands to Watch (less common for this app's flow but possible) ---

  /// Sends a message to the Apple Watch.
  ///
  /// [message] - A Map containing the data to send.
  ///
  /// Native Swift (iPhone): Send a message to the Apple Watch if it's reachable and paired.
  /// Use WCSession.sendMessage() for immediate messages.
  static Future<void> sendMessageToWatch(Map<String, dynamic> message) async {
    try {
      await _channel.invokeMethod('sendMessageToWatch', message);
      print("Message sent to watch: $message");
    } on PlatformException catch (e) {
      print("Failed to send message to watch: '${e.message}'.");
    }
  }

  /// Updates the application context for the Apple Watch.
  /// This is useful for sending data that should be available to the watch
  /// even if it's not immediately reachable.
  ///
  /// [context] - A Map containing the data to send as application context.
  ///
  /// Native Swift (iPhone): Update the application context for the Apple Watch.
  /// Use WCSession.updateApplicationContext().
  static Future<void> updateApplicationContext(Map<String, dynamic> context) async {
    try {
      await _channel.invokeMethod('updateApplicationContext', context);
      print("Application context updated for watch: $context");
    } on PlatformException catch (e) {
      print("Failed to update application context for watch: '${e.message}'.");
    }
  }

  // Conceptual: Method that might be called by the watch to transfer a batch of data
  // This would be invoked *from* the native watchOS side.
  // This is not typically how data flows from watch to phone (usually it's message or context update),
  // but included for completeness if a specific scenario required it.
  // static Future<void> receiveDataFromWatch(Map<String, dynamic> data) async {
  //   // Logic to handle data received from watch, e.g., store in database.
  //   // This would be called by the Swift side via platform channel.
  //   print("Data received from watch on Flutter side: $data");
  // }
}
