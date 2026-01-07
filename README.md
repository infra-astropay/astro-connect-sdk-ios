# AstroConnectSDK - iOS

SDK for integrating AstroPay Connect into iOS applications.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

### Option 1: Swift Package Manager (Recommended)

Add the AstroConnectSDK package to your Xcode project:

1. In Xcode, go to **File → Add Packages**
2. Enter the repository URL: `https://github.com/infra-astropay/astro-connect-sdk-ios`
3. Select the version you want to use
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/infra-astropay/astro-connect-sdk-ios", from: "1.0.3")
]
```

### Option 2: Manual Integration – Using XCFramework

To integrate AstroConnectSDK manually into your Xcode project, import the SDK as a framework using the `astro-connect-sdk-{VERSION}.xcframework` file (e.g., `astro-connect-sdk-1.0.0.xcframework`).

When adding the file, make sure to check "Copy items if needed" and select your app target under "Add to targets" to include the framework in your project.

Next, embed the framework in your app's target settings: go to the Frameworks, Libraries, and Embedded Content section, select the xcframework, and ensure "Embed & Sign" is selected.

## Configuration

### Required Permissions

Add the following keys to your `Info.plist` if the flow requires camera access:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for identity verification</string>
```

### Create Configuration

```swift
import AstroConnectSDK

let configuration = AstroConfiguration(
    environment: "sandbox",             // "sandbox", "production"
    appIssuer: "your-app-issuer",       // Application identifier (your app name)
    accessToken: "your-access-token",   // Authentication token
    theme: .system,                     // .light, .dark, .system (optional)
    language: "en",                     // Language code (optional, default: "en")
    flow: "home",                       // Specific flow (optional)
    flowParams: ["amount": 100],        // Flow parameters (optional)
    showCloseButton: true,              // Show close button (optional, default: true)
    embedded: true,                     // Embedded mode (optional, default: true)
    logSetting: AstroLogSetting(        // Log configuration (optional)
        enabled: true,
        logLevel: .debug
    )
)
```

### Configuration Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `environment` | `String` | Yes | Environment: `"sandbox"`, `"production"` |
| `appIssuer` | `String` | Yes | Application identifier |
| `accessToken` | `String` | No* | Authentication token. *Required on first use to initiate session; optional afterwards |
| `theme` | `AstroTheme` | No | Visual theme: `.light`, `.dark`, `.system` |
| `language` | `String` | No | Language code (e.g., `"en"`, `"es"`, `"pt"`) |
| `flow` | `String` | No | Flow to execute (e.g., `"home"`, `"activities"`, `"topup"`, `"cards"`) |
| `flowParams` | `[String: Any]` | No | Additional flow parameters |
| `showCloseButton` | `Bool` | No | Show built-in close button in the SDK header (default: `true`) |
| `embedded` | `Bool` | No | Embedded mode (default: `true`) |
| `logSetting` | `AstroLogSetting` | No | Logging configuration |

## Integration

### SwiftUI

```swift
import SwiftUI
import AstroConnectSDK

struct ContentView: View {
    @State private var showSDK = false
    @Environment(\.dismiss) private var dismiss
    @State private var showError = false
    @State private var errorMessage = ""

    let configuration = AstroConfiguration(
        environment: "sandbox",
        appIssuer: "your-app-issuer",
        accessToken: "your-access-token"
    )

    var body: some View {
        Button("Open AstroPay") {
            showSDK = true
        }
        .fullScreenCover(isPresented: $showSDK) {
            AstroConnectView(
                configuration: configuration,
                onResult: handleResult
            )
            .alert("Error", isPresented: $showError) {
                Button("OK") { dismiss() }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func handleResult(_ result: AstroResult) {
        switch result {
        case .success:
            print("Operation completed successfully")
        case .failure(let error):
            errorMessage = error.errorDetail
            showError = true
        case .closed:
            print("User closed the SDK")
            dismiss()
        case .event(let event):
            print("Event: \(event.eventName)")
        }
    }
}
```

### UIKit

```swift
import UIKit
import SwiftUI
import AstroConnectSDK

class MyViewController: UIViewController {

    func presentAstroConnect() {
        let configuration = AstroConfiguration(
            environment: "sandbox",
            appIssuer: "your-app-issuer",
            accessToken: "your-access-token"
        )

        let sdkView = AstroConnectView(
            configuration: configuration,
            onResult: { [weak self] result in
                self?.handleResult(result)
            }
        )

        let hostingController = UIHostingController(rootView: sdkView)
        hostingController.modalPresentationStyle = .fullScreen

        present(hostingController, animated: true)
    }

    private func handleResult(_ result: AstroResult) {
        switch result {
        case .success:
            print("Operation completed successfully")
        case .failure(let error):
            showErrorAlert(message: error.errorDetail)
        case .closed:
            print("User closed the SDK")
            dismiss(animated: true)
        case .event(let event):
            print("Event: \(event.eventName)")
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
```

## Handling Results

The SDK returns an `AstroResult` with four possible states:

```swift
public enum AstroResult {
    case success              // Operation completed successfully
    case failure(AstroError)  // An error occurred
    case closed               // User closed the SDK
    case event(AstroEvent)    // An analytics event was received
}
```

### Handling Events

The SDK emits analytics events during user interactions. You can capture these events for tracking purposes:

```swift
private func handleResult(_ result: AstroResult) {
    switch result {
    case .success:
        print("Operation completed successfully")
    case .failure(let error):
        print("Error: \(error.errorDetail)")
    case .closed:
        print("User closed the SDK")
    case .event(let event):
        print("Event: \(event.eventName) - \(event.eventCategory)")
        // Send to your analytics platform
    }
}
```

### Event Structure

```swift
public struct AstroEvent {
    public let screenName: String           // Screen where the event occurred
    public let eventName: String            // Name of the event
    public let eventCategory: String        // Category: "user_action", "page_view", etc.
    public let eventProperties: [String: Any]?  // Additional event data (optional)
    public let sessionId: String            // Session identifier
    public let appVersion: String           // SDK version
    public let platform: String             // Platform: "ios"
}
```

### Accessing Event Properties

```swift
case .event(let event):
    // Access a specific property safely
    if let amount = event.eventProperties?["amount"] as? Int {
        print("Amount: \(amount)")
    }
```

## Error Codes

### Error Structure

```swift
let error: AstroError

error.errorCode        // Numeric code (e.g., "1003")
error.errorSubCode     // Optional subcode (e.g., "01")
error.errorMessage     // Descriptive message
error.errorDetail      // Full detail: "[1003-01] No internet connection"
```

### Error Table

| Code | Name | Description |
|------|------|-------------|
| `1001` | `INITIALIZATION_ERROR` | Error initializing the SDK |
| `1002` | `INVALID_CONFIG` | Invalid configuration |
| `1003` | `NETWORK_ERROR` | Network error |
| `1004` | `BRIDGE_ERROR` | Communication error with the app |
| `1005` | `TIMEOUT` | Request timed out |
| `1006` | `CAMERA_PERMISSION` | Camera permission error |

### Network Error Subcodes (1003)

| Subcode | Name | Description |
|---------|------|-------------|
| `01` | `NO_CONNECTION` | No internet connection |
| `02` | `HOST_NOT_FOUND` | Server not found |
| `03` | `TIMEOUT` | Connection timed out |
| `04` | `CANNOT_CONNECT` | Unable to connect to server |
| `05` | `CONNECTION_LOST` | Connection lost |
| `06` | `UNKNOWN` | Unknown network error |

### Bridge Error Subcodes (1004)

| Subcode | Name | Description |
|---------|------|-------------|
| `01`  | `JSON_PARSING_ERROR` | Error parsing data from the SDK |
| `401` | `UNAUTHORIZED` | Authentication error (invalid or expired token) |

### Configuration Errors (1002)

| Message | Cause |
|---------|-------|
| `"accessToken is required"` | Empty access token |
| `"appIssuer is required"` | Empty app issuer |
| `"Environment is not supported"` | Invalid environment |

## Log Configuration

Logs are disabled in production for security.

```swift
let logSetting = AstroLogSetting(
    enabled: true,      // Enable logs
    logLevel: .debug    // .error, .info, .debug
)

let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    accessToken: "your-access-token",
    logSetting: logSetting
)
```

### Log Levels

| Level | Description |
|-------|-------------|
| `.error` | Errors only |
| `.info` | Errors and general information |
| `.debug` | All messages including debug |

### Filtering Logs

You can filter logs by SUBSYSTEM: `com.astropay.connect`

## Custom Loading View

You can customize the loading view:

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    accessToken: "your-access-token"
) {
    // Custom loading view
    VStack {
        ProgressView()
            .scaleEffect(1.5)
        Text("Loading...")
            .padding(.top)
    }
}
```

## Environments

| Environment |
|-------------|
| `production` |
| `sandbox` |

## Support

For technical support, contact the AstroPay integrations team.
