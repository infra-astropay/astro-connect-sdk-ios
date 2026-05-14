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
    .package(url: "https://github.com/infra-astropay/astro-connect-sdk-ios", from: "1.0.12")
]
```

### Option 2: Manual Integration – Using XCFramework

To integrate AstroConnectSDK manually into your Xcode project, import the SDK as a framework using the `astro-connect-sdk-{VERSION}.xcframework` file (e.g., `astro-connect-sdk-1.0.0.xcframework`).

When adding the file, make sure to check "Copy items if needed" and select your app target under "Add to targets" to include the framework in your project.

Next, embed the framework in your app's target settings: go to the Frameworks, Libraries, and Embedded Content section, select the xcframework, and ensure "Embed & Sign" is selected.

## Configuration

### Required Permissions

Add the following keys to your `Info.plist` depending on the features your flow requires:

#### Camera Access

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for identity verification</string>
```

> **Important:** The `NSCameraUsageDescription` value is the message shown to users in the camera permission dialog. Customize this message to clearly explain why your app needs camera access. The dialog will display your **app name** (from your app's bundle display name) along with this message.

#### Biometric Authentication (Face ID)

If your flow uses biometric authentication (2FA with Face ID), add:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Face ID is required for biometric authentication</string>
```

> **Note:** This permission is required for devices with Face ID. Touch ID does not require a usage description in Info.plist.

### Create Configuration

```swift
import AstroConnectSDK

let configuration = AstroConfiguration(
    environment: "sandbox",             // "sandbox", "production"
    appIssuer: "your-app-issuer",       // Application identifier (your app name)
    clientId: "your-client-id",         // Client identifier (required)
    partnerUserId: "your-partner-user-id", // Partner user identifier (required)
    phoneCode: "51",                    // Phone country code (optional)
    phoneNumber: "123456789",           // Phone number (optional)
    accessToken: "your-access-token",   // Authentication token
    theme: .system,                     // .light, .dark, .system (optional)
    language: "en",                     // Language code (optional, default: "en")
    flow: "home",                       // Specific flow (optional)
    flowParams: ["amount": 100],        // Flow parameters (optional)
    showHeader: true,                   // Show header bar with close button (optional, default: true)
    showHeaderLogo: true,               // Show co-branded logo in header (optional, default: true)
    embedded: true,                     // Embedded mode (optional, default: true)
    biometricGracePeriod: 120,          // Seconds to skip biometric re-prompt (optional, default: 120)
    style: AstroStyle(                  // Custom style settings (optional)
        backgroundColor: "#FFFFFF",
        header: AstroHeaderStyle(
            backgroundColor: "#EFEFEF",
            borderColor: "#CCCCCC",
            borderWidth: 1,
            paddingHorizontal: 24,
            paddingVertical: 16
        )
    ),
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
| `clientId` | `String` | Yes | Client identifier |
| `partnerUserId` | `String` | Yes | Partner user identifier |
| `phoneCode` | `String?` | No | Phone country code (e.g., `"51"`, `"54"`) |
| `phoneNumber` | `String?` | No | Phone number |
| `accessToken` | `String` | No | Authentication token. |
| `theme` | `AstroTheme` | No | Visual theme: `.light`, `.dark`, `.system`. Default: `.system` |
| `language` | `String` | No | Language code (e.g., `"en"`, `"es"`, `"pt"`). Default: `"en"` |
| `flow` | `String` | No | Flow to execute (e.g., `"home"`, `"activities"`, `"topup"`, `"cards"`) |
| `flowParams` | `[String: Any]` | No | Additional flow parameters |
| `showHeader` | `Bool?` | No | Show header bar with close button and co-branded logo (default: `true`) |
| `showHeaderLogo` | `Bool?` | No | Show co-branded issuer logo in the header (default: `true`) |
| `showCloseButton` | `Bool?` | No | **Deprecated.** Use `showHeader` instead. |
| `autoSize` | `Bool?` | No | **Deprecated.** Use `showHeader` instead. |
| `embedded` | `Bool?` | No | Embedded mode (default: `true`) |
| `biometricGracePeriod` | `TimeInterval?` | No | Seconds to skip biometric re-prompt after a successful auth. Default: `120` (2 min). Range: `0`–`600` (10 min). Set to `0` to always require biometric. |
| `style` | `AstroStyle?` | No | Custom style settings for background and header (see [Style Customization](#style-customization)) |
| `logSetting` | `AstroLogSetting?` | No | Logging configuration |

### Home Banners

When the SDK lands on the home screen (either `flow: "home"` or when no `flow` is specified), you can render promotional banners by passing a `banners` array inside `flowParams`. Each banner is a dictionary and supports two types:

- `home-page` — full-screen banner shown once per session before the home loads (e.g. onboarding).
- `home-header` — compact banner rendered at the top of the home. Multiple `home-header` banners scroll horizontally.

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    flow: "home",
    flowParams: [
        "banners": [
            [
                "bannerType": "home-page",
                "bannerTitle": "Your wallet is ready to use!",
                "bannerDescription": "Top up now and get 5% cashback on your first transaction.",
                "bannerActionText": "Top Up Now",
                "bannerDismissText": "Dismiss",
                "bannerDeepLink": "topup",
                "bannerImage": "banner-home-page-en",
                "bannerImageSize": "30vh",
            ],
            [
                "bannerType": "home-header",
                "bannerTitle": "Your wallet is ready to use!",
                "bannerDescription": "Top up now and get 5% cashback.",
                "bannerActionText": "Top Up Now",
                "bannerDeepLink": "topup",
                "bannerImage": "banner-home-header-en",
            ],
        ]
    ]
)
```

#### Banner Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `bannerType` | `String` | Yes | Banner placement: `"home-page"` or `"home-header"` |
| `bannerTitle` | `String?` | No | Title text |
| `bannerDescription` | `String?` | No | Description text |
| `bannerActionText` | `String?` | No | Primary action button label. If omitted on a `home-header` banner, a chevron is shown instead and the entire banner is clickable |
| `bannerDismissText` | `String?` | No | Dismiss button label (only used by `home-page`) |
| `bannerDeepLink` | `String` | Yes | Deep link triggered on action: `"topup"`, `"activities"`, `"cards"`, `"withdrawal"` |
| `bannerImage` | `String?` | No | Image asset name to render on the banner |
| `bannerImageSize` | `String?` | No | Image size for `home-page` banners. Accepts a CSS length in `px`, `vh`, or `vw` (e.g. `"200px"`, `"50vh"`, `"40vw"`). Defaults to `30vh` when omitted or invalid |

### Topup Flow Parameters

When the SDK opens in the topup flow (`flow: "topup"`), you can preset the amount, the currency, and a list of suggested amounts that are rendered as pills below the amount input.

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    flow: "topup",
    flowParams: [
        "amount": 50,
        "currency": "USD",
        "suggestedAmounts": [50, 100, 200],
    ]
)
```

#### Topup Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `amount` | `Double` | No | Pre-fills the amount input |
| `currency` | `String` | No | Pre-selects the currency (ISO 4217 code, e.g., `"USD"`) |
| `suggestedAmounts` | `[Double]` | No | List of positive amounts rendered as clickable pills below the input. Tapping a pill sets the input to that value |

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
        clientId: "your-client-id",
        partnerUserId: "your-partner-user-id",
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
            clientId: "your-client-id",
            partnerUserId: "your-partner-user-id",
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

## Performance Optimization

### Pre-Warming (Recommended)

Initializes the SDK in the background as early as possible (e.g. `application(_:didFinishLaunchingWithOptions:)` or `scene(_:willConnectTo:)`). This reduces the cold-start delay so the first SDK open feels instant.

If `appIssuer` is provided, the co-branded header logo is also prepared in advance.

```swift
AstroConnect.preWarm(
    environment: "sandbox",
    appIssuer: "your-app-issuer"     // Optional — prepares the header logo in advance
) {
    print("SDK ready")
} onError: { error in
    print("Pre-warm failed: \(error.errorDetail)")
}
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `environment` | `String` | Yes | Target environment: `"production"`, `"sandbox"` |
| `appIssuer` | `String?` | No | If provided, the co-branded header logo is prepared in advance |
| `logSetting` | `AstroLogSetting?` | No | Logging configuration |
| `force` | `Bool` | No | Force re-initialization even if already completed (default: `false`) |
| `onSuccess` | `(() -> Void)?` | No | Called when the SDK is ready |
| `onError` | `((AstroError) -> Void)?` | No | Called if initialization fails |

### Pre-Loading

Pre-loads the SDK with a specific configuration before presenting it to the user. Call this when the user lands on a screen that will open the SDK shortly. When `AstroConnectView` is presented with the same configuration, it appears instantly with no loading screen.

> **Important:** A pre-load is **single-use** and **configuration-bound**.
> - Once `AstroConnectView` is presented, the pre-loaded session is consumed. To keep the instant-open behavior the next time the user enters the SDK, call `preload` again after the view is dismissed.
> - If the configuration passed to `AstroConnectView` differs from the one used in `preload`, the pre-load is discarded and the SDK initializes normally. If the configuration may change after pre-loading, call `preload` again with the updated configuration to restore the fast path.
> - When biometric authentication is required for the user, any prompt is automatically deferred until `AstroConnectView` is presented, so the user is never prompted before the SDK is on screen.

```swift
AstroConnect.preload(
    configuration: configuration,
    onPreloadEnded: { reason in
        switch reason {
        case .loaded:
            print("SDK ready — will open instantly")
        case .deferred:
            print("Preload deferred — will resume when AstroConnectView is presented")
        case .failed(let error):
            print("Preload failed: \(error.errorDetail)")
        @unknown default:
            print("Preload ended")
        }
    }
)
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `configuration` | `AstroConfiguration` | Yes | The same configuration that will be passed to `AstroConnectView` |
| `onPreloadEnded` | `((AstroPreloadEndReason) -> Void)?` | No | Called once with the reason the preload phase ended |

#### `AstroPreloadEndReason`

| Case | Meaning |
|------|---------|
| `.loaded` | The page finished loading during preload. The next `AstroConnectView` opens instantly. |
| `.deferred` | The preload ended before the page fully loaded because the SDK deferred a biometric prompt or the integrator presented `AstroConnectView` before loading finished. The remaining work continues on the live view. |
| `.failed(AstroError)` | The preload failed (network error, timeout, invalid configuration). |

> The previous `onSuccess` / `onError` overload is deprecated but still works for backward compatibility.

### Clearing SDK Data

Resets the SDK to a clean state for the given environment. Also discards any active pre-load. Call this after user logout or when a fresh start is required.

```swift
AstroConnect.clear(environment: "sandbox") {
    print("SDK data cleared")
} onError: { error in
    print("Clear failed: \(error.errorDetail)")
}
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `environment` | `String` | Yes | Target environment: `"production"`, `"sandbox"` |
| `onSuccess` | `(() -> Void)?` | No | Called when the SDK data has been cleared |
| `onError` | `((AstroError) -> Void)?` | No | Called if the environment is invalid |

## Handling Results

The SDK returns an `AstroResult` with four possible states:

```swift
@frozen
public enum AstroResult {
    case success              // Operation completed successfully
    case failure(AstroError)  // An error occurred
    case closed               // User closed the SDK
    case event(AstroEvent)    // An analytics event was received
}
```

```swift
private func handleResult(_ result: AstroResult) {
    switch result {
    case .success:
        print("Operation completed successfully")
    case .failure(let error):
        print("Error: \(error.errorDetail)")
    case .closed:
        print("User closed the SDK")
        dismiss()
    case .event(let event):
        print("Event: \(event.eventName) - \(event.eventCategory)")
        // Send to your analytics platform
    }
}
```


## Events

The SDK emits analytics events during user interactions via the `.event(AstroEvent)` case. Each event exposes the following fields:

### Event Structure

```swift
public struct AstroEvent {
    public let screenName: String                    // Screen where the event occurred
    public let eventName: String                     // Name of the event
    public let eventCategory: String                 // Category: "user_action", "page_view", etc.
    public let eventProperties: [String: Any]?       // Additional event data (optional)
    public let sessionId: String                     // Session identifier
    public let appVersion: String                    // SDK version
    public let platform: String                      // Platform: "ios"
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

For the full catalog of events, screen names, and their properties, see [Events Reference](EVENTS.md).

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
| `"appIssuer is required"` | Empty app issuer |
| `"clientId is required"` | Empty client ID |
| `"partnerUserId is required"` | Empty partner user ID |
| `"Environment is not supported"` | Invalid environment |
| `"biometricGracePeriod must be a whole number (integer seconds)"` | Non-integer value passed to `biometricGracePeriod` |
| `"biometricGracePeriod must be between 0 and 600 seconds"` | `biometricGracePeriod` outside the supported range |

## Log Configuration

Logs are disabled in production for security.

```swift
let logSetting = AstroLogSetting(
    enabled: true,      // Enable logs
    verbose: false,     // Verbose mode (optional, default: false)
    logLevel: .debug    // .error, .info, .debug
)

let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
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

## Style Customization

You can customize the SDK's visual appearance using `AstroStyle`. This allows you to override the default background color and header styling.

### AstroStyle

| Property          | Type                | Description                                              |
|-------------------|---------------------|----------------------------------------------------------|
| `backgroundColor` | `String?`           | Main background color as hex string (e.g., `"#FFFFFF"`)  |
| `header`          | `AstroHeaderStyle?` | Header style settings                                    |

### AstroHeaderStyle

| Property            | Type       | Default     | Description                                                          |
|---------------------|------------|-------------|----------------------------------------------------------------------|
| `backgroundColor`   | `String?`  | Theme-based | Header background color as hex string                                |
| `borderColor`       | `String?`  | Theme-based | Header bottom border color as hex string                             |
| `borderWidth`       | `CGFloat?` | `0`         | Header bottom border width in points. Set to `0` to hide the border  |
| `paddingHorizontal` | `CGFloat?` | `24`        | Horizontal padding inside the header                                 |
| `paddingVertical`   | `CGFloat?` | `16`        | Vertical padding inside the header                                   |

### Example

```swift
let style = AstroStyle(
    backgroundColor: "#FFFFFF",
    header: AstroHeaderStyle(
        backgroundColor: "#EFEFEF",
        borderColor: "#CCCCCC",
        borderWidth: 1,
        paddingHorizontal: 24,
        paddingVertical: 16
    )
)

let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    style: style
)
```

> **Note:** When `style` is not provided, the SDK uses default colors based on the selected theme (light/dark/system).
>
> **Important:** When you override a color via `AstroStyle`, the SDK **stops using the theme-based default** for that property. This means you are responsible for providing the appropriate value for both light and dark modes. For example:
>
> ```swift
> let isDark = UITraitCollection.current.userInterfaceStyle == .dark
>
> let style = AstroStyle(
>     backgroundColor: isDark ? "#041311" : "#FFFFFF",
>     header: AstroHeaderStyle(
>         backgroundColor: isDark ? "#061E1D" : "#EFEFEF"
>     )
> )
> ```

## Co-Branded Header Logo

When `showHeaderLogo` is `true` (the default), the SDK header displays a co-branded logo for the issuer. The logo is fetched automatically based on the `appIssuer` value and the current theme.

- The SDK looks for a logo at: `{baseUrl}/{appIssuer}_{theme}.webp`
- If the issuer logo is not found, it falls back to the default AstroPay logo
- Set `showHeaderLogo: false` to hide the logo entirely

## Custom Loading View

You can customize the loading view:

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
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

## Resources

- [Changelog](CHANGELOG.md) — Version history and what changed in each release.
- [Events Reference](EVENTS.md) — All analytics events emitted by the SDK, including screen names, event names, categories, and properties.
- [Migration Guides](migrations/) — Step-by-step guides for upgrading between versions that include breaking changes.

## Support

For technical support, contact the AstroPay integrations team.
