# AstroConnectSDK - iOS

SDK for integrating AstroPay Connect into iOS applications.

The SDK ships in **two flavors**: a **core** product (`AstroConnectSDK`) for most integrations, and a **native KYC** product (`AstroConnectSDKNativeKYC`) that adds on-device identity verification for regulated markets. Both expose the identical public API — see [Choosing a product](#choosing-a-product-core-vs-native-kyc) to pick one.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

### Choosing a product: core vs. native KYC

The SDK ships **two products** at the same version — the same integration code, but different bundled capabilities. Pick the one that matches your flows:

| Product | Use when | On-device identity verification | Extra dependency |
|---------|----------|---------------------------------|------------------|
| `AstroConnectSDK` (core) | The standard product for most integrations. Identity verification, when the server requests it, runs through the standard in-app browser flow. | Not included | None |
| `AstroConnectSDKNativeKYC` (native KYC) | You operate in a regulated market (e.g. Brazil) that requires **on-device identity verification** — face liveness and document capture handled natively in your app rather than in the in-app browser. | Included | Adds CafSDK (`7.0.0`) |

**Not sure which to pick?** Use the core **`AstroConnectSDK`** product — most integrations don't need native KYC, and switching to `AstroConnectSDKNativeKYC` later requires **no code changes** beyond the import (see [Switching between core and native KYC](#switching-between-core-and-native-kyc)).

Both products expose the identical public API — only the import and the bundled native KYC capability differ. If you integrate `AstroConnectSDK` and a native KYC flow is requested, it returns an error result instead of running, and every other feature works normally.

Import the product you chose:

```swift
import AstroConnectSDK      // core
// or
import AstroConnectSDKNativeKYC   // includes native KYC
```

### Option 1: Swift Package Manager (Recommended)

Add the AstroConnectSDK package to your Xcode project:

1. In Xcode, go to **File → Add Packages**
2. Enter the repository URL: `https://github.com/infra-astropay/astro-connect-sdk-ios`
3. Select the version you want to use
4. Add the product you need to your target: **`AstroConnectSDK`** (core) or **`AstroConnectSDKNativeKYC`** (native KYC)
5. Click **Add Package**

Or add it to your `Package.swift`. The package exposes both products from the same version — list whichever your target imports:

```swift
dependencies: [
    .package(url: "https://github.com/infra-astropay/astro-connect-sdk-ios", from: "1.0.15")
]
```

```swift
// Core product (no native KYC, no CafSDK)
.product(name: "AstroConnectSDK", package: "astro-connect-sdk-ios")

// or — native KYC product (pulls in CafSDK 7.0.0 transitively)
.product(name: "AstroConnectSDKNativeKYC", package: "astro-connect-sdk-ios")
```

When you select `AstroConnectSDKNativeKYC` via Swift Package Manager, CafSDK is resolved transitively — no additional step required.

### Option 2: Manual Integration – Using XCFramework

Two XCFrameworks are published at the same version, one per product:

- `AstroConnectSDK-{VERSION}.xcframework` — core, no native KYC.
- `AstroConnectSDKNativeKYC-{VERSION}.xcframework` — includes native KYC.

Download the XCFramework zips from the **Releases** page of the SDK repository (`https://github.com/infra-astropay/astro-connect-sdk-ios/releases`); each release attaches both products as assets.

Import the XCFramework that matches the product you need. When adding the file, make sure to check "Copy items if needed" and select your app target under "Add to targets" to include the framework in your project.

Next, embed the framework in your app's target settings: go to the Frameworks, Libraries, and Embedded Content section, select the xcframework, and ensure "Embed & Sign" is selected.

> **Note:** If you use the **`AstroConnectSDKNativeKYC`** XCFramework, the native KYC feature requires CafSDK to be added separately to your project. You can add it via Swift Package Manager using the repository `https://github.com/combateafraude/caf-ios-sdk` (version 7.0.0 — the exact version this SDK is built against), or include its XCFramework manually. The core **`AstroConnectSDK`** XCFramework does not require CafSDK.

### Switching between core and native KYC

Both products expose an identical public API, so moving from `AstroConnectSDK` to `AstroConnectSDKNativeKYC` (or back) needs **no code changes** beyond the import. To switch:

**Swift Package Manager**

1. In your target, replace the `AstroConnectSDK` product with `AstroConnectSDKNativeKYC` (same version). CafSDK is resolved transitively — no extra step.
2. Update the import: `import AstroConnectSDKNativeKYC`.
3. Add the native KYC keys to your `Info.plist` (see [Native KYC — Additional Plist Keys](#native-kyc--additional-plist-keys)).

**XCFramework (manual)**

1. Replace `AstroConnectSDK-{VERSION}.xcframework` with `AstroConnectSDKNativeKYC-{VERSION}.xcframework`.
2. Add CafSDK `7.0.0` to your project (see the note in [Option 2](#option-2-manual-integration--using-xcframework)).
3. Update the import to `import AstroConnectSDKNativeKYC` and add the `Info.plist` keys as above.

To go back to core, reverse the steps: switch the product/XCFramework, change the import to `import AstroConnectSDK`, and remove the CafSDK dependency. The KYC-only `Info.plist` keys can be removed if no other flow needs them.

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

#### Native KYC — Additional Plist Keys

> These keys are only required when you integrate the **`AstroConnectSDKNativeKYC`** product. The core **`AstroConnectSDK`** product does not run the native KYC flow and needs none of these keys.

If your integration uses the native KYC flow, add the following keys to your `Info.plist`:

```xml
<!-- Required by the face liveness module for audio liveness detection -->
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for identity verification</string>

<!-- Required to allow document upload from the photo library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required for document verification</string>

<!-- Required if captured documents are saved to the photo library -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Photo library access is required to save verification documents</string>
```

Customize the description strings to match your app's tone. iOS will display these strings in the system permission dialogs.

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
    flowParams: ["topup": ["amount": 100]], // Flow parameters (optional)
    showHeader: true,                   // Show header bar with close button (optional, default: true)
    showHeaderLogo: true,               // Show co-branded logo in header (optional, default: true)
    embedded: true,                     // Embedded mode (optional, default: true)
    biometricGracePeriod: 120,          // Seconds to skip biometric re-prompt (optional, default: 120)
    style: AstroStyle(                  // Custom style settings (optional)
        backgroundColor: .white,
        primaryColor: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),
        buttons: AstroButtonStyle(
            colors: AstroButtonColors(
                primaryBackground: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),
                primaryText: .black
            )
        ),
        header: AstroHeaderStyle(
            backgroundColor: UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1),
            borderColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
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
| `embedded` | `Bool?` | No | Embedded mode (default: `true`) |
| `biometricGracePeriod` | `TimeInterval?` | No | Seconds to skip biometric re-prompt after a successful auth. Default: `120` (2 min). Range: `0`–`600` (10 min). Set to `0` to always require biometric. |
| `style` | `AstroStyle?` | No | Custom style settings for background and header (see [Style Customization](#style-customization)) |
| `styleOverrides` | `[String: Any]?` | No | Free-form hex/color overrides forwarded to the web, mirroring the `AstroStyle` key shape. Escape hatch for tokens not yet in the typed catalog (see [Hex-string escape hatch via `styleOverrides`](#hex-string-escape-hatch-via-styleoverrides)) |
| `logSetting` | `AstroLogSetting?` | No | Logging configuration |

### Home Banners

Banners are cross-cutting: you can pass them via `flowParams.banners` regardless of the active flow. The `bannerType` value determines where each banner is rendered, not the flow that was initialized. Two placements are supported:

- `home-page` — full-screen banner shown once per session before the home loads (e.g. onboarding).
- `home-header` — compact banner rendered at the top of the home. Multiple `home-header` banners scroll horizontally.

Each banner is a dictionary inside the `banners` array.

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

### Topup Parameters

Topup parameters are cross-cutting: whenever the user lands on the topup amount screen — regardless of the flow that was initialized — you can preset the amount, the currency, and a list of suggested amounts that are rendered as pills below the amount input.

Pass these values under a nested `topup` dictionary inside `flowParams`.

`currency` is required for `amount` and `suggestedAmounts` to take effect: if it is omitted, or does not match the currency shown on the screen, neither is applied.

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    flow: "topup",
    flowParams: [
        "topup": [
            "amount": 50,
            "currency": "USD",
            "suggestedAmounts": [50, 100, 200],
        ]
    ]
)
```

For partners that operate multiple currencies, you can supply a per-currency preset map instead of (or alongside) the flat `suggestedAmounts` list. Keys are ISO 4217 codes (case-insensitive — they are normalized to uppercase internally):

```swift
// Per-currency preset map — overrides `suggestedAmounts` when present.
// Keys are ISO 4217 codes (case-insensitive).
let flowParams: [String: Any] = [
    "topup": [
        "suggestedAmountsByCurrency": [
            "USD": [10, 25, 50, 100],
            "EUR": [10, 20, 50, 100],
            "BRL": [50, 100, 200, 500]
        ]
    ]
]
```

> **Precedence:** When both `suggestedAmounts` and `suggestedAmountsByCurrency` are provided, the per-currency map wins. If the user is on a currency that is not a key in the map, no preset pills are shown — the flat list is NOT consulted as a fallback.

> **Deprecated:** The flat keys `amount`, `currency`, and `suggestedAmounts` placed directly under `flowParams` are still accepted for backward compatibility, but the nested `flowParams.topup` shape is the recommended form. The flat keys will be removed in a future major version.

#### Topup Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `amount` | `Double` | No | Pre-fills the amount input. Requires `currency` and only applied when it matches the screen currency |
| `currency` | `String` | No | Target currency (ISO 4217 code, e.g., `"USD"`). Required for `amount` and `suggestedAmounts` to take effect |
| `suggestedAmounts` | `[Double]` | No | List of positive amounts rendered as clickable pills below the input. Tapping a pill sets the input to that value. Requires `currency` and only rendered when it matches the screen currency. Ignored entirely when `suggestedAmountsByCurrency` is provided |
| `suggestedAmountsByCurrency` | `[String: [Double]]` | No | Per-currency preset map. Keys are ISO 4217 codes (case-insensitive). When present, takes precedence over `suggestedAmounts`; if the screen currency is not a key in the map, no preset pills are shown |

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
        case .closed(let code, let message):
            switch code {
            case "CLOSED_BY_USER_HEADER_BUTTON", "CLOSED_BY_USER_NAVIGATED_BACK", "CLOSED_BY_SYSTEM_DISMISS":
                // User backed out or the view was dismissed — log a dismissal event to your analytics
                print("sdk_dismissed code=\(code) message=\(message)")
            case "CLOSED_BY_USER_SIGNED_OUT":
                // User signed out from inside the SDK — clear local session state
                print("User signed out — clearing local session")
            default:
                print("SDK closed: \(code) — \(message)")
            }
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
        case .closed(let code, let message):
            switch code {
            case "CLOSED_BY_USER_HEADER_BUTTON", "CLOSED_BY_USER_NAVIGATED_BACK", "CLOSED_BY_SYSTEM_DISMISS":
                // User backed out or the view was dismissed — log a dismissal event to your analytics
                print("sdk_dismissed code=\(code) message=\(message)")
            case "CLOSED_BY_USER_SIGNED_OUT":
                // User signed out from inside the SDK — clear local session state
                print("User signed out — clearing local session")
            default:
                print("SDK closed: \(code) — \(message)")
            }
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

> **Custom header?** If your host renders its own header instead of the built-in one, drive the SDK with `AstroConnectController` and set `showHeader = false` so you can wire your own close button to `controller.close(...)`. See [Custom Header](#custom-header) for the full setup.

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
    case success                                       // Operation completed successfully
    case failure(AstroError)                           // An error occurred
    case closed(code: String, message: String)         // User closed the SDK — see Close payload
    case event(AstroEvent)                             // An analytics event was received
}
```

```swift
private func handleResult(_ result: AstroResult) {
    switch result {
    case .success:
        print("Operation completed successfully")
    case .failure(let error):
        print("Error: \(error.errorDetail)")
    case .closed(let code, let message):
        print("User closed the SDK: \(code) — \(message)")
        dismiss()
    case .event(let event):
        print("Event: \(event.eventName) - \(event.eventCategory)")
        // Send to your analytics platform
    }
}
```

### Close payload

The associated values of `.closed` describe why the SDK closed:

- `code: String` — a short machine-readable identifier in `UPPER_SNAKE_CASE`. All codes follow the `CLOSED_BY_*` convention (e.g. `CLOSED_BY_USER_HEADER_BUTTON`, `CLOSED_BY_HOST_APP`) and describe who or what triggered the close. Branch on this value when you need different behavior per close source.
- `message: String` — a human-readable description, useful for logging.

Both are plain strings. There is no enum or whitelist on the integrator side; the SDK fixes the values it emits and may introduce additional `code` values for in-SDK close paths in future releases without breaking the API. Treat any unrecognized `code` as a generic close.

| code | source | typical message |
|---|---|---|
| `CLOSED_BY_USER_HEADER_BUTTON` | The built-in header close button | `User tapped the close button` |
| `CLOSED_BY_HOST_APP` | `AstroConnectController.close()` | `Closed by host integrator` |
| `CLOSED_BY_SYSTEM_DISMISS` | View was dismissed without an explicit close call (back-swipe, sheet drag, host removal) | `View was dismissed` |
| `UNKNOWN` | Fallback when the close payload is missing or malformed | `` (empty string) |
| `CLOSED_BY_USER_NAVIGATED_BACK` | User backed out at the root of a flow sub-tree | descriptive (e.g., `User backed out of activities`) |
| `CLOSED_BY_USER_DISMISSED_ERROR` | User dismissed a terminal-error screen | descriptive (e.g., `User dismissed biometric error`) |
| `CLOSED_BY_USER_CANCELLED_PIN` | User cancelled the PIN re-prompt | `User cancelled PIN re-prompt` |
| `CLOSED_BY_USER_SIGNED_OUT` | User signed out from inside the SDK | `User signed out` |

The `CLOSED_BY_USER_NAVIGATED_BACK`, `CLOSED_BY_USER_DISMISSED_ERROR`, `CLOSED_BY_USER_CANCELLED_PIN`, and `CLOSED_BY_USER_SIGNED_OUT` entries above are common examples — the list of in-SDK codes is not exhaustive.


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

| Property          | Type                  | Description                                                                                                            |
|-------------------|-----------------------|------------------------------------------------------------------------------------------------------------------------|
| `backgroundColor` | `UIColor?`            | Main background color (e.g., `.white`). Also cascades to `surface.base` when not overridden.                          |
| `primaryColor`    | `UIColor?`            | Primary brand color. Cascades to `surface.highlight`, `text.highlight`, and `border.highlight` when those tokens are not overridden. |
| `surface`         | `AstroSurfaceColors?` | Background fills for containers, cards, banners and overlays. See [Style Tokens Reference](STYLE-TOKENS.md#astrosurfacecolors).           |
| `text`            | `AstroTextColors?`    | Foreground colors for typography. See [Style Tokens Reference](STYLE-TOKENS.md#astrotextcolors).                                       |
| `border`          | `AstroBorderColors?`  | Stroke colors for outlines, dividers, and separators. See [Style Tokens Reference](STYLE-TOKENS.md#astrobordercolors).                   |
| `typography`      | `AstroTypography?`          | Global typography settings — single field `fontFamily: String?` used as the default font family across the SDK. See [Style Tokens Reference](STYLE-TOKENS.md#astrotypography). |
| `buttons`         | `AstroButtonStyle?`         | Wrapper around `AstroButtonColors` (12 variants × 11 props) and optional `AstroButtonTypography`. See [Style Tokens Reference](STYLE-TOKENS.md#astrobuttonstyle). |
| `buttonsIcon`     | `AstroButtonIconStyle?`     | Wrapper around `AstroButtonIconColors` (same 12 variants, icon-specific) and optional `AstroButtonIconTypography`. See [Style Tokens Reference](STYLE-TOKENS.md#astrobuttoniconstyle). |
| `buttonsPill`     | `AstroButtonPillStyle?`     | Wrapper around `AstroButtonPillColors` (14 statuses) and optional `AstroButtonPillTypography`. See [Style Tokens Reference](STYLE-TOKENS.md#astrobuttonpillstyle). |
| `inputs`          | `AstroInputStyle?`          | Wrapper around `AstroInputColors` and optional `AstroInputTypography` (input / label / helper / placeholder). See [Style Tokens Reference](STYLE-TOKENS.md#astroinputstyle). |
| `header`          | `AstroHeaderStyle?`   | Header style settings                                                                                                  |

> All color values are `UIColor?` — construct them with `UIColor(red:green:blue:alpha:)`, a UIKit named color like `UIColor.systemBlue`, or `UIColor(named:)` for an asset-catalog entry. Alpha is honored: a `UIColor` with `alpha < 1.0` is delivered to the SDK and rendered with transparency. See the [Style Tokens Reference — Color values](STYLE-TOKENS.md#color-values) for details.

### AstroHeaderStyle

| Property            | Type       | Default     | Description                                                          |
|---------------------|------------|-------------|----------------------------------------------------------------------|
| `backgroundColor`   | `UIColor?` | Theme-based | Header background color                                              |
| `borderColor`       | `UIColor?` | Theme-based | Header bottom border color                                           |
| `borderWidth`       | `CGFloat?` | `0`         | Header bottom border width in points. Set to `0` to hide the border  |
| `paddingHorizontal` | `CGFloat?` | `24`        | Horizontal padding inside the header                                 |
| `paddingVertical`   | `CGFloat?` | `16`        | Vertical padding inside the header                                   |

### Example

```swift
let style = AstroStyle(
    backgroundColor: .white,
    primaryColor: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),
    buttons: AstroButtonStyle(
        colors: AstroButtonColors(
            primaryBackground: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),
            primaryText: .black
        )
    ),
    surface: AstroSurfaceColors(
        // 50%-opacity black scrim — alpha is honored end-to-end.
        overlay: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    ),
    header: AstroHeaderStyle(
        backgroundColor: UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1),
        borderColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
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
>     backgroundColor: isDark ? UIColor(red: 0.016, green: 0.075, blue: 0.067, alpha: 1) : .white,
>     header: AstroHeaderStyle(
>         backgroundColor: isDark ? UIColor(red: 0.024, green: 0.118, blue: 0.114, alpha: 1)
>                                 : UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1)
>     )
> )
> ```

### Hex-string escape hatch via `styleOverrides`

For partners who need to pass colors as hex strings — for example, theme values fetched from a remote configuration service, or tokens not yet exposed by the typed `AstroStyle` catalog — use `AstroConfiguration.styleOverrides`. Its color leaves accept both hex strings (`"#RRGGBB"` / `"#RRGGBBAA"`) and native `UIColor` values interchangeably. See [Free-form overrides via `styleOverrides`](STYLE-TOKENS.md#free-form-overrides-via-styleoverrides) for the full contract.

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    styleOverrides: [
        "backgroundColor": "#FFFFFF",
        "primaryColor": "#00DBBF"
    ]
)
```

> **Native KYC:** The native identity verification flow (available with the **`AstroConnectSDKNativeKYC`** product) also honors your `AstroConfiguration`. Your `style` / `styleOverrides` colors theme its screens — background, primary/brand color, on-screen text, and borders all follow your configured palette — and `theme` (`.light` / `.dark` / `.system`) sets light or dark mode. The native KYC screens render in the **device language**, not the SDK's `language` config — unlike the web flow, where `language` applies. An integration that sets no colors is unchanged.

## Co-Branded Header Logo

When `showHeaderLogo` is `true` (the default), the SDK header displays a co-branded logo for the issuer. The logo is fetched automatically based on the `appIssuer` value and the current theme.

- The SDK looks for a logo at: `{baseUrl}/{appIssuer}_{theme}.webp`
- If the issuer logo is not found, it falls back to the default AstroPay logo
- Set `showHeaderLogo: false` to hide the logo entirely

## Custom Header

If you set `showHeader: false` and render your own header (for example, a custom close button or a navigation bar), use `AstroConnectController` to dismiss the SDK from your own UI. Calling `controller.close()` funnels into the same close path as the built-in header button and emits `AstroResult.closed` exactly once.

```swift
import SwiftUI
import AstroConnectSDK

struct CustomHeaderScreen: View {
    @State private var showSDK = false
    @State private var controller = AstroConnectController()

    let configuration = AstroConfiguration(
        environment: "sandbox",
        appIssuer: "your-app-issuer",
        clientId: "your-client-id",
        partnerUserId: "your-partner-user-id",
        accessToken: "your-access-token",
        showHeader: false
    )

    var body: some View {
        Button("Open AstroPay") { showSDK = true }
            .fullScreenCover(isPresented: $showSDK) {
                VStack(spacing: 0) {
                    // Your custom header
                    HStack {
                        Text("My App")
                            .font(.headline)
                        Spacer()
                        Button("Close") {
                            controller.close()
                        }
                    }
                    .padding()

                    AstroConnectView(
                        configuration: configuration,
                        controller: controller,
                        onResult: handleResult
                    )
                }
            }
    }

    private func handleResult(_ result: AstroResult) {
        switch result {
        case .closed(let code, let message):
            print("Closed: \(code) — \(message)")
            showSDK = false
        default:
            break
        }
    }
}
```

> `controller.close()` is idempotent — subsequent calls after the SDK has already closed are no-ops. The same applies if the SDK closes itself first (for example, when the user completes the flow): a later `controller.close()` will not re-fire `AstroResult.closed`. See [Close payload](#close-payload) for the list of `code` values the SDK emits with `.closed`.

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
- [Style Tokens Reference](STYLE-TOKENS.md) — Full catalog of design tokens accepted by `AstroStyle` (surface, text, border, buttons), plus cascade rules.
- [Migration Guides](migrations/) — Step-by-step guides for upgrading between versions that include breaking changes.

## Support

For technical support, contact the AstroPay integrations team.
