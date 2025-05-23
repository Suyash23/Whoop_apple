# watchOS App Guidance (Whoop Clone)

## 1. Overview

The watchOS component of the Whoop Clone app will primarily be a native Swift application. This is due to the current limitations of Flutter on watchOS, especially concerning background execution, continuous HealthKit access, and efficient Watch Connectivity usage. The native watchOS app will be responsible for collecting health and activity data directly from the Apple Watch and communicating this data to the main Flutter application on the iPhone using the Watch Connectivity framework.

## 2. Project Structure (Conceptual for Native Swift App)

```
watchos_app/
├── WatchApp/                 # Main WatchKit App target
│   ├── Assets.xcassets
│   ├── Base.lproj/
│   ├── Info.plist
│   ├── WatchApp.swift        # Main App entry point (e.g., @main struct conforming to App)
│   └── ContentView.swift     # Main UI view (SwiftUI)
├── HealthKitManager/
│   └── HealthKitManager.swift # Handles all HealthKit interactions (authorization, queries, workout sessions)
├── WatchConnectivityManager/
│   └── WatchConnectivityManager.swift # Manages WCSession, data transfer to/from iPhone
├── Models/                   # Data models shared within the watch app (e.g., HeartRateData, WorkoutSession)
│   └── HealthDataModels.swift
├── Views/                    # SwiftUI views for different parts of the watch app
│   ├── HeartRateView.swift
│   ├── WorkoutView.swift
│   └── SleepTrackingView.swift
└── Controllers/              # Logic controllers if not directly in SwiftUI views or managers
    └── WorkoutController.swift
```

*(Note: The `watchos_app` directory in the Flutter project currently holds this guidance. The actual Swift project would be separate but conceptually linked.)*

## 3. Key Native Swift Components

### `WatchApp.swift` (Main App Entry)
- Initializes `HealthKitManager` and `WatchConnectivityManager` as singletons or environment objects.
- Sets up the main SwiftUI view hierarchy, starting with `ContentView`.
- Handles app lifecycle events.

### `ContentView.swift` (Main UI)
- Serves as the primary user interface on the Apple Watch.
- Could use a `TabView` for different sections (e.g., Live HR, Start Workout, Sleep).
- Displays real-time heart rate data fetched via `HealthKitManager`.
- Provides controls to start and stop workout sessions.
- Includes an interface to manually trigger the start and end of a sleep session if desired (though automatic detection via HealthKit is also possible).

### `HealthKitManager.swift`
- **Responsibilities:**
    - **Authorization:** Manages requests for HealthKit authorization for necessary data types (e.g., `HKObjectType.quantityType(forIdentifier: .heartRate)`, `HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)`, `HKObjectType.categoryType(forIdentifier: .sleepAnalysis)`, `HKObjectType.workoutType()`, `HKObjectType.quantityType(forIdentifier: .respiratoryRate)`).
    - **Heart Rate Queries:** Implements queries to fetch heart rate data. This could be an `HKAnchoredObjectQuery` for background collection and `HKStreamingQuery` or updates during an active `HKWorkoutSession` for higher frequency.
    - **Workout Sessions:** Manages `HKWorkoutSession` and `HKLiveWorkoutBuilder` to track activities, collect real-time metrics, and save workouts to HealthKit.
    - **Data Saving:** Saves collected data (heart rate samples, workout details, sleep analysis if manually entered or processed) into the HealthKit store.
    - **Data Fetching:** Fetches data from HealthKit if needed for display on the watch (e.g., today's step count, last recorded HR).
- **Battery Optimization Notes:**
    - Background App Refresh should be used sparingly. Schedule updates intelligently.
    - Leverage `HKWorkoutSession` for continuous, high-frequency heart rate monitoring during workouts, as this is power-efficient and sanctioned by Apple.
    - Be mindful of the frequency of general background queries; anchor queries are generally preferred over frequent polling.
    - For sleep, HealthKit can often automatically detect sleep, which can be queried, reducing the need for constant background activity from the app itself.

### `WatchConnectivityManager.swift`
- **Responsibilities:**
    - **Session Activation:** Initializes and activates the `WCSession.default` session.
    - **Delegate Implementation:** Implements `WCSessionDelegate` to handle session activation status (`session(_:activationDidCompleteWith:error:)`), reachability changes (`sessionReachabilityDidChange(_:)`), and incoming data/messages.
    - **Sending Data to iPhone:**
        - Uses `WCSession.default.sendMessage(_:replyHandler:errorHandler:)` for immediate, high-priority data (e.g., live heart rate if the iPhone app is active and requesting it).
        - Uses `WCSession.default.updateApplicationContext(_:)` to send data that should be available to the iPhone app when it next launches or in the background (e.g., completed workout summaries, daily HR stats, sleep session details). This is generally preferred for non-critical updates.
    - **Receiving Data from iPhone:** Implements `session(_:didReceiveMessage:)` and `session(_:didReceiveApplicationContext:)` to handle commands or data sent from the iPhone app (e.g., configuration updates, though this is less common for this app's primary data flow).
    - **Buffering:** Implements a mechanism to buffer or queue data if the iPhone is not reachable. Data is sent when the `isReachable` property of `WCSession` becomes true.
- **Data to Transfer (Examples):**
    - Heart rate samples (timestamp, value).
    - Workout session details (type, start time, end time, energy burned, distance, etc.).
    - Sleep session details (start time, end time, potentially stages if processed on watch).
    - Daily HRV, RHR values once calculated or fetched.

### Data Models (`HealthDataModels.swift`)
- Define Swift `struct`s (preferably `Codable`) for data representation.
- Examples:
  ```swift
  struct HeartRateSample: Codable {
      let timestamp: Date
      let value: Double // bpm
  }

  struct WorkoutSummary: Codable {
      let type: String // e.g., "Running", "Cycling"
      let startDate: Date
      let endDate: Date
      let energyBurned: Double // calories
      let distance: Double? // meters
  }

  struct SleepSessionData: Codable {
      let startDate: Date
      let endDate: Date
      // Potentially add sleep stages if processed on watch
  }
  ```
- These models are used internally in the watch app, for saving to HealthKit (by mapping to HealthKit types), and for serializing to send via Watch Connectivity.

## 4. Flutter Interaction (If any part of Watch UI is Flutter)

While a fully native Swift app is recommended for the watchOS component due to background processing and HealthKit integration complexities, if a portion of the watch UI were to be built with Flutter (this is currently less common and has more limitations on watchOS):

- A dedicated Flutter plugin for watchOS would be required. This plugin would bridge Dart code to native Swift.
- Native Swift code (as described above with `HealthKitManager` and `WatchConnectivityManager`) would still be essential for all HealthKit operations and Watch Connectivity communication.
- Platform channels (`MethodChannel` for invoking methods, `EventChannel` for streaming data) would be used to communicate between the Flutter Dart code (UI) on the watch and the native Swift services.
- If a Flutter target for watchOS existed, its Dart code would reside in a directory like `watchos_app/lib/`. The current `lib` directory in the project root is for the main Flutter (iOS/Android) application.

## 5. Data Flow (Watch to iPhone)

1.  **Data Collection (Watch):** The native Swift watchOS app, through `HealthKitManager`, collects health data (heart rate, workout details, sleep information).
2.  **Data Packaging (Watch):** Collected data is structured using the defined Swift data models.
3.  **Data Transfer Initiation (Watch):** `HealthKitManager` passes this data to `WatchConnectivityManager`.
4.  **Watch Connectivity Transfer (Watch -> iPhone):** `WatchConnectivityManager` on the watch sends the serialized data to the paired iPhone using `updateApplicationContext` (for durable updates) or `sendMessage` (for immediate updates if the iPhone app is active).
5.  **Data Reception (iPhone - Native):** On the iPhone, a corresponding native Swift component (e.g., a `WatchConnectivityProvider` class within the iOS part of the Flutter app) implements `WCSessionDelegate` and receives the data in `session(_:didReceiveApplicationContext:)` or `session(_:didReceiveMessage:)`.
6.  **Data Bridge (iPhone - Native to Flutter):** This native Swift component then uses the platform channel defined in `lib/features/watch_connectivity/platform_channels.dart` (specifically, the `MethodChannel` named `com.example.whoop_clone_app/watchconnectivity`) to forward the received data to the Flutter/Dart side of the iPhone application. This might involve invoking a method like `onDataReceivedFromWatch` on the Dart side.
7.  **Data Processing (iPhone - Flutter):** The Flutter app receives the data via `WatchConnectivityChannels` and can then process it, store it using `DatabaseService`, and update the UI.

This layered structure provides a solid foundation for the native watchOS app development, ensuring efficient data collection and reliable communication with the main iPhone application.
