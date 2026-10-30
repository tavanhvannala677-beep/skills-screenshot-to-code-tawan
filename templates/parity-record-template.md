# Feature Contract & Cross-Platform Parity Record

This template serves as the official parity record for features implemented using `screenshot-to-code`, ensuring visual, behavioral, and contract parity across **Android (Jetpack Compose)**, **iOS (SwiftUI)**, and **HarmonyOS (ArkUI)**.

---

## 1. Feature Overview & Contracts

| Field | Details |
| :--- | :--- |
| **Feature Name** | [e.g. Wallet Balance & Transaction History] |
| **Screen / Route ID** | [e.g. `/wallet`, `WalletScreen`] |
| **Target Platforms** | Android (Compose), iOS (SwiftUI), HarmonyOS (ArkUI) |
| **Figma / Screenshot Reference** | `[Link or Image Reference File]` |
| **Shared API Contract / Schema** | `[Link to OpenAPI / Protobuf / Shared Model fixture]` |
| **Delivery Milestone** | `[Sprint / Release Version]` |

---

## 2. Agreed States & Fixture Data

> **Rule:** Never invent synthetic mock data or fields that deviate from the agreed contract.

| State | Visual Treatment | Test Fixture Source |
| :--- | :--- | :--- |
| **Loaded (Default)** | Full data displayed as per reference | `fixtures/wallet_success.json` |
| **Loading** | Shimmer skeleton matching card layout | Built-in shimmer modifier |
| **Empty** | Empty state illustration + Call-to-Action button | `fixtures/wallet_empty.json` |
| **Error / Retry** | Snackbar / Banner with retry action | `fixtures/wallet_error.json` |

---

## 3. Platform Parity Matrix

| Checkpoint | Android (Jetpack Compose) | iOS (SwiftUI) | HarmonyOS (ArkUI) |
| :--- | :--- | :--- | :--- |
| **Framework & Language** | Kotlin (`1.9+`), Compose (`1.6+`) | Swift (`5.9+`), SwiftUI (`iOS 16+`) | ArkTS, ArkUI (`API 11+`) |
| **Touch Target Minimum** | **48 x 48 dp** (`minimumInteractiveComponentSize()`) | **44 x 44 pt** (`.frame(minWidth: 44, minHeight: 44)`) | **48 x 48 vp** (`.width(48).height(48)`) |
| **Safe Area Insets** | `WindowInsets.safeDrawing` | `.safeAreaInset()` | `Window.getLastWindow().getWindowAvoidArea()` |
| **Design Tokens** | `MaterialTheme.colorScheme` / `LocalSpacing` | `Color.accentColor` / `AssetCatalog` | `$r('app.color.primary')` / Resource tokens |
| **Primary Button** | `PrimaryButton(...)` | `PrimaryButtonView(...)` | `PrimaryButtonComponent(...)` |
| **Top App Bar** | `GrabtampTopAppBar(...)` | `GrabtampNavigationBar(...)` | `GrabtampTitleBar(...)` |
| **Routing / Navigation** | `NavHost` / Compose Destinations | `NavigationStack` / Coordinator | `Navigation` / `Router` |

---

## 4. Verification & Build Audit

Run the platform-specific build and record the verified output:

- **Android:**
  - Command: `./gradlew :app:compileDebugKotlin`
  - Result: `[PASS / FAIL / NOT RUN (Reason)]`
- **iOS:**
  - Command: `xcodebuild -scheme App -destination 'generic/platform=iOS' build`
  - Result: `[PASS / FAIL / NOT RUN (Reason)]`
- **HarmonyOS:**
  - Command: `hvigorw --mode module -p module=entry assembleHap`
  - Result: `[PASS / FAIL / NOT RUN (Reason)]`

---

## 5. Unresolved Discrepancies & Trade-offs

| Item | Platform | Discrepancy Description | Justification / Follow-up Action |
| :--- | :--- | :--- | :--- |
| 1 | All | Custom SVG icon substitution | Used existing design system icon pending final asset export |
| 2 | HarmonyOS | Font weight variation | ArkUI font fallback used until custom font family is bundled |

---

## 6. Sign-off Checklist

- [ ] Reused existing design system tokens and components (no raw hex codes).
- [ ] Safe area insets properly handled across notches, islands, and navigation bars.
- [ ] Verified minimum touch targets (48dp Android / 44pt iOS / 48vp HarmonyOS).
- [ ] No unauthorized third-party libraries installed.
- [ ] `git diff` audited: only target screen/component files were modified.
