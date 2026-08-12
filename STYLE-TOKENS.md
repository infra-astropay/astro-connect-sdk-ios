# Style Tokens Reference - iOS

This document describes the full catalog of design tokens accepted by [`AstroStyle`](README.md#style-customization) and how brand-level overrides cascade to individual tokens.

## Overview

`AstroStyle` exposes the following slots:

| Slot              | Type                   | Purpose                                                                                                                            |
|-------------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| `backgroundColor` | `UIColor?`             | Main background color. Also drives the initial loading screen and cascades to `surface.base` when unset.                           |
| `primaryColor`    | `UIColor?`             | Primary brand color. Cascades to the three highlight tokens (`surface.highlight`, `text.highlight`, `border.highlight`) when those are unset (see [Cascade rules](#cascade-rules)). |
| `surface`         | `AstroSurfaceColors?`  | Background fills for containers, cards, banners and overlays.                                                                      |
| `text`            | `AstroTextColors?`     | Foreground colors for typography.                                                                                                  |
| `border`          | `AstroBorderColors?`   | Stroke colors for outlines, dividers, and separators.                                                                              |
| `typography`      | `AstroTypography?`     | Global typography settings. Exposes a single field, `fontFamily: String?`, used as the default font family across the SDK.   |
| `buttons`         | `AstroButtonStyle?`    | Wrapper around `AstroButtonColors` (12 variants × 11 props) and an optional `AstroButtonTypography` slot.                          |
| `buttonsIcon`     | `AstroButtonIconStyle?` | Wrapper around `AstroButtonIconColors` (14 variants, icon-specific props — the 12 button variants plus two icon-only back-button variants) and an optional `AstroButtonIconTypography` slot.   |
| `buttonsPill`     | `AstroButtonPillStyle?` | Wrapper around `AstroButtonPillColors` (14 status pills × 5 props) and an optional `AstroButtonPillTypography` slot.               |
| `inputs`          | `AstroInputStyle?`     | Wrapper around `AstroInputColors` (text inputs, dropdown, phone-country dropdown) and an optional `AstroInputTypography` slot.     |
| `avatar`          | `AstroAvatarColors?`   | Colors for user avatars and avatar groups — fill, border, initials, icon, focus outline, the ring between grouped avatars, and the loading placeholder. |
| `header`          | `AstroHeaderStyle?`    | Typed header layout and colors (see [README](README.md#astroheaderstyle)).                                                         |

All color values are `UIColor?` — see [Color values](#color-values) below for the accepted construction forms and alpha support. Per-component typography values are plain numbers (see [`AstroFontStyle`](#astrofontstyle) for accepted formats).

## Cascade rules

The brand-level fields (`backgroundColor`, `primaryColor`) propagate to related tokens **only when those tokens are not set explicitly**. Explicit values always win. Typography does not cascade — each per-component slot is applied only where it is set.

| Brand field       | Cascades to (when token unset)                                                                  |
|-------------------|-------------------------------------------------------------------------------------------------|
| `backgroundColor` | `surface.base`                                                                                  |
| `primaryColor`    | `surface.highlight`, `text.highlight`, `border.highlight`                                       |

The same cascade applies to the free-form dictionary — see [Brand cascade in `styleOverrides`](#brand-cascade-in-styleoverrides).

Example: setting `backgroundColor: UIColor(red: 0.016, green: 0.075, blue: 0.067, alpha: 1)` and leaving `surface.base` unset is equivalent to setting `surface.base` to the same `UIColor`. Setting both explicitly uses the value passed to `surface.base` — the cascade is evaluated per field, so the other fields of `surface` are unaffected by that choice.

```swift
// .white wins for surface.base. The cascade is per field: surface.highlight,
// text.highlight and border.highlight are unset, so all three take primaryColor.
let style = AstroStyle(
    backgroundColor: UIColor(red: 0.016, green: 0.075, blue: 0.067, alpha: 1),
    primaryColor: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),
    surface: AstroSurfaceColors(base: .white)
)
```

## Color values

Every color field on the typed `AstroStyle` surface is a `UIColor?` — the same color representation used across UIKit. Any of the following construction forms work:

```swift
// 1. UIKit system / named colors
let brand  = UIColor.systemBlue
let red    = UIColor.red

// 2. Component-based constructor (sRGB)
let brand2 = UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)

// 3. Asset catalog color
let brand3 = UIColor(named: "BrandPrimary")
```

Alpha is honored. `UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)` (50%-opacity blue) round-trips on the wire as `#0000FF80` — fully opaque colors keep emitting 6-digit `#RRGGBB`, partially transparent colors emit 8-digit `#RRGGBBAA`.

> The typed `AstroStyle` API exposes color fields as `UIColor`. The escape-hatch `styleOverrides` dictionary still uses hex strings (`"#RRGGBB"` or `"#RRGGBBAA"`) because it is a free-form passthrough — see [Free-form overrides via `styleOverrides`](#free-form-overrides-via-styleoverrides).

## Token reference

### `AstroSurfaceColors`

Background fills for containers, cards, banners and overlays. Most tokens come in three variants: the base color, a `Hover` variant for pointer hover/press, and an `Active` variant for the pressed state. Some semantic tokens also expose a lighter `Light` variant.

Every field below is an optional `UIColor?` — see [Color values](#color-values).

| Field                  | Description                          |
|------------------------|--------------------------------------|
| `base`                 | App background                       |
| `baseHover`            | Base / hover                         |
| `baseActive`           | Base / pressed                       |
| `secondary`            | Secondary container                  |
| `secondaryHover`       | Secondary / hover                    |
| `secondaryActive`      | Secondary / pressed                  |
| `terciary`             | Tertiary container                   |
| `terciaryHover`        | Tertiary / hover                     |
| `terciaryActive`       | Tertiary / pressed                   |
| `muted`                | Muted/neutral container              |
| `mutedHover`           | Muted / hover                        |
| `mutedActive`          | Muted / pressed                      |
| `contrast`             | High-contrast container              |
| `contrastHover`        | Contrast / hover                     |
| `contrastActive`       | Contrast / pressed                   |
| `invert`               | Inverted-theme container             |
| `invertHover`          | Invert / hover                       |
| `invertActive`         | Invert / pressed                     |
| `white`                | Fixed-white container                |
| `whiteHover`           | White / hover                        |
| `whiteActive`          | White / pressed                      |
| `highlight`            | Brand highlight (filled accent)      |
| `highlightHover`       | Highlight / hover                    |
| `highlightActive`      | Highlight / pressed                  |
| `highlightMuted`       | Subdued brand highlight              |
| `highlightMutedHover`  | Highlight muted / hover              |
| `highlightMutedActive` | Highlight muted / pressed            |
| `error`                | Error/destructive container          |
| `errorHover`           | Error / hover                        |
| `errorActive`          | Error / pressed                      |
| `errorMuted`           | Subdued error container              |
| `errorMutedHover`      | Error muted / hover                  |
| `errorMutedActive`     | Error muted / pressed                |
| `errorLight`           | Lightest error tone (info banner)    |
| `warning`              | Warning container                    |
| `warningHover`         | Warning / hover                      |
| `warningActive`        | Warning / pressed                    |
| `warningMuted`         | Subdued warning container            |
| `warningMutedHover`    | Warning muted / hover                |
| `warningMutedActive`   | Warning muted / pressed              |
| `warningLight`         | Lightest warning tone                |
| `success`              | Success container                    |
| `successHover`         | Success / hover                      |
| `successActive`        | Success / pressed                    |
| `successMuted`         | Subdued success container            |
| `successMutedHover`    | Success muted / hover                |
| `successMutedActive`   | Success muted / pressed              |
| `successLight`         | Lightest success tone                |
| `accent`               | Secondary accent container           |
| `accentHover`          | Accent / hover                       |
| `accentActive`         | Accent / pressed                     |
| `accentMuted`          | Subdued accent container             |
| `accentMutedHover`     | Accent muted / hover                 |
| `accentMutedActive`    | Accent muted / pressed               |
| `accentLight`          | Lightest accent tone                 |
| `lime`                 | Lime decorative tone                 |
| `limeMuted`            | Subdued lime tone                    |
| `overlay`              | Modal/scrim overlay                  |
| `black`                | Fixed-black container                |

### `AstroTextColors`

Foreground colors for typography. Every field below is an optional `UIColor?` — see [Color values](#color-values).

| Field            | Description                                |
|------------------|--------------------------------------------|
| `black`          | Fixed black                                |
| `white`          | Fixed white                                |
| `base`           | Default body text                          |
| `muted`          | De-emphasized body text                    |
| `mutedSecondary` | Secondary de-emphasized text               |
| `faint`          | Faintest text (placeholders, hints)        |
| `invert`         | Text on inverted-theme surfaces            |
| `highlight`      | Brand-colored text (links, accents)        |
| `error`          | Error / destructive text                   |
| `accent`         | Secondary accent text                      |
| `warning`        | Warning text                               |
| `success`        | Success text                               |

### `AstroBorderColors`

Stroke colors for outlines, dividers, and separators. Every field below is an optional `UIColor?` — see [Color values](#color-values).

| Field       | Description                       |
|-------------|-----------------------------------|
| `base`      | Default container border          |
| `faint`     | Subtle dividers                   |
| `muted`     | Muted dividers                    |
| `highlight` | Brand-colored border              |
| `error`     | Error border                      |
| `accent`    | Accent border                     |
| `warning`   | Warning border                    |
| `success`   | Success border                    |

### `AstroButtonStyle`

Wrapper for the `buttons` slot. Both fields optional.

| Field        | Type                       | Description                                                                |
|--------------|----------------------------|----------------------------------------------------------------------------|
| `colors`     | `AstroButtonColors?`       | 12 variants × 11 props = 132 tokens (see `colors:` table below).            |
| `typography` | `AstroButtonTypography?`   | Single `label` slot of type [`AstroFontStyle?`](#astrofontstyle) for visible button text. |

#### `colors:` → `AstroButtonColors`

Buttons expose **12 variants × 11 props = 132 tokens**, aligned with the design system. Variants: `primary`, `secondary`, `tertiary`, `gray`, `muted`, `transparent`, `transparentWhite`, `errorMuted`, `error`, `warningMuted`, `warning`, `white`. Each variant has the same set of state-driven props (background, text, loader, focus outline). Every field is an optional `UIColor?` — see [Color values](#color-values).

| Field | Type | Description |
|-------|------|-------------|
| `primaryBackground` | `UIColor?` | Primary button — default background |
| `primaryBackgroundHover` | `UIColor?` | Primary button — hover background |
| `primaryBackgroundFocus` | `UIColor?` | Primary button — focus background |
| `primaryBackgroundDisabled` | `UIColor?` | Primary button — disabled background |
| `primaryText` | `UIColor?` | Primary button — text |
| `primaryTextHover` | `UIColor?` | Primary button — hover text |
| `primaryTextFocus` | `UIColor?` | Primary button — focus text |
| `primaryTextDisabled` | `UIColor?` | Primary button — disabled text |
| `primaryLoaderColor` | `UIColor?` | Primary button — loader |
| `primaryLoaderColorDisabled` | `UIColor?` | Primary button — disabled loader |
| `primaryFocusOutlineColor` | `UIColor?` | Primary button — focus outline |
| `secondaryBackground` | `UIColor?` | Secondary button — default background |
| `secondaryBackgroundHover` | `UIColor?` | Secondary button — hover background |
| `secondaryBackgroundFocus` | `UIColor?` | Secondary button — focus background |
| `secondaryBackgroundDisabled` | `UIColor?` | Secondary button — disabled background |
| `secondaryText` | `UIColor?` | Secondary button — text |
| `secondaryTextHover` | `UIColor?` | Secondary button — hover text |
| `secondaryTextFocus` | `UIColor?` | Secondary button — focus text |
| `secondaryTextDisabled` | `UIColor?` | Secondary button — disabled text |
| `secondaryLoaderColor` | `UIColor?` | Secondary button — loader |
| `secondaryLoaderColorDisabled` | `UIColor?` | Secondary button — disabled loader |
| `secondaryFocusOutlineColor` | `UIColor?` | Secondary button — focus outline |
| `tertiaryBackground` | `UIColor?` | Tertiary button — default background |
| `tertiaryBackgroundHover` | `UIColor?` | Tertiary button — hover background |
| `tertiaryBackgroundFocus` | `UIColor?` | Tertiary button — focus background |
| `tertiaryBackgroundDisabled` | `UIColor?` | Tertiary button — disabled background |
| `tertiaryText` | `UIColor?` | Tertiary button — text |
| `tertiaryTextHover` | `UIColor?` | Tertiary button — hover text |
| `tertiaryTextFocus` | `UIColor?` | Tertiary button — focus text |
| `tertiaryTextDisabled` | `UIColor?` | Tertiary button — disabled text |
| `tertiaryLoaderColor` | `UIColor?` | Tertiary button — loader |
| `tertiaryLoaderColorDisabled` | `UIColor?` | Tertiary button — disabled loader |
| `tertiaryFocusOutlineColor` | `UIColor?` | Tertiary button — focus outline |
| `grayBackground` | `UIColor?` | Gray button — default background |
| `grayBackgroundHover` | `UIColor?` | Gray button — hover background |
| `grayBackgroundFocus` | `UIColor?` | Gray button — focus background |
| `grayBackgroundDisabled` | `UIColor?` | Gray button — disabled background |
| `grayText` | `UIColor?` | Gray button — text |
| `grayTextHover` | `UIColor?` | Gray button — hover text |
| `grayTextFocus` | `UIColor?` | Gray button — focus text |
| `grayTextDisabled` | `UIColor?` | Gray button — disabled text |
| `grayLoaderColor` | `UIColor?` | Gray button — loader |
| `grayLoaderColorDisabled` | `UIColor?` | Gray button — disabled loader |
| `grayFocusOutlineColor` | `UIColor?` | Gray button — focus outline |
| `mutedBackground` | `UIColor?` | Muted button — default background |
| `mutedBackgroundHover` | `UIColor?` | Muted button — hover background |
| `mutedBackgroundFocus` | `UIColor?` | Muted button — focus background |
| `mutedBackgroundDisabled` | `UIColor?` | Muted button — disabled background |
| `mutedText` | `UIColor?` | Muted button — text |
| `mutedTextHover` | `UIColor?` | Muted button — hover text |
| `mutedTextFocus` | `UIColor?` | Muted button — focus text |
| `mutedTextDisabled` | `UIColor?` | Muted button — disabled text |
| `mutedLoaderColor` | `UIColor?` | Muted button — loader |
| `mutedLoaderColorDisabled` | `UIColor?` | Muted button — disabled loader |
| `mutedFocusOutlineColor` | `UIColor?` | Muted button — focus outline |
| `transparentBackground` | `UIColor?` | Transparent button — default background |
| `transparentBackgroundHover` | `UIColor?` | Transparent button — hover background |
| `transparentBackgroundFocus` | `UIColor?` | Transparent button — focus background |
| `transparentBackgroundDisabled` | `UIColor?` | Transparent button — disabled background |
| `transparentText` | `UIColor?` | Transparent button — text |
| `transparentTextHover` | `UIColor?` | Transparent button — hover text |
| `transparentTextFocus` | `UIColor?` | Transparent button — focus text |
| `transparentTextDisabled` | `UIColor?` | Transparent button — disabled text |
| `transparentLoaderColor` | `UIColor?` | Transparent button — loader |
| `transparentLoaderColorDisabled` | `UIColor?` | Transparent button — disabled loader |
| `transparentFocusOutlineColor` | `UIColor?` | Transparent button — focus outline |
| `transparentWhiteBackground` | `UIColor?` | Transparent White button — default background |
| `transparentWhiteBackgroundHover` | `UIColor?` | Transparent White button — hover background |
| `transparentWhiteBackgroundFocus` | `UIColor?` | Transparent White button — focus background |
| `transparentWhiteBackgroundDisabled` | `UIColor?` | Transparent White button — disabled background |
| `transparentWhiteText` | `UIColor?` | Transparent White button — text |
| `transparentWhiteTextHover` | `UIColor?` | Transparent White button — hover text |
| `transparentWhiteTextFocus` | `UIColor?` | Transparent White button — focus text |
| `transparentWhiteTextDisabled` | `UIColor?` | Transparent White button — disabled text |
| `transparentWhiteLoaderColor` | `UIColor?` | Transparent White button — loader |
| `transparentWhiteLoaderColorDisabled` | `UIColor?` | Transparent White button — disabled loader |
| `transparentWhiteFocusOutlineColor` | `UIColor?` | Transparent White button — focus outline |
| `errorMutedBackground` | `UIColor?` | Error Muted button — default background |
| `errorMutedBackgroundHover` | `UIColor?` | Error Muted button — hover background |
| `errorMutedBackgroundFocus` | `UIColor?` | Error Muted button — focus background |
| `errorMutedBackgroundDisabled` | `UIColor?` | Error Muted button — disabled background |
| `errorMutedText` | `UIColor?` | Error Muted button — text |
| `errorMutedTextHover` | `UIColor?` | Error Muted button — hover text |
| `errorMutedTextFocus` | `UIColor?` | Error Muted button — focus text |
| `errorMutedTextDisabled` | `UIColor?` | Error Muted button — disabled text |
| `errorMutedLoaderColor` | `UIColor?` | Error Muted button — loader |
| `errorMutedLoaderColorDisabled` | `UIColor?` | Error Muted button — disabled loader |
| `errorMutedFocusOutlineColor` | `UIColor?` | Error Muted button — focus outline |
| `errorBackground` | `UIColor?` | Error button — default background |
| `errorBackgroundHover` | `UIColor?` | Error button — hover background |
| `errorBackgroundFocus` | `UIColor?` | Error button — focus background |
| `errorBackgroundDisabled` | `UIColor?` | Error button — disabled background |
| `errorText` | `UIColor?` | Error button — text |
| `errorTextHover` | `UIColor?` | Error button — hover text |
| `errorTextFocus` | `UIColor?` | Error button — focus text |
| `errorTextDisabled` | `UIColor?` | Error button — disabled text |
| `errorLoaderColor` | `UIColor?` | Error button — loader |
| `errorLoaderColorDisabled` | `UIColor?` | Error button — disabled loader |
| `errorFocusOutlineColor` | `UIColor?` | Error button — focus outline |
| `warningMutedBackground` | `UIColor?` | Warning Muted button — default background |
| `warningMutedBackgroundHover` | `UIColor?` | Warning Muted button — hover background |
| `warningMutedBackgroundFocus` | `UIColor?` | Warning Muted button — focus background |
| `warningMutedBackgroundDisabled` | `UIColor?` | Warning Muted button — disabled background |
| `warningMutedText` | `UIColor?` | Warning Muted button — text |
| `warningMutedTextHover` | `UIColor?` | Warning Muted button — hover text |
| `warningMutedTextFocus` | `UIColor?` | Warning Muted button — focus text |
| `warningMutedTextDisabled` | `UIColor?` | Warning Muted button — disabled text |
| `warningMutedLoaderColor` | `UIColor?` | Warning Muted button — loader |
| `warningMutedLoaderColorDisabled` | `UIColor?` | Warning Muted button — disabled loader |
| `warningMutedFocusOutlineColor` | `UIColor?` | Warning Muted button — focus outline |
| `warningBackground` | `UIColor?` | Warning button — default background |
| `warningBackgroundHover` | `UIColor?` | Warning button — hover background |
| `warningBackgroundFocus` | `UIColor?` | Warning button — focus background |
| `warningBackgroundDisabled` | `UIColor?` | Warning button — disabled background |
| `warningText` | `UIColor?` | Warning button — text |
| `warningTextHover` | `UIColor?` | Warning button — hover text |
| `warningTextFocus` | `UIColor?` | Warning button — focus text |
| `warningTextDisabled` | `UIColor?` | Warning button — disabled text |
| `warningLoaderColor` | `UIColor?` | Warning button — loader |
| `warningLoaderColorDisabled` | `UIColor?` | Warning button — disabled loader |
| `warningFocusOutlineColor` | `UIColor?` | Warning button — focus outline |
| `whiteBackground` | `UIColor?` | White button — default background |
| `whiteBackgroundHover` | `UIColor?` | White button — hover background |
| `whiteBackgroundFocus` | `UIColor?` | White button — focus background |
| `whiteBackgroundDisabled` | `UIColor?` | White button — disabled background |
| `whiteText` | `UIColor?` | White button — text |
| `whiteTextHover` | `UIColor?` | White button — hover text |
| `whiteTextFocus` | `UIColor?` | White button — focus text |
| `whiteTextDisabled` | `UIColor?` | White button — disabled text |
| `whiteLoaderColor` | `UIColor?` | White button — loader |
| `whiteLoaderColorDisabled` | `UIColor?` | White button — disabled loader |
| `whiteFocusOutlineColor` | `UIColor?` | White button — focus outline |

### `AstroButtonIconStyle`

Wrapper for the `buttonsIcon` slot. Both fields optional.

| Field        | Type                          | Description                                                                |
|--------------|-------------------------------|----------------------------------------------------------------------------|
| `colors`     | `AstroButtonIconColors?`      | 154 tokens (see `colors:` table below).                                     |
| `typography` | `AstroButtonIconTypography?`  | Single `label` slot of type [`AstroFontStyle?`](#astrofontstyle) for the text variant of icon-with-text buttons. |

#### `colors:` → `AstroButtonIconColors`

Icon buttons mirror the 12 button variants and add two back-button variants of their own, each with an icon-specific prop set (icon color, text, loader, focus outline). 14 variants × 11 props = 154 tokens total. The `backDefault*` and `backTransparent*` variants are icon-only — they style the back affordance and have no counterpart in `AstroButtonColors`. Every field is an optional `UIColor?` — see [Color values](#color-values).

| Field | Type | Description |
|-------|------|-------------|
| `primaryBackground` | `UIColor?` | Primary icon button — default background |
| `primaryBackgroundHover` | `UIColor?` | Primary icon button — hover background |
| `primaryBackgroundFocus` | `UIColor?` | Primary icon button — focus background |
| `primaryBackgroundDisabled` | `UIColor?` | Primary icon button — disabled background |
| `primaryIconColor` | `UIColor?` | Primary icon button — icon |
| `primaryIconColorDisabled` | `UIColor?` | Primary icon button — disabled icon |
| `primaryText` | `UIColor?` | Primary icon button — text |
| `primaryTextDisabled` | `UIColor?` | Primary icon button — disabled text |
| `primaryLoaderColor` | `UIColor?` | Primary icon button — loader |
| `primaryLoaderColorDisabled` | `UIColor?` | Primary icon button — disabled loader |
| `primaryFocusOutlineColor` | `UIColor?` | Primary icon button — focus outline |
| `secondaryBackground` | `UIColor?` | Secondary icon button — default background |
| `secondaryBackgroundHover` | `UIColor?` | Secondary icon button — hover background |
| `secondaryBackgroundFocus` | `UIColor?` | Secondary icon button — focus background |
| `secondaryBackgroundDisabled` | `UIColor?` | Secondary icon button — disabled background |
| `secondaryIconColor` | `UIColor?` | Secondary icon button — icon |
| `secondaryIconColorDisabled` | `UIColor?` | Secondary icon button — disabled icon |
| `secondaryText` | `UIColor?` | Secondary icon button — text |
| `secondaryTextDisabled` | `UIColor?` | Secondary icon button — disabled text |
| `secondaryLoaderColor` | `UIColor?` | Secondary icon button — loader |
| `secondaryLoaderColorDisabled` | `UIColor?` | Secondary icon button — disabled loader |
| `secondaryFocusOutlineColor` | `UIColor?` | Secondary icon button — focus outline |
| `tertiaryBackground` | `UIColor?` | Tertiary icon button — default background |
| `tertiaryBackgroundHover` | `UIColor?` | Tertiary icon button — hover background |
| `tertiaryBackgroundFocus` | `UIColor?` | Tertiary icon button — focus background |
| `tertiaryBackgroundDisabled` | `UIColor?` | Tertiary icon button — disabled background |
| `tertiaryIconColor` | `UIColor?` | Tertiary icon button — icon |
| `tertiaryIconColorDisabled` | `UIColor?` | Tertiary icon button — disabled icon |
| `tertiaryText` | `UIColor?` | Tertiary icon button — text |
| `tertiaryTextDisabled` | `UIColor?` | Tertiary icon button — disabled text |
| `tertiaryLoaderColor` | `UIColor?` | Tertiary icon button — loader |
| `tertiaryLoaderColorDisabled` | `UIColor?` | Tertiary icon button — disabled loader |
| `tertiaryFocusOutlineColor` | `UIColor?` | Tertiary icon button — focus outline |
| `grayBackground` | `UIColor?` | Gray icon button — default background |
| `grayBackgroundHover` | `UIColor?` | Gray icon button — hover background |
| `grayBackgroundFocus` | `UIColor?` | Gray icon button — focus background |
| `grayBackgroundDisabled` | `UIColor?` | Gray icon button — disabled background |
| `grayIconColor` | `UIColor?` | Gray icon button — icon |
| `grayIconColorDisabled` | `UIColor?` | Gray icon button — disabled icon |
| `grayText` | `UIColor?` | Gray icon button — text |
| `grayTextDisabled` | `UIColor?` | Gray icon button — disabled text |
| `grayLoaderColor` | `UIColor?` | Gray icon button — loader |
| `grayLoaderColorDisabled` | `UIColor?` | Gray icon button — disabled loader |
| `grayFocusOutlineColor` | `UIColor?` | Gray icon button — focus outline |
| `mutedBackground` | `UIColor?` | Muted icon button — default background |
| `mutedBackgroundHover` | `UIColor?` | Muted icon button — hover background |
| `mutedBackgroundFocus` | `UIColor?` | Muted icon button — focus background |
| `mutedBackgroundDisabled` | `UIColor?` | Muted icon button — disabled background |
| `mutedIconColor` | `UIColor?` | Muted icon button — icon |
| `mutedIconColorDisabled` | `UIColor?` | Muted icon button — disabled icon |
| `mutedText` | `UIColor?` | Muted icon button — text |
| `mutedTextDisabled` | `UIColor?` | Muted icon button — disabled text |
| `mutedLoaderColor` | `UIColor?` | Muted icon button — loader |
| `mutedLoaderColorDisabled` | `UIColor?` | Muted icon button — disabled loader |
| `mutedFocusOutlineColor` | `UIColor?` | Muted icon button — focus outline |
| `transparentBackground` | `UIColor?` | Transparent icon button — default background |
| `transparentBackgroundHover` | `UIColor?` | Transparent icon button — hover background |
| `transparentBackgroundFocus` | `UIColor?` | Transparent icon button — focus background |
| `transparentBackgroundDisabled` | `UIColor?` | Transparent icon button — disabled background |
| `transparentIconColor` | `UIColor?` | Transparent icon button — icon |
| `transparentIconColorDisabled` | `UIColor?` | Transparent icon button — disabled icon |
| `transparentText` | `UIColor?` | Transparent icon button — text |
| `transparentTextDisabled` | `UIColor?` | Transparent icon button — disabled text |
| `transparentLoaderColor` | `UIColor?` | Transparent icon button — loader |
| `transparentLoaderColorDisabled` | `UIColor?` | Transparent icon button — disabled loader |
| `transparentFocusOutlineColor` | `UIColor?` | Transparent icon button — focus outline |
| `transparentWhiteBackground` | `UIColor?` | Transparent White icon button — default background |
| `transparentWhiteBackgroundHover` | `UIColor?` | Transparent White icon button — hover background |
| `transparentWhiteBackgroundFocus` | `UIColor?` | Transparent White icon button — focus background |
| `transparentWhiteBackgroundDisabled` | `UIColor?` | Transparent White icon button — disabled background |
| `transparentWhiteIconColor` | `UIColor?` | Transparent White icon button — icon |
| `transparentWhiteIconColorDisabled` | `UIColor?` | Transparent White icon button — disabled icon |
| `transparentWhiteText` | `UIColor?` | Transparent White icon button — text |
| `transparentWhiteTextDisabled` | `UIColor?` | Transparent White icon button — disabled text |
| `transparentWhiteLoaderColor` | `UIColor?` | Transparent White icon button — loader |
| `transparentWhiteLoaderColorDisabled` | `UIColor?` | Transparent White icon button — disabled loader |
| `transparentWhiteFocusOutlineColor` | `UIColor?` | Transparent White icon button — focus outline |
| `errorMutedBackground` | `UIColor?` | Error Muted icon button — default background |
| `errorMutedBackgroundHover` | `UIColor?` | Error Muted icon button — hover background |
| `errorMutedBackgroundFocus` | `UIColor?` | Error Muted icon button — focus background |
| `errorMutedBackgroundDisabled` | `UIColor?` | Error Muted icon button — disabled background |
| `errorMutedIconColor` | `UIColor?` | Error Muted icon button — icon |
| `errorMutedIconColorDisabled` | `UIColor?` | Error Muted icon button — disabled icon |
| `errorMutedText` | `UIColor?` | Error Muted icon button — text |
| `errorMutedTextDisabled` | `UIColor?` | Error Muted icon button — disabled text |
| `errorMutedLoaderColor` | `UIColor?` | Error Muted icon button — loader |
| `errorMutedLoaderColorDisabled` | `UIColor?` | Error Muted icon button — disabled loader |
| `errorMutedFocusOutlineColor` | `UIColor?` | Error Muted icon button — focus outline |
| `errorBackground` | `UIColor?` | Error icon button — default background |
| `errorBackgroundHover` | `UIColor?` | Error icon button — hover background |
| `errorBackgroundFocus` | `UIColor?` | Error icon button — focus background |
| `errorBackgroundDisabled` | `UIColor?` | Error icon button — disabled background |
| `errorIconColor` | `UIColor?` | Error icon button — icon |
| `errorIconColorDisabled` | `UIColor?` | Error icon button — disabled icon |
| `errorText` | `UIColor?` | Error icon button — text |
| `errorTextDisabled` | `UIColor?` | Error icon button — disabled text |
| `errorLoaderColor` | `UIColor?` | Error icon button — loader |
| `errorLoaderColorDisabled` | `UIColor?` | Error icon button — disabled loader |
| `errorFocusOutlineColor` | `UIColor?` | Error icon button — focus outline |
| `warningMutedBackground` | `UIColor?` | Warning Muted icon button — default background |
| `warningMutedBackgroundHover` | `UIColor?` | Warning Muted icon button — hover background |
| `warningMutedBackgroundFocus` | `UIColor?` | Warning Muted icon button — focus background |
| `warningMutedBackgroundDisabled` | `UIColor?` | Warning Muted icon button — disabled background |
| `warningMutedIconColor` | `UIColor?` | Warning Muted icon button — icon |
| `warningMutedIconColorDisabled` | `UIColor?` | Warning Muted icon button — disabled icon |
| `warningMutedText` | `UIColor?` | Warning Muted icon button — text |
| `warningMutedTextDisabled` | `UIColor?` | Warning Muted icon button — disabled text |
| `warningMutedLoaderColor` | `UIColor?` | Warning Muted icon button — loader |
| `warningMutedLoaderColorDisabled` | `UIColor?` | Warning Muted icon button — disabled loader |
| `warningMutedFocusOutlineColor` | `UIColor?` | Warning Muted icon button — focus outline |
| `warningBackground` | `UIColor?` | Warning icon button — default background |
| `warningBackgroundHover` | `UIColor?` | Warning icon button — hover background |
| `warningBackgroundFocus` | `UIColor?` | Warning icon button — focus background |
| `warningBackgroundDisabled` | `UIColor?` | Warning icon button — disabled background |
| `warningIconColor` | `UIColor?` | Warning icon button — icon |
| `warningIconColorDisabled` | `UIColor?` | Warning icon button — disabled icon |
| `warningText` | `UIColor?` | Warning icon button — text |
| `warningTextDisabled` | `UIColor?` | Warning icon button — disabled text |
| `warningLoaderColor` | `UIColor?` | Warning icon button — loader |
| `warningLoaderColorDisabled` | `UIColor?` | Warning icon button — disabled loader |
| `warningFocusOutlineColor` | `UIColor?` | Warning icon button — focus outline |
| `whiteBackground` | `UIColor?` | White icon button — default background |
| `whiteBackgroundHover` | `UIColor?` | White icon button — hover background |
| `whiteBackgroundFocus` | `UIColor?` | White icon button — focus background |
| `whiteBackgroundDisabled` | `UIColor?` | White icon button — disabled background |
| `whiteIconColor` | `UIColor?` | White icon button — icon |
| `whiteIconColorDisabled` | `UIColor?` | White icon button — disabled icon |
| `whiteText` | `UIColor?` | White icon button — text |
| `whiteTextDisabled` | `UIColor?` | White icon button — disabled text |
| `whiteLoaderColor` | `UIColor?` | White icon button — loader |
| `whiteLoaderColorDisabled` | `UIColor?` | White icon button — disabled loader |
| `whiteFocusOutlineColor` | `UIColor?` | White icon button — focus outline |
| `backDefaultBackground` | `UIColor?` | Back button — default background |
| `backDefaultBackgroundHover` | `UIColor?` | Back button — hover background |
| `backDefaultBackgroundFocus` | `UIColor?` | Back button — focus background |
| `backDefaultBackgroundDisabled` | `UIColor?` | Back button — disabled background |
| `backDefaultIconColor` | `UIColor?` | Back button — icon |
| `backDefaultIconColorDisabled` | `UIColor?` | Back button — disabled icon |
| `backDefaultText` | `UIColor?` | Back button — text |
| `backDefaultTextDisabled` | `UIColor?` | Back button — disabled text |
| `backDefaultLoaderColor` | `UIColor?` | Back button — loader |
| `backDefaultLoaderColorDisabled` | `UIColor?` | Back button — disabled loader |
| `backDefaultFocusOutlineColor` | `UIColor?` | Back button — focus outline |
| `backTransparentBackground` | `UIColor?` | Back button (transparent) — default background |
| `backTransparentBackgroundHover` | `UIColor?` | Back button (transparent) — hover background |
| `backTransparentBackgroundFocus` | `UIColor?` | Back button (transparent) — focus background |
| `backTransparentBackgroundDisabled` | `UIColor?` | Back button (transparent) — disabled background |
| `backTransparentIconColor` | `UIColor?` | Back button (transparent) — icon |
| `backTransparentIconColorDisabled` | `UIColor?` | Back button (transparent) — disabled icon |
| `backTransparentText` | `UIColor?` | Back button (transparent) — text |
| `backTransparentTextDisabled` | `UIColor?` | Back button (transparent) — disabled text |
| `backTransparentLoaderColor` | `UIColor?` | Back button (transparent) — loader |
| `backTransparentLoaderColorDisabled` | `UIColor?` | Back button (transparent) — disabled loader |
| `backTransparentFocusOutlineColor` | `UIColor?` | Back button (transparent) — focus outline |

### `AstroButtonPillStyle`

Wrapper for the `buttonsPill` slot. Both fields optional.

| Field        | Type                          | Description                                                                |
|--------------|-------------------------------|----------------------------------------------------------------------------|
| `colors`     | `AstroButtonPillColors?`      | 70 tokens (see `colors:` table below).                                      |
| `typography` | `AstroButtonPillTypography?`  | Single `label` slot of type [`AstroFontStyle?`](#astrofontstyle) for pill text. |

#### `colors:` → `AstroButtonPillColors`

Pills cover 14 semantic statuses × 5 props (background, hover background, border, text, focus outline) = 70 tokens. Every field is an optional `UIColor?` — see [Color values](#color-values).

| Field | Type | Description |
|-------|------|-------------|
| `infoBackground` | `UIColor?` | Info pill — default background |
| `infoBackgroundHover` | `UIColor?` | Info pill — hover background |
| `infoBorder` | `UIColor?` | Info pill — border |
| `infoText` | `UIColor?` | Info pill — text |
| `infoFocusOutlineColor` | `UIColor?` | Info pill — focus outline |
| `infoAltBackground` | `UIColor?` | Info Alt pill — default background |
| `infoAltBackgroundHover` | `UIColor?` | Info Alt pill — hover background |
| `infoAltBorder` | `UIColor?` | Info Alt pill — border |
| `infoAltText` | `UIColor?` | Info Alt pill — text |
| `infoAltFocusOutlineColor` | `UIColor?` | Info Alt pill — focus outline |
| `successBackground` | `UIColor?` | Success pill — default background |
| `successBackgroundHover` | `UIColor?` | Success pill — hover background |
| `successBorder` | `UIColor?` | Success pill — border |
| `successText` | `UIColor?` | Success pill — text |
| `successFocusOutlineColor` | `UIColor?` | Success pill — focus outline |
| `successMutedBackground` | `UIColor?` | Success Muted pill — default background |
| `successMutedBackgroundHover` | `UIColor?` | Success Muted pill — hover background |
| `successMutedBorder` | `UIColor?` | Success Muted pill — border |
| `successMutedText` | `UIColor?` | Success Muted pill — text |
| `successMutedFocusOutlineColor` | `UIColor?` | Success Muted pill — focus outline |
| `errorBackground` | `UIColor?` | Error pill — default background |
| `errorBackgroundHover` | `UIColor?` | Error pill — hover background |
| `errorBorder` | `UIColor?` | Error pill — border |
| `errorText` | `UIColor?` | Error pill — text |
| `errorFocusOutlineColor` | `UIColor?` | Error pill — focus outline |
| `errorMutedBackground` | `UIColor?` | Error Muted pill — default background |
| `errorMutedBackgroundHover` | `UIColor?` | Error Muted pill — hover background |
| `errorMutedBorder` | `UIColor?` | Error Muted pill — border |
| `errorMutedText` | `UIColor?` | Error Muted pill — text |
| `errorMutedFocusOutlineColor` | `UIColor?` | Error Muted pill — focus outline |
| `warningBackground` | `UIColor?` | Warning pill — default background |
| `warningBackgroundHover` | `UIColor?` | Warning pill — hover background |
| `warningBorder` | `UIColor?` | Warning pill — border |
| `warningText` | `UIColor?` | Warning pill — text |
| `warningFocusOutlineColor` | `UIColor?` | Warning pill — focus outline |
| `warningMutedBackground` | `UIColor?` | Warning Muted pill — default background |
| `warningMutedBackgroundHover` | `UIColor?` | Warning Muted pill — hover background |
| `warningMutedBorder` | `UIColor?` | Warning Muted pill — border |
| `warningMutedText` | `UIColor?` | Warning Muted pill — text |
| `warningMutedFocusOutlineColor` | `UIColor?` | Warning Muted pill — focus outline |
| `neutralBackground` | `UIColor?` | Neutral pill — default background |
| `neutralBackgroundHover` | `UIColor?` | Neutral pill — hover background |
| `neutralBorder` | `UIColor?` | Neutral pill — border |
| `neutralText` | `UIColor?` | Neutral pill — text |
| `neutralFocusOutlineColor` | `UIColor?` | Neutral pill — focus outline |
| `neutralMutedBackground` | `UIColor?` | Neutral Muted pill — default background |
| `neutralMutedBackgroundHover` | `UIColor?` | Neutral Muted pill — hover background |
| `neutralMutedBorder` | `UIColor?` | Neutral Muted pill — border |
| `neutralMutedText` | `UIColor?` | Neutral Muted pill — text |
| `neutralMutedFocusOutlineColor` | `UIColor?` | Neutral Muted pill — focus outline |
| `pearlBackground` | `UIColor?` | Pearl pill — default background |
| `pearlBackgroundHover` | `UIColor?` | Pearl pill — hover background |
| `pearlBorder` | `UIColor?` | Pearl pill — border |
| `pearlText` | `UIColor?` | Pearl pill — text |
| `pearlFocusOutlineColor` | `UIColor?` | Pearl pill — focus outline |
| `pearlMutedBackground` | `UIColor?` | Pearl Muted pill — default background |
| `pearlMutedBackgroundHover` | `UIColor?` | Pearl Muted pill — hover background |
| `pearlMutedBorder` | `UIColor?` | Pearl Muted pill — border |
| `pearlMutedText` | `UIColor?` | Pearl Muted pill — text |
| `pearlMutedFocusOutlineColor` | `UIColor?` | Pearl Muted pill — focus outline |
| `highlightBackground` | `UIColor?` | Highlight pill — default background |
| `highlightBackgroundHover` | `UIColor?` | Highlight pill — hover background |
| `highlightBorder` | `UIColor?` | Highlight pill — border |
| `highlightText` | `UIColor?` | Highlight pill — text |
| `highlightFocusOutlineColor` | `UIColor?` | Highlight pill — focus outline |
| `highlightMutedBackground` | `UIColor?` | Highlight Muted pill — default background |
| `highlightMutedBackgroundHover` | `UIColor?` | Highlight Muted pill — hover background |
| `highlightMutedBorder` | `UIColor?` | Highlight Muted pill — border |
| `highlightMutedText` | `UIColor?` | Highlight Muted pill — text |
| `highlightMutedFocusOutlineColor` | `UIColor?` | Highlight Muted pill — focus outline |

### `AstroInputStyle`

Wrapper for the `inputs` slot. Both fields optional.

| Field        | Type                       | Description                                                                |
|--------------|----------------------------|----------------------------------------------------------------------------|
| `colors`     | `AstroInputColors?`        | 55 tokens (see `colors:` table below).                                      |
| `typography` | `AstroInputTypography?`    | Per-slot typography: `input` (typed value), `label` (floating/static label), `helper` (helper / error / success message), `placeholder`. Each is an [`AstroFontStyle?`](#astrofontstyle). |

#### `colors:` → `AstroInputColors`

Tokens for text inputs, including the trailing icon area, the dropdown panel, and the phone-country dropdown (sheet + items). 55 tokens. Every field is an optional `UIColor?` — see [Color values](#color-values).

| Field | Type | Description |
|-------|------|-------------|
| `background` | `UIColor?` | Input background (default) |
| `backgroundHover` | `UIColor?` | Input background (hover) |
| `backgroundFocus` | `UIColor?` | Input background (focus) |
| `backgroundActive` | `UIColor?` | Input background (active/pressed) |
| `backgroundFilled` | `UIColor?` | Input background (filled) |
| `backgroundDisabled` | `UIColor?` | Input background (disabled) |
| `backgroundError` | `UIColor?` | Input background (error) |
| `backgroundSuccess` | `UIColor?` | Input background (success) |
| `border` | `UIColor?` | Input border (default) |
| `borderHover` | `UIColor?` | Input border (hover) |
| `borderFocus` | `UIColor?` | Input border (focus) |
| `borderActive` | `UIColor?` | Input border (active) |
| `borderFilled` | `UIColor?` | Input border (filled) |
| `borderDisabled` | `UIColor?` | Input border (disabled) |
| `borderError` | `UIColor?` | Input border (error) |
| `borderSuccess` | `UIColor?` | Input border (success) |
| `text` | `UIColor?` | Input text (default) |
| `textHover` | `UIColor?` | Input text (hover) |
| `textDisabled` | `UIColor?` | Input text (disabled) |
| `placeholder` | `UIColor?` | Placeholder text |
| `placeholderHover` | `UIColor?` | Placeholder text (hover) |
| `label` | `UIColor?` | Field label |
| `helper` | `UIColor?` | Helper text |
| `errorMessage` | `UIColor?` | Error message text |
| `successMessage` | `UIColor?` | Success message text |
| `icon` | `UIColor?` | Leading/trailing icon |
| `iconHover` | `UIColor?` | Icon (hover) |
| `iconFocus` | `UIColor?` | Icon (focus) |
| `iconDisabled` | `UIColor?` | Icon (disabled) |
| `caret` | `UIColor?` | Caret/cursor color |
| `focusOutlineColor` | `UIColor?` | Focus outline ring |
| `iconBackground` | `UIColor?` | Icon background (default) |
| `iconBackgroundHover` | `UIColor?` | Icon background (hover) |
| `iconBackgroundFocus` | `UIColor?` | Icon background (focus) |
| `iconBackgroundDisabled` | `UIColor?` | Icon background (disabled) |
| `dropdownBackground` | `UIColor?` | Dropdown panel background |
| `dropdownBorder` | `UIColor?` | Dropdown panel border |
| `dropdownOptionBackground` | `UIColor?` | Dropdown option background |
| `dropdownOptionBackgroundHover` | `UIColor?` | Dropdown option background (hover) |
| `dropdownOptionBackgroundSelected` | `UIColor?` | Dropdown option background (selected) |
| `dropdownOptionBackgroundDisabled` | `UIColor?` | Dropdown option background (disabled) |
| `dropdownOptionText` | `UIColor?` | Dropdown option text |
| `dropdownOptionTextHover` | `UIColor?` | Dropdown option text (hover) |
| `dropdownOptionTextSelected` | `UIColor?` | Dropdown option text (selected) |
| `dropdownOptionTextDisabled` | `UIColor?` | Dropdown option text (disabled) |
| `dropdownOptionIcon` | `UIColor?` | Dropdown option icon |
| `dropdownEmptyMessage` | `UIColor?` | Dropdown empty-state text |
| `phoneDropdownBackground` | `UIColor?` | Phone country dropdown background |
| `phoneDropdownOverlayBackground` | `UIColor?` | Phone dropdown overlay background |
| `phoneDropdownHeaderBackground` | `UIColor?` | Phone dropdown header background |
| `phoneDropdownItemBackground` | `UIColor?` | Phone dropdown item background |
| `phoneDropdownItemBackgroundHover` | `UIColor?` | Phone dropdown item background (hover) |
| `phoneDropdownItemBackgroundActive` | `UIColor?` | Phone dropdown item background (active) |
| `phoneDropdownItemText` | `UIColor?` | Phone dropdown item text |
| `phoneDropdownItemTextSecondary` | `UIColor?` | Phone dropdown item text (secondary) |

### `AstroAvatarColors`

Colors for user avatars and avatar groups. Every field below is an optional `UIColor?` — see [Color values](#color-values).

| Field                | Description                                            |
|----------------------|--------------------------------------------------------|
| `background`         | Avatar fill behind initials and the fallback icon      |
| `backgroundHover`    | Avatar fill / hover                                    |
| `border`             | Avatar border, when a bordered avatar is rendered      |
| `borderHover`        | Avatar border / hover                                  |
| `text`               | Initials shown when no image is available              |
| `iconColor`          | Fallback icon shown when there are no initials         |
| `focusOutlineColor`  | Focus outline on a tappable avatar                     |
| `groupRing`          | Separating ring between overlapping avatars in a group |
| `skeletonBackground` | Placeholder fill while the avatar is loading           |

### `AstroTypography`

Global typography settings. Exposes a single field — `fontFamily` — used as the default font family for every text token rendered by the SDK. Per-token typography customization (overriding `displayLarge`, `base500`, etc. individually) is **not** supported at the global typography level; use per-component typography slots (see [`AstroButtonStyle`](#astrobuttonstyle), [`AstroInputStyle`](#astroinputstyle), etc.) to customize specific component text.

#### Global default

| Field        | Type      | Description |
|--------------|-----------|-------------|
| `fontFamily` | `String?` | Optional global default font family applied to every text token rendered by the SDK. When omitted, the SDK's static default is used. The partner is responsible for ensuring the requested family is registered in the host app and resolvable when the SDK renders; the SDK does not load fonts on your behalf. `fontFamily` is not validated — any non-null string is forwarded as-is; an empty string is dropped. |

### `AstroFontStyle`

Leaf type used by per-component typography slots (`button.typography.label`, `input.typography.helper`, etc.). All fields are optional — only the fields you set are applied; the remaining attributes fall back to the SDK default.

| Field           | Type        | Accepted values                                                  |
|-----------------|-------------|------------------------------------------------------------------|
| `fontSize`      | `CGFloat?`  | Non-negative number (size in px).                                |
| `fontWeight`    | `Int?`      | Integer in the range `100..900` (matches CSS / UIKit weights).   |
| `lineHeight`    | `CGFloat?`  | Non-negative number (line height in px).                         |
| `letterSpacing` | `CGFloat?`  | Any number (px). May be negative for tighter tracking.           |
| `fontFamily`    | `String?`   | Any non-null string accepted (no validation); an empty string is dropped. Applied to the specific component slot. The partner is responsible for ensuring the requested family is registered in the host app and resolvable when the SDK renders; the SDK does not load fonts on your behalf. |

Invalid values (negative `fontSize`/`lineHeight`, `fontWeight` outside `100..900`) cause the typed `AstroStyle.validate()` to throw. `fontFamily` is not validated — any non-null string is forwarded as-is.

## Example

```swift
import AstroConnectSDK

let style = AstroStyle(
    backgroundColor: UIColor(red: 0.016, green: 0.075, blue: 0.067, alpha: 1),   // cascades to surface.base
    primaryColor: UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1),          // cascades to surface.highlight, text.highlight, border.highlight
    typography: AstroTypography(
        fontFamily: "Inter"
    ),
    surface: AstroSurfaceColors(
        // Explicit overrides take precedence over the cascade.
        secondary: UIColor(red: 0.043, green: 0.149, blue: 0.141, alpha: 1),
        muted: UIColor(red: 0.078, green: 0.220, blue: 0.204, alpha: 1),
        // Alpha is supported — this overlay renders at 50% opacity.
        overlay: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    ),
    text: AstroTextColors(
        base: .white,
        muted: UIColor(red: 0.651, green: 0.710, blue: 0.702, alpha: 1)
    ),
    border: AstroBorderColors(
        base: UIColor(red: 0.122, green: 0.290, blue: 0.271, alpha: 1)
    ),
    buttons: AstroButtonStyle(
        colors: AstroButtonColors(
            // Button tokens are never cascaded — set each one explicitly.
            primaryText: .black,
            primaryBackgroundDisabled: UIColor(red: 0.122, green: 0.290, blue: 0.271, alpha: 1),
            primaryTextDisabled: UIColor(red: 0.361, green: 0.478, blue: 0.467, alpha: 1)
        ),
        typography: AstroButtonTypography(
            label: AstroFontStyle(fontSize: 14, fontWeight: 500)
        )
    ),
    header: AstroHeaderStyle(
        backgroundColor: UIColor(red: 0.024, green: 0.118, blue: 0.114, alpha: 1),
        borderColor: UIColor(red: 0.122, green: 0.290, blue: 0.271, alpha: 1),
        borderWidth: 1
    )
)
```

> **Theme awareness:** When you override a color via `AstroStyle`, the SDK stops using the theme-based default for that token. If your app supports both light and dark modes, build the typed structs dynamically based on the current `UITraitCollection.userInterfaceStyle`.

## Free-form overrides via `styleOverrides`

`AstroConfiguration.styleOverrides` is a free-form `[String: Any]?` that covers the same token catalog as the typed `AstroStyle`. It is intended for partners who need to set tokens dynamically (e.g. fetched from a remote theme service) or to reach tokens that have not yet been promoted to the typed catalog.

### Key naming

The typed `AstroStyle` API is **nested** (`buttonsIcon.colors.primaryIconColor`). `styleOverrides` color keys are **flat**: take the flat prefix of the slot from the table below and append the field name from the [Token reference](#token-reference), in camelCase.

| Typed slot    | Flat key prefix | Example typed path                    | Example flat key             |
|---------------|-----------------|---------------------------------------|------------------------------|
| `surface`     | `surface`       | `surface.secondary`                   | `surfaceSecondary`           |
| `text`        | `text`          | `text.highlight`                      | `textHighlight`              |
| `border`      | `border`        | `border.highlight`                    | `borderHighlight`            |
| `buttons`     | `button`        | `buttons.colors.primaryBackground`    | `buttonPrimaryBackground`    |
| `buttonsIcon` | `buttonIcon`    | `buttonsIcon.colors.primaryIconColor` | `buttonIconPrimaryIconColor` |
| `buttonsPill` | `buttonPill`    | `buttonsPill.colors.highlightText`    | `buttonPillHighlightText`    |
| `inputs`      | `input`         | `inputs.colors.dropdownBackground`    | `inputDropdownBackground`    |
| `avatar`      | `avatar`        | `avatar.iconColor`                    | `avatarIconColor`            |

**The component slots are singular in `styleOverrides`.** `buttons`, `buttonsIcon`, `buttonsPill` and `inputs` become `button`, `buttonIcon`, `buttonPill` and `input`. Carrying the plural form over from the typed API is the single most common integration mistake.

The color-only slots — `surface`, `text`, `border` and `avatar` — use their own name as the prefix, unchanged.

`styleOverrides` honors exactly these shapes:

- Flat color keys at the top level — e.g. `"buttonIconPrimaryIconColor": "#00DBBF"`.
- The same flat color keys nested under a `colors` dictionary — e.g. `"colors": ["buttonIconPrimaryIconColor": "#00DBBF"]`.
- `typography` with a single `fontFamily` string.
- Per-component typography under `button` / `buttonIcon` / `buttonPill` / `input`, each holding a `typography` dictionary of slots.
- `header` with `backgroundColor` / `borderColor`.

A nested structure that mirrors the typed shape for **colors** is not one of them — it is accepted and has no effect:

```swift
// WRONG — mirrors the typed nested shape; silently ignored
styleOverrides: [
    "buttonsIcon": [
        "colors": ["primaryIconColor": "#00DBBF"]
    ]
]

// RIGHT — flat key at the top level
styleOverrides: [
    "buttonIconPrimaryIconColor": "#00DBBF"
]

// RIGHT — the same flat key nested under `colors`
styleOverrides: [
    "colors": ["buttonIconPrimaryIconColor": "#00DBBF"]
]
```

> **Key names are case-sensitive and are not validated.** A valid color under a key that is not part of the catalog is accepted and simply has no visual effect — no error, no warning, no crash. A typo such as `"buttonsPrimaryBackground"` or `"buttonPrimarybackground"` is a silent no-op. Copy key names from the [Token reference](#token-reference) tables in this document instead of typing them by hand.

### Accepted value forms

- Top-level colors (e.g. `"surfaceBase"`, `"primaryColor"`). Color leaves accept **either** a hex string — 6-digit `"#RRGGBB"` or 8-digit `"#RRGGBBAA"` for alpha, leading `#` optional — **or** a `UIColor` value. Both forms are normalized to the same hex wire representation, so mixing them within the same dictionary is fine. Any malformed hex string causes `AstroConfiguration.validate()` to throw, so invalid hex is caught at configuration time rather than silently dropped at runtime; `UIColor` leaves are always considered valid.
- The `typography` dictionary, which accepts a single top-level `fontFamily` string — the global default font family, with the same semantics as the typed [`AstroTypography.fontFamily`](#astrotypography). Per-token nested keys (e.g. `typography.base500.fontFamily`, `typography.displayLarge.fontSize`) are **not** honored — they are silently ignored for forward compatibility, so partners migrating away from per-token overrides won't see validation errors but the values won't take effect either.
- Per-component typography under the component slot (e.g. `button.typography.label.fontSize`, `input.typography.placeholder.fontSize`) — fully supported.

Numeric values for `fontSize`, `lineHeight`, and `letterSpacing` are automatically normalized — you can pass either a number (e.g. `14`) or a string (e.g. `"14px"`); both work. Normalization recurses into nested dictionaries, so numbers inside `button.typography.label`, `input.typography.helper`, and any other per-component typography map are normalized the same way. `fontWeight` is the only typography field that is **not** normalized to a `"<n>px"` string — it stays an integer in the range `100..900` because it is a unitless weight.

> The typed `AstroStyle` API uses `UIColor` for color fields; the free-form `styleOverrides` dictionary accepts **both** hex strings and `UIColor` values for color leaves. Internally both are converted to the same hex wire representation.

```swift
// Form 1 — hex string
styleOverrides: [
    "surfaceBase": "#FFFFFF",
    "primaryColor": "#0033CC80"
]

// Form 2 — UIColor (equivalent on the wire)
styleOverrides: [
    "surfaceBase": UIColor.white,
    "primaryColor": UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 0.5)
]
```

```swift
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    styleOverrides: [
        "surfaceBase": "#FFFFFF",
        "typography": [
            "fontFamily": "Inter"
        ],
        "button": [
            "typography": [
                "label": ["fontSize": 14, "fontWeight": 500]
            ]
        ]
    ]
)
```

> The typed API (`AstroStyle.typography.fontFamily`, per-component `typography` slots, etc.) is the recommended path because it gives compile-time safety and IDE autocompletion. `styleOverrides` is the escape hatch for the dynamic / late-bound use cases described above.

### Brand cascade in `styleOverrides`

The brand cascade described in [Cascade rules](#cascade-rules) also applies to `styleOverrides`, with these semantics:

- **Source:** `primaryColor` only — either as the top-level key `"primaryColor"` or nested as `colors.primaryColor`. `surfaceHighlight` is **not** a cascade source, even though it is accepted as a brand alias for the loading spinner.
- **Targets:** `surfaceHighlight`, `textHighlight` and `borderHighlight` — filled only when your dictionary does not name them.
- An explicit value always wins, no matter in which order the keys appear in the dictionary.
- A `primaryColor` value that cannot be resolved to a color produces no cascade at all; the highlight tokens keep their defaults. (Malformed hex strings are additionally rejected by `AstroConfiguration.validate()`.)
- `backgroundColor` → `surfaceBase` is unchanged and behaves as described in [Cascade rules](#cascade-rules).

```swift
// `primaryColor` alone also brands highlighted surfaces, text and borders.
styleOverrides: [
    "primaryColor": "#00DBBF"
]
// → surfaceHighlight, textHighlight and borderHighlight all resolve to #00DBBF

// Explicit values win; the rest still cascade — order is irrelevant.
styleOverrides: [
    "textHighlight": "#FFFFFF",
    "primaryColor": "#00DBBF"
]
// → textHighlight stays #FFFFFF; surfaceHighlight and borderHighlight become #00DBBF
```

### Brand color aliases (apply throughout the SDK)

Two brand colors — background and primary — are **special-cased**: when set via `styleOverrides`, they apply throughout the SDK, including the initial loading screen background and the loading spinner. Every other `styleOverrides` key applies only to the main SDK content and does not affect the initial loading screen.

Each brand color accepts a top-level key in `styleOverrides`, plus a nested form under `colors`. When both are present, the top-level key takes precedence.

| Brand color  | Accepted keys                                                                                                          | Where it applies                  |
|--------------|---------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| Background   | `backgroundColor`, or nested `colors.surfaceBase`                                          | Initial loading screen background |
| Primary      | `primaryColor`, `surfaceHighlight`, or nested `colors.surfaceHighlight` / `colors.primaryColor` | Loading spinner color, plus the highlight tokens (`surfaceHighlight`, `textHighlight`, `borderHighlight`) via the [brand cascade](#brand-cascade-in-styleoverrides) |

All the keys in the Primary row feed the loading spinner. The highlight cascade, however, is driven by `primaryColor` only (top-level or `colors.primaryColor`) — passing `surfaceHighlight` sets that one token and colors the spinner, but does not cascade to `textHighlight` or `borderHighlight`.

**Precedence (highest → lowest):**

1. `styleOverrides` key — the top-level key takes precedence over the nested `colors.*` form.
2. Typed `AstroStyle.surface.base` (for background) / `AstroStyle.surface.highlight` (for primary) — the specific token.
3. Typed `AstroStyle.backgroundColor` / `AstroStyle.primaryColor` — the brand-level field.
4. Default theme color.

The specific surface token wins over the brand-level field when both are set — for example, `style.surface.base` overrides `style.backgroundColor` for the initial loading screen, mirroring the typed cascade semantics used elsewhere in the SDK. Free-form `styleOverrides` apply after the typed `style` cascade and the specific token wins over the brand-level field.

**Accepted value forms:** `UIColor` value, or hex string (`#RRGGBB` / `#RRGGBBAA`). Leading `#` optional.

```swift
// Hex string form
let configuration = AstroConfiguration(
    environment: "sandbox",
    appIssuer: "your-app-issuer",
    clientId: "your-client-id",
    partnerUserId: "your-partner-user-id",
    accessToken: "your-access-token",
    styleOverrides: [
        "backgroundColor": "#041311",
        "primaryColor": "#00DBBF"
    ]
)

// UIColor form (equivalent on the wire)
styleOverrides: [
    "backgroundColor": UIColor(red: 0.016, green: 0.075, blue: 0.067, alpha: 1),
    "primaryColor": UIColor(red: 0.0, green: 0.86, blue: 0.75, alpha: 1)
]
```

> If a brand color key is present in `styleOverrides`, it is used for the initial loading screen even when the typed `AstroStyle.backgroundColor` / `AstroStyle.primaryColor` is also set — `styleOverrides` wins. The typed `AstroStyle` field is used only when no `styleOverrides` key is present.

### Header colors (header bar only)

The SDK header bar's background and border colors can also be set via `styleOverrides`, using a nested `header` dictionary that mirrors the typed `AstroStyle.header` shape:

| Header bar target    | styleOverrides key path                           |
|----------------------|---------------------------------------------------|
| Header background    | `styleOverrides["header"]["backgroundColor"]`     |
| Header border        | `styleOverrides["header"]["borderColor"]`         |

The keys are case-sensitive camelCase — no aliases. Unlike the brand colors above, these header keys affect the SDK's header bar only; they do not change other parts of the SDK.

**Precedence (highest → lowest):**

1. `styleOverrides["header"]["backgroundColor"]` / `["borderColor"]` — wins when present.
2. Typed `AstroStyle.header.backgroundColor` / `AstroStyle.header.borderColor`.
3. Default theme color.

**Accepted value forms:** a hex string (`#RRGGBB` / `#RRGGBBAA`, leading `#` optional) **or** a `UIColor` value. A malformed hex string causes `AstroConfiguration.validate()` to throw. The sibling layout keys under `header` (`borderWidth`, `paddingHorizontal`, `paddingVertical`) are not consumed from `styleOverrides` — set those on the typed `AstroStyle.header` instead.

```swift
// Hex string form
styleOverrides: [
    "header": [
        "backgroundColor": "#FFFFFF",
        "borderColor": "#000000"
    ]
]

// UIColor form (equivalent on the wire)
styleOverrides: [
    "header": [
        "backgroundColor": UIColor.white,
        "borderColor": UIColor.black
    ]
]
```

> If a header color is present under `styleOverrides["header"]`, it is used for the native header even when the typed `AstroStyle.header.backgroundColor` / `borderColor` is also set — `styleOverrides` wins. The typed field is used only when no `styleOverrides` header key is present.
