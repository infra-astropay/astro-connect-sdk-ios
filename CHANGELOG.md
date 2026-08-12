# Changelog

All notable changes to the AstroConnectSDK for iOS will be documented in this file.

---

## [1.0.16]

### Added

- **QR Scanner**: the SDK now presents its own built-in QR scanner when the user taps "Scan QR Code" in the PIX Send Money flow. No configuration is required from the host app. The `NSCameraUsageDescription` key must be present in your `Info.plist` (already required for identity verification).
- **External banner links**: a home banner can now send the user outside the SDK — to a website or to a screen in your own app — by setting `bannerLinkTarget` to `"external"`. Purely additive: existing banner payloads keep their current behavior. See [Banner Link Target](README.md#banner-link-target) in the README.
- **Dismissible header banners**: a `home-header` banner can now show a close button while still being tappable, by setting `bannerDismissible` to `true`. Previously a banner could be either dismissible or tappable, not both. Purely additive: existing banner payloads keep their current behavior. See [Dismissing a header banner](README.md#dismissing-a-header-banner) in the README.
- **Avatar colors**: `AstroStyle` now exposes an `avatar` slot for theming user avatars and avatar groups. Purely additive — existing configurations are unaffected. See [Style Tokens Reference](STYLE-TOKENS.md#astroavatarcolors).
- **Back button colors**: `AstroStyle.buttonsIcon` now exposes two icon-only back-button variants (`backDefault*` and `backTransparent*`, 22 tokens) so the back button can be themed independently from the gray and transparent icon buttons. Purely additive and color-neutral on upgrade — until you set them, the back button keeps exactly the colors it has today. See [Style Tokens Reference](STYLE-TOKENS.md#astrobuttoniconstyle).

---

## [1.0.15]

### Added

- **Native KYC** (`AstroConnectSDKNativeKYC` product): the SDK now runs the identity verification flow natively on the device when the server enables it, instead of falling back to an in-app browser session. Native KYC ships in the new `AstroConnectSDKNativeKYC` product; the core `AstroConnectSDK` product is unchanged for everyone else and includes no identity-verification dependency. The native flow honors your configured `style` / `styleOverrides`, `theme`, and `language`. Choose the product that matches your flows — see [Installation](README.md#installation).
- **`Info.plist` keys for native KYC** (only when using `AstroConnectSDKNativeKYC`): add `NSMicrophoneUsageDescription`, `NSPhotoLibraryUsageDescription`, and `NSPhotoLibraryAddUsageDescription` to your app's `Info.plist`. See [Required Permissions](README.md#native-kyc--additional-plist-keys) for the full entries.
- **Native KYC progress events**: the native identity verification flow now reports its progress on the SDK's event callback (`AstroConnect.onEvent` / `AstroResult.event`), emitting a loading event when the flow starts and further events when a document result and a liveness result are produced. Purely additive — no action required.

---

## [1.0.14]

> **Breaking change:** The color fields on the typed `AstroStyle` API changed from hex `String?` to `UIColor?`. This affects `AstroStyle.backgroundColor`, `AstroHeaderStyle.backgroundColor`, and `AstroHeaderStyle.borderColor`. Code that passes a hex string (e.g. `AstroStyle(backgroundColor: "#FFFFFF")`) will no longer compile — pass a `UIColor` instead, or move the hex value into the `styleOverrides` dictionary. See the [Migration Guide](migrations/v1.0.13-to-v1.0.14.md) for details.

### Added

- **Style customization**: `AstroStyle` now lets you override colors and typography across the SDK, including brand colors, surface/text/border tokens, per-component wrappers (`buttons`, `buttonsIcon`, `buttonsPill`, `inputs`), and a global font family. See [Style Customization](README.md#style-customization) and the [Style Tokens Reference](STYLE-TOKENS.md) for the full catalog.
  - Color leaves in `styleOverrides` accept both hex strings (6- or 8-digit `#RRGGBB` / `#RRGGBBAA`) and `UIColor` values.
  - Brand colors and the typed `surface.base` / `surface.highlight` sub-tokens apply throughout the SDK, including the initial loading screen and spinner. See [Brand color aliases](STYLE-TOKENS.md#brand-color-aliases-apply-throughout-the-sdk).
  - Invalid color hex in `styleOverrides` is rejected at `AstroConfiguration.validate()` time.

---

## [1.0.13]

> **Breaking change:** `AstroResult.closed` now carries `(code: String, message: String)` associated values describing why the SDK closed. Existing `switch` statements on `AstroResult` must update the `.closed` arm. See the [Migration Guide](migrations/v1.0.12-to-v1.0.13.md) for details.

> **Breaking change:** The previously deprecated `AstroConfiguration` parameters `showCloseButton` and `autoSize` have been removed. Code that still passes either label will fail to compile. Use `showHeader` instead. See the [Migration Guide](migrations/v1.0.12-to-v1.0.13.md) for details.

### Added

- **Custom header support**: new `AstroConnectController` with a public `close()` method for integrators who set `showHeader: false` and render their own header. Pass the controller into `AstroConnectView(configuration:controller:onResult:)` and call `controller.close()` from your custom close button to dismiss the SDK. See [Custom Header](README.md#custom-header) in the README.
- **Close payload**: `AstroResult.closed` now delivers a `(code: String, message: String)` pair. `code` is a short machine-readable identifier (UPPER_SNAKE_CASE) and `message` is a human-readable description. Lets you distinguish whether the SDK was closed by the built-in header button (`CLOSED_BY_USER_HEADER_BUTTON`), by your own `controller.close()` call (`CLOSED_BY_HOST_APP`), by the view being removed from the view tree without an explicit close call (`CLOSED_BY_SYSTEM_DISMISS` — back-swipe in a `NavigationStack`, sheet drag-down, or host removal), or by a flow-specific path inside the SDK (for example `CLOSED_BY_USER_NAVIGATED_BACK`, `CLOSED_BY_USER_SIGNED_OUT`, `CLOSED_BY_USER_CANCELLED_PIN`, `CLOSED_BY_USER_DISMISSED_ERROR`). `AstroConnect.onClose` receives the same pair. See [Close payload](README.md#close-payload) in the README.
- Added support for `flowParams.topup.suggestedAmountsByCurrency` — a per-currency preset map. Overrides `suggestedAmounts` when present. No SDK changes required; just add the key to your dictionary.

### Changed

- **Topup parameters**: `amount` and `suggestedAmounts` now apply whenever the user lands on the topup amount screen, regardless of the active flow. Both now require `currency` to be provided in `flowParams` and to match the screen currency; otherwise they are ignored. See [Topup Parameters](README.md#topup-parameters) in the README.
- **Banners are cross-cutting**: clarified that `flowParams.banners` may be passed regardless of the active flow. The `bannerType` value identifies where the banner is rendered; it is not tied to a specific flow.
- **Topup parameter namespacing**: `flowParams.topup.{amount, currency, suggestedAmounts}` is the new recommended nested shape. `flowParams.topup` may be sent regardless of which `flow` is initialized.

### Fixed

- Fixed the topup amount being lost when navigating back from the amount screen and re-selecting a payment method.

### Removed

- `AstroConfiguration.showCloseButton` and `AstroConfiguration.autoSize` (deprecated since v1.0.10). Use `showHeader` to control header visibility.

### Deprecated

- Flat topup keys `amount`, `currency`, and `suggestedAmounts` placed directly under `flowParams` — use the nested `flowParams.topup` shape instead. The flat keys are still accepted silently for backward compatibility and will be removed in a future major version.

---

## [1.0.12]

### Added

- **Pre-load terminal callback**: new `AstroConnect.preload(configuration:onPreloadEnded:)` overload that reports `.loaded`, `.deferred`, or `.failed(error)`.
- `AstroConnect.preload` now has a load timeout — the callback fires with `.failed` instead of hanging if the page never reaches a terminal state.
- **Home Banners documentation**: documented how to render `home-page` and `home-header` promotional banners via `flowParams.banners`. See [Home Banners](README.md#home-banners) in the README.
- **Topup flow parameters documentation**: documented `amount`, `currency`, and `suggestedAmounts` for the topup flow. See [Topup Flow Parameters](README.md#topup-flow-parameters) in the README.

### Fixed

- Fixed an unexpected biometric prompt that could appear before the SDK was visible when calling `AstroConnect.preload`. The prompt is now deferred until `AstroConnectView` is presented.

### Deprecated

- `AstroConnect.preload(configuration:onSuccess:onError:)` — use the new `onPreloadEnded` overload. The old callbacks still work. See the [Migration Guide](migrations/v1.0.11-to-v1.0.12.md).

---

## [1.0.11]

### Added

- **Pre-warming**: new `AstroConnect.preWarm` to initialize the SDK in the background early in the app lifecycle, reducing first-open latency. Optional `appIssuer` parameter prepares the co-branded header logo in advance.
- **Pre-loading**: new `AstroConnect.preload` to load the SDK with a specific configuration before presenting it, so `AstroConnectView` opens with no loading screen.
- **Clear**: new `AstroConnect.clear` to reset SDK data (cookies, local storage, caches) for a given environment. Also discards any active pre-load.

---

## [1.0.10]

### Added

- Added co-branded issuer logo in the SDK header. Controlled via `showHeaderLogo` in `AstroConfiguration`.

---

## [1.0.9]

### Added

- Added `biometricGracePeriod` parameter to control how long biometric re-prompting is suppressed after a successful authentication.
- Added biometric hardware availability check before registration.

---

## [1.0.8]

> **Breaking change:** `clientId` and `partnerUserId` are now required parameters in `AstroConfiguration`. See the [Migration Guide](migrations/v1.0.7-to-v1.0.10.md) for details.

### Added

- Added phone sign-in support.
- Added biometric authentication (2FA). Requires `NSFaceIDUsageDescription` in `Info.plist` for Face ID.

---

## [1.0.7]

### Changed

- Redesigned KYC and address onboarding screens.

---

## [1.0.6]

### Changed

- Updated minimum iOS deployment target to **iOS 15.0**.

---

## [1.0.5]

### Added

- Added external URL support (opens in Safari or default browser).
- Added analytics event emission during user flows, accessible via `.event(AstroEvent)`.

---

## [1.0.4]

### Added

- Access token is now included in the URL builder.

---

## [1.0.3]

### Added

- Added close button to the SDK header.

---

## [1.0.2]

### Added

- Added support for `.event(AstroEvent)` callbacks during user flows.
- Initial iOS SDK release.
